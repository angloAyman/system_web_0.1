

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/billes/data/repositories/bill_repository.dart';
import 'package:system/features/billes/presentation/Dialog/details-editing-pdf/bill/showEditBillDialog.dart';
import 'package:system/features/billes/presentation/pdf/presentation/show_pdf_preview_dialog.dart';
import 'package:system/features/report/data/model/report_model.dart';
import 'package:system/features/report/data/repository/report_repository.dart';
import 'package:system/features/Vaults/data/repositories/supabase_vault_repository.dart';
import 'package:system/main_screens/mobile_screens/bills/dialog/edit_items_bill/showEditBillDialogMobile.dart';

import '../../../../../features/billes/presentation/Dialog/adding/bill/AddbillPaymentPage.dart';

class BillDetailsDialogMobile extends StatefulWidget {
  final Bill bill;

  const BillDetailsDialogMobile({Key? key, required this.bill}) : super(key: key);

  @override
  _BillDetailsDialogMobileState createState() => _BillDetailsDialogMobileState();
}

class _BillDetailsDialogMobileState extends State<BillDetailsDialogMobile> {
  late Bill _bill;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _bill = widget.bill;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // String _formatCurrency(double amount) {
  //   return '${amount.toStringAsFixed(2)} جنيه مصري';
  // }
  //
  // String _formatCurrencyint(int amount) {
  //   return '${amount.toStringAsFixed(2)} جنيه مصري';
  // }

  String _formatCurrency(num amount) {
    // Convert to double to ensure we can use toStringAsFixed
    final doubleValue = amount.toDouble();
    return '${doubleValue.toStringAsFixed(2)} جنيه مصري';
  }

  String _formatDate(dynamic date) {
    try {
      DateTime parsedDate;
      if (date is DateTime) {
        parsedDate = date;
      } else if (date is String) {
        parsedDate = DateTime.parse(date);
      } else {
        return 'غير محدد';
      }
      return '${parsedDate.day.toString().padLeft(2, '0')}/'
          '${parsedDate.month.toString().padLeft(2, '0')}/'
          '${parsedDate.year}';
    } catch (e) {
      return 'غير محدد';
    }
  }

  Future<bool> _removeBill(BuildContext context, int billId, String vaultId, double billPayment) async {
    setState(() => _isLoading = true);

    try {
      final currentUser = Supabase.instance.client.auth.currentUser!;
      final userData = await Supabase.instance.client
          .from('users')
          .select('name')
          .eq('id', currentUser.id)
          .maybeSingle();

      final report = Report(
        id: currentUser.id,
        title: "حذف فاتورة",
        // user_id: currentUser.id,
        user_name: userData?['name'] ?? "مجهول", // 👈 من جدول users
        date: DateTime.now(),
        description: 'رقم الفاتورة: ${_bill.id} - اسم العميل: ${_bill.customerName} - إجمالي: ${_formatCurrency(_bill.total_price)}',
        operationNumber: 0,
      );

      final vaultRepository = SupabaseVaultRepository();
      final currentBalance = await vaultRepository.getVaultBalance(vaultId);
      final updatedBalance = currentBalance - billPayment;

      await Future.wait([
        BillRepository().removeBill(billId),
        ReportRepository().addReport(report),
        vaultRepository.subtractFromVaultBalance2(vaultId, updatedBalance),
      ]);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حذف الفاتورة بنجاح')),
        );
        return true;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
    return false;
  }

