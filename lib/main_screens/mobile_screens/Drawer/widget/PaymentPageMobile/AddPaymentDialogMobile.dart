
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddPaymentDialogMobile extends StatefulWidget {
  final int billId;
  final int payment;
  final int total_price;
  final String customerName;
  final DateTime billDate;
  // final int vaultId; // <-- Add this field

  const AddPaymentDialogMobile({
    Key? key,
    required this.billId,
    required this.payment,
    required this.total_price,
    required this.customerName,
    required this.billDate,
    // required this.vaultId, // <-- Update constructor
  }) : super(key: key);

  @override
  State<AddPaymentDialogMobile> createState() => _AddPaymentDialogMobileState();
}

class _AddPaymentDialogMobileState extends State<AddPaymentDialogMobile> {
  final TextEditingController _amountController = TextEditingController();
  bool _isSubmitting = false;
  String? _selectedVaultId; // To store the selected vault ID
  List<Map<String, dynamic>> _vaults = []; // Vault list

  @override
  void initState() {
    super.initState();
    _fetchVaults();
    // Fetch vaults on initialization
  }




  Future<bool> _submitPayment() async {
    final amount = int.tryParse(_amountController.text);
    // الحصول على معرف المستخدم الحالي
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null|| amount == null || amount <= 0 || _selectedVaultId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر تحديد المستخدم الحالي. يرجى تسجيل الدخول مرة أخرى.')),
      );
      return false;
    }

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال مبلغ صالح.')),
      );
      return false;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // إنشاء كائن الدفع
      final payment = {
        'bill_id': widget.billId,
        'date': DateTime.now().toIso8601String(),
        'user_id': userId,
        'payment': amount,
        'vault_id': _selectedVaultId, // <-- Add vault_id here
        'payment_status': 'إيداع', // حالة الدفع
        'created_at': DateTime.now().toIso8601String(),
      };

      // الاتصال بـ Supabase لإضافة السجل
      final paymentResponse = await Supabase.instance.client
          .from('payment')
          .insert(payment)
          .select();

      final billUpdateResponse = await Supabase.instance.client
          .from('bills')
          .update({
        'payment': widget.payment + amount,
      })
          .eq('id', widget.billId,)
          .select()
          .single();


      if (paymentResponse == null || paymentResponse.isEmpty) {
        throw Exception('فشل في إضافة سجل الدفع.');
      }

      // تحديث حالة الفاتورة
      await _updateBillStatus();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إضافة الدفع بنجاح!')),
      );

      Navigator.pop(context); // إغلاق الـ Dialog
      // Navigator.pop(context); // إغلاق الـ Dialog
      return true ;
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في إضافة الدفع: $error')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
    return true ;
  }





  Future<void> _updateBillStatus() async {
    try {
      // Fetch all payments for the current bill
      final payments = await _fetchPayments(widget.billId);
      // Calculate the total payment
      final totalPayment = payments.fold<double>(
        0.0,
            (sum, payment) => sum + (payment['payment'] ?? 0),
      );

      // Determine the new status of the bill
      String status;
      if (totalPayment == widget.total_price) {
        status = 'تم الدفع';
      } else if (totalPayment > widget.total_price) {
        status = 'فاتورة مفتوحة';
      } else {
        status = 'آجل';
      }

      // Update the bill status in the database
      await Supabase.instance.client
          .from('bills')
          .update({'status': status})
          .eq('id', widget.billId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم تحديث حالة الفاتورة إلى: $status')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في تحديث حالة الفاتورة: $error')),
      );
    }
  }

  Future<List<Map<String, dynamic>>> _fetchPayments(int billId) async {
    final response = await Supabase.instance.client
        .from('payment')
        .select('*, users(name)')
        .eq('bill_id', billId)
        .order('date', ascending: false);

    if (response == null) {
      throw Exception('Failed to fetch payments.');
    }

    return List<Map<String, dynamic>>.from(response);
  }

  // Function to fetch vaults from Supabase
  Future<void> _fetchVaults() async {
    try {
      final response = await Supabase.instance.client
          .from('vaults') // Replace with your vault table name
          .select('id, name'); // Fetch vault ID and name

      setState(() {
        _vaults = List<Map<String, dynamic>>.from(response);
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في جلب القيم: $error')),
      );
    }
  }

  // Dropdown for selecting vaults
  DropdownButtonFormField<String> _vaultDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedVaultId,
      decoration: const InputDecoration(
        labelText: 'اختر الخزنة',
        border: OutlineInputBorder(),
      ),
      items: _vaults.map((vault) {
        return DropdownMenuItem<String>(
          value: vault['id'],
          child: Text(vault['name']), // Display vault name
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedVaultId = newValue;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AlertDialog(
        title: const Text('إضافة الدفع'),
        content: Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'رقم الفاتورة: ${widget.billId}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                'اسم العميل: ${widget.customerName}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                'تاريخ الفاتورة: ${DateFormat('yyyy-MM-dd').format(widget.billDate)}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              const SizedBox(height: 16),
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'المبلغ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              _vaultDropdown(), // Dropdown for selecting vaults
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'إجمالي الفاتورة: ${widget.total_price}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: _fetchPayments(widget.billId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Text('خطأ في تحميل المدفوعات: ${snapshot.error}');
                            }
                            final payments = snapshot.data ?? [];
                            if (payments.isEmpty) {
                              return const Text('لا توجد مدفوعات لهذه الفاتورة.');
                            }

                            return Expanded(
                              child: SizedBox(
                                height: 200, // تحديد ارتفاع مناسب للتمرير
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: payments.map((payment) {
                                      String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(payment['date']));
                                      final userName = payment['users']?['name'] ?? 'غير معروف';

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                                        child: Text(
                                          'المبلغ: ${payment['payment']} - التاريخ: $formattedDate - المستخدم: $userName',
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            );

                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Row(
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context), // إغلاق الـ Dialog
                child: const Text('إلغاء'),
              ),

              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitPayment,
                child: _isSubmitting
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text('إرسال الدفع'),
              ),


            ],
          ),
        ],
      ),
    );
  }
}
