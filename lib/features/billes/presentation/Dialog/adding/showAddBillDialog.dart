// // import 'package:flutter/material.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart';
// // import 'package:system/features/billes/data/models/bill_model.dart';
// // import 'package:system/features/billes/data/repositories/bill_repository.dart';
// // import 'package:system/features/customer/data/model/customer_model.dart';
// // import 'add_customer_dialog.dart'; // Import the new dialog file
// // import 'showAddItemDialog.dart';
// //
// // Future<void> showAddBillDialog({
// //   required BuildContext context,
// //   required Function(Bill) onAddBill,
// // }) async {
// //   final TextEditingController customerNameController = TextEditingController();
// //   final TextEditingController dateController = TextEditingController();
// //   final TextEditingController paymentController = TextEditingController();
// //
// //   final List<BillItem> items = [];
// //   final BillRepository billRepository = BillRepository();
// //   String _selectedPaymentStatus = "تم الدفع"; // default status
// //   double _totalPrice = 0.0; // Initialize total price
// //   List<String> customerNames = [];
// //   bool customerExists = false;
// //
// //   List<Map<String, String>> vaults = []; // Holds vaults fetched from Supabase
// //   String? selectedVaultId; // Holds the selected vault ID
// //
// //   // Fetch customer names initially
// //   await billRepository.getCustomerNames().then((names) {
// //     customerNames = names;
// //   });
// //
// // // Fetch vaults
// //   await billRepository.fetchVaultList().then((fetchedVaults) {
// //     vaults = fetchedVaults;
// //   });
// //
// //   void addItemCallback(BillItem item) {
// //     items.add(item);
// //     // Update total price whenever a new item is added
// //     _totalPrice = items.fold(
// //         0.0, (sum, item) => sum + (item.amount * item.price_per_unit));
// //   }
// //
// //   // Function to return the appropriate icon based on the payment status
// //   IconData _getPaymentStatusIcon() {
// //     switch (_selectedPaymentStatus) {
// //       case "تم الدفع":
// //         return Icons.check_circle; // Green check icon
// //       case "فاتورة مفتوحة":
// //         return Icons.hourglass_empty; // Hourglass icon for open invoice
// //       case "آجل":
// //       default:
// //         return Icons.pending_actions; // Pending actions icon
// //     }
// //   }
// //
// //   // Function to return the color based on the payment status
// //   Color _getPaymentStatusColor() {
// //     switch (_selectedPaymentStatus) {
// //       case "تم الدفع":
// //         return Colors.green;
// //       case "فاتورة مفتوحة":
// //         return Colors.blue;
// //       case "آجل":
// //       default:
// //         return Colors.orange;
// //     }
// //   }
// //
// //   // Function to check if the customer exists after adding a new one
// //   void _updateCustomerExistence(String customerName) {
// //     customerExists = customerNames.contains(customerName);
// //   }
// //
// //   // Updated showAddDialog with state management
// //   return showDialog(
// //     context: context,
// //     builder: (context) {
// //       return StatefulBuilder(
// //         builder: (context, setDialogState) {
// //           return AlertDialog(
// //             title: Text('------------انشاء فاتورة جديدة------------'),
// //             content: SingleChildScrollView(
// //               child: Expanded(
// //                 // width: 400, // Set your desired width here
// //                 child: Column(
// //                   children: [
// //                     Container(
// //                       color: Colors.black26,
// //                       child: Column(
// //                         mainAxisSize: MainAxisSize.max,
// //                         children: [
// //                           TextField(
// //                             controller: customerNameController,
// //                             decoration:
// //                                 InputDecoration(labelText: 'أسم العميل'),
// //                             onChanged: (value) {
// //                               setDialogState(() {
// //                                 _updateCustomerExistence(value);
// //                               });
// //                             },
// //                           ),
// //                           SizedBox(height: 5),
// //                           // Display customer status message
// //                           if (customerExists)
// //                             Text(
// //                               'العميل موجود بالفعل',
// //                               style: TextStyle(color: Colors.green),
// //                             )
// //                           else if (customerNameController.text.isNotEmpty)
// //                             Text(
// //                               'العميل ليس موجود',
// //                               style: TextStyle(color: Colors.red),
// //                             ),
// //                           SizedBox(height: 5),
// //                           if (!customerExists)
// //                             TextButton(
// //                               onPressed: () {
// //                                 showAddDialog(
// //                                   context,
// //                                   onAdd: () async {
// //                                     await billRepository
// //                                         .getCustomerNames()
// //                                         .then((names) {
// //                                       customerNames = names;
// //                                       setDialogState(() {
// //                                         _updateCustomerExistence(
// //                                             customerNameController.text);
// //                                       });
// //                                     });
// //                                   },
// //                                 );
// //                               },
// //                               child: Text('اضافة عميل جديد'),
// //                             ),
// //                           TextField(
// //                             controller: dateController,
// //                             decoration: InputDecoration(
// //                                 labelText: 'التاريخ (يوم/شهر/سنة )'),
// //                           ),
// //                           SizedBox(height: 40),
// //                         ],
// //                       ),
// //                     ),
// //                     Container(
// //                       child: Column(
// //                         children: [
// //                           ElevatedButton(
// //                             onPressed: () async {
// //                               await showAddItemDialog(
// //                                 context: context,
// //                                 onAddItem: (item) {
// //                                   setDialogState(() {
// //                                     addItemCallback(item);
// //                                   });
// //                                 },
// //                               );
// //                             },
// //                             child: Text('اضافة عناصر الفاتورة'),
// //                           ),
// //                           if (items.isNotEmpty) ...[
// //                             Text('عناصر الفاتورة:',
// //                                 style: TextStyle(fontWeight: FontWeight.bold)),
// //                             // Table displaying bill items
// //                             Table(
// //                               border: TableBorder.all(),
// //                               // Adds borders to the table
// //                               columnWidths: {
// //                                 0: FlexColumnWidth(2),
// //                                 1: FlexColumnWidth(2),
// //                                 2: FlexColumnWidth(1),
// //                                 3: FlexColumnWidth(1),
// //                               },
// //                               children: [
// //                                 // Table Header
// //                                 TableRow(
// //                                   children: [
// //                                     Padding(
// //                                       padding: const EdgeInsets.all(8.0),
// //                                       child: Text('الفئة / الفئة الفرعية',
// //                                           style: TextStyle(
// //                                               fontWeight: FontWeight.bold)),
// //                                     ),
// //                                     Padding(
// //                                       padding: const EdgeInsets.all(8.0),
// //                                       child: Text('الكمية',
// //                                           style: TextStyle(
// //                                               fontWeight: FontWeight.bold)),
// //                                     ),
// //                                     Padding(
// //                                       padding: const EdgeInsets.all(8.0),
// //                                       child: Text('السعر للوحدة',
// //                                           style: TextStyle(
// //                                               fontWeight: FontWeight.bold)),
// //                                     ),
// //                                     Padding(
// //                                       padding: const EdgeInsets.all(8.0),
// //                                       child: Text('السعر الإجمالي',
// //                                           style: TextStyle(
// //                                               fontWeight: FontWeight.bold)),
// //                                     ),
// //                                   ],
// //                                 ),
// //                                 // Table rows for each item
// //                                 ...items.map((item) {
// //                                   return TableRow(
// //                                     children: [
// //                                       Padding(
// //                                         padding: const EdgeInsets.all(8.0),
// //                                         child: Text(
// //                                             '${item.categoryName} / ${item.subcategoryName}'),
// //                                       ),
// //                                       Padding(
// //                                         padding: const EdgeInsets.all(8.0),
// //                                         child: Text('${item.amount}'),
// //                                       ),
// //                                       Padding(
// //                                         padding: const EdgeInsets.all(8.0),
// //                                         child:
// //                                             Text('\جنيه${item.price_per_unit}'),
// //                                       ),
// //                                       Padding(
// //                                         padding: const EdgeInsets.all(8.0),
// //                                         child: Text(
// //                                             '\جنيه${(item.amount * item.price_per_unit).toStringAsFixed(2)}'),
// //                                       ),
// //                                     ],
// //                                   );
// //                                 }).toList(),
// //                               ],
// //                             ),
// //                           ],
// //                         ],
// //                       ),
// //                     ),
// //                     Container(
// //                       color: Colors.black26,
// //                       child: Column(
// //                         children: [
// //                           TextField(
// //                             controller: paymentController,
// //                             decoration:
// //                                 InputDecoration(labelText: 'المبلغ المدفوع'),
// //                             keyboardType: TextInputType.number,
// //                             onChanged: (value) {
// //                               setDialogState(() {
// //                                 final paymentAmount =
// //                                     double.tryParse(value) ?? 0.0;
// //
// //                                 if (_totalPrice == paymentAmount) {
// //                                   _selectedPaymentStatus = "تم الدفع";
// //                                 } else if (_totalPrice < paymentAmount) {
// //                                   _selectedPaymentStatus = "فاتورة مفتوحة";
// //                                 } else {
// //                                   _selectedPaymentStatus = "آجل";
// //                                 }
// //                               });
// //                             },
// //                           ),
// //                           DropdownButtonFormField<String>(
// //                             value: selectedVaultId,
// //                             hint: Text('اختر الخزنة'), // Placeholder
// //                             onChanged: (value) {
// //                               setDialogState(() {
// //                                 selectedVaultId = value;
// //                               });
// //                             },
// //                             items: vaults.map((vault) {
// //                               return DropdownMenuItem<String>(
// //                                 value: vault['id'], // Vault ID
// //                                 child: Text(vault['name']!), // Vault Name
// //                               );
// //                             }).toList(),
// //                           ),
// //                         ],
// //                       ),
// //                     )
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             actions: [
// //               Column(
// //                 children: [
// //                   Row(
// //                     children: [
// //                       SizedBox(height: 10),
// //                       IconButton(
// //                         icon: Row(
// //                           children: [
// //                             Icon(
// //                               _getPaymentStatusIcon(),
// //                               color:
// //                                   _getPaymentStatusColor(), // Color of the icon based on the status
// //                             ),
// //                             SizedBox(width: 8), // Space between icon and text
// //                             Text(
// //                               _selectedPaymentStatus,
// //                               // The text will show the payment status
// //                               style: TextStyle(
// //                                 color: _getPaymentStatusColor(),
// //                                 // Text color matches the icon color
// //                                 fontWeight: FontWeight.bold,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                         onPressed: () {
// //                           // Here, you calculate the total bill price and compare it to the payment
// //                           final paymentAmount =
// //                               double.tryParse(paymentController.text) ?? 0.0;
// //
// //                           if (_totalPrice == paymentAmount) {
// //                             setDialogState(() {
// //                               _selectedPaymentStatus = "تم الدفع";
// //                             });
// //                           } else if (_totalPrice < paymentAmount) {
// //                             setDialogState(() {
// //                               _selectedPaymentStatus = "فاتورة مفتوحة";
// //                             });
// //                           } else {
// //                             setDialogState(() {
// //                               _selectedPaymentStatus = "آجل";
// //                             });
// //                           }
// //                         },
// //                       ),
// //                       TextButton(
// //                         onPressed: () => Navigator.of(context).pop(),
// //                         child: Text('الغاء'),
// //                       ),
// //                       TextButton(
// //                         onPressed: customerExists
// //                             ? () async {
// //                                 final user =
// //                                     Supabase.instance.client.auth.currentUser;
// //                                 if (user != null) {
// //                                   final bill = Bill(
// //                                     status: _selectedPaymentStatus,
// //                                     id: 0,
// //                                     userId: user.id,
// //                                     customerName: customerNameController.text,
// //                                     date: dateController.text,
// //                                     items: items,
// //                                     payment:
// //                                         double.parse(paymentController.text),
// //                                     total_price: _totalPrice,
// //                                     vault_id:
// //                                         selectedVaultId!, // Pass the selected vault
// //                                   );
// //                                   await onAddBill(bill);
// //
// //                                   // Create a Payment record
// //                                   final payment = Payment(
// //                                     id: Supabase
// //                                         .instance.client.auth.currentUser!.id,
// //                                     // Corrected here                              createdAt: DateTime.now(),
// //                                     billId: bill.id.toString(),
// //                                     date: DateTime.now(),
// //                                     userId: user.id,
// //                                     payment: bill.payment,
// //                                     status: 'ايداع',
// //                                     createdAt: DateTime.now(),
// //                                   );
// //
// //                                   final repository = BillRepository();
// //                                   await repository.addPaymentRecord(payment);
// //
// //                                   // Update Vault balance
// //                                   await repository.addPaymentToVault(
// //                                     vault_id: selectedVaultId!,
// //                                     paymentAmount: bill.payment,
// //                                   );
// //
// //                                   Navigator.of(context).pop();
// //                                 } else {
// //                                   ScaffoldMessenger.of(context).showSnackBar(
// //                                     SnackBar(
// //                                         content: Text(
// //                                             'Error: User not authenticated')),
// //                                   );
// //                                 }
// //                               }
// //                             : null, // Disable button if customer doesn't exist
// //                         child: Text('اضف الفاتورة'),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           );
// //         },
// //       );
// //     },
// //   );
// // }
//
//
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:system/features/billes/data/models/bill_model.dart';
// import 'package:system/features/billes/data/repositories/bill_repository.dart';
// import 'package:system/features/billes/presentation/Dialog/adding/add_customer_dialog.dart';
// import 'package:system/features/billes/presentation/Dialog/adding/showAddItemDialog.dart';
//
// Future<void> showAddBillDialog({
//   required BuildContext context,
//   required Function(Bill) onAddBill,
// }) async {
//   final TextEditingController customerNameController = TextEditingController();
//   final TextEditingController dateController = TextEditingController();
//   final TextEditingController paymentController = TextEditingController();
//
//   final List<BillItem> items = [];
//   final BillRepository billRepository = BillRepository();
//   String _selectedPaymentStatus = "تم الدفع"; // default status
//   double _totalPrice = 0.0; // Initialize total price
//   List<String> customerNames = [];
//   bool customerExists = false;
//
//   List<Map<String, String>> vaults = []; // Holds vaults fetched from Supabase
//   String? selectedVaultId; // Holds the selected vault ID
//
//   // Fetch customer names initially
//   await billRepository.getCustomerNames().then((names) {
//     customerNames = names;
//   });
//
//   // Fetch vaults
//   await billRepository.fetchVaultList().then((fetchedVaults) {
//     vaults = fetchedVaults;
//   });
//
//   void addItemCallback(BillItem item) {
//     items.add(item);
//     // Update total price whenever a new item is added
//     _totalPrice = items.fold(
//         0.0, (sum, item) => sum + (item.amount * item.price_per_unit));
//   }
//
//   // Function to return the appropriate icon based on the payment status
//   IconData _getPaymentStatusIcon() {
//     switch (_selectedPaymentStatus) {
//       case "تم الدفع":
//         return Icons.check_circle; // Green check icon
//       case "فاتورة مفتوحة":
//         return Icons.hourglass_empty; // Hourglass icon for open invoice
//       case "آجل":
//       default:
//         return Icons.pending_actions; // Pending actions icon
//     }
//   }
//
//   // Function to return the color based on the payment status
//   Color _getPaymentStatusColor() {
//     switch (_selectedPaymentStatus) {
//       case "تم الدفع":
//         return Colors.green;
//       case "فاتورة مفتوحة":
//         return Colors.blue;
//       case "آجل":
//       default:
//         return Colors.orange;
//     }
//   }
//
//   // Function to check if the customer exists after adding a new one
//   void _updateCustomerExistence(String customerName) {
//     customerExists = customerNames.contains(customerName);
//   }
//
//   return showDialog(
//     context: context,
//     builder: (context) {
//       return StatefulBuilder(
//         builder: (context, setDialogState) {
//           return AlertDialog(
//             title: Text('--------------انشاء فاتورة جديدة--------------'),
//             content: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(12.0), // Add padding
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200], // Gray background color
//                       borderRadius: BorderRadius.circular(8.0), // Rounded corners
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         TextField(
//                           controller: customerNameController,
//                           decoration: InputDecoration(
//                             labelText: 'أسم العميل',
//                           ),
//                           onChanged: (value) {
//                             setDialogState(() {
//                               _updateCustomerExistence(value);
//                             });
//                           },
//                         ),
//                         SizedBox(height: 5),
//                         if (customerExists)
//                           Text(
//                             'العميل موجود بالفعل',
//                             style: TextStyle(color: Colors.green),
//                           )
//                         else if (customerNameController.text.isNotEmpty)
//                           Text(
//                             'العميل ليس موجود',
//                             style: TextStyle(color: Colors.red),
//                           ),
//                         SizedBox(height: 5),
//                         if (!customerExists)
//                           TextButton(
//                             onPressed: () {
//                               showAddDialog(
//                                 context,
//                                 onAdd: ()  {
//                                    billRepository
//                                       .getCustomerNames()
//                                       .then((names) {
//                                     customerNames = names;
//                                     setDialogState(() {
//                                       _updateCustomerExistence(
//                                           customerNameController.text);
//                                     });
//                                   });
//                                 },
//                               );
//                             },
//                             child: Text('اضافة عميل جديد'),
//                           ),
//                         TextField(
//                           controller: dateController,
//                           decoration: InputDecoration(
//                             labelText: 'التاريخ (يوم/شهر/سنة)',
//                           ),
//                           onChanged: (value) {
//                             // Optionally validate the date format
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () async {
//                       await showAddItemDialog(
//                         context: context,
//                         onAddItem: (item) {
//                           setDialogState(() {
//                             addItemCallback(item);
//                           });
//                         },
//                       );
//                     },
//                     child: Text('اضافة عناصر الفاتورة'),
//                   ),
//                   if (items.isNotEmpty) ...[
//                     Text('عناصر الفاتورة:', style: TextStyle(fontWeight: FontWeight.bold)),
//                     Table(
//                       border: TableBorder.all(),
//                       columnWidths: {
//                         0: FlexColumnWidth(2),
//                         1: FlexColumnWidth(2),
//                         2: FlexColumnWidth(1),
//                         3: FlexColumnWidth(1),
//                       },
//                       children: [
//                         TableRow(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text('الفئة / الفئة الفرعية', style: TextStyle(fontWeight: FontWeight.bold)),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text('الكمية', style: TextStyle(fontWeight: FontWeight.bold)),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text('السعر للوحدة', style: TextStyle(fontWeight: FontWeight.bold)),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text('السعر الإجمالي', style: TextStyle(fontWeight: FontWeight.bold)),
//                             ),
//                           ],
//                         ),
//                         ...items.map((item) {
//                           return TableRow(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text('${item.categoryName} / ${item.subcategoryName}'),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text('${item.amount}'),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text('\جنيه${item.price_per_unit}'),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text('\جنيه${(item.amount * item.price_per_unit).toStringAsFixed(2)}'),
//                               ),
//                             ],
//                           );
//                         }).toList(),
//                       ],
//                     ),
//                   ],
//                   SizedBox(height: 20),
//                   Container(
//                     padding: EdgeInsets.all(12.0),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     child: Column(
//                       children: [
//                         TextField(
//                           controller: paymentController,
//                           decoration: InputDecoration(
//                             labelText: 'المبلغ المدفوع',
//                           ),
//                           keyboardType: TextInputType.number,
//                           onChanged: (value) {
//                             setDialogState(() {
//                               final paymentAmount =
//                                   double.tryParse(value) ?? 0.0;
//
//                               if (_totalPrice == paymentAmount) {
//                                 _selectedPaymentStatus = "تم الدفع";
//                               } else if (_totalPrice < paymentAmount) {
//                                 _selectedPaymentStatus = "فاتورة مفتوحة";
//                               } else {
//                                 _selectedPaymentStatus = "آجل";
//                               }
//                             });
//                           },
//                         ),
//                         DropdownButtonFormField<String>(
//                           value: selectedVaultId,
//                           hint: Text('اختر الخزنة'),
//                           onChanged: (value) {
//                             setDialogState(() {
//                               selectedVaultId = value;
//                             });
//                           },
//                           items: vaults.map((vault) {
//                             return DropdownMenuItem<String>(
//                               value: vault['id'],
//                               child: Text(vault['name']!),
//                             );
//                           }).toList(),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             actions: [
//               Row(
//                 children: [
//                   IconButton(
//                     icon: Row(
//                       children: [
//                         Icon(
//                           _getPaymentStatusIcon(),
//                           color: _getPaymentStatusColor(),
//                         ),
//                         SizedBox(width: 8),
//                         Text(
//                           _selectedPaymentStatus,
//                           style: TextStyle(
//                             color: _getPaymentStatusColor(),
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                     onPressed: () {
//                       final paymentAmount =
//                           double.tryParse(paymentController.text) ?? 0.0;
//
//                       if (_totalPrice == paymentAmount) {
//                         setDialogState(() {
//                           _selectedPaymentStatus = "تم الدفع";
//                         });
//                       } else if (_totalPrice < paymentAmount) {
//                         setDialogState(() {
//                           _selectedPaymentStatus = "فاتورة مفتوحة";
//                         });
//                       } else {
//                         setDialogState(() {
//                           _selectedPaymentStatus = "آجل";
//                         });
//                       }
//                     },
//                   ),
//                   TextButton(
//                     onPressed: () => Navigator.of(context).pop(),
//                     child: Text('الغاء'),
//                   ),
//                   TextButton(
//                     onPressed: customerExists
//                         ? () async {
//                       final user = Supabase.instance.client.auth.currentUser;
//                       if (user != null) {
//                         final bill = Bill(
//                           status: _selectedPaymentStatus,
//                           id: 0,
//                           userId: user.id,
//                           customerName: customerNameController.text,
//                           date: dateController.text,
//                           items: items,
//                           payment: double.parse(paymentController.text),
//                           total_price: _totalPrice,
//                           vault_id: selectedVaultId!,
//                         );
//                         await onAddBill(bill);
//
//                         final payment = Payment(
//                           id: Supabase.instance.client.auth.currentUser!.id,
//                           billId: bill.id.toString(),
//                           date: DateTime.now(),
//                           userId: user.id,
//                           payment: bill.payment,
//                           payment_status: 'إيداع',
//                           createdAt: DateTime.now(),
//                         );
//
//                         final repository = BillRepository();
//                         await repository.addPaymentRecord(payment);
//
//                         await repository.addPaymentToVault(
//                           vaultId: selectedVaultId!,
//                           paymentAmount: bill.payment,
//                         );
//
//                         Navigator.of(context).pop();
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text('Error: User not authenticated'),
//                           ),
//                         );
//                       }
//                     }
//                         : null, // Disable button if customer doesn't exist
//                     child: Text('اضف الفاتورة'),
//                   ),
//                 ],
//               ),
//             ],
//           );
//         },
//       );
//     },
//   );
// }
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/billes/data/repositories/bill_repository.dart';
import 'package:system/features/billes/presentation/Dialog/adding/add_customer_dialog.dart';
import 'package:system/features/billes/presentation/Dialog/adding/showAddItemDialog.dart';

Future<void> showAddBillDialog({
  required BuildContext context,
  required Function(Bill,Payment) onAddBill,
}) async {
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController paymentController = TextEditingController();

  final List<BillItem> items = [];
  final BillRepository billRepository = BillRepository();
  String _selectedPaymentStatus = "تم الدفع"; // default status
  double _totalPrice = 0.0; // Initialize total price
  List<String> customerNames = [];
  bool customerExists = false;

  List<Map<String, String>> vaults = []; // Holds vaults fetched from Supabase
  String? selectedVaultId; // Holds the selected vault ID

  // Fetch customer names and vaults
  await billRepository.getCustomerNames().then((names) {
    customerNames = names;
  });
  await billRepository.fetchVaultList().then((fetchedVaults) {
    vaults = fetchedVaults;
  });

  void addItemCallback(BillItem item) {
    items.add(item);
    // Update total price whenever a new item is added
    _totalPrice = items.fold(
        0.0, (sum, item) => sum + (item.amount * item.price_per_unit));
  }

  // Function to return the appropriate icon based on the payment status
  IconData _getPaymentStatusIcon() {
    switch (_selectedPaymentStatus) {
      case "تم الدفع":
        return Icons.check_circle; // Green check icon
      case "فاتورة مفتوحة":
        return Icons.hourglass_empty; // Hourglass icon for open invoice
      case "آجل":
      default:
        return Icons.pending_actions; // Pending actions icon
    }
  }

  // Function to return the color based on the payment status
  Color _getPaymentStatusColor() {
    switch (_selectedPaymentStatus) {
      case "تم الدفع":
        return Colors.green;
      case "فاتورة مفتوحة":
        return Colors.blue;
      case "آجل":
      default:
        return Colors.orange;
    }
  }

  // Function to check if the customer exists after adding a new one
  void _updateCustomerExistence(String customerName) {
    customerExists = customerNames.contains(customerName);
  }

  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text('-------------- انشاء فاتورة جديدة --------------'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: customerNameController,
                          decoration: InputDecoration(
                            labelText: 'أسم العميل',
                          ),
                          onChanged: (value) {
                            setDialogState(() {
                              _updateCustomerExistence(value);
                            });
                          },
                        ),
                        SizedBox(height: 5),
                        if (customerExists)
                          Text(
                            'العميل موجود بالفعل',
                            style: TextStyle(color: Colors.green),
                          )
                        else if (customerNameController.text.isNotEmpty)
                          Text(
                            'العميل ليس موجود',
                            style: TextStyle(color: Colors.red),
                          ),
                        SizedBox(height: 5),
                        if (!customerExists)
                          TextButton(
                            onPressed: () {
                              showAddDialog(
                                context,
                                onAdd: () {
                                  billRepository
                                      .getCustomerNames()
                                      .then((names) {
                                    customerNames = names;
                                    setDialogState(() {
                                      _updateCustomerExistence(
                                          customerNameController.text);
                                    });
                                  });
                                },
                              );
                            },
                            child: Text('اضافة عميل جديد'),
                          ),
                        TextField(
                          controller: dateController,
                          decoration: InputDecoration(
                            labelText: 'التاريخ (يوم/شهر/سنة)',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await showAddItemDialog(
                        context: context,
                        onAddItem: (item) {
                          setDialogState(() {
                            addItemCallback(item);
                          });
                        },
                      );
                    },
                    child: Text('اضافة عناصر الفاتورة'),
                  ),
                  if (items.isNotEmpty) ...[
                    Text('عناصر الفاتورة:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Table(
                      border: TableBorder.all(),
                      columnWidths: {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(1),
                        3: FlexColumnWidth(1),
                      },
                      children: [
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('الفئة / الفئة الفرعية', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('الكمية', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('السعر للوحدة', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('السعر الإجمالي', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        ...items.map((item) {
                          return TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${item.categoryName} / ${item.subcategoryName}'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${item.amount}'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('\جنيه${item.price_per_unit}'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('\جنيه${(item.amount * item.price_per_unit).toStringAsFixed(2)}'),
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ],
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: paymentController,
                          decoration: InputDecoration(
                            labelText: 'المبلغ المدفوع',
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setDialogState(() {
                              final paymentAmount =
                                  double.tryParse(value) ?? 0.0;

                              if (_totalPrice == paymentAmount) {
                                _selectedPaymentStatus = "تم الدفع";
                              } else if (_totalPrice < paymentAmount) {
                                _selectedPaymentStatus = "فاتورة مفتوحة";
                              } else {
                                _selectedPaymentStatus = "آجل";
                              }
                            });
                          },
                        ),
                        DropdownButtonFormField<String>(
                          value: selectedVaultId,
                          hint: Text('اختر الخزنة'),
                          onChanged: (value) {
                            setDialogState(() {
                              selectedVaultId = value;
                            });
                          },
                          items: vaults.map((vault) {
                            return DropdownMenuItem<String>(
                              value: vault['id'],
                              child: Text(vault['name']!),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                children: [
                  IconButton(
                    icon: Row(
                      children: [
                        Icon(
                          _getPaymentStatusIcon(),
                          color: _getPaymentStatusColor(),
                        ),
                        SizedBox(width: 8),
                        Text(
                          _selectedPaymentStatus,
                          style: TextStyle(
                            color: _getPaymentStatusColor(),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      final paymentAmount =
                          double.tryParse(paymentController.text) ?? 0.0;

                      if (_totalPrice == paymentAmount) {
                        setDialogState(() {
                          _selectedPaymentStatus = "تم الدفع";
                        });
                      } else if (_totalPrice < paymentAmount) {
                        setDialogState(() {
                          _selectedPaymentStatus = "فاتورة مفتوحة";
                        });
                      } else {
                        setDialogState(() {
                          _selectedPaymentStatus = "آجل";
                        });
                      }
                    },
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('الغاء'),
                  ),
                  TextButton(
                    onPressed: customerExists
                        ? () async {
                      final user = Supabase.instance.client.auth.currentUser;
                      if (user != null) {
                        final bill = Bill(
                          status: _selectedPaymentStatus,
                          id: 0,
                          userId: user.id,
                          customerName: customerNameController.text,
                          date: dateController.text,
                          items: items,
                          payment: double.parse(paymentController.text),
                          total_price: _totalPrice,
                          vault_id: selectedVaultId!,
                        );


                        final payment = Payment(
                          id: Supabase.instance.client.auth.currentUser!.id,
                          // id: 0,
                          billId: bill.id ,
                          date: DateTime.now(),
                          userId: user.id,
                          payment: bill.payment,
                          payment_status: 'إيداع',
                          createdAt: DateTime.now(),
                        );
                        await onAddBill(bill,payment);
                        final repository = BillRepository();
                        // await repository.addPaymentRecord(payment);

                        // await repository.addPaymentToVault(
                        //   vaultId: selectedVaultId!,
                        //   paymentAmount: bill.payment  ,
                        // );

                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: User not authenticated'),
                          ),
                        );
                      }
                    }
                        : null, // Disable button if customer doesn't exist
                    child: Text('اضف الفاتورة'),
                  ),
                ],
              ),
            ],
          );
        },
      );
    },
  );
}
