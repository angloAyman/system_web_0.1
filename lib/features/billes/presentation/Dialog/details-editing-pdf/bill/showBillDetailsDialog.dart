import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/Vaults/data/repositories/supabase_vault_repository.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/billes/data/repositories/bill_repository.dart';
import 'package:system/features/billes/presentation/Dialog/adding/item/showAddItemDialog.dart';
import 'package:system/features/billes/presentation/Dialog/details-editing-pdf/bill/showEditBillDialog.dart';
import 'package:system/features/billes/presentation/pdf/presentation/show_pdf_preview_dialog.dart';
import 'package:system/features/report/data/model/report_model.dart';
import 'package:system/features/report/data/repository/report_repository.dart';
import 'package:system/main_screens/Responsive/AdminHomeResponsive.dart';

import '../../adding/bill/AddbillPaymentPage.dart';

class BillDetailsDialog extends StatefulWidget {
  final Bill bill;

  const BillDetailsDialog({Key? key, required this.bill}) : super(key: key);

  @override
  _BillDetailsDialogState createState() => _BillDetailsDialogState();
}

class _BillDetailsDialogState extends State<BillDetailsDialog> {
  late Bill _bill;
  final List<BillItem> items = [];
  double _totalPrice = 0.0; // Initialize total price
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _bill = widget.bill;
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  double calculateTotalPrice({
    required double total_Item_price,
  }) {
    double totalPrice = total_Item_price;
    return totalPrice;
  }



