//اضافة دفع
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddPaymentDialog extends StatefulWidget {
  final int billId;
  final double total_price;
  final String customerName;
  final DateTime billDate;
  // final int vaultId; // <-- Add this field

  const AddPaymentDialog({
    Key? key,
    required this.billId,
    required this.total_price,
    required this.customerName,
    required this.billDate,
    // required this.vaultId, // <-- Update constructor
  }) : super(key: key);

  @override
  State<AddPaymentDialog> createState() => _AddPaymentDialogState();
}

class _AddPaymentDialogState extends State<AddPaymentDialog> {
  final TextEditingController _amountController = TextEditingController();
  bool _isSubmitting = false;
  String? _selectedVaultId; // To store the selected vault ID
  List<Map<String, dynamic>> _vaults = []; // Vault list

  @override
  void initState() {
    super.initState();
    _fetchVaults(); // Fetch vaults on initialization
  }

  Future<void> _submitPayment() async {
    final amount = double.tryParse(_amountController.text);

    // الحصول على معرف المستخدم الحالي
    final userId = Supabase.instance.client.auth.currentUser?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر تحديد المستخدم الحالي. يرجى تسجيل الدخول مرة أخرى.')),
      );
      return;
    }
      // if (userId == null|| amount == null || amount <= 0 || _selectedVaultId == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('تعذر تحديد المستخدم الحالي. يرجى تسجيل الدخول مرة أخرى.')),
    //   );
    //   return;
    // }

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال مبلغ صالح.')),
      );
      return;
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

      if (paymentResponse == null || paymentResponse.isEmpty) {
        throw Exception('فشل في إضافة سجل الدفع.');
      }

      // تحديث حالة الفاتورة
      await _updateBillStatus();
      // تحديث إجمالي المدفوعات في الفاتورة
      await _updateBillTotalPayment(amount);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إضافة الدفع بنجاح!')),
      );

      Navigator.pop(context); // إغلاق الـ Dialog
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في إضافة الدفع: $error')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
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

  Future<void> _updateBillTotalPayment(double newPaymentAmount) async {
    try {
      // Fetch the current total payment for the bill
      final response = await Supabase.instance.client
          .from('bills')
          .select('payment')
          .eq('id', widget.billId)
          .single();

      if (response == null) {
        throw Exception('Bill not found.');
      }

      final currentTotalPayment = response['payment'] ?? 0.0;

      // Calculate the updated total payment
      final updatedTotalPayment = currentTotalPayment + newPaymentAmount;

      // Update the bill's total payment
      final updateResponse = await Supabase.instance.client
          .from('bills')
          .update({'payment': updatedTotalPayment})
          .eq('id', widget.billId);

      if (updateResponse == null || updateResponse.isEmpty) {
        throw Exception('Failed to update bill total payment.');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تحديث إجمالي المدفوعات بنجاح!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في تحديث إجمالي المدفوعات: $error')),
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
      // final response = await Supabase.instance.client
      //     .from('vaults') // Replace with your vault table name
      //     .select('id, name'); // Fetch vault ID and name

      final response = await Supabase.instance.client
          .from('vaults')
          .select('id,name,balance,isActive')
          .eq('isActive', true); // ✅ شرط يجيب بس الـ Active



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
    return AlertDialog(
      title: const Text('إضافة الدفع'),
      content: Padding(
        padding: const EdgeInsets.all(16.0),
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
              'تاريخ الفاتورة: ${ widget.billDate.year} / ${ widget.billDate.month} / ${widget.billDate.day}',
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
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'إجمالي الفاتورة: ${widget.total_price}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
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

                      // Calculate the total payment for the bill
                      final totalPayment = payments.fold<double>(
                        0.0,
                            (sum, payment) => sum + (payment['payment'] ?? 0),
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...payments.map((payment) {
                            final dateString = payment['date'];
                            final dateTime = DateTime.parse(dateString);
                            final formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

                            final userName = payment['users']?['name'] ?? 'غير معروف';
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                'المبلغ: ${payment['payment']} - التاريخ:  $formattedDate - المستخدم: $userName',
                              ),
                            );
                          }).toList(),
                          const Divider(height: 16, thickness: 1),
                          Text(
                            'إجمالي المدفوعات: ${totalPayment.toStringAsFixed(2)} جنيه مصري',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
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
    );
  }
}
