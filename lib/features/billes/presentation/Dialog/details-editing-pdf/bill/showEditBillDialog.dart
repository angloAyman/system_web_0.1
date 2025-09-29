// // // // // // import 'package:flutter/material.dart';
// // // // // // import 'package:supabase_flutter/supabase_flutter.dart';
// // // // // // import 'package:system/features/billes/data/models/bill_model.dart';
// // // // // // import 'package:system/features/billes/data/repositories/bill_repository.dart';
// // // // // // import 'package:system/features/billes/presentation/Dialog/details-editing-pdf/item/showEditItemDialog.dart';
// // // // // // import 'package:system/features/report/data/model/report_model.dart';
// // // // // // import 'package:system/features/report/data/repository/report_repository.dart';
// // // // // //
// // // // // // Future<void> showEditBillDialog(BuildContext context, Bill bill) async {
// // // // // //   final TextEditingController paymentController = TextEditingController(text: bill.payment.toString());
// // // // // //   final List<BillItem> updatedItems = List.from(bill.items); // Clone items for editing.
// // // // // //
// // // // // //   void _updateBill() async {
// // // // // //     try {
// // // // // //       // Create updated Bill object
// // // // // //       final updatedBill = Bill(
// // // // // //         id: bill.id,
// // // // // //         customerName: bill.customerName,
// // // // // //         date: bill.date,
// // // // // //         status: bill.status,
// // // // // //         payment: double.tryParse(paymentController.text) ?? bill.payment,
// // // // // //         items: updatedItems,
// // // // // //         userId: bill.userId,
// // // // // //         total_price: updatedItems.fold(0.0,
// // // // // //                 (sum, item) => sum + (item.amount * item.price_per_unit)),
// // // // // //         vault_id: bill.vault_id,
// // // // // //       );
// // // // // //
// // // // // //       // Update bill in database
// // // // // //       final BillRepository billRepository = BillRepository();
// // // // // //       await billRepository.updateBill(updatedBill);
// // // // // //
// // // // // //       // Log the changes as a report
// // // // // //       final user = Supabase.instance.client.auth.currentUser;
// // // // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // // // //         const SnackBar(content: Text('تم تحديث الفاتورة بنجاح')),
// // // // // //       );
// // // // // //       Navigator.of(context).pop(); // Close the dialog.
// // // // // //     } catch (e) {
// // // // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // // // //         SnackBar(content: Text('خطأ أثناء تحديث الفاتورة: $e')),
// // // // // //       );
// // // // // //     }
// // // // // //   }
// // // // // //
// // // // // //   showDialog(
// // // // // //     context: context,
// // // // // //     builder: (context) {
// // // // // //       return AlertDialog(
// // // // // //         title: const Text('تعديل الفاتورة'),
// // // // // //         content: StatefulBuilder(
// // // // // //           builder: (context, setState) {
// // // // // //             return SingleChildScrollView(
// // // // // //               child: Column(
// // // // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //                 children: [
// // // // // //                   // Edit Payment
// // // // // //                   // TextField(
// // // // // //                   //   controller: paymentController,
// // // // // //                   //   keyboardType: TextInputType.number,
// // // // // //                   //   decoration: const InputDecoration(
// // // // // //                   //     labelText: 'تفاصيل الدفع',
// // // // // //                   //     border: OutlineInputBorder(),
// // // // // //                   //   ),
// // // // // //                   // ),
// // // // // //                   const SizedBox(height: 16),
// // // // // //
// // // // // //                   // Edit Items
// // // // // //                   Text('الأصناف:', style: const TextStyle(fontWeight: FontWeight.bold)),
// // // // // //                   // Add New Item
// // // // // //                   SingleChildScrollView(
// // // // // //                     scrollDirection: Axis.horizontal, // Enable horizontal scrolling if needed
// // // // // //                     child: DataTable(
// // // // // //                       columns: const [
// // // // // //                         DataColumn(label: Text('الفئة / الفرعية')), // Category Name
// // // // // //                         DataColumn(label: Text('الوصف')), // Subcategory Name
// // // // // //                         DataColumn(label: Text('الكمية')), // Quantity
// // // // // //                         DataColumn(label: Text(' السعر القطعة')), // Price per Unit
// // // // // //                         DataColumn(label: Text('الإجراءات')), // Actions
// // // // // //                       ],
// // // // // //                       rows: updatedItems.asMap().entries.map((entry) {
// // // // // //                         final index = entry.key;
// // // // // //                         final item = entry.value;
// // // // // //
// // // // // //                         return DataRow(
// // // // // //                           cells: [
// // // // // //                             DataCell(Text('${item.categoryName} / ${item.subcategoryName}')), // Category Name
// // // // // //                             DataCell(Text(item.description ?? 'غير متوفر')), // Subcategory Name
// // // // // //                             DataCell(Text(item.quantity?.toString() ?? '0')), // Quantity
// // // // // //                             DataCell(Text('\جنيه${(item.amount * item.price_per_unit)}'),),
// // // // // //                             DataCell(
// // // // // //                               Row(
// // // // // //                                 children: [
// // // // // //                                   IconButton(
// // // // // //                                     icon: const Icon(Icons.edit, color: Colors.blue),
// // // // // //                                     onPressed: () {
// // // // // //                                       showEditItemDialog(
// // // // // //                                         context: context,
// // // // // //                                         item: item,
// // // // // //                                         // onSave: (BillItem updatedItem) {
// // // // // //                                         //   setState(() {
// // // // // //                                         //     updatedItems[index] = updatedItem;
// // // // // //                                         //   });
// // // // // //                                         // },
// // // // // //             onUpdateItem: (BillItem updatedItem ) {  setState(() {
// // // // // //                                         updatedItems[index] = updatedItem;
// // // // // //                                       }); },
// // // // // //                                       );
// // // // // //                                     },
// // // // // //                                   ),
// // // // // //                                   IconButton(
// // // // // //                                     icon: const Icon(Icons.delete, color: Colors.red),
// // // // // //                                     onPressed: () {
// // // // // //                                       setState(() {
// // // // // //                                         updatedItems.removeAt(index);
// // // // // //                                       });
// // // // // //                                     },
// // // // // //                                   ),
// // // // // //                                 ],
// // // // // //                               ),
// // // // // //                             ), // Action buttons
// // // // // //                           ],
// // // // // //                         );
// // // // // //                       }).toList(),
// // // // // //                     ),
// // // // // //                   ),
// // // // // //
// // // // // //                   //إضافة صنف جديد
// // // // // //                   TextButton(
// // // // // //                     onPressed: () {
// // // // // //                       showEditItemDialog(
// // // // // //                         context: context,
// // // // // //                         item: BillItem.empty(), // Create a blank item for new entry.
// // // // // //                         // onSave: (BillItem newItem) {
// // // // // //                         //   setState(() {
// // // // // //                         //     updatedItems.add(newItem);
// // // // // //                         //   });
// // // // // //                         // },
// // // // // //             onUpdateItem: (BillItem newItem ) {  setState(() {
// // // // // //                         updatedItems.add(newItem);
// // // // // //                       });},
// // // // // //                       );
// // // // // //                     },
// // // // // //                     child: const Text('إضافة صنف جديد'),
// // // // // //                   ),
// // // // // //                 ],
// // // // // //               ),
// // // // // //             );
// // // // // //           },
// // // // // //         ),
// // // // // //         actions: [
// // // // // //           TextButton(
// // // // // //             onPressed: () => Navigator.of(context).pop(),
// // // // // //             child: const Text('إلغاء'),
// // // // // //           ),
// // // // // //           ElevatedButton(
// // // // // //             onPressed: _updateBill,
// // // // // //             child: const Text('حفظ التعديلات'),
// // // // // //           ),
// // // // // //         ],
// // // // // //       );
// // // // // //     },
// // // // // //   );
// // // // // // }
// // // // // //
// // // // // // // Helper to generate changes description for the report.
// // // // // // String _generateItemChangesDescription(List<BillItem> oldItems, List<BillItem> newItems) {
// // // // // //   final buffer = StringBuffer();
// // // // // //   for (var i = 0; i < newItems.length; i++) {
// // // // // //     if (i < oldItems.length) {
// // // // // //       buffer.writeln(
// // // // // //         'الصنف القديم: ${oldItems[i].categoryName}/${oldItems[i].subcategoryName}, '
// // // // // //             'الكمية: ${oldItems[i].amount}, السعر: ${oldItems[i].price_per_unit} '
// // // // // //             '=> الجديد: ${newItems[i].categoryName}/${newItems[i].subcategoryName}, '
// // // // // //             'الكمية: ${newItems[i].amount}, السعر: ${newItems[i].price_per_unit}',
// // // // // //       );
// // // // // //     } else {
// // // // // //       buffer.writeln(
// // // // // //         'صنف جديد: ${newItems[i].categoryName}/${newItems[i].subcategoryName}, '
// // // // // //             'الكمية: ${newItems[i].amount}, السعر: ${newItems[i].price_per_unit}',
// // // // // //       );
// // // // // //     }
// // // // // //   }
// // // // // //   return buffer.toString();
// // // // // // }
// // // //
// // // import 'package:flutter/material.dart';
// // // import 'package:supabase_flutter/supabase_flutter.dart';
// // // import 'package:system/features/billes/data/models/bill_model.dart';
// // // import 'package:system/features/billes/data/repositories/bill_repository.dart';
// // // import 'package:system/features/billes/presentation/Dialog/details-editing-pdf/item/showEditItemDialog.dart';
// // // import 'package:system/features/report/data/model/report_model.dart';
// // // import 'package:system/features/report/data/repository/report_repository.dart';
// // // //
// // // // Future<void> showEditBillDialog(BuildContext context, Bill bill) async {
// // // //   final TextEditingController paymentController = TextEditingController(text: bill.payment.toString());
// // // //   final List<BillItem> updatedItems = List.from(bill.items); // Clone items for editing.
// // // //
// // // //   // Update Bill function
// // // //   void _updateBill() async {
// // // //     try {
// // // //       final updatedBill = Bill(
// // // //         id: bill.id,
// // // //         customerName: bill.customerName,
// // // //         date: bill.date,
// // // //         status: bill.status,
// // // //         payment: double.tryParse(paymentController.text) ?? bill.payment,
// // // //         items: updatedItems,
// // // //         userId: bill.userId,
// // // //         total_price: updatedItems.fold(0.0, (sum, item) => sum + (item.amount * item.price_per_unit)),
// // // //         vault_id: bill.vault_id,
// // // //       );
// // // //
// // // //       // Update bill in the database
// // // //       final BillRepository billRepository = BillRepository();
// // // //       await billRepository.updateBill(updatedBill);
// // // //
// // // //
// // // //       // Update each bill item in the database
// // // //       for (var updatedItem in updatedItems) {
// // // //         await billRepository.updateBillItem(updatedItem.id, updatedItem);
// // // //       }
// // // //
// // // //       // Success Message
// // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // //         const SnackBar(content: Text('تم تحديث الفاتورة بنجاح')),
// // // //       );
// // // //       Navigator.of(context).pop(); // Close the dialog
// // // //     } catch (e) {
// // // //       // Error Message
// // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // //         SnackBar(content: Text('خطأ أثناء تحديث الفاتورة: $e')),
// // // //       );
// // // //     }
// // // //   }
// // // //
// // // //   showDialog(
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
// // // //                   // Edit Items Table
// // // //                   Text('الأصناف:', style: const TextStyle(fontWeight: FontWeight.bold)),
// // // //                   SingleChildScrollView(
// // // //                     scrollDirection: Axis.horizontal,
// // // //                     child: DataTable(
// // // //                       columns: const [
// // // //                         DataColumn(label: Text('الفئة / الفرعية')), // Category Name
// // // //                         DataColumn(label: Text('الوصف')), // Description
// // // //                         DataColumn(label: Text('عدد الوحدات')), // Quantity
// // // //                         DataColumn(label: Text('الكمية')), // Quantity
// // // //                         DataColumn(label: Text('السعر القطعة')), // Price per Unit
// // // //                         DataColumn(label: Text('السعر الوحدة')), // Price per Unit
// // // //                         DataColumn(label: Text('الإجراءات')), // Actions
// // // //                       ],
// // // //                       rows: updatedItems.asMap().entries.map((entry) {
// // // //                         final index = entry.key;
// // // //                         final item = entry.value;
// // // //
// // // //                         return DataRow(
// // // //                           cells: [
// // // //                             DataCell(Text('${item.categoryName} / ${item.subcategoryName}')),
// // // //                             DataCell(Text(item.description ?? 'غير متوفر')),
// // // //                             DataCell(Text(item.amount?.toString() ?? '0')),
// // // //                             DataCell(Text(item.quantity?.toString() ?? '0')),
// // // //                             DataCell(Text(item.price_per_unit?.toString() ?? '0')),
// // // //                             DataCell(Text('\جنيه${(item.amount * item.price_per_unit)}')),
// // // //                             DataCell(
// // // //                               Row(
// // // //                                 children: [
// // // //                                   IconButton(
// // // //                                     icon: const Icon(Icons.edit, color: Colors.blue),
// // // //                                     onPressed: () {
// // // //                                       showEditItemDialog(
// // // //                                         context: context,
// // // //                                         item: item,
// // // //                                         onUpdateItem: (BillItem updatedItem) {
// // // //                                           setState(() {
// // // //                                             updatedItems[index] = updatedItem;
// // // //                                           });
// // // //                                         },
// // // //                                       );
// // // //                                     },
// // // //                                   ),
// // // //                                   IconButton(
// // // //                                     icon: const Icon(Icons.delete, color: Colors.red),
// // // //                                     onPressed: () {
// // // //                                       setState(() {
// // // //                                         updatedItems.removeAt(index); // Remove the item
// // // //                                       });
// // // //                                     },
// // // //                                   ),
// // // //                                 ],
// // // //                               ),
// // // //                             ),
// // // //                           ],
// // // //                         );
// // // //                       }).toList(),
// // // //                     ),
// // // //                   ),
// // // //
// // // //                   // Add New Item Button
// // // //                   TextButton(
// // // //                     onPressed: () {
// // // //                       showEditItemDialog(
// // // //                         context: context,
// // // //                         item: BillItem.empty(), // Blank item for new entry
// // // //                         onUpdateItem: (BillItem newItem) {
// // // //                           setState(() {
// // // //                             updatedItems.add(newItem); // Add new item to the list
// // // //                           });
// // // //                         },
// // // //                       );
// // // //                     },
// // // //                     child: const Text('إضافة صنف جديد'),
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //             );
// // // //           },
// // // //         ),
// // // //         actions: [
// // // //           TextButton(
// // // //             onPressed: () => Navigator.of(context).pop(),
// // // //             child: const Text('إلغاء'),
// // // //           ),
// // // //           ElevatedButton(
// // // //             onPressed: _updateBill,
// // // //             child: const Text('حفظ التعديلات'),
// // // //           ),
// // // //         ],
// // // //       );
// // // //     },
// // // //   );
// // // // }
// // // //
// // // // // Helper to generate changes description for the report.
// // // // String _generateItemChangesDescription(List<BillItem> oldItems, List<BillItem> newItems) {
// // // //   final buffer = StringBuffer();
// // // //   for (var i = 0; i < newItems.length; i++) {
// // // //     if (i < oldItems.length) {
// // // //       buffer.writeln(
// // // //         'الصنف القديم: ${oldItems[i].categoryName}/${oldItems[i].subcategoryName}, '
// // // //             'الكمية: ${oldItems[i].amount}, السعر: ${oldItems[i].price_per_unit} '
// // // //             '=> الجديد: ${newItems[i].categoryName}/${newItems[i].subcategoryName}, '
// // // //             'الكمية: ${newItems[i].amount}, السعر: ${newItems[i].price_per_unit}',
// // // //       );
// // // //     } else {
// // // //       buffer.writeln(
// // // //         'صنف جديد: ${newItems[i].categoryName}/${newItems[i].subcategoryName}, '
// // // //             'الكمية: ${newItems[i].amount}, السعر: ${newItems[i].price_per_unit}',
// // // //       );
// // // //     }
// // // //   }
// // // //   return buffer.toString();
// // // // }
// // // //
// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:system/features/billes/data/models/bill_model.dart';
// // // // //
// // // // // Future<Bill?> showEditBillDialog(BuildContext context, Bill bill) async {
// // // // //   // final TextEditingController paymentController = TextEditingController(text: bill.payment.toString());
// // // // //   final List<BillItem> updatedItems = List.from(bill.items);
// // // // //
// // // // //   // The return statement gives back the updated bill after editing
// // // // //   return await showDialog<Bill>(
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
// // // // //                   // Add other widgets for editing
// // // // //                   // TextField(
// // // // //                   //   // controller: paymentController,
// // // // //                   //   keyboardType: TextInputType.number,
// // // // //                   //   decoration: const InputDecoration(
// // // // //                   //     labelText: 'تفاصيل الدفع',
// // // // //                   //     border: OutlineInputBorder(),
// // // // //                   //   ),
// // // // //                   // ),
// // // // //                   const SizedBox(height: 16),
// // // // //                   // Your other widgets for editing the bill's items
// // // // //                 ],
// // // // //               ),
// // // // //             );
// // // // //           },
// // // // //         ),
// // // // //         actions: [
// // // // //           TextButton(
// // // // //             onPressed: () => Navigator.of(context).pop(), // Close dialog
// // // // //             child: const Text('إلغاء'),
// // // // //           ),
// // // // //           ElevatedButton(
// // // // //             onPressed: () {
// // // // //               final updatedBill = Bill(
// // // // //                 id: bill.id,
// // // // //                 customerName: bill.customerName,
// // // // //                 date: bill.date,
// // // // //                 status: bill.status,
// // // // //                 payment:  bill.payment,
// // // // //                 items: updatedItems,
// // // // //                 userId: bill.userId,
// // // // //                 total_price: updatedItems.fold(0.0, (sum, item) => sum + (item.amount * item.price_per_unit)),
// // // // //                 vault_id: bill.vault_id,
// // // // //               );
// // // // //               Navigator.of(context).pop(updatedBill); // Return the updated bill
// // // // //             },
// // // // //             child: const Text('حفظ التعديلات'),
// // // // //           ),
// // // // //         ],
// // // // //       );
// // // // //     },
// // // // //   );
// // // // // }
// // // Future<void> showEditBillDialog(BuildContext context, Bill bill) async {
// // //   final TextEditingController paymentController = TextEditingController(text: bill.payment.toString());
// // //   final updatedItems = List<BillItem>.from(bill.items);
// // //
// // //   // Update Bill function
// // //   Future<void> _updateBill()  async {
// // //     try {
// // //       final updatedBill = Bill(
// // //         id: bill.id,
// // //         customerName: bill.customerName,
// // //         date: bill.date,
// // //         status: bill.status,
// // //         payment: double.tryParse(paymentController.text) ?? bill.payment,
// // //         items: updatedItems,
// // //         userId: bill.userId,
// // //         total_price: updatedItems.fold(0.0, (sum, item) => sum + item.price_per_unit * item.quantity),
// // //         vault_id: bill.vault_id,
// // //       );
// // //
// // //       final repository = BillRepository();
// // //       await repository.updateBill(updatedBill);
// // //       // await repository.getBills();
// // //
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         const SnackBar(content: Text('تم تحديث الفاتورة بنجاح')),
// // //       );
// // //       Navigator.of(context).pop(updatedBill); // Close dialog
// // //     } catch (e) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(content: Text('خطأ أثناء تحديث الفاتورة: $e')),
// // //       );
// // //     }
// // //   }
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
// // //                                         onUpdateItem: (updatedItem) {
// // //                                           setState(() {
// // //                                             updatedItems[index] = updatedItem;
// // //                                             // BillRepository().getBills();
// // //                                             // Update bill in the database
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
// // //                         item: BillItem(
// // //                           categoryName: '',
// // //                           subcategoryName: '',
// // //                           amount: 0.0,
// // //                           price_per_unit: 0.0,
// // //                           quantity: 0.0,
// // //                           description: '',
// // //                         ), // Create a new BillItem instance
// // //                         onUpdateItem: (newItem) {
// // //                           setState(() {
// // //                             updatedItems.add(newItem); // Add new item to the list
// // //                           });
// // //                         },
// // //                       );
// // //
// // //                     },
// // //                     child: const Text('إضافة صنف جديد'),
// // //                   ),
// // //
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
// // //             onPressed:(){
// // //               _updateBill();
// // //               BillRepository().getBills();
// // //       },
// // //             child: const Text('حفظ التعديلات'),
// // //           ),
// // //         ],
// // //       );
// // //     },
// // //   );
// // // }
// // import 'package:flutter/material.dart';
// // import 'package:system/features/billes/data/models/bill_model.dart';
// // import 'package:system/features/billes/data/repositories/bill_repository.dart';
// // import 'package:system/features/billes/presentation/Dialog/details-editing-pdf/item/showEditItemDialog.dart';
// //
// // Future<void> showEditBillDialog(BuildContext context, Bill bill) async {
// //   final TextEditingController paymentController = TextEditingController(text: bill.payment.toString());
// //   final updatedItems = List<BillItem>.from(bill.items);
// //
// //   // Update Bill function
// //   Future<void> _updateBill() async {
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
// //
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('تم تحديث الفاتورة بنجاح')),
// //       );
// //       Navigator.of(context).pop(updatedBill); // Close dialog and pass updated bill back
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('خطأ أثناء تحديث الفاتورة: $e')),
// //       );
// //     }
// //   }
// //
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
// //                         ),
// //                         onUpdateItem: (newItem) {
// //                           setState(() {
// //                             updatedItems.add(newItem); // Add new item to the list
// //                           });
// //                         },
// //                       );
// //                     },
// //                     child: const Text('إضافة صنف جديد'),
// //                   ),
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
// //             onPressed: () {
// //               _updateBill(); // Update bill in database and close dialog
// //               // You may want to fetch updated bills here if needed
// //               // BillRepository().getBills();
// //             },
// //             child: const Text('حفظ التعديلات'),
// //           ),
// //         ],
// //       );
// //     },
// //   );
// // }
// // import 'package:flutter/material.dart';
// // import 'package:system/features/billes/data/models/bill_model.dart';
// // import 'package:system/features/billes/data/repositories/bill_repository.dart';
// // import 'package:system/features/billes/presentation/Dialog/adding/item/showAddItemDialog.dart';
// // import 'package:system/features/billes/presentation/Dialog/details-editing-pdf/item/showEditItemDialog.dart';
// //
// // Future<Bill?> showEditBillDialog(BuildContext context, Bill bill) async {
// //   final TextEditingController paymentController = TextEditingController(text: bill.payment.toString());
// //   final updatedItems = List<BillItem>.from(bill.items);
// //
// //   // Update Bill function
// //   Future<void> _updateBill() async {
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
// //
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('تم تحديث الفاتورة بنجاح')),
// //       );
// //       Navigator.of(context).pop(updatedBill); // Close dialog and pass updated bill back
// //       Navigator.of(context).pop();// Close dialog and pass updated bill back
// //       repository.getBills();
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('خطأ أثناء تحديث الفاتورة: $e')),
// //       );
// //     }
// //   }
// //
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
// //                   ElevatedButton(
// //                     onPressed: () {
// //                       showAddItemDialog(
// //                         context: context,
// //                         onAddItem: (item) {
// //                           setState(() {
// //                             updatedItems.add(item); // Add the new item to the list
// //                           });
// //                         },
// //                       );
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
// //               },
// //             child: const Text('حفظ التعديلات'),
// //           ),
// //         ],
// //       );
// //     },
// //   );
// //   return null; // Add this return statement if nothing else is returned from the dialog
// // }
// // import 'package:flutter/material.dart';
// // import 'package:system/features/billes/data/models/bill_model.dart';
// // import 'package:system/features/billes/data/repositories/bill_repository.dart';
// // import 'package:system/features/billes/presentation/Dialog/adding/item/showAddItemDialog.dart';
// // import 'package:system/features/billes/presentation/Dialog/details-editing-pdf/item/showEditItemDialog.dart';
// //
// // Future<Bill?> showEditBillDialog(BuildContext context, Bill bill) async {
// //   final TextEditingController paymentController =
// //   TextEditingController(text: bill.payment.toString());
// //   final updatedItems = List<BillItem>.from(bill.items);
// //
// //   // Update Bill function with validation
// //   Future<void> _updateBill() async {
// //     try {
// //       if (updatedItems.isEmpty) {
// //         throw Exception('لا يمكن حفظ الفاتورة بدون عناصر.');
// //       }
// //
// //       final paymentValue = double.tryParse(paymentController.text);
// //       if (paymentValue == null || paymentValue < 0) {
// //         throw Exception('يرجى إدخال قيمة دفع صحيحة.');
// //       }
// //
// //       final updatedBill = Bill(
// //         id: bill.id,
// //         customerName: bill.customerName,
// //         date: bill.date,
// //         status: bill.status,
// //         payment: paymentValue,
// //         items: updatedItems,
// //         userId: bill.userId,
// //         total_price: updatedItems.fold(
// //           0.0,
// //               (sum, item) => sum + (item.price_per_unit ?? 0) * (item.quantity ?? 0),
// //         ),
// //         vault_id: bill.vault_id,
// //       );
// //
// //       final repository = BillRepository();
// //       await repository.updateBill(updatedBill);
// //
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('تم تحديث الفاتورة بنجاح')),
// //       );
// //       Navigator.of(context).pop(updatedBill); // Close dialog and pass updated bill back
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('خطأ أثناء تحديث الفاتورة: $e')),
// //       );
// //     }
// //   }
// //
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
// //                   const Text('الأصناف:', style: TextStyle(fontWeight: FontWeight.bold)),
// //                   SingleChildScrollView(
// //                     scrollDirection: Axis.horizontal,
// //                     child: DataTable(
// //                       columns: const [
// //                         DataColumn(label: Text('الفئة / الفرعية')), // Category Name
// //                         DataColumn(label: Text('الوصف')), // Description
// //                         DataColumn(label: Text('عدد الوحدات')), // Units
// //                         DataColumn(label: Text('الكمية')), // Quantity
// //                         DataColumn(label: Text('قيمة الخصم')), // Price per Unit
// //                         DataColumn(label: Text('السعر لكل وحدة')), // Price per Unit
// //                         DataColumn(label: Text('السعر الإجمالي')), // Total Price
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
// //                             DataCell(Text(item.discount?.toString() ?? '0.0')),
// //                             DataCell(Text(item.price_per_unit?.toString() ?? '0')),
// //                             DataCell(Text(
// //                                 '\جنيه ${(item.price_per_unit ?? 0) * (item.quantity ?? 0)}')),
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
// //                   ElevatedButton(
// //                     onPressed: () {
// //                       showAddItemDialog(
// //                         context: context,
// //                         onAddItem: (item) {
// //                           setState(() {
// //                             updatedItems.add(item); // Add the new item to the list
// //                           });
// //                         },
// //                       );
// //                     },
// //                     child: const Text('إضافة صنف جديد'),
// //                   ),
// //
// //                   // Payment Field
// //                   const SizedBox(height: 20),
// //                   // TextField(
// //                   //   controller: paymentController,
// //                   //   keyboardType: TextInputType.number,
// //                   //   decoration: const InputDecoration(
// //                   //     labelText: 'قيمة الدفع',
// //                   //     border: OutlineInputBorder(),
// //                   //   ),
// //                   // ),
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
// //             onPressed: _updateBill,
// //             child: const Text('حفظ التعديلات'),
// //           ),
// //         ],
// //       );
// //     },
// //   );
// //   return null; // Add this return statement if nothing else is returned from the dialog
// // }
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:system/features/billes/data/models/bill_model.dart';
// import 'package:system/features/billes/data/repositories/bill_repository.dart';
// import 'package:system/features/billes/presentation/Dialog/adding/item/showAddItemDialog.dart';
// import 'package:system/features/billes/presentation/Dialog/details-editing-pdf/item/showEditItemDialog.dart';
// import 'package:system/features/report/data/model/report_model.dart';
//
// Future<Bill?> showEditBillDialog(BuildContext context, Bill bill) async {
//   final TextEditingController paymentController =
//       TextEditingController(text: bill.payment.toString());
//   final updatedItems = List<BillItem>.from(bill.items);
//   final ScrollController _horizontalScrollController = ScrollController();
//   final ScrollController _verticalScrollController = ScrollController();
//
//   // Function to delete an item from the bill_items array in the bills table
//   Future<void> _deleteItemFromDatabase(Bill bill, BillItem item) async {
//     final supabase = Supabase.instance.client;
//
//     try {
//       // Create a new list excluding the item to be deleted
//       final updatedItems =
//           bill.items.where((existingItem) => existingItem != item).toList();
//
//       // Update the bills table with the modified bill_items array
//       final response = await supabase.from('bills').update({
//         'items': updatedItems.map((item) => item.toJson()).toList()
//       }).eq('id', bill.id);
//
//       if (response.error != null) {
//         throw Exception(response.error!.message);
//       }
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('تم حذف العنصر بنجاح')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('خطأ أثناء حذف العنصر: $e')),
//       );
//     }
//   }
//
//   double calculateTotalPrice({
//
//     required double total_Item_price,
//   }) {
//
//     double totalPrice = total_Item_price;
//
//     return totalPrice;
//   }
//
//   // Function to validate and update the bill
//   Future<void> _updateBill() async {
//     try {
//       if (updatedItems.isEmpty) {
//         throw Exception('لا يمكن حفظ الفاتورة بدون عناصر.');
//       }
//
// // احسب إجمالي الفاتورة من إجمالي كل صنف المخزون مسبقًا
//       final double newTotal = updatedItems.fold<double>(
//         0.0,
//             (sum, item) => sum + item.total_Item_price,
//       );
//
// // نفس منطق شاشة الإضافة:
//       final String newStatus = (newTotal == bill.payment)
//           ? "تم الدفع"
//           : (newTotal < bill.payment)
//           ? "فاتورة مفتوحة"
//           : "آجل";
//
//       final updatedBill = Bill(
//         id: bill.id,
//         customerName: bill.customerName,
//         date: bill.date,
//         // status: bill.status,
//         // status: (updatedItems.fold<int>( 0, (sum, item) {        final itemPrice =
//         //                 ((item.price_per_unit ?? 0) * (item.quantity ?? 0))
//         //                     .toInt();
//         //             final discountValue =
//         //                 (itemPrice * ((item.discount ?? 0) / 100)).toInt();
//         //             return sum + (itemPrice - discountValue);
//         //           },) == bill.payment)
//         //     ? "تم الدفع" : (updatedItems.fold<int>( 0,
//         //               (sum, item) {
//         //                 final itemPrice =
//         //                     ((item.price_per_unit ?? 0) * (item.quantity ?? 0))
//         //                         .toInt();
//         //                 final discountValue =
//         //                     (itemPrice * ((item.discount ?? 0) / 100)).toInt();
//         //                 return sum + (itemPrice - discountValue);
//         //               },
//         //             ) >
//         //             bill.payment)
//         //         ? "فاتورة مفتوحة"
//         //         : "آجل",
//
//         status: newStatus,
//
//         customer_type: bill.customer_type,
//         payment: bill.payment,
//         items: updatedItems,
//         userId: bill.userId,
//         // total_price: updatedItems.fold<double>(
//         //   0,
//         //   (sum, item) {
//         //     final itemPrice =
//         //         ((item.price_per_unit ?? 0) * (item.quantity ?? 0)).toInt();
//         //     final discountValue =
//         //         (itemPrice * ((item.discount ?? 0) / 100)).toInt();
//         //     return sum + (itemPrice - discountValue);
//         //   },
//         // ),
//         total_price: newTotal,
//
//         vault_id: bill.vault_id,
//         isFavorite: false,
//         description: 'جاري التنفيذ' ,
//       );
//
//       // final updatedBill = Bill(
//       //   id: bill.id,
//       //   customerName: bill.customerName,
//       //   date: bill.date,
//       //
//       //   status: (
//       //       updatedItems.fold<double>(0, (sum, item) {
//       //     final itemPrice =
//       //         (item.price_per_unit ?? 0) * (item.quantity ?? 0);
//       //     final discountValue =
//       //         itemPrice * ((item.discount ?? 0) / 100);
//       //     return sum + (itemPrice - discountValue);
//       //   }) ==
//       //       bill.payment)
//       //       ? "تم الدفع"
//       //       : (updatedItems.fold<double>(0, (sum, item) {
//       //     final itemPrice =
//       //         (item.price_per_unit ?? 0) * (item.quantity ?? 0);
//       //     final discountValue =
//       //         itemPrice * ((item.discount ?? 0) / 100);
//       //     return sum + (itemPrice - discountValue);
//       //   }) >
//       //       bill.payment)
//       //       ? "فاتورة مفتوحة"
//       //       : "آجل",
//       //
//       //   customer_type: bill.customer_type,
//       //   payment: bill.payment,
//       //   items: updatedItems,
//       //   userId: bill.userId,
//       //
//       //   total_price: updatedItems.fold<double>(0, (sum, item) {
//       //     final itemPrice =
//       //         (item.price_per_unit ?? 0) * (item.quantity ?? 0);
//       //     final discountValue =
//       //         itemPrice * ((item.discount ?? 0) / 100);
//       //     return sum + (itemPrice - discountValue);
//       //   }),
//       //
//       //   vault_id: bill.vault_id,
//       //   isFavorite: false,
//       //   description: 'جاري التنفيذ',
//       // );
//
//
//       final repository = BillRepository();
//       await repository.updateBill(updatedBill);
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('تم تحديث الفاتورة بنجاح')),
//       );
//       Navigator.of(context).pop(updatedBill);
//     } catch (e) {
//       print('خطأ أثناء تحديث الفاتورة: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('خطأ أثناء تحديث الفاتورة: $e')),
//       );
//     }
//   }
//
//   return showDialog<Bill>(
//     context: context,
//     builder: (context) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           return AlertDialog(
//             title: const Text('تعديل الفاتورة...'),
//             content: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('الأصناف:',
//                       style: TextStyle(fontWeight: FontWeight.bold)),
//                   Scrollbar(
//                     controller: _verticalScrollController,
//                     thumbVisibility: true, // Show scrollbar for better UX
//                     interactive: true,
//                     child: SingleChildScrollView(
//                       controller: _verticalScrollController,
//                       // Vertical scrolling
//                       scrollDirection: Axis.vertical,
//                       child: Scrollbar(
//                         controller: _horizontalScrollController,
//                         thumbVisibility: true,
//                         interactive: true,
//                         child: SingleChildScrollView(
//                           controller: _horizontalScrollController,
//                           scrollDirection: Axis.horizontal,
//
//                           // SingleChildScrollView(
//                           //   scrollDirection: Axis.vertical,
//                           child: DataTable(
//                             columns: const [
//                               DataColumn(label: Text('الفئة/الفرعية')),
//                               // Category Name/description
//                               DataColumn(label: Text('وصف')),
//                               // Description
//                               DataColumn(label: Text('سعر الوحدة')),
//                               // Price per unit
//                               DataColumn(label: Text('عدد الوحدات')),
//                               // Quantity
//                               DataColumn(label: Text('سعر القطعة')),
//                               // price_per_unit * amount
//                               DataColumn(label: Text('الكمية')),
//                               // Quantity
//                               DataColumn(label: Text('قيمة الخصم')),
//                               // Discount Value
//                               DataColumn(label: Text('نوع الخصم')),
//                               // Discount Type
//                               DataColumn(label: Text('السعر')),
//                               // Price
//                               DataColumn(label: Text('المهام')),
//                             ],
//                             rows: updatedItems.asMap().entries.map((entry) {
//                               final index = entry.key;
//                               final item = entry.value;
//
//                               return DataRow(
//                                 cells: [
//                                   DataCell(Text(
//                                       '${item.categoryName} / ${item.subcategoryName}')),
//                                   DataCell(
//                                       Text(item.description ?? 'غير متوفر')),
//                                   DataCell(
//                                       Text(item.price_per_unit.toString())),
//                                   DataCell(Text(item.amount.toString())),
//                                   DataCell(Text(
//                                       '\جنيه${(item.amount * item.price_per_unit)}')),
//                                   DataCell(Text(item.quantity.toString())),
//                                   DataCell(Text(item.discount.toString())),
//                                   DataCell(Text(item.discountType.toString())),
//                                   DataCell(
//                                     Text(
//                                       calculateTotalPrice(
//                                         total_Item_price: item.total_Item_price,
//                                       ).toString(),
//                                       style: TextStyle(fontSize: 16.0),
//                                     ),
//                                   ),
//                                   DataCell(
//                                     Row(
//                                       children: [
//                                         IconButton(
//                                           icon: const Icon(Icons.edit,
//                                               color: Colors.blue),
//                                           onPressed: () {
//                                             showEditItemDialog(
//                                               context: context,
//                                               item: item,
//                                               onUpdateItem: (updatedItem,Report report) {
//                                                 setState(() {
//                                                   updatedItems[index] =
//                                                       updatedItem;
//
//                                                 });
//                                               },
//                                             );
//                                           },
//                                         ),
//                                         IconButton(
//                                           icon: const Icon(Icons.delete,
//                                               color: Colors.red),
//                                           onPressed: () async {
//                                             await _deleteItemFromDatabase(bill,
//                                                 item); // Pass the full bill and the item to delete
//                                             setState(() {
//                                               updatedItems.removeAt(index);
//                                             });
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       showAddItemDialog(
//                         context: context,
//                         onAddItem: (item) {
//                           setState(() {
//                             updatedItems.add(item);
//                           });
//                         },
//                       );
//                     },
//                     child: const Text('إضافة عنصر جديد للفاتورة'),
//                   ),
//                 ],
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: const Text('إلغاء'),
//               ),
//               ElevatedButton(
//                 // onPressed: () => _updateBill,
//                 onPressed: _updateBill,
//                 child: const Text('حفظ التعديلات'),
//               ),
//             ],
//           );
//         },
//       );
//     },
//   );
// }



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
// import 'package:flutter/material.dart';
// import 'package:system/features/billes/data/models/bill_model.dart';
// import 'package:system/features/billes/data/repositories/bill_repository.dart';
// import 'package:system/features/billes/presentation/Dialog/adding/item/showAddItemDialog.dart';
// import 'package:system/features/billes/presentation/Dialog/details-editing-pdf/item/showEditItemDialog.dart';
//
// Future<Bill?> showEditBillDialog(BuildContext context, Bill bill) async {
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
//       Navigator.of(context).pop();// Close dialog and pass updated bill back
//       repository.getBills();
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
//                   ElevatedButton(
//                     onPressed: () {
//                       showAddItemDialog(
//                         context: context,
//                         onAddItem: (item) {
//                           setState(() {
//                             updatedItems.add(item); // Add the new item to the list
//                           });
//                         },
//                       );
//                     },
//                     child: const Text('إضافة صنف جديد'),
//                   ),
//
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
//             onPressed:(){
//               _updateBill();
//               },
//             child: const Text('حفظ التعديلات'),
//           ),
//         ],
//       );
//     },
//   );
//   return null; // Add this return statement if nothing else is returned from the dialog
// }
// import 'package:flutter/material.dart';
// import 'package:system/features/billes/data/models/bill_model.dart';
// import 'package:system/features/billes/data/repositories/bill_repository.dart';
// import 'package:system/features/billes/presentation/Dialog/adding/item/showAddItemDialog.dart';
// import 'package:system/features/billes/presentation/Dialog/details-editing-pdf/item/showEditItemDialog.dart';
//
// Future<Bill?> showEditBillDialog(BuildContext context, Bill bill) async {
//   final TextEditingController paymentController =
//   TextEditingController(text: bill.payment.toString());
//   final updatedItems = List<BillItem>.from(bill.items);
//
//   // Update Bill function with validation
//   Future<void> _updateBill() async {
//     try {
//       if (updatedItems.isEmpty) {
//         throw Exception('لا يمكن حفظ الفاتورة بدون عناصر.');
//       }
//
//       final paymentValue = double.tryParse(paymentController.text);
//       if (paymentValue == null || paymentValue < 0) {
//         throw Exception('يرجى إدخال قيمة دفع صحيحة.');
//       }
//
//       final updatedBill = Bill(
//         id: bill.id,
//         customerName: bill.customerName,
//         date: bill.date,
//         status: bill.status,
//         payment: paymentValue,
//         items: updatedItems,
//         userId: bill.userId,
//         total_price: updatedItems.fold(
//           0.0,
//               (sum, item) => sum + (item.price_per_unit ?? 0) * (item.quantity ?? 0),
//         ),
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
//                   const Text('الأصناف:', style: TextStyle(fontWeight: FontWeight.bold)),
//                   SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: DataTable(
//                       columns: const [
//                         DataColumn(label: Text('الفئة / الفرعية')), // Category Name
//                         DataColumn(label: Text('الوصف')), // Description
//                         DataColumn(label: Text('عدد الوحدات')), // Units
//                         DataColumn(label: Text('الكمية')), // Quantity
//                         DataColumn(label: Text('قيمة الخصم')), // Price per Unit
//                         DataColumn(label: Text('السعر لكل وحدة')), // Price per Unit
//                         DataColumn(label: Text('السعر الإجمالي')), // Total Price
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
//                             DataCell(Text(item.discount?.toString() ?? '0.0')),
//                             DataCell(Text(item.price_per_unit?.toString() ?? '0')),
//                             DataCell(Text(
//                                 '\جنيه ${(item.price_per_unit ?? 0) * (item.quantity ?? 0)}')),
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
//                   ElevatedButton(
//                     onPressed: () {
//                       showAddItemDialog(
//                         context: context,
//                         onAddItem: (item) {
//                           setState(() {
//                             updatedItems.add(item); // Add the new item to the list
//                           });
//                         },
//                       );
//                     },
//                     child: const Text('إضافة صنف جديد'),
//                   ),
//
//                   // Payment Field
//                   const SizedBox(height: 20),
//                   // TextField(
//                   //   controller: paymentController,
//                   //   keyboardType: TextInputType.number,
//                   //   decoration: const InputDecoration(
//                   //     labelText: 'قيمة الدفع',
//                   //     border: OutlineInputBorder(),
//                   //   ),
//                   // ),
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
//             onPressed: _updateBill,
//             child: const Text('حفظ التعديلات'),
//           ),
//         ],
//       );
//     },
//   );
//   return null; // Add this return statement if nothing else is returned from the dialog
// }


import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/billes/data/repositories/bill_repository.dart';
import 'package:system/features/billes/presentation/Dialog/adding/item/showAddItemDialog.dart';
import 'package:system/features/billes/presentation/Dialog/adding/item/showAddItemDialogReportBillN.dart';
import 'package:system/features/billes/presentation/Dialog/details-editing-pdf/item/showEditItemDialog.dart';
import 'package:system/features/billes/presentation/Dialog/details-editing-pdf/item/showEditItemDialogReport-BillNum.dart';
import 'package:system/features/report/data/model/report_model.dart';

Future<Bill?> showEditBillDialog(BuildContext context, Bill bill) async {
  final TextEditingController paymentController =
  TextEditingController(text: bill.payment.toString());
  final updatedItems = List<BillItem>.from(bill.items);
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  // Function to delete an item from the bill_items array in the bills table
  Future<void> _deleteItemFromDatabase(Bill bill, BillItem item) async {
    final supabase = Supabase.instance.client;

    try {
      // Create a new list excluding the item to be deleted
      final updatedItems =
      bill.items.where((existingItem) => existingItem != item).toList();

      // Update the bills table with the modified bill_items array
      final response = await supabase.from('bills').update({
        'items': updatedItems.map((item) => item.toJson()).toList()
      }).eq('id', bill.id);

      if (response.error != null) {
        throw Exception(response.error!.message);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حذف العنصر بنجاح')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ أثناء حذف العنصر: $e')),
      );
    }
  }

  double calculateTotalPrice({

    required double total_Item_price,
  }) {

    double totalPrice = total_Item_price;

    return totalPrice;
  }

  // Function to validate and update the bill
  Future<void> _updateBill() async {
    try {
      if (updatedItems.isEmpty) {
        throw Exception('لا يمكن حفظ الفاتورة بدون عناصر.');
      }

// احسب إجمالي الفاتورة من إجمالي كل صنف المخزون مسبقًا
      final double newTotal = updatedItems.fold<double>(
        0.0,
            (sum, item) => sum + item.total_Item_price,
      );

// نفس منطق شاشة الإضافة:
      final String newStatus = (newTotal == bill.payment)
          ? "تم الدفع"
          : (newTotal < bill.payment)
          ? "فاتورة مفتوحة"
          : "آجل";

      final updatedBill = Bill(
        id: bill.id,
        customerName: bill.customerName,
        date: bill.date,
        status: newStatus,

        customer_type: bill.customer_type,
        payment: bill.payment,
        items: updatedItems,
        userId: bill.userId,
        total_price: newTotal,

        vault_id: bill.vault_id,
        isFavorite: false,
        description: 'جاري التنفيذ' ,
      );


      final repository = BillRepository();
      await repository.updateBill(updatedBill);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تحديث الفاتورة بنجاح')),
      );
      Navigator.of(context).pop(updatedBill);
    } catch (e) {
      print('خطأ أثناء تحديث الفاتورة: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ أثناء تحديث الفاتورة: $e')),
      );
    }
  }

  return showDialog<Bill>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('تعديل الفاتورة...'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('الأصناف:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Scrollbar(
                    controller: _verticalScrollController,
                    thumbVisibility: true, // Show scrollbar for better UX
                    interactive: true,
                    child: SingleChildScrollView(
                      controller: _verticalScrollController,
                      // Vertical scrolling
                      scrollDirection: Axis.vertical,
                      child: Scrollbar(
                        controller: _horizontalScrollController,
                        thumbVisibility: true,
                        interactive: true,
                        child: SingleChildScrollView(
                          controller: _horizontalScrollController,
                          scrollDirection: Axis.horizontal,

                          // SingleChildScrollView(
                          //   scrollDirection: Axis.vertical,
                          child: DataTable(
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
                              DataColumn(label: Text('المهام')),
                            ],
                            rows: updatedItems.asMap().entries.map((entry) {
                              final index = entry.key;
                              final item = entry.value;

                              return DataRow(
                                cells: [
                                  DataCell(Text(
                                      '${item.categoryName} / ${item.subcategoryName}')),
                                  DataCell(
                                      Text(item.description ?? 'غير متوفر')),
                                  DataCell(
                                      Text(item.price_per_unit.toString())),
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
                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit,
                                              color: Colors.blue),
                                          // onPressed: () {
                                          //   showEditItemDialog(
                                          //     context: context,
                                          //     item: item,
                                          //     onUpdateItem: (updatedItem,Report report) {
                                          //       setState(() {
                                          //         updatedItems[index] =
                                          //             updatedItem;
                                          //
                                          //       });
                                          //     },
                                          //   );
                                          // },

                                          onPressed: () {
                                            showEditItemDialogReportBillNum(
                                              context: context,
                                              item: item,
                                              billId: bill.id, // 👈 مرر رقم الفاتورة هنا
                                              onUpdateItem: (updatedItem, Report report) async {
                                                setState(() {
                                                  updatedItems[index] = updatedItem;
                                                });
                                                // 👇 حفظ التقرير في Supabase
                                                final supabase = Supabase.instance.client;
                                                try {

                                                  await supabase.from('reports').insert(report.toMap());
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('تم حفظ التقرير بنجاح')),
                                                  );
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('فشل في حفظ التقرير: $e')),
                                                  );
                                                }
                                              },
                                            );
                                          },

                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () async {
                                            await _deleteItemFromDatabase(bill,
                                                item); // Pass the full bill and the item to delete
                                            setState(() {
                                              updatedItems.removeAt(index);
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
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showAddItemDialog2(
                        context: context,
                        billId: bill.id, // 👈 مرر رقم الفاتورة هنا
                        onAddItem: (item, Report report) async {
                          setState(() {
                            updatedItems.add(item);
                          });
                          final supabase = Supabase.instance.client;
                          try {

                            await supabase.from('reports').insert(report.toMap());
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم حفظ التقرير بنجاح')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('فشل في حفظ التقرير: $e')),
                            );
                          }



                        },
                      );
                    },
                    child: const Text('إضافة عنصر جديد للفاتورة'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                // onPressed: () => _updateBill,
                onPressed: _updateBill,
                child: const Text('حفظ التعديلات'),
              ),
            ],
          );
        },
      );
    },
  );
}
