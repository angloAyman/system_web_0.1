
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/billes/data/repositories/bill_repository.dart';
import 'package:system/features/billes/presentation/Dialog/details-editing-pdf/bill/showEditBillDialog.dart';
import 'package:system/features/billes/presentation/pdf/presentation/show_pdf_preview_dialog.dart';
import 'package:system/features/report/data/model/report_model.dart';
import 'package:system/features/report/data/repository/report_repository.dart';

class BillDetailsDialog extends StatefulWidget {
  final Bill bill;

  const BillDetailsDialog({Key? key, required this.bill}) : super(key: key);

  @override
  _BillDetailsDialogState createState() => _BillDetailsDialogState();
}

class _BillDetailsDialogState extends State<BillDetailsDialog> {
  late Bill _bill;

  @override
  void initState() {
    super.initState();
    _bill = widget.bill;
  }

  // @override
  // void dispose() {
  //   // Cancel any active listeners or operations
  //   super.dispose();
  // }

  // Function to remove a bill
  Future<void> _removeBill(BuildContext context, int billId, Report report) async {
    final BillRepository _billRepository = BillRepository();
    final ReportRepository _reportRepository = ReportRepository();

    try {
      // Remove the bill from the database
       _billRepository.removeBill(billId);

      // Add the report to the system
       _reportRepository.addReport(report);

      // Ensure the widget is still mounted before accessing context
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bill removed successfully')),
        );
        // Navigator.of(context).pop(); // Close the details dialog
      }
    } catch (e) {
      // Ensure the widget is still mounted before accessing context
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error removing bill: $e')),
        );
      }
    }
  }

  // Function to open the edit bill dialog
  void _openEditBillDialog() {
    showEditBillDialog(context, _bill).then((updatedBill) {
      if (updatedBill != null) {
        setState(() {
          _bill = updatedBill; // Update the bill with new data
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('تفاصيل الفاتورة'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('رقم الفاتورة: ${_bill.id}'),
            Text('اسم العميل: ${_bill.customerName}'),
            Text('التاريخ: ${_bill.date}'),
            Text('حالة الدفع: ${_bill.status}'),
            const SizedBox(height: 16),
            const Text('تفاصيل الدفع:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('مبلغ الدفع: ${_bill.payment} - تاريخ الدفع : ${_bill.date}'),
            const SizedBox(height: 16),
            const Text('الأصناف:', style: TextStyle(fontWeight: FontWeight.bold)),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('الفئة/الفرعية')), // Category Name/description
                  DataColumn(label: Text('وصف')), // description
                  DataColumn(label: Text('سعر الوحدة')), // price_per_unit
                  DataColumn(label: Text('عدد الوحدات')), // quantity
                  DataColumn(label: Text('سعر القطعة')), // price_per_unit * amount
                  DataColumn(label: Text('الكمية')), // Quantity
                  DataColumn(label: Text('السعر')), // Price per Unit
                ],
                rows: _bill.items.map((item) {
                  return DataRow(
                    cells: [
                      DataCell(Text('${item.categoryName} / ${item.subcategoryName}')),
                      DataCell(Text(item.description ?? 'غير متوفر')),
                      DataCell(Text(item.price_per_unit.toString())),
                      DataCell(Text(item.amount.toString())),
                      DataCell(Text('\جنيه${(item.amount * item.price_per_unit)}')),
                      DataCell(Text(item.quantity.toString())),
                      DataCell(Text('\جنيه${(item.amount * item.price_per_unit * item.quantity)}')),
                    ],
                  );
                }).toList(),
              ),
            ),
            const Divider(),
            Text(
              'الإجمالي:  ${_bill.items.fold(0.0, (sum, item) => sum + (item.amount * item.price_per_unit * item.quantity)).toStringAsFixed(2)} جنيه مصري فقط لاغير ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      actions: [

        TextButton(
          onPressed: _openEditBillDialog,
          child: const Text('تعديل', style: TextStyle(color: Colors.cyan),),
        ),
        TextButton(
          onPressed: () async {
            await showPdfPreviewDialog(context, _bill);
          },
          child: const Text('PDF'),
        ),
        TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (dialogContext) {
                return AlertDialog(
                  title: const Text('تأكيد الحذف'),
                  content: const Text('هل أنت متأكد من حذف الفاتورة؟'),
                  actions: [
                    TextButton(
                      onPressed: ()  {
                        final user = Supabase.instance.client.auth.currentUser;
                        final report = Report(
                          id: user!.id,
                          title: "حذف فاتورة",
                          user_name: user.id,
                          date: DateTime.now(),
                          description:
                          'رقم الفاتورة: ${_bill.id} - اسم العميل : ${_bill.customerName} - اجمالي الفاتورة: ${_bill.total_price.toStringAsFixed(2)}',
                          operationNumber: 0,
                        );
                         _removeBill(dialogContext, _bill.id, report);
                        Navigator.of(dialogContext).pop(); // Close confirmation dialog
                        Navigator.of(context).pop(); // Close bill details
                      },
                      child: const Text('حذف', style: TextStyle(color: Colors.red)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: const Text('إلغاء'),
                    ),
                  ],
                );
              },
            );
          },
          child: const Text('حذف', style: TextStyle(color: Colors.red)),
        ),

        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إغلاق'),
        ),
      ],
    );
  }
}

Future<void> showBillDetailsDialog(BuildContext context, Bill bill) async {
  showDialog(
    context: context,
    builder: (context) {
      return BillDetailsDialog(bill: bill);
    },
  );
}
