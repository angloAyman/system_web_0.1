// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:supabase_flutter/supabase_flutter.dart';
// // // // // import 'package:system/features/billes/data/models/bill_model.dart';
// // // // // import 'package:system/features/billes/data/repositories/bill_repository.dart';
// // // // // import 'package:system/features/billes/presentation/Dialog/details-editing-pdf/item/showEditItemDialog.dart';
// // // // // import 'package:system/features/report/data/model/report_model.dart';
// // // // // import 'package:system/features/report/data/repository/report_repository.dart';
// // // // //
// // // // // Future<void> showEditBillDialog(BuildContext context, Bill bill) async {
// // // // //   final TextEditingController paymentController = TextEditingController(text: bill.payment.toString());
// // // // //   final List<BillItem> updatedItems = List.from(bill.items); // Clone items for editing.
// // // // //
// // // // //   void _updateBill() async {
// // // // //     try {
// // // // //       // Create updated Bill object
// // // // //       final updatedBill = Bill(
// // // // //         id: bill.id,
// // // // //         customerName: bill.customerName,
// // // // //         date: bill.date,
// // // // //         status: bill.status,
// // // // //         payment: double.tryParse(paymentController.text) ?? bill.payment,
// // // // //         items: updatedItems,
// // // // //         userId: bill.userId,
// // // // //         total_price: updatedItems.fold(0.0,
// // // // //                 (sum, item) => sum + (item.amount * item.price_per_unit)),
// // // // //         vault_id: bill.vault_id,
// // // // //       );
// // // // //
// // // // //       // Update bill in database
// // // // //       final BillRepository billRepository = BillRepository();
// // // // //       await billRepository.updateBill(updatedBill);
// // // // //
// // // // //       // Log the changes as a report
// // // // //       final user = Supabase.instance.client.auth.currentUser;
// // // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // // //         const SnackBar(content: Text('تم تحديث الفاتورة بنجاح')),
// // // // //       );
// // // // //       Navigator.of(context).pop(); // Close the dialog.
// // // // //     } catch (e) {
// // // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // // //         SnackBar(content: Text('خطأ أثناء تحديث الفاتورة: $e')),
// // // // //       );
// // // // //     }
// // // // //   }
// // // // //
// // // // //   showDialog(
// // // // //     context: context,
// // // // //     builder: (context) {
// // // // //       return AlertDialog(
// // // // //         title: const Text('تعديل الفاتورة'),
// // // // //         content: StatefulBuilder(
// // // // //           builder: (context, setState) {
// // // // //             return SingleChildScrollView(
// // // // //               child: Column(
// // // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // // //                 children: [
// // // // //                   // Edit Payment
// // // // //                   // TextField(
// // // // //                   //   controller: paymentController,
// // // // //                   //   keyboardType: TextInputType.number,
// // // // //                   //   decoration: const InputDecoration(
// // // // //                   //     labelText: 'تفاصيل الدفع',
// // // // //                   //     border: OutlineInputBorder(),
// // // // //                   //   ),
// // // // //                   // ),
// // // // //                   const SizedBox(height: 16),
// // // // //
// // // // //                   // Edit Items
// // // // //                   Text('الأصناف:', style: const TextStyle(fontWeight: FontWeight.bold)),
// // // // //                   // Add New Item
// // // // //                   SingleChildScrollView(
// // // // //                     scrollDirection: Axis.horizontal, // Enable horizontal scrolling if needed
// // // // //                     child: DataTable(
// // // // //                       columns: const [
// // // // //                         DataColumn(label: Text('الفئة / الفرعية')), // Category Name
// // // // //                         DataColumn(label: Text('الوصف')), // Subcategory Name
// // // // //                         DataColumn(label: Text('الكمية')), // Quantity
// // // // //                         DataColumn(label: Text(' السعر القطعة')), // Price per Unit
// // // // //                         DataColumn(label: Text('الإجراءات')), // Actions
// // // // //                       ],
// // // // //                       rows: updatedItems.asMap().entries.map((entry) {
// // // // //                         final index = entry.key;
// // // // //                         final item = entry.value;
// // // // //
// // // // //                         return DataRow(
// // // // //                           cells: [
// // // // //                             DataCell(Text('${item.categoryName} / ${item.subcategoryName}')), // Category Name
// // // // //                             DataCell(Text(item.description ?? 'غير متوفر')), // Subcategory Name
// // // // //                             DataCell(Text(item.quantity?.toString() ?? '0')), // Quantity
// // // // //                             DataCell(Text('\جنيه${(item.amount * item.price_per_unit)}'),),
// // // // //                             DataCell(
// // // // //                               Row(
// // // // //                                 children: [
// // // // //                                   IconButton(
// // // // //                                     icon: const Icon(Icons.edit, color: Colors.blue),
// // // // //                                     onPressed: () {
// // // // //                                       showEditItemDialog(
// // // // //                                         context: context,
// // // // //                                         item: item,
// // // // //                                         // onSave: (BillItem updatedItem) {
// // // // //                                         //   setState(() {
// // // // //                                         //     updatedItems[index] = updatedItem;
// // // // //                                         //   });
// // // // //                                         // },
// // // // //             onUpdateItem: (BillItem updatedItem ) {  setState(() {
// // // // //                                         updatedItems[index] = updatedItem;
// // // // //                                       }); },
// // // // //                                       );
// // // // //                                     },
// // // // //                                   ),
// // // // //                                   IconButton(
// // // // //                                     icon: const Icon(Icons.delete, color: Colors.red),
// // // // //                                     onPressed: () {
// // // // //                                       setState(() {
// // // // //                                         updatedItems.removeAt(index);
// // // // //                                       });
// // // // //                                     },
// // // // //                                   ),
// // // // //                                 ],
// // // // //                               ),
// // // // //                             ), // Action buttons
// // // // //                           ],
// // // // //                         );
// // // // //                       }).toList(),
// // // // //                     ),
// // // // //                   ),
// // // // //
// // // // //                   //إضافة صنف جديد
// // // // //                   TextButton(
// // // // //                     onPressed: () {
// // // // //                       showEditItemDialog(
// // // // //                         context: context,
// // // // //                         item: BillItem.empty(), // Create a blank item for new entry.
// // // // //                         // onSave: (BillItem newItem) {
// // // // //                         //   setState(() {
// // // // //                         //     updatedItems.add(newItem);
// // // // //                         //   });
// // // // //                         // },
// // // // //             onUpdateItem: (BillItem newItem ) {  setState(() {
// // // // //                         updatedItems.add(newItem);
// // // // //                       });},
// // // // //                       );
// // // // //                     },
// // // // //                     child: const Text('إضافة صنف جديد'),
// // // // //                   ),
// // // // //                 ],
// // // // //               ),
// // // // //             );
// // // // //           },
// // // // //         ),
// // // // //         actions: [
// // // // //           TextButton(
// // // // //             onPressed: () => Navigator.of(context).pop(),
// // // // //             child: const Text('إلغاء'),
// // // // //           ),
// // // // //           ElevatedButton(
// // // // //             onPressed: _updateBill,
// // // // //             child: const Text('حفظ التعديلات'),
// // // // //           ),
// // // // //         ],
// // // // //       );
// // // // //     },
// // // // //   );
// // // // // }
// // // // //
// // // // // // Helper to generate changes description for the report.
// // // // // String _generateItemChangesDescription(List<BillItem> oldItems, List<BillItem> newItems) {
// // // // //   final buffer = StringBuffer();
// // // // //   for (var i = 0; i < newItems.length; i++) {
// // // // //     if (i < oldItems.length) {
// // // // //       buffer.writeln(
// // // // //         'الصنف القديم: ${oldItems[i].categoryName}/${oldItems[i].subcategoryName}, '
// // // // //             'الكمية: ${oldItems[i].amount}, السعر: ${oldItems[i].price_per_unit} '
// // // // //             '=> الجديد: ${newItems[i].categoryName}/${newItems[i].subcategoryName}, '
// // // // //             'الكمية: ${newItems[i].amount}, السعر: ${newItems[i].price_per_unit}',
// // // // //       );
// // // // //     } else {
// // // // //       buffer.writeln(
// // // // //         'صنف جديد: ${newItems[i].categoryName}/${newItems[i].subcategoryName}, '
// // // // //             'الكمية: ${newItems[i].amount}, السعر: ${newItems[i].price_per_unit}',
// // // // //       );
// // // // //     }
// // // // //   }
// // // // //   return buffer.toString();
// // // // // }
// // //
// // import 'package:flutter/material.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart';
// // import 'package:system/features/billes/data/models/bill_model.dart';
// // import 'package:system/features/billes/data/repositories/bill_repository.dart';
// // import 'package:system/features/billes/presentation/Dialog/details-editing-pdf/item/showEditItemDialog.dart';
// // import 'package:system/features/report/data/model/report_model.dart';
// // import 'package:system/features/report/data/repository/report_repository.dart';
// // //
// // // Future<void> showEditBillDialog(BuildContext context, Bill bill) async {
// // //   final TextEditingController paymentController = TextEditingController(text: bill.payment.toString());
// // //   final List<BillItem> updatedItems = List.from(bill.items); // Clone items for editing.
// // //
// // //   // Update Bill function
// // //   void _updateBill() async {
// // //     try {
// // //       final updatedBill = Bill(
// // //         id: bill.id,
// // //         customerName: bill.customerName,
// // //         date: bill.date,
// // //         status: bill.status,
// // //         payment: double.tryParse(paymentController.text) ?? bill.payment,
// // //         items: updatedItems,
// // //         userId: bill.userId,
// // //         total_price: updatedItems.fold(0.0, (sum, item) => sum + (item.amount * item.price_per_unit)),
// // //         vault_id: bill.vault_id,
// // //       );
// // //
// // //       // Update bill in the database
// // //       final BillRepository billRepository = BillRepository();
// // //       await billRepository.updateBill(updatedBill);
// // //
// // //
// // //       // Update each bill item in the database
// // //       for (var updatedItem in updatedItems) {
// // //         await billRepository.updateBillItem(updatedItem.id, updatedItem);
// // //       }
// // //
// // //       // Success Message
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         const SnackBar(content: Text('تم تحديث الفاتورة بنجاح')),
// // //       );
// // //       Navigator.of(context).pop(); // Close the dialog
// // //     } catch (e) {
// // //       // Error Message
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(content: Text('خطأ أثناء تحديث الفاتورة: $e')),
// // //       );
// // //     }
// // //   }
// // //
// // //   showDialog(
// // //     context: context,
// // //     builder: (context) {
// // //       return AlertDialog(
// // //         title: const Text('تعديل الفاتورة'),
// // //         content: StatefulBuilder(
// // //           builder: (context, setState) {
// // //             return SingleChildScrollView(
// // //               child: Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   // Edit Items Table
// // //                   Text('الأصناف:', style: const TextStyle(fontWeight: FontWeight.bold)),
// // //                   SingleChildScrollView(
// // //                     scrollDirection: Axis.horizontal,
// // //                     child: DataTable(
// // //                       columns: const [
// // //                         DataColumn(label: Text('الفئة / الفرعية')), // Category Name
// // //                         DataColumn(label: Text('الوصف')), // Description
// // //                         DataColumn(label: Text('عدد الوحدات')), // Quantity
// // //                         DataColumn(label: Text('الكمية')), // Quantity
// // //                         DataColumn(label: Text('السعر القطعة')), // Price per Unit
// // //                         DataColumn(label: Text('السعر الوحدة')), // Price per Unit
// // //                         DataColumn(label: Text('الإجراءات')), // Actions
// // //                       ],
// // //                       rows: updatedItems.asMap().entries.map((entry) {
// // //                         final index = entry.key;
// // //                         final item = entry.value;
// // //
// // //                         return DataRow(
// // //                           cells: [
// // //                             DataCell(Text('${item.categoryName} / ${item.subcategoryName}')),
// // //                             DataCell(Text(item.description ?? 'غير متوفر')),
// // //                             DataCell(Text(item.amount?.toString() ?? '0')),
// // //                             DataCell(Text(item.quantity?.toString() ?? '0')),
// // //                             DataCell(Text(item.price_per_unit?.toString() ?? '0')),
// // //                             DataCell(Text('\جنيه${(item.amount * item.price_per_unit)}')),
// // //                             DataCell(
// // //                               Row(
// // //                                 children: [
// // //                                   IconButton(
// // //                                     icon: const Icon(Icons.edit, color: Colors.blue),
// // //                                     onPressed: () {
// // //                                       showEditItemDialog(
// // //                                         context: context,
// // //                                         item: item,
// // //                                         onUpdateItem: (BillItem updatedItem) {
// // //                                           setState(() {
// // //                                             updatedItems[index] = updatedItem;
// // //                                           });
// // //                                         },
// // //                                       );
// // //                                     },
// // //                                   ),
// // //                                   IconButton(
// // //                                     icon: const Icon(Icons.delete, color: Colors.red),
// // //                                     onPressed: () {
// // //                                       setState(() {
// // //                                         updatedItems.removeAt(index); // Remove the item
// // //                                       });
// // //                                     },
// // //                                   ),
// // //                                 ],
// // //                               ),
// // //                             ),
// // //                           ],
// // //                         );
// // //                       }).toList(),
// // //                     ),
// // //                   ),
// // //
// // //                   // Add New Item Button
// // //                   TextButton(
// // //                     onPressed: () {
// // //                       showEditItemDialog(
// // //                         context: context,
// // //                         item: BillItem.empty(), // Blank item for new entry
// // //                         onUpdateItem: (BillItem newItem) {
// // //                           setState(() {
// // //                             updatedItems.add(newItem); // Add new item to the list
// // //                           });
// // //                         },
// // //                       );
// // //                     },
// // //                     child: const Text('إضافة صنف جديد'),
// // //                   ),
// // //                 ],
// // //               ),
// // //             );
// // //           },
// // //         ),
// // //         actions: [
// // //           TextButton(
// // //             onPressed: () => Navigator.of(context).pop(),
// // //             child: const Text('إلغاء'),
// // //           ),
// // //           ElevatedButton(
// // //             onPressed: _updateBill,
// // //             child: const Text('حفظ التعديلات'),
// // //           ),
// // //         ],
// // //       );
// // //     },
// // //   );
// // // }
// // //
// // // // Helper to generate changes description for the report.
// // // String _generateItemChangesDescription(List<BillItem> oldItems, List<BillItem> newItems) {
// // //   final buffer = StringBuffer();
// // //   for (var i = 0; i < newItems.length; i++) {
// // //     if (i < oldItems.length) {
// // //       buffer.writeln(
// // //         'الصنف القديم: ${oldItems[i].categoryName}/${oldItems[i].subcategoryName}, '
// // //             'الكمية: ${oldItems[i].amount}, السعر: ${oldItems[i].price_per_unit} '
// // //             '=> الجديد: ${newItems[i].categoryName}/${newItems[i].subcategoryName}, '
// // //             'الكمية: ${newItems[i].amount}, السعر: ${newItems[i].price_per_unit}',
// // //       );
// // //     } else {
// // //       buffer.writeln(
// // //         'صنف جديد: ${newItems[i].categoryName}/${newItems[i].subcategoryName}, '
// // //             'الكمية: ${newItems[i].amount}, السعر: ${newItems[i].price_per_unit}',
// // //       );
// // //     }
// // //   }
// // //   return buffer.toString();
// // // }
// // //
// // // // import 'package:flutter/material.dart';
// // // // import 'package:system/features/billes/data/models/bill_model.dart';
// // // //
// // // // Future<Bill?> showEditBillDialog(BuildContext context, Bill bill) async {
// // // //   // final TextEditingController paymentController = TextEditingController(text: bill.payment.toString());
// // // //   final List<BillItem> updatedItems = List.from(bill.items);
// // // //
// // // //   // The return statement gives back the updated bill after editing
// // // //   return await showDialog<Bill>(
// // // //     context: context,
// // // //     builder: (context) {
// // // //       return AlertDialog(
// // // //         title: const Text('تعديل الفاتورة'),
// // // //         content: StatefulBuilder(
// // // //           builder: (context, setState) {
// // // //             return SingleChildScrollView(
// // // //               child: Column(
// // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // //                 children: [
// // // //                   // Add other widgets for editing
// // // //                   // TextField(
// // // //                   //   // controller: paymentController,
// // // //                   //   keyboardType: TextInputType.number,
// // // //                   //   decoration: const InputDecoration(
// // // //                   //     labelText: 'تفاصيل الدفع',
// // // //                   //     border: OutlineInputBorder(),
// // // //                   //   ),
// // // //                   // ),
// // // //                   const SizedBox(height: 16),
// // // //                   // Your other widgets for editing the bill's items
// // // //                 ],
// // // //               ),
// // // //             );
// // // //           },
// // // //         ),
// // // //         actions: [
// // // //           TextButton(
// // // //             onPressed: () => Navigator.of(context).pop(), // Close dialog
// // // //             child: const Text('إلغاء'),
// // // //           ),
// // // //           ElevatedButton(
// // // //             onPressed: () {
// // // //               final updatedBill = Bill(
// // // //                 id: bill.id,
// // // //                 customerName: bill.customerName,
// // // //                 date: bill.date,
// // // //                 status: bill.status,
// // // //                 payment:  bill.payment,
// // // //                 items: updatedItems,
// // // //                 userId: bill.userId,
// // // //                 total_price: updatedItems.fold(0.0, (sum, item) => sum + (item.amount * item.price_per_unit)),
// // // //                 vault_id: bill.vault_id,
// // // //               );
// // // //               Navigator.of(context).pop(updatedBill); // Return the updated bill
// // // //             },
// // // //             child: const Text('حفظ التعديلات'),
// // // //           ),
// // // //         ],
// // // //       );
// // // //     },
// // // //   );
// // // // }
// // Future<void> showEditBillDialog(BuildContext context, Bill bill) async {
// //   final TextEditingController paymentController = TextEditingController(text: bill.payment.toString());
// //   final updatedItems = List<BillItem>.from(bill.items);
// //
// //   // Update Bill function
// //   Future<void> _updateBill()  async {
// //     try {
// //       final updatedBill = Bill(
// //         id: bill.id,
// //         customerName: bill.customerName,
// //         date: bill.date,
// //         status: bill.status,
// //         payment: double.tryParse(paymentController.text) ?? bill.payment,
// //         items: updatedItems,
// //         userId: bill.userId,
// //         total_price: updatedItems.fold(0.0, (sum, item) => sum + item.price_per_unit * item.quantity),
// //         vault_id: bill.vault_id,
// //       );
// //
// //       final repository = BillRepository();
// //       await repository.updateBill(updatedBill);
// //       // await repository.getBills();
// //
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('تم تحديث الفاتورة بنجاح')),
// //       );
// //       Navigator.of(context).pop(updatedBill); // Close dialog
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('خطأ أثناء تحديث الفاتورة: $e')),
// //       );
// //     }
// //   }
// //   showDialog(
// //     context: context,
// //     builder: (context) {
// //       return AlertDialog(
// //         title: const Text('تعديل الفاتورة'),
// //         content: StatefulBuilder(
// //           builder: (context, setState) {
// //             return SingleChildScrollView(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   // Edit Items Table
// //                   Text('الأصناف:', style: const TextStyle(fontWeight: FontWeight.bold)),
// //                   SingleChildScrollView(
// //                     scrollDirection: Axis.horizontal,
// //                     child: DataTable(
// //                       columns: const [
// //                         DataColumn(label: Text('الفئة / الفرعية')), // Category Name
// //                         DataColumn(label: Text('الوصف')), // Description
// //                         DataColumn(label: Text('عدد الوحدات')), // Quantity
// //                         DataColumn(label: Text('الكمية')), // Quantity
// //                         DataColumn(label: Text('السعر القطعة')), // Price per Unit
// //                         DataColumn(label: Text('السعر الوحدة')), // Price per Unit
// //                         DataColumn(label: Text('الإجراءات')), // Actions
// //                       ],
// //                       rows: updatedItems.asMap().entries.map((entry) {
// //                         final index = entry.key;
// //                         final item = entry.value;
// //
// //                         return DataRow(
// //                           cells: [
// //                             DataCell(Text('${item.categoryName} / ${item.subcategoryName}')),
// //                             DataCell(Text(item.description ?? 'غير متوفر')),
// //                             DataCell(Text(item.amount?.toString() ?? '0')),
// //                             DataCell(Text(item.quantity?.toString() ?? '0')),
// //                             DataCell(Text(item.price_per_unit?.toString() ?? '0')),
// //                             DataCell(Text('\جنيه${(item.amount * item.price_per_unit)}')),
// //                             DataCell(
// //                               Row(
// //                                 children: [
// //                                   IconButton(
// //                                     icon: const Icon(Icons.edit, color: Colors.blue),
// //                                     onPressed: () {
// //                                       showEditItemDialog(
// //                                         context: context,
// //                                         item: item,
// //                                         onUpdateItem: (updatedItem) {
// //                                           setState(() {
// //                                             updatedItems[index] = updatedItem;
// //                                             // BillRepository().getBills();
// //                                             // Update bill in the database
// //                                           });
// //                                         },
// //                                       );
// //                                     },
// //                                   ),
// //                                   IconButton(
// //                                     icon: const Icon(Icons.delete, color: Colors.red),
// //                                     onPressed: () {
// //                                       setState(() {
// //                                         updatedItems.removeAt(index); // Remove the item
// //                                       });
// //                                     },
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //                           ],
// //                         );
// //                       }).toList(),
// //                     ),
// //                   ),
// //
// //                   // Add New Item Button
// //                   TextButton(
// //                     onPressed: () {
// //                       showEditItemDialog(
// //                         context: context,
// //                         item: BillItem(
// //                           categoryName: '',
// //                           subcategoryName: '',
// //                           amount: 0.0,
// //                           price_per_unit: 0.0,
// //                           quantity: 0.0,
// //                           description: '',
// //                         ), // Create a new BillItem instance
// //                         onUpdateItem: (newItem) {
// //                           setState(() {
// //                             updatedItems.add(newItem); // Add new item to the list
// //                           });
// //                         },
// //                       );
// //
// //                     },
// //                     child: const Text('إضافة صنف جديد'),
// //                   ),
// //
// //                 ],
// //               ),
// //             );
// //           },
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.of(context).pop(),
// //             child: const Text('إلغاء'),
// //           ),
// //           ElevatedButton(
// //             onPressed:(){
// //               _updateBill();
// //               BillRepository().getBills();
// //       },
// //             child: const Text('حفظ التعديلات'),
// //           ),
// //         ],
// //       );
// //     },
// //   );
// // }
// import 'package:flutter/material.dart';
// import 'package:system/features/billes/data/models/bill_model.dart';
// import 'package:system/features/billes/data/repositories/bill_repository.dart';
// import 'package:system/features/billes/presentation/Dialog/details-editing-pdf/item/showEditItemDialog.dart';
//
// Future<void> showEditBillDialog(BuildContext context, Bill bill) async {
//   final TextEditingController paymentController = TextEditingController(text: bill.payment.toString());
//   final updatedItems = List<BillItem>.from(bill.items);
//
//   // Update Bill function
//   Future<void> _updateBill() async {
//     try {
//       final updatedBill = Bill(
//         id: bill.id,
//         customerName: bill.customerName,
//         date: bill.date,
//         status: bill.status,
//         payment: double.tryParse(paymentController.text) ?? bill.payment,
//         items: updatedItems,
//         userId: bill.userId,
//         total_price: updatedItems.fold(0.0, (sum, item) => sum + item.price_per_unit * item.quantity),
//         vault_id: bill.vault_id,
//       );
//
//       final repository = BillRepository();
//       await repository.updateBill(updatedBill);
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('تم تحديث الفاتورة بنجاح')),
//       );
//       Navigator.of(context).pop(updatedBill); // Close dialog and pass updated bill back
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('خطأ أثناء تحديث الفاتورة: $e')),
//       );
//     }
//   }
//
//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: const Text('تعديل الفاتورة'),
//         content: StatefulBuilder(
//           builder: (context, setState) {
//             return SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Edit Items Table
//                   Text('الأصناف:', style: const TextStyle(fontWeight: FontWeight.bold)),
//                   SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: DataTable(
//                       columns: const [
//                         DataColumn(label: Text('الفئة / الفرعية')), // Category Name
//                         DataColumn(label: Text('الوصف')), // Description
//                         DataColumn(label: Text('عدد الوحدات')), // Quantity
//                         DataColumn(label: Text('الكمية')), // Quantity
//                         DataColumn(label: Text('السعر القطعة')), // Price per Unit
//                         DataColumn(label: Text('السعر الوحدة')), // Price per Unit
//                         DataColumn(label: Text('الإجراءات')), // Actions
//                       ],
//                       rows: updatedItems.asMap().entries.map((entry) {
//                         final index = entry.key;
//                         final item = entry.value;
//
//                         return DataRow(
//                           cells: [
//                             DataCell(Text('${item.categoryName} / ${item.subcategoryName}')),
//                             DataCell(Text(item.description ?? 'غير متوفر')),
//                             DataCell(Text(item.amount?.toString() ?? '0')),
//                             DataCell(Text(item.quantity?.toString() ?? '0')),
//                             DataCell(Text(item.price_per_unit?.toString() ?? '0')),
//                             DataCell(Text('\جنيه${(item.amount * item.price_per_unit)}')),
//                             DataCell(
//                               Row(
//                                 children: [
//                                   IconButton(
//                                     icon: const Icon(Icons.edit, color: Colors.blue),
//                                     onPressed: () {
//                                       showEditItemDialog(
//                                         context: context,
//                                         item: item,
//                                         onUpdateItem: (updatedItem) {
//                                           setState(() {
//                                             updatedItems[index] = updatedItem;
//                                           });
//                                         },
//                                       );
//                                     },
//                                   ),
//                                   IconButton(
//                                     icon: const Icon(Icons.delete, color: Colors.red),
//                                     onPressed: () {
//                                       setState(() {
//                                         updatedItems.removeAt(index); // Remove the item
//                                       });
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         );
//                       }).toList(),
//                     ),
//                   ),
//
//                   // Add New Item Button
//                   TextButton(
//                     onPressed: () {
//                       showEditItemDialog(
//                         context: context,
//                         item: BillItem(
//                           categoryName: '',
//                           subcategoryName: '',
//                           amount: 0.0,
//                           price_per_unit: 0.0,
//                           quantity: 0.0,
//                           description: '',
//                         ),
//                         onUpdateItem: (newItem) {
//                           setState(() {
//                             updatedItems.add(newItem); // Add new item to the list
//                           });
//                         },
//                       );
//                     },
//                     child: const Text('إضافة صنف جديد'),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('إلغاء'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               _updateBill(); // Update bill in database and close dialog
//               // You may want to fetch updated bills here if needed
//               // BillRepository().getBills();
//             },
//             child: const Text('حفظ التعديلات'),
//           ),
//         ],
//       );
//     },
//   );
// }
import 'package:flutter/material.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/billes/data/repositories/bill_repository.dart';
import 'package:system/features/billes/presentation/Dialog/details-editing-pdf/item/showEditItemDialog.dart';