  Future<bool> _showAddPaymentDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AddPaymentDialog(
        billId: _bill.id,
        payment: _bill.payment,
        customerName: _bill.customerName,
        billDate: _bill.date,
        total_price: _bill.total_price,
      ),
    ) ?? false;
  }

  void _openEditBillDialog() {
    showEditBillDialogMobile(context, _bill).then((updatedBill) {
      if (updatedBill != null && mounted) {
        setState(() {
          _bill = updatedBill;
        });
      }
    });
  }


  void _openDeleteBillDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذه الفاتورة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              final result = await _removeBill(
                  dialogContext,
                  _bill.id,
                  _bill.vault_id,
                  _bill.payment
              );
              if (result && mounted) {
                Navigator.pop(dialogContext);
                Navigator.pop(context);
              }
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchPayments() async {
    final response = await Supabase.instance.client
        .from('payment')
        .select('*, users(name)')
        .eq('bill_id', _bill.id)
        .order('date', ascending: false);

    if (response == null) {
      throw Exception('Failed to fetch payments');
    }

    return List<Map<String, dynamic>>.from(response);
  }

  Widget _buildHeaderSection() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.receipt, size: 18),
                const SizedBox(width: 8),
                Text('فاتورة ${_bill.id}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 16),
            _buildInfoRow('العميل', _bill.customerName),
            _buildInfoRow('التاريخ', _formatDate(_bill.date)),
            _buildInfoRow('حالة الدفع', _bill.status),
            _buildInfoRow('إجمالي الفاتورة', _formatCurrency(_bill.total_price)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildPaymentSection() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchPayments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('خطأ: ${snapshot.error}');
        }

        final payments = snapshot.data ?? [];
        // final totalPayment = payments.fold<int>(
        //   0,
        //       (sum, payment) => sum + ((payment['payment'] ?? 0) as int),
        // );
        final totalPayment = payments.fold<double>(
          0.0,
              (sum, payment) => sum + ((payment['payment'] ?? 0).toDouble()),
        );


        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('المدفوعات',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () async {
                        final result = await _showAddPaymentDialog();
                        if (result == true && mounted) {
                          setState(() {});
                        }
                      },
                      tooltip: 'إضافة دفعة',
                      iconSize: 20,
                    ),
                  ],
                ),
                const Divider(height: 16),
                if (payments.isEmpty)
                  const Center(child: Text('لا توجد مدفوعات مسجلة'))
                else
                  ...payments.map((payment) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_formatCurrency(payment['payment'] ?? 0.0)),
                        Text('بواسطة: ${payment['users']?['name'] ?? 'غير معروف'}'),
                        Text('التاريخ: ${_formatDate(payment['date'])}'),
                        const Divider(height: 8),
                      ],
                    ),
                  )),
                if (payments.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('المجموع: ${_formatCurrency(totalPayment)}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
        Text('المتبقي: ${_formatCurrency((_bill.total_price - totalPayment).toDouble())}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: (_bill.total_price - totalPayment) > 0
                            ? Colors.red
                            : Colors.green,
                      )),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildItemsSection() {
    final totalAmount = _bill.items.fold<double>(
      0, (sum, item) => sum + item.total_Item_price,
    );

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('الأصناف', style: TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: _openEditBillDialog,
                  tooltip: 'تعديل الفاتورة',
                  iconSize: 20,
                ),

              ],
            ),
            const Divider(height: 16),
            ..._bill.items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${item.categoryName} / ${item.subcategoryName}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  if (item.description?.isNotEmpty ?? false)
                    Text(item.description!),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Chip(
                        label: Text('السعر: ${item.price_per_unit}'),
                        visualDensity: VisualDensity.compact,
                      ),
                      Chip(
                        label: Text('الكمية: ${item.quantity}'),
                        visualDensity: VisualDensity.compact,
                      ),
                      Chip(
                        label: Text('الخصم: ${item.discount} ${item.discountType}'),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('الإجمالي: ${_formatCurrency(item.total_Item_price)}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Divider(height: 16),
                ],
              ),
            )),
            Text('المجموع الكلي: ${_formatCurrency(totalAmount)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blue,
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isSmallScreen = mediaQuery.size.width < 360;

    return Dialog(
      insetPadding: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: mediaQuery.size.height * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: const Text('تفاصيل الفاتورة'),
              centerTitle: true,
              actions: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    switch (value) {
                      case 'pdf':
                        showPdfPreviewDialog(context, _bill);
                        break;
                      case 'delete':
                        _openDeleteBillDialog();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'pdf',
                      child: Row(
                        children: [
                          Icon(Icons.picture_as_pdf, size: 20),
                          SizedBox(width: 8),
                          Text('تصدير PDF'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('حذف الفاتورة', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (_isLoading)
              const LinearProgressIndicator()
            else
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      _buildHeaderSection(),
                      const SizedBox(height: 12),
                      _buildPaymentSection(),
                      const SizedBox(height: 12),
                      _buildItemsSection(),
                    ],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.picture_as_pdf, size: 18),
                    label: Text(isSmallScreen ? 'PDF' : 'تصدير PDF'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onPressed: () => showPdfPreviewDialog(context, _bill),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('إغلاق'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showBillDetailsDialogMobile(BuildContext context, Bill bill) async {
  await showDialog(
    context: context,
    builder: (context) => BillDetailsDialogMobile(bill: bill),
  );
}