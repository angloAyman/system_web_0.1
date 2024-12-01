// import 'package:flutter/material.dart';
// import 'package:system/features/billes/data/models/bill_model.dart';
//
// Future<void> showBillDetailsDialog(BuildContext context, Bill bill) async {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: Text('تفاصيل الفاتورة'),
//         content: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('رقم الفاتورة: ${bill.id}'),
//               Text('اسم العميل: ${bill.customerName}'),
//               Text('التاريخ: ${bill.date}'),
//               Text('حالة الدفع: ${bill.status}'),
//               SizedBox(height: 16),
//               Text('الأصناف:', style: TextStyle(fontWeight: FontWeight.bold)),
//               ...bill.items.map((item) {
//                 return ListTile(
//                   title: Text('${item.categoryName} / ${item.subcategoryName}'),
//                   subtitle: Text('الكمية: ${item.amount}, السعر: ${item.price}'),
//                 );
//               }).toList(),
//               Divider(),
//               Text(
//                 'الإجمالي: L.E ${bill.items.fold(0.0, (sum, item) => sum + (item.amount * item.price)).toStringAsFixed(2)}',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text('إغلاق'),
//           ),
//           TextButton(
//             onPressed: (){},
//             child: Text('تعديل'),
//           ),
//         ],
//       );
//     },
//   );
// }

import 'package:flutter/material.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/billes/data/repositories/bill_repository.dart';
import 'package:system/features/billes/presentation/BillingPage.dart';
import 'package:system/features/billes/presentation/Dialog/details-editing-pdf/PdfService.dart';
import 'package:system/features/billes/presentation/Dialog/details-editing-pdf/showEditItemDialog.dart';




Future<void> showBillDetailsDialog(BuildContext context, Bill bill) async {
  final BillRepository _billRepository = BillRepository();

  //
//   void _refreshBills() {
//     setState(() {
//       _billsFuture = _billRepository.getBills();
//       _billsFuture.then((bills) {
//         setState(() {
//           _bills = bills;
//           _filteredBills = bills;
//         });
//       });
//     });
//   }

  // Function to remove a bill
  void _removeBill(int billId) async {
    try {
      await _billRepository.removeBill(billId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bill removed successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing bill: $e')),
      );
    }
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('تفاصيل الفاتورة'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('رقم الفاتورة: ${bill.id}'),
              Text('اسم العميل: ${bill.customerName}'),
              Text('التاريخ: ${bill.date}'),
              Text('حالة الدفع: ${bill.status}'),
              SizedBox(height: 16),
              Text('تفاصيل الدفع:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('تفاصيل الدفع: ${bill.payment}'),
              SizedBox(height: 16),
              Text('الأصناف:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...bill.items.map((item) {
                return ListTile(
                  title: Text('${item.categoryName} / ${item.subcategoryName}'),
                  subtitle: Text('الكمية: ${item.amount}, السعر: ${item.price_per_unit}'),
                );
              }).toList(),
              Divider(),
              Text(
                'الإجمالي: L.E ${bill.items.fold(0.0, (sum, item) => sum + (item.amount * item.price_per_unit)).toStringAsFixed(2)}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('إغلاق'),
          ),
          TextButton(
            onPressed: () {
              // عند الضغط على تعديل، فتح نافذة التعديل
              showEditBillDialog(context, bill);
            },
            child: Text('تعديل'),
          ),
          TextButton(
            onPressed: () async {
              // عند الضغط على زر PDF، توليد PDF
              await PdfService.generatePdf(bill);
            },
            child: Text('PDF'),
          ),

          TextButton(
            onPressed: () {
              // تأكيد الحذف
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('تأكيد الحذف'),
                    content: Text('هل أنت متأكد من حذف الفاتورة؟'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('إلغاء'),
                      ),
                      TextButton(
                        onPressed: () {
                          // تنفيذ الحذف
                          _removeBill(bill.id as int);
                          Navigator.of(context).pop(); // إغلاق التأكيد
                          Navigator.of(context).pop(); // إغلاق التفاصيل
                        },
                        child: Text('حذف', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}