Future<Bill?> showEditBillDialog(BuildContext context, Bill bill) async {
  final TextEditingController paymentController = TextEditingController(text: bill.payment.toString());
  final updatedItems = List<BillItem>.from(bill.items);

  // Update Bill function
  Future<void> _updateBill() async {
    try {
      final updatedBill = Bill(
        id: bill.id,
        customerName: bill.customerName,
        date: bill.date,
        status: bill.status,
        payment: double.tryParse(paymentController.text) ?? bill.payment,
        items: updatedItems,
        userId: bill.userId,
        total_price: updatedItems.fold(0.0, (sum, item) => sum + item.price_per_unit * item.quantity),
        vault_id: bill.vault_id,
      );

      final repository = BillRepository();
      await repository.updateBill(updatedBill);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تحديث الفاتورة بنجاح')),
      );
      Navigator.of(context).pop(updatedBill); // Close dialog and pass updated bill back
      Navigator.of(context).pop();// Close dialog and pass updated bill back
      repository.getBills();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ أثناء تحديث الفاتورة: $e')),
      );
    }
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('تعديل الفاتورة'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Edit Items Table
                  Text('الأصناف:', style: const TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('الفئة / الفرعية')), // Category Name
                        DataColumn(label: Text('الوصف')), // Description
                        DataColumn(label: Text('عدد الوحدات')), // Quantity
                        DataColumn(label: Text('الكمية')), // Quantity
                        DataColumn(label: Text('السعر القطعة')), // Price per Unit
                        DataColumn(label: Text('السعر الوحدة')), // Price per Unit
                        DataColumn(label: Text('الإجراءات')), // Actions
                      ],
                      rows: updatedItems.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;

                        return DataRow(
                          cells: [
                            DataCell(Text('${item.categoryName} / ${item.subcategoryName}')),
                            DataCell(Text(item.description ?? 'غير متوفر')),
                            DataCell(Text(item.amount?.toString() ?? '0')),
                            DataCell(Text(item.quantity?.toString() ?? '0')),
                            DataCell(Text(item.price_per_unit?.toString() ?? '0')),
                            DataCell(Text('\جنيه${(item.amount * item.price_per_unit)}')),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      showEditItemDialog(
                                        context: context,
                                        item: item,
                                        onUpdateItem: (updatedItem) {
                                          setState(() {
                                            updatedItems[index] = updatedItem;
                                          });
                                        },
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        updatedItems.removeAt(index); // Remove the item
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),

                  // Add New Item Button
                  TextButton(
                    onPressed: () {
                      showEditItemDialog(
                        context: context,
                        item: BillItem(
                          categoryName: '',
                          subcategoryName: '',
                          amount: 0.0,
                          price_per_unit: 0.0,
                          quantity: 0.0,
                          description: '',
                          discount: 0.0,
                        ), // Create a new BillItem instance
                        onUpdateItem: (newItem) {
                          setState(() {
                            updatedItems.add(newItem); // Add new item to the list
                          });
                        },
                      );
                    },
                    child: const Text('إضافة صنف جديد'),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed:(){
              _updateBill();
              },
            child: const Text('حفظ التعديلات'),
          ),
        ],
      );
    },
  );
  return null; // Add this return statement if nothing else is returned from the dialog
}