  // Function to remove a bill
  // Future<bool> _removeBill(
  //     BuildContext context, int billId,String vault_id ,double billPayment, Report report) async {
  //   final BillRepository _billRepository = BillRepository();
  //   final ReportRepository _reportRepository = ReportRepository();
  //   final SupabaseVaultRepository _vaultRepository = SupabaseVaultRepository();
  //
  //
  //   try {
  //     // Remove the bill from the database
  //     _billRepository.removeBill(billId);
  //
  //     // Add the report to the system
  //     _reportRepository.addReport(report);
  //
  //     final double currentBalance = await _vaultRepository.getVaultBalance(vault_id);
  //
  //
  //     // final double currentBalance = (vault['balance'] ?? 0).toDouble();
  //     final double updatedBalance = currentBalance - billPayment;
  //     await _vaultRepository.subtractFromVaultBalance2(vault_id, updatedBalance);
  //
  //     // Ensure the widget is still mounted before accessing context
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('تم حذف الفاتورة بنجاح.....')),
  //       );
  //       // Navigator.of(context).pop(); // Close the details dialog
  //     }
  //   } catch (e) {
  //     // Ensure the widget is still mounted before accessing context
  //     if (mounted) {
  //       print('خطا في حذف الفاتورة: $e');
  //       // ScaffoldMessenger.of(context).showSnackBar(
  //       //   SnackBar(content: Text('خطا في حذف الفاتورة: $e')),
  //       // );
  //     }
  //   }
  //   return mounted ;
  // }

  Future<bool> _removeBill(
      BuildContext context,
      int billId,
      String vault_id,
      double billPayment,
      Report report,
      ) async {
    final BillRepository _billRepository = BillRepository();
    final ReportRepository _reportRepository = ReportRepository();
    final SupabaseVaultRepository _vaultRepository = SupabaseVaultRepository();

    try {


      // 1. خصم الدفعه من الرصيد
      final success = await _vaultRepository.subtractFromVaultBalance2(
        vault_id,
        billPayment,
      );

      if (!success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('⚠️ الرصيد غير كافي أو حدث خطأ في خصم المبلغ. لم يتم حذف الفاتورة.')),
          );
        }
        return false; // ❌ نوقف العملية هنا
      }

      // 1. احذف الفاتورة
      await _billRepository.removeBill(billId);

      // 2. سجل تقرير العملية
      await _reportRepository.addReport(report);



      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حذف الفاتورة بنجاح.....')),
        );
      }

      return true; // ✅ نجحت العملية
    } catch (e) {
      if (mounted) {
        print('خطا في حذف الفاتورة: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطا في حذف الفاتورة: $e')),
        );
      }
      return false; // ❌ فشلت العملية
    }
  }


  Future<bool> showAddPaymentDialog(
      BuildContext context,
      int billId,
      double payment,
      String customerName,
      DateTime billDate,
      double total_price,
      ) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AddPaymentDialog(
          billId: billId,
          payment: payment,
          customerName: customerName,
          billDate: billDate,
          total_price: total_price,

        );
      },
    ) ??
        false ;
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
  // Function to open the edit bill dialog
  void _openDeleteBillDialog() {
          showDialog(
            context: context,
            builder: (dialogContext) {
              return AlertDialog(
                title: const Text('تأكيد الحذف'),
                content: const Text('هل أنت متأكد من حذف الفاتورة؟'),
                actions: [
                  TextButton(
                    onPressed: () async {
                      // final user = Supabase.instance.client.auth.currentUser;
                      final user = Supabase.instance.client.auth.currentUser!;
                      final userData = await Supabase.instance.client
                          .from('users')
                          .select('name')
                          .eq('id', user.id)
                          .maybeSingle();


                      final report = Report(
                        id: user!.id,
                        title: "حذف فاتورة",
                        // user_id: user.id,
                        user_name: userData?['name'] ?? "مجهول", // 👈 من جدول users

                        date: DateTime.now(),
                        description:
                            'رقم الفاتورة: ${_bill.id} - اسم العميل : ${_bill.customerName} - اجمالي الفاتورة: ${_bill.total_price.toStringAsFixed(2)}',
                        operationNumber: 0,
                      );

                      bool result =await _removeBill(
                          dialogContext,
                          _bill.id,
                          _bill.vault_id,
                          // _bill.payment,
                          (_bill.payment as num).toDouble(), // 👈 مهم
                          report
                      );


                      if (result) {
                        setState(() {
                          Navigator.of(dialogContext).pop(); // Close confirmation dialog
                          Navigator.of(context).pop(); // Close bill details
                        }); // Refresh UI only after async work is completed
                      }

                    },
                    child: const Text('حذف',
                        style: TextStyle(color: Colors.red)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: const Text('إلغاء'),
                  ),
                ],
              );
            },
          );
        }

  Future<List<Map<String, dynamic>>> _fetchPayments(int billId) async {
    final response = await Supabase.instance.client
        .from('payment')
        .select('*, users(name)')
        .eq('bill_id', billId)
        .order('date', ascending: false);

    if (response == null) {
      throw Exception('Failed to fetch payments: ${response}');
    }

    return List<Map<String, dynamic>>.from(response ?? []);
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
            Text(
                'التاريخ: ${_bill.date.year}/${_bill.date.month}/${_bill.date.day}'),
            Text('حالة الدفع: ${_bill.status}'),
            const SizedBox(height: 16),
            Text('تفاصيل الدفع:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            // Fetch and display payments
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchPayments(_bill.id),
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

                // Method to format date to DD/MM/YYYY format
                String _formatDate(dynamic date) {
                  if (date is DateTime) {
                    return '${date.day.toString().padLeft(2, '0')}/'
                        '${date.month.toString().padLeft(2, '0')}/'
                        '${date.year}';
                  } else if (date is String) {
                    // If the date is already a string in a known format (like 'YYYY-MM-DD'), you can parse it
                    final parsedDate = DateTime.tryParse(date);
                    if (parsedDate != null) {
                      return '${parsedDate.day.toString().padLeft(2, '0')}/'
                          '${parsedDate.month.toString().padLeft(2, '0')}/'
                          '${parsedDate.year}';
                    }
                  }
                  return 'غير محدد'; // Return a default value if the date is invalid
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: payments.map((payment) {
                        final userName = payment['users']?['name'] ??
                            'غير معروف'; // Fetch user_name
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            'المبلغ: ${payment['payment']} جنيه مصري-'
                            ' التاريخ: ${_formatDate(payment['date'])} -'
                            ' المستخدم: $userName',
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    // Add spacing between the payment list and total
                    Text(
                      'إجمالي المدفوعات: ${totalPayment.toStringAsFixed(2)} جنيه مصري',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 16),
            const Text('الأصناف:',
                style: TextStyle(fontWeight: FontWeight.bold)),

            Scrollbar(
              controller: _verticalScrollController,
              thumbVisibility: true, // Show scrollbar for better UX
              interactive: true,
              child: SingleChildScrollView(
                controller: _verticalScrollController,// Vertical scrolling
                scrollDirection: Axis.vertical,
                child: Scrollbar(
                  controller: _horizontalScrollController,
                  thumbVisibility: true,
                  interactive: true,
                  child: SingleChildScrollView(
                    controller: _horizontalScrollController,
                    scrollDirection: Axis.horizontal,
                    // Horizontal scrolling
                    child: DataTable(
                      headingTextStyle: TextStyle(color: Colors.cyan),
                      columns: const [
                        DataColumn(label: Text('الفئة/الفرعية')),
                        // Category Name/description
                        DataColumn(label: Text('وصف')),
                        // Description
                        DataColumn(label: Text('سعر الوحدة')),
                        // Price per unit
                        DataColumn(label: Text('عدد الوحدات')),
                        // Quantity
                        DataColumn(label: Text('سعر القطعة')),
                        // price_per_unit * amount
                        DataColumn(label: Text('الكمية')),
                        // Quantity
                        DataColumn(label: Text('قيمة الخصم')),
                        // Discount Value
                        DataColumn(label: Text('نوع الخصم')),
                        // Discount Type
                        DataColumn(label: Text('السعر')),
                        // Price
                      ],
                      rows: _bill.items.map((item) {
                        return DataRow(
                          cells: [
                            DataCell(Text(
                                '${item.categoryName} / ${item.subcategoryName}')),
                            DataCell(Text(item.description ?? 'غير متوفر')),
                            DataCell(Text(item.price_per_unit.toString())),
                            DataCell(Text(item.amount.toString())),
                            DataCell(Text(
                                '\جنيه${(item.amount * item.price_per_unit)}')),
                            DataCell(Text(item.quantity.toString())),
                            DataCell(Text(item.discount.toString())),
                            DataCell(Text(item.discountType.toString())),
                            DataCell(
                              Text(
                                calculateTotalPrice(
                                  total_Item_price: item.total_Item_price,
                                ).toString(),
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),

            const Divider(),

            Text(
              'الإجمالي:   ${_bill.items.fold(0.0, (sum, item) {
                return sum +
                    calculateTotalPrice(

                      total_Item_price: item.total_Item_price,
                    );
              })} جنيه مصري فقط لا غير   ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),

      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                _openEditBillDialog();
                break;
              case 'pdf':
                showPdfPreviewDialog(context, _bill);
                break;
              case 'delete':
                _openDeleteBillDialog();
              //     break;
              case 'payment':
                showAddPaymentDialog(
                    context,
                    _bill.id,
                    _bill.payment,
                    _bill.customerName,
                    _bill.date,
                    _bill.total_price);
                break;

            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(value: 'edit', child: Text('تعديل')),
            PopupMenuItem(value: 'pdf', child: Text('PDF')),
            PopupMenuItem(value: 'delete', child: Text('حذف')),
            PopupMenuItem(value: 'payment', child: Text('اضافة دفع')),
          ],
        ),

        TextButton(
          onPressed: () => Navigator.pop(context), // إغلاق الـ Dialog
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
// actions: [
//   TextButton(
//     onPressed: _openEditBillDialog,
//     child: const Text(
//       'تعديل',
//       style: TextStyle(color: Colors.cyan),
//     ),
//   ),
//   TextButton(
//     onPressed: () async {
//       await showPdfPreviewDialog(context, _bill);
//     },
//     child: const Text('PDF'),
//   ),
//   TextButton(
//     onPressed: () {
//       showDialog(
//         context: context,
//         builder: (dialogContext) {
//           return AlertDialog(
//             title: const Text('تأكيد الحذف'),
//             content: const Text('هل أنت متأكد من حذف الفاتورة؟'),
//             actions: [
//               TextButton(
//                 onPressed: () async {
//                   final user = Supabase.instance.client.auth.currentUser;
//                   final report = Report(
//                     id: user!.id,
//                     title: "حذف فاتورة",
//                     user_name: user.id,
//                     date: DateTime.now(),
//                     description:
//                         'رقم الفاتورة: ${_bill.id} - اسم العميل : ${_bill.customerName} - اجمالي الفاتورة: ${_bill.total_price.toStringAsFixed(2)}',
//                     operationNumber: 0,
//                   );
//
//                   bool result =await _removeBill(dialogContext, _bill.id,_bill.vault_id,_bill.payment, report);
//
//
//                   if (result) {
//                     setState(() async {
//                       Navigator.of(dialogContext).pop(); // Close confirmation dialog
//                       Navigator.of(context).pop(); // Close bill details
//                     }); // Refresh UI only after async work is completed
//                   }
//
//                 },
//                 child: const Text('حذف',
//                     style: TextStyle(color: Colors.red)),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.of(dialogContext).pop(),
//                 child: const Text('إلغاء'),
//               ),
//             ],
//           );
//         },
//       );
//     },
//     child: const Text('حذف', style: TextStyle(color: Colors.red)),
//   ),
//   ElevatedButton(
//     onPressed: () async {
//       bool result = await showAddPaymentDialog(
//           context,
//           _bill.id,
//           _bill.payment,
//           _bill.customerName,
//           _bill.date ,
//           _bill.total_price);
//
//       if (result) {
//         setState(() async {
//                         // fetchBills();
//         }); // Refresh UI only after async work is completed
//       }
//
//     },
//     child: const Text('اضافة دفع للفاتورة'),
//   ),
//
//   TextButton(
//     onPressed: () {
//       // Navigator.defaultRouteName;
//       Navigator.of(context).push(MaterialPageRoute(
//         builder: (context) => adminHomeResponsive(),
//       ));
//     },
//     child: const Text('إغلاق'),
//   ),
// ],