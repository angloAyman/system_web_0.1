// // // import 'package:flutter/material.dart';
// // // import 'package:system/features/billes/presentation/Dialog/showAddBillDialog.dart';
// // // import 'package:system/features/billes/presentation/generatePdf.dart';
// // // import '../data/repositories/bill_repository.dart';
// // // import '../data/models/bill_model.dart';
// // //
// // // class BillingPage extends StatefulWidget {
// // //   @override
// // //   _BillingPageState createState() => _BillingPageState();
// // // }
// // //
// // // class _BillingPageState extends State<BillingPage> {
// // //   final BillRepository _billRepository = BillRepository();
// // //   late Future<List<Bill>> _billsFuture;
// // //   List<Bill> _bills = [];
// // //   List<Bill> _filteredBills = [];
// // //   final TextEditingController _searchController = TextEditingController();
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _billsFuture = _billRepository.getBills();
// // //     _billsFuture.then((bills) {
// // //       setState(() {
// // //         _bills = bills;
// // //         _filteredBills = bills;
// // //       });
// // //     });
// // //     _searchController.addListener(_filterBills);
// // //   }
// // //
// // //   void _filterBills() {
// // //     final query = _searchController.text.toLowerCase();
// // //     setState(() {
// // //       _filteredBills = _bills.where((bill) {
// // //         return bill.id.toString().contains(query);
// // //       }).toList();
// // //     });
// // //   }
// // //
// // //   void _addBill(Bill bill) async {
// // //     try {
// // //       await _billRepository.addBill(bill);
// // //       setState(() {
// // //         _billsFuture = _billRepository.getBills();
// // //         _billsFuture.then((bills) {
// // //           setState(() {
// // //             _bills = bills;
// // //             _filteredBills = bills;
// // //           });
// // //         });
// // //       });
// // //     } catch (e) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(content: Text('Error adding bill: $e')),
// // //       );
// // //     }
// // //   }
// // //
// // //   void _refreshBills() {
// // //     setState(() {
// // //       _billsFuture = _billRepository.getBills();
// // //       _billsFuture.then((bills) {
// // //         setState(() {
// // //           _bills = bills;
// // //           _filteredBills = bills;
// // //         });
// // //       });
// // //     });
// // //   }
// // //   // Function to remove a bill
// // //   void _removeBill(int billId) async {
// // //     try {
// // //       await _billRepository.removeBill(billId);
// // //       _refreshBills();
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(content: Text('Bill removed successfully')),
// // //       );
// // //     } catch (e) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(content: Text('Error removing bill: $e')),
// // //       );
// // //     }
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text('Billing'),
// // //         actions: [
// // //           Expanded(
// // //             child: Padding(
// // //               padding: const EdgeInsets.symmetric(horizontal: 16.0),
// // //               child: TextField(
// // //                 cursorColor: Colors.black12,
// // //                 controller: _searchController,
// // //                 decoration: InputDecoration(
// // //                   hintText: 'Search by Bill ID',
// // //                   hintStyle: TextStyle(color: Colors.deepPurple),
// // //                   border: InputBorder.none,
// // //                   icon: Icon(Icons.search, color: Colors.purple),
// // //                 ),
// // //                 style: TextStyle(color: Colors.purpleAccent),
// // //               ),
// // //             ),
// // //           ),
// // //           IconButton(
// // //             icon: Icon(Icons.add),
// // //             onPressed: () {
// // //               showAddBillDialog(
// // //                 context: context,
// // //                 onAddBill: _addBill,
// // //               );
// // //             },
// // //           ),
// // //         ],
// // //       ),
// // //       body: FutureBuilder<List<Bill>>(
// // //         future: _billsFuture,
// // //         builder: (context, snapshot) {
// // //           if (snapshot.connectionState == ConnectionState.waiting) {
// // //             return Center(child: CircularProgressIndicator());
// // //           } else if (snapshot.hasError) {
// // //             return Center(child: Text('Error: ${snapshot.error}'));
// // //           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
// // //             return Center(child: Text('No bills found.'));
// // //           }
// // //           return ListView.builder(
// // //             itemCount: _filteredBills.length,
// // //             itemBuilder: (context, index) {
// // //               final bill = _filteredBills[index];
// // //               double total = bill.items
// // //                   .fold(0.0, (sum, item) => sum + (item.amount * item.price));
// // //               return ExpansionTile(
// // //                 title: Text('${bill.id} - ${bill.customerName} - ${bill.date}'),
// // //                 subtitle: Text('Total: \L.E ${total.toStringAsFixed(2)}'),
// // //                 children: [
// // //                   ...bill.items.map((item) {
// // //                     return ListTile(
// // //                       title: Text(
// // //                           '${item.categoryName} / ${item.subcategoryName}'),
// // //                       subtitle: Text(
// // //                           'Amount: ${item.amount}, Price: \$${item.price}'),
// // //                     );
// // //                   }).toList(),
// // //                   Row(
// // //                     mainAxisAlignment: MainAxisAlignment.end,
// // //                     children: [
// // //                       TextButton.icon(
// // //                         onPressed: () => _removeBill(bill.id),
// // //                         icon: Icon(Icons.delete, color: Colors.red),
// // //                         label: Text('Remove Bill',
// // //                             style: TextStyle(color: Colors.red)),
// // //                       ),
// // //                       TextButton.icon(
// // //                         onPressed: () async => await PdfGenerator(),
// // //                         icon: Icon(Icons.picture_as_pdf, color: Colors.purple),
// // //                         label: Text('pdf',
// // //                             style: TextStyle(color: Colors.purple)),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ],
// // //               );
// // //             },
// // //           );
// // //         },
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // // // // //
// // // // //
// // // // // // import 'package:flutter/material.dart';
// // // // // // import 'package:share/share.dart';
// // // // // // import 'package:system/core/constants/colors.dart';
// // // // // // import 'package:system/core/themes/them_constants.dart';
// // // // // // import 'package:system/features/billes/data/models/bill_model.dart';
// // // // // // import 'package:system/features/billes/data/repositories/bill_repository.dart';
// // // // // // import 'package:system/features/billes/presentation/Dialog/showAddBillDialog.dart';
// // // // // // import 'package:system/features/billes/testPdfGeneration.dart';
// // // // // //
// // // // // // class BillingPage extends StatefulWidget {
// // // // // //   @override
// // // // // //   _BillingPageState createState() => _BillingPageState();
// // // // // // }
// // // // // //
// // // // // // class _BillingPageState extends State<BillingPage> {
// // // // // //   final BillRepository _billRepository = BillRepository();
// // // // // //   late Future<List<Bill>> _billsFuture;
// // // // // //   List<Bill> _bills = [];
// // // // // //   List<Bill> _filteredBills = [];
// // // // // //   final TextEditingController _searchController = TextEditingController();
// // // // // //
// // // // // //   @override
// // // // // //   void initState() {
// // // // // //     super.initState();
// // // // // //     _billsFuture = _billRepository.getBills();
// // // // // //     _billsFuture.then((bills) {
// // // // // //       setState(() {
// // // // // //         _bills = bills;
// // // // // //         _filteredBills = bills;
// // // // // //       });
// // // // // //     });
// // // // // //     _searchController.addListener(_filterBills);
// // // // // //   }
// // // // // //
// // // // // //   void _filterBills() {
// // // // // //     final query = _searchController.text.toLowerCase();
// // // // // //     setState(() {
// // // // // //       _filteredBills = _bills.where((bill) {
// // // // // //         return bill.id.toString().contains(query);
// // // // // //       }).toList();
// // // // // //     });
// // // // // //   }
// // // // // //
// // // // // //   void _addBill(Bill bill) async {
// // // // // //     try {
// // // // // //       await _billRepository.addBill(bill);
// // // // // //       setState(() {
// // // // // //         _billsFuture = _billRepository.getBills();
// // // // // //         _billsFuture.then((bills) {
// // // // // //           setState(() {
// // // // // //             _bills = bills;
// // // // // //             _filteredBills = bills;
// // // // // //           });
// // // // // //         });
// // // // // //       });
// // // // // //     } catch (e) {
// // // // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // // // //         SnackBar(content: Text('Error adding bill: $e')),
// // // // // //       );
// // // // // //     }
// // // // // //   }
// // // // // //
// // // // // //   void _refreshBills() {
// // // // // //     setState(() {
// // // // // //       _billsFuture = _billRepository.getBills();
// // // // // //       _billsFuture.then((bills) {
// // // // // //         setState(() {
// // // // // //           _bills = bills;
// // // // // //           _filteredBills = bills;
// // // // // //         });
// // // // // //       });
// // // // // //     });
// // // // // //   }
// // // // // //
// // // // // //   // Function to remove a bill
// // // // // //   void _removeBill(int billId) async {
// // // // // //     try {
// // // // // //       await _billRepository.removeBill(billId);
// // // // // //       _refreshBills();
// // // // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // // // //         SnackBar(content: Text('Bill removed successfully')),
// // // // // //       );
// // // // // //     } catch (e) {
// // // // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // // // //         SnackBar(content: Text('Error removing bill: $e')),
// // // // // //       );
// // // // // //     }
// // // // // //   }
// // // // // //
// // // // // //   // void _generateAndShareBillPdf(Bill bill) async {
// // // // // //   //   final pdfGenerator = generatePdf(bill);
// // // // // //   //   final pdfPath = await pdfGenerator.generatePdf(bill);
// // // // // //   //   Share.shareFiles([pdfPath], text: 'Check out this PDF report!');
// // // // // //   // }
// // // // // //
// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     return Scaffold(
// // // // // //       appBar: AppBar(
// // // // // //         title: Text('Billing'),
// // // // // //         actions: [
// // // // // //           Expanded(
// // // // // //             child: Padding(
// // // // // //               padding: const EdgeInsets.symmetric(horizontal: 16.0),
// // // // // //               child: TextField(
// // // // // //                 controller: _searchController,
// // // // // //                 decoration: InputDecoration(
// // // // // //                   hintText: 'بحث برقم الفاتورة',
// // // // // //                   hintStyle: TextStyle(color: AppColors.primary),
// // // // // //                   border: InputBorder.none,
// // // // // //                   icon: Icon(Icons.search, color: AppColors.primary),
// // // // // //                 ),
// // // // // //                 style: TextStyle(color: AppColors.primary),
// // // // // //               ),
// // // // // //             ),
// // // // // //           ),
// // // // // //           IconButton(
// // // // // //             icon: Icon(Icons.add),
// // // // // //             onPressed: () {
// // // // // //               showAddBillDialog(
// // // // // //                 context: context,
// // // // // //                 onAddBill: _addBill,
// // // // // //               );
// // // // // //             },
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //       body: Container(
// // // // // //         child: FutureBuilder<List<Bill>>(
// // // // // //           future: _billsFuture,
// // // // // //           builder: (context, snapshot) {
// // // // // //             if (snapshot.connectionState == ConnectionState.waiting) {
// // // // // //               return Center(child: CircularProgressIndicator());
// // // // // //             } else if (snapshot.hasError) {
// // // // // //               return Center(child: Text('Error: ${snapshot.error}'));
// // // // // //             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
// // // // // //               return Center(child: Text('No bills found.'));
// // // // // //             }
// // // // // //
// // // // // //             return ListView.builder(
// // // // // //               itemCount: _filteredBills.length,
// // // // // //               itemBuilder: (context, index) {
// // // // // //                 final bill = _filteredBills[index];
// // // // // //                 double total = bill.items
// // // // // //                     .fold(0.0, (sum, item) => sum + (item.amount * item.price));
// // // // // //
// // // // // //                 return ExpansionTile(
// // // // // //                   title: Text('${bill.id} - ${bill.customerName} - ${bill.date}'),
// // // // // //                   subtitle: Text('Total: \L.E ${total.toStringAsFixed(2)}'),
// // // // // //                   children: [
// // // // // //                     ...bill.items.map((item) {
// // // // // //                       return ListTile(
// // // // // //                         title: Text(
// // // // // //                             '${item.categoryName} / ${item.subcategoryName}'),
// // // // // //                         subtitle: Text(
// // // // // //                             'Amount: ${item.amount}, Price: \$${item.price}'),
// // // // // //                       );
// // // // // //                     }).toList(),
// // // // // //                     Row(
// // // // // //                       mainAxisAlignment: MainAxisAlignment.end,
// // // // // //                       children: [
// // // // // //                         IconButton(
// // // // // //                           icon: Icon(Icons.picture_as_pdf),
// // // // // //                           onPressed: () {
// // // // // //                             generateArabicPdf(bill,context);
// // // // // //
// // // // // //                             // generatePdf( bill); // bill is your current bill object
// // // // // //                           },
// // // // // //                         ),
// // // // // //                         TextButton.icon(
// // // // // //                           onPressed: () => _removeBill(bill.id),
// // // // // //                           icon: Icon(Icons.delete, color: Colors.red),
// // // // // //                           label: Text('Remove Bill',
// // // // // //                               style: TextStyle(color: Colors.red)),
// // // // // //                         ),
// // // // // //                       ],
// // // // // //                     ),
// // // // // //                   ],
// // // // // //                 );
// // // // // //               },
// // // // // //             );
// // // // // //           },
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // // }
// // // // //
// // // // // // import 'package:flutter/material.dart';
// // // // // // import 'package:share/share.dart';
// // // // // // import 'package:system/core/constants/colors.dart';
// // // // // // import 'package:system/core/themes/them_constants.dart';
// // // // // // import 'package:system/features/billes/data/models/bill_model.dart';
// // // // // // import 'package:system/features/billes/data/repositories/bill_repository.dart';
// // // // // // import 'package:system/features/billes/presentation/Dialog/showAddBillDialog.dart';
// // // // // // import 'package:system/features/billes/testPdfGeneration.dart';
// // // // // //
// // // // // // class BillingPage extends StatefulWidget {
// // // // // //   @override
// // // // // //   _BillingPageState createState() => _BillingPageState();
// // // // // // }
// // // // // //
// // // // // // class _BillingPageState extends State<BillingPage> {
// // // // // //   final BillRepository _billRepository = BillRepository();
// // // // // //   late Future<List<Bill>> _billsFuture;
// // // // // //   List<Bill> _bills = [];
// // // // // //   List<Bill> _filteredBills = [];
// // // // // //   final TextEditingController _searchController = TextEditingController();
// // // // // //
// // // // // //   @override
// // // // // //   void initState() {
// // // // // //     super.initState();
// // // // // //     _billsFuture = _billRepository.getBills();
// // // // // //     _billsFuture.then((bills) {
// // // // // //       setState(() {
// // // // // //         _bills = bills;
// // // // // //         _filteredBills = bills;
// // // // // //       });
// // // // // //     });
// // // // // //     _searchController.addListener(_filterBills);
// // // // // //   }
// // // // // //
// // // // // //   void _filterBills() {
// // // // // //     final query = _searchController.text.toLowerCase();
// // // // // //     setState(() {
// // // // // //       _filteredBills = _bills.where((bill) {
// // // // // //         return bill.id.toString().contains(query);
// // // // // //       }).toList();
// // // // // //     });
// // // // // //   }
// // // // // //
// // // // // //   void _addBill(Bill bill) async {
// // // // // //     try {
// // // // // //       await _billRepository.addBill(bill);
// // // // // //       _refreshBills();
// // // // // //     } catch (e) {
// // // // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // // // //         SnackBar(content: Text('Error adding bill: $e')),
// // // // // //       );
// // // // // //     }
// // // // // //   }
// // // // // //
// // // // // //   void _refreshBills() {
// // // // // //     setState(() {
// // // // // //       _billsFuture = _billRepository.getBills();
// // // // // //       _billsFuture.then((bills) {
// // // // // //         setState(() {
// // // // // //           _bills = bills;
// // // // // //           _filteredBills = bills;
// // // // // //         });
// // // // // //       });
// // // // // //     });
// // // // // //   }
// // // // // //
// // // // // //   void _confirmRemoveBill(int billId) {
// // // // // //     showDialog(
// // // // // //       context: context,
// // // // // //       builder: (context) => AlertDialog(
// // // // // //         title: Text('تأكيد الحذف'),
// // // // // //         content: Text('هل أنت متأكد من أنك تريد حذف هذه الفاتورة؟'),
// // // // // //         actions: [
// // // // // //           TextButton(
// // // // // //             onPressed: () => Navigator.of(context).pop(),
// // // // // //             child: Text('إلغاء'),
// // // // // //           ),
// // // // // //           TextButton(
// // // // // //             onPressed: () {
// // // // // //               Navigator.of(context).pop();
// // // // // //               _removeBill(billId);
// // // // // //             },
// // // // // //             child: Text('حذف', style: TextStyle(color: Colors.red)),
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   void _removeBill(int billId) async {
// // // // // //     try {
// // // // // //       await _billRepository.removeBill(billId);
// // // // // //       _refreshBills();
// // // // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // // // //         SnackBar(content: Text('تم حذف الفاتورة بنجاح')),
// // // // // //       );
// // // // // //     } catch (e) {
// // // // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // // // //         SnackBar(content: Text('خطأ أثناء حذف الفاتورة: $e')),
// // // // // //       );
// // // // // //     }
// // // // // //   }
// // // // // //
// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     return Scaffold(
// // // // // //       appBar: AppBar(
// // // // // //         title: Text('الفواتير'),
// // // // // //         bottom: PreferredSize(
// // // // // //           preferredSize: Size.fromHeight(56.0),
// // // // // //           child: Padding(
// // // // // //             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
// // // // // //             child: TextField(
// // // // // //               controller: _searchController,
// // // // // //               decoration: InputDecoration(
// // // // // //                 hintText: 'بحث برقم الفاتورة',
// // // // // //                 prefixIcon: Icon(Icons.search, color: AppColors.primary),
// // // // // //                 filled: true,
// // // // // //                 fillColor: Colors.white,
// // // // // //                 border: OutlineInputBorder(
// // // // // //                   borderRadius: BorderRadius.circular(8.0),
// // // // // //                   borderSide: BorderSide.none,
// // // // // //                 ),
// // // // // //               ),
// // // // // //               style: TextStyle(color: AppColors.primary),
// // // // // //             ),
// // // // // //           ),
// // // // // //         ),
// // // // // //         actions: [
// // // // // //         IconButton(
// // // // // //             icon: Icon(Icons.add),
// // // // // //             onPressed: () {
// // // // // //               showAddBillDialog(
// // // // // //                 context: context,
// // // // // //                 onAddBill: _addBill,
// // // // // //               );
// // // // // //             },
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //       body: FutureBuilder<List<Bill>>(
// // // // // //         future: _billsFuture,
// // // // // //         builder: (context, snapshot) {
// // // // // //           if (snapshot.connectionState == ConnectionState.waiting) {
// // // // // //             return Center(child: CircularProgressIndicator());
// // // // // //           } else if (snapshot.hasError) {
// // // // // //             return Center(child: Text('خطأ: ${snapshot.error}'));
// // // // // //           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
// // // // // //             return Center(
// // // // // //               child: Column(
// // // // // //                 mainAxisSize: MainAxisSize.min,
// // // // // //                 children: [
// // // // // //                   Icon(Icons.receipt_long, size: 64, color: Colors.grey),
// // // // // //                   SizedBox(height: 8),
// // // // // //                   Text('لا توجد فواتير حالياً.', style: TextStyle(color: Colors.grey)),
// // // // // //                 ],
// // // // // //               ),
// // // // // //             );
// // // // // //           }
// // // // // //
// // // // // //           return ListView.builder(
// // // // // //             itemCount: _filteredBills.length,
// // // // // //             itemBuilder: (context, index) {
// // // // // //               final bill = _filteredBills[index];
// // // // // //               double total = bill.items.fold(0.0, (sum, item) => sum + (item.amount * item.price));
// // // // // //
// // // // // //               return ExpansionTile(
// // // // // //                 title: Text('${bill.id} - ${bill.customerName} - ${bill.date}'),
// // // // // //                 subtitle: Text('الإجمالي: L.E ${total.toStringAsFixed(2)}'),
// // // // // //                 children: [
// // // // // //                   Padding(
// // // // // //                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
// // // // // //                     child: Column(
// // // // // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //                       children: [
// // // // // //                         Text('العناصر:', style: TextStyle(fontWeight: FontWeight.bold)),
// // // // // //                         ...bill.items.map((item) => Padding(
// // // // // //                           padding: const EdgeInsets.symmetric(vertical: 4.0),
// // // // // //                           child: Row(
// // // // // //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // // //                             children: [
// // // // // //                               Text('${item.categoryName} / ${item.subcategoryName}'),
// // // // // //                               Text('الكمية: ${item.amount}, السعر: L.E ${item.price}'),
// // // // // //                             ],
// // // // // //                           ),
// // // // // //                         )),
// // // // // //                       ],
// // // // // //                     ),
// // // // // //                   ),
// // // // // //                   ButtonBar(
// // // // // //                     alignment: MainAxisAlignment.end,
// // // // // //                     children: [
// // // // // //                       IconButton(
// // // // // //                         icon: Icon(Icons.picture_as_pdf),
// // // // // //                         onPressed: () => generateArabicPdf(bill, context),
// // // // // //                       ),
// // // // // //                       TextButton.icon(
// // // // // //                         onPressed: () => _confirmRemoveBill(bill.id),
// // // // // //                         icon: Icon(Icons.delete, color: Colors.red),
// // // // // //                         label: Text('حذف', style: TextStyle(color: Colors.red)),
// // // // // //                       ),
// // // // // //                     ],
// // // // // //                   ),
// // // // // //                 ],
// // // // // //               );
// // // // // //             },
// // // // // //           );
// // // // // //         },
// // // // // //       ),
// // // // // //       floatingActionButton: FloatingActionButton(
// // // // // //         onPressed: () {
// // // // // //           showAddBillDialog(
// // // // // //             context: context,
// // // // // //             onAddBill: _addBill,
// // // // // //           );
// // // // // //         },
// // // // // //         child: Icon(Icons.add),
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // // }
// // // // //
// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:system/core/themes/them_constants.dart';
// // // // // import 'package:system/features/billes/data/models/bill_model.dart';
// // // // // import 'package:system/features/billes/data/repositories/bill_repository.dart';
// // // // // import 'package:system/features/billes/presentation/Dialog/showAddBillDialog.dart';
// // // // //
// // // // // class BillingPage extends StatefulWidget {
// // // // //   @override
// // // // //   _BillingPageState createState() => _BillingPageState();
// // // // // }
// // // // //
// // // // // class _BillingPageState extends State<BillingPage> {
// // // // //   final BillRepository _billRepository = BillRepository();
// // // // //   late Future<List<Bill>> _billsFuture;
// // // // //   List<Bill> _bills = [];
// // // // //   List<Bill> _filteredBills = [];
// // // // //   final TextEditingController _searchController = TextEditingController();
// // // // //   String? _selectedStatus; // "تم الدفع" أو "آجل" أو null للتصفية
// // // // //
// // // // //   @override
// // // // //   void initState() {
// // // // //     super.initState();
// // // // //     _billsFuture = _billRepository.getBills();
// // // // //     _billsFuture.then((bills) {
// // // // //       setState(() {
// // // // //         _bills = bills;
// // // // //         _filteredBills = bills;
// // // // //       });
// // // // //     });
// // // // //     _searchController.addListener(_filterBills);
// // // // //   }
// // // // //
// // // // //   void _filterBills() {
// // // // //     final query = _searchController.text.toLowerCase();
// // // // //     setState(() {
// // // // //       _filteredBills = _bills.where((bill) {
// // // // //         final matchesSearch = bill.id.toString().contains(query);
// // // // //         final matchesStatus = _selectedStatus == null || bill.status == _selectedStatus;
// // // // //         return matchesSearch && matchesStatus;
// // // // //       }).toList();
// // // // //     });
// // // // //   }
// // // // //
// // // // //   void _addBill(Bill bill) async {
// // // // //     try {
// // // // //       await _billRepository.addBill(bill);
// // // // //       _refreshBills();
// // // // //     } catch (e) {
// // // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // // //         SnackBar(content: Text('Error adding bill: $e')),
// // // // //       );
// // // // //     }
// // // // //   }
// // // // //
// // // // //   void _refreshBills() {
// // // // //     setState(() {
// // // // //       _billsFuture = _billRepository.getBills();
// // // // //       _billsFuture.then((bills) {
// // // // //         setState(() {
// // // // //           _bills = bills;
// // // // //           _filteredBills = bills;
// // // // //         });
// // // // //       });
// // // // //     });
// // // // //   }
// // // // //
// // // // //   void _setFilter(String? status) {
// // // // //     setState(() {
// // // // //       _selectedStatus = status;
// // // // //       _filterBills();
// // // // //     });
// // // // //   }
// // // // //
// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Scaffold(
// // // // //       appBar: AppBar(
// // // // //         title: Text('الفواتير'),
// // // // //         bottom: PreferredSize(
// // // // //           preferredSize: Size.fromHeight(112.0),
// // // // //           child: Container(
// // // // //             color: AppColors.background2 ,
// // // // //             child: Column(
// // // // //               children: [
// // // // //                 Padding(
// // // // //                   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
// // // // //                   child: TextField(
// // // // //                     controller: _searchController,
// // // // //                     decoration: InputDecoration(
// // // // //                       hintText: 'بحث برقم الفاتورة',
// // // // //                       prefixIcon: Icon(Icons.search, color: Colors.white),
// // // // //                       filled: true,
// // // // //                       fillColor: Colors.white,
// // // // //                       border: OutlineInputBorder(
// // // // //                         borderRadius: BorderRadius.circular(8.0),
// // // // //                         borderSide: BorderSide.none,
// // // // //                       ),
// // // // //                     ),
// // // // //                     style: TextStyle(color: Colors.black),
// // // // //                   ),
// // // // //                 ),
// // // // //                 Padding(
// // // // //                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
// // // // //                   child: Row(
// // // // //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // //                     children: [
// // // // //                       Text('تصفية حسب حالة الدفع:', style: TextStyle(color: Colors.white)),
// // // // //                       DropdownButton<String>(
// // // // //                         value: _selectedStatus,
// // // // //                         hint: Text('اختر حالة الدفع', style: TextStyle(color: Colors.white)),
// // // // //                         dropdownColor: Colors.blue,
// // // // //                         items: [
// // // // //                           DropdownMenuItem(
// // // // //                             value: null,
// // // // //                             child: Text('الكل', style: TextStyle(color: Colors.white)),
// // // // //                           ),
// // // // //                           DropdownMenuItem(
// // // // //                             value: 'تم الدفع',
// // // // //                             child: Text('تم الدفع', style: TextStyle(color: Colors.white)),
// // // // //                           ),
// // // // //                           DropdownMenuItem(
// // // // //                             value: 'آجل',
// // // // //                             child: Text('آجل', style: TextStyle(color: Colors.white)),
// // // // //                           ),
// // // // //                         ],
// // // // //                         onChanged: (value) => _setFilter(value),
// // // // //                       ),
// // // // //                     ],
// // // // //                   ),
// // // // //                 ),
// // // // //               ],
// // // // //             ),
// // // // //           ),
// // // // //         ),
// // // // //       ),
// // // // //       body: FutureBuilder<List<Bill>>(
// // // // //         future: _billsFuture,
// // // // //         builder: (context, snapshot) {
// // // // //           if (snapshot.connectionState == ConnectionState.waiting) {
// // // // //             return Center(child: CircularProgressIndicator());
// // // // //           } else if (snapshot.hasError) {
// // // // //             return Center(child: Text('خطأ: ${snapshot.error}'));
// // // // //           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
// // // // //             return Center(child: Text('لا توجد فواتير حالياً.'));
// // // // //           }
// // // // //
// // // // //           return ListView.builder(
// // // // //             itemCount: _filteredBills.length,
// // // // //             itemBuilder: (context, index) {
// // // // //               final bill = _filteredBills[index];
// // // // //               double total = bill.items.fold(0.0, (sum, item) => sum + (item.amount * item.price));
// // // // //
// // // // //               return ListTile(
// // // // //                 title: Text('${bill.id} - ${bill.customerName} - ${bill.date}'),
// // // // //                 subtitle: Text('الإجمالي: L.E ${total.toStringAsFixed(2)}'),
// // // // //                 trailing: Text(
// // // // //                   bill.status,
// // // // //                   style: TextStyle(
// // // // //                     color: bill.status == 'تم الدفع' ? Colors.green : Colors.orange,
// // // // //                   ),
// // // // //                 ),
// // // // //               );
// // // // //             },
// // // // //           );
// // // // //         },
// // // // //       ),
// // // // //       floatingActionButton: FloatingActionButton(
// // // // //         onPressed: () {
// // // // //           showAddBillDialog(
// // // // //             context: context,
// // // // //             onAddBill: _addBill,
// // // // //           );
// // // // //         },
// // // // //         child: Icon(Icons.add),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }
// // // //
// // // // import 'package:flutter/material.dart';
// // // // import 'package:system/features/billes/data/models/bill_model.dart';
// // // // import 'package:system/features/billes/data/repositories/bill_repository.dart';
// // // // import 'package:system/features/billes/presentation/Dialog/showAddBillDialog.dart';
// // // //
// // // // class BillingPage extends StatefulWidget {
// // // //   @override
// // // //   _BillingPageState createState() => _BillingPageState();
// // // // }
// // // //
// // // // class _BillingPageState extends State<BillingPage> {
// // // //   final BillRepository _billRepository = BillRepository();
// // // //   late Future<List<Bill>> _billsFuture;
// // // //   List<Bill> _bills = [];
// // // //   List<Bill> _filteredBills = [];
// // // //   final TextEditingController _searchController = TextEditingController();
// // // //   String? _selectedStatus;
// // // //
// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     _billsFuture = _billRepository.getBills();
// // // //     _billsFuture.then((bills) {
// // // //       setState(() {
// // // //         _bills = bills;
// // // //         _filteredBills = bills;
// // // //       });
// // // //     });
// // // //     _searchController.addListener(_filterBills);
// // // //   }
// // // //
// // // //   void _filterBills() {
// // // //     final query = _searchController.text.toLowerCase();
// // // //     setState(() {
// // // //       _filteredBills = _bills.where((bill) {
// // // //         final matchesSearch = bill.id.toString().contains(query);
// // // //         final matchesStatus = _selectedStatus == null || bill.status == _selectedStatus;
// // // //         return matchesSearch && matchesStatus;
// // // //       }).toList();
// // // //     });
// // // //   }
// // // //
// // // //   void _addBill(Bill bill) async {
// // // //     try {
// // // //       await _billRepository.addBill(bill);
// // // //       _refreshBills();
// // // //     } catch (e) {
// // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // //         SnackBar(content: Text('Error adding bill: $e')),
// // // //       );
// // // //     }
// // // //   }
// // // //
// // // //   void _refreshBills() {
// // // //     setState(() {
// // // //       _billsFuture = _billRepository.getBills();
// // // //       _billsFuture.then((bills) {
// // // //         setState(() {
// // // //           _bills = bills;
// // // //           _filteredBills = bills;
// // // //         });
// // // //       });
// // // //     });
// // // //   }
// // // //
// // // //   void _showBillDetailsDialog(Bill bill) {
// // // //     showDialog(
// // // //       context: context,
// // // //       builder: (context) {
// // // //         return AlertDialog(
// // // //           title: Text('تفاصيل الفاتورة'),
// // // //           content: SingleChildScrollView(
// // // //             child: Column(
// // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // //               children: [
// // // //                 Text('رقم الفاتورة: ${bill.id}'),
// // // //                 Text('اسم العميل: ${bill.customerName}'),
// // // //                 Text('التاريخ: ${bill.date}'),
// // // //                 Text('حالة الدفع: ${bill.status}'),
// // // //                 SizedBox(height: 16),
// // // //                 Text('الأصناف:', style: TextStyle(fontWeight: FontWeight.bold)),
// // // //                 ...bill.items.map((item) {
// // // //                   return ListTile(
// // // //                     title: Text('${item.categoryName} / ${item.subcategoryName}'),
// // // //                     subtitle: Text('الكمية: ${item.amount}, السعر: ${item.price}'),
// // // //                   );
// // // //                 }).toList(),
// // // //                 Divider(),
// // // //                 Text(
// // // //                   'الإجمالي: L.E ${bill.items.fold(0.0, (sum, item) => sum + (item.amount * item.price)).toStringAsFixed(2)}',
// // // //                   style: TextStyle(fontWeight: FontWeight.bold),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //           actions: [
// // // //             TextButton(
// // // //               onPressed: () => Navigator.of(context).pop(),
// // // //               child: Text('إغلاق'),
// // // //             ),
// // // //           ],
// // // //         );
// // // //       },
// // // //     );
// // // //   }
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(
// // // //         title: Text('الفواتير'),
// // // //         bottom: PreferredSize(
// // // //           preferredSize: Size.fromHeight(112.0),
// // // //           child: Column(
// // // //             children: [
// // // //               Padding(
// // // //                 padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
// // // //                 child: TextField(
// // // //                   controller: _searchController,
// // // //                   decoration: InputDecoration(
// // // //                     hintText: 'بحث برقم الفاتورة',
// // // //                     prefixIcon: Icon(Icons.search, color: Colors.white),
// // // //                     filled: true,
// // // //                     fillColor: Colors.white,
// // // //                     border: OutlineInputBorder(
// // // //                       borderRadius: BorderRadius.circular(8.0),
// // // //                       borderSide: BorderSide.none,
// // // //                     ),
// // // //                   ),
// // // //                   style: TextStyle(color: Colors.black),
// // // //                 ),
// // // //               ),
// // // //               Padding(
// // // //                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
// // // //                 child: Row(
// // // //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //                   children: [
// // // //                     Text('تصفية حسب حالة الدفع:', style: TextStyle(color: Colors.white)),
// // // //                     DropdownButton<String>(
// // // //                       value: _selectedStatus,
// // // //                       hint: Text('اختر حالة الدفع', style: TextStyle(color: Colors.white)),
// // // //                       dropdownColor: Colors.blue,
// // // //                       items: [
// // // //                         DropdownMenuItem(
// // // //                           value: null,
// // // //                           child: Text('الكل', style: TextStyle(color: Colors.white)),
// // // //                         ),
// // // //                         DropdownMenuItem(
// // // //                           value: 'تم الدفع',
// // // //                           child: Text('تم الدفع', style: TextStyle(color: Colors.white)),
// // // //                         ),
// // // //                         DropdownMenuItem(
// // // //                           value: 'آجل',
// // // //                           child: Text('آجل', style: TextStyle(color: Colors.white)),
// // // //                         ),
// // // //                       ],
// // // //                       onChanged: (value) {
// // // //                         setState(() {
// // // //                           _selectedStatus = value;
// // // //                           _filterBills();
// // // //                         });
// // // //                       },
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         ),
// // // //       ),
// // // //       body: FutureBuilder<List<Bill>>(
// // // //         future: _billsFuture,
// // // //         builder: (context, snapshot) {
// // // //           if (snapshot.connectionState == ConnectionState.waiting) {
// // // //             return Center(child: CircularProgressIndicator());
// // // //           } else if (snapshot.hasError) {
// // // //             return Center(child: Text('خطأ: ${snapshot.error}'));
// // // //           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
// // // //             return Center(child: Text('لا توجد فواتير حالياً.'));
// // // //           }
// // // //
// // // //           return ListView.builder(
// // // //             itemCount: _filteredBills.length,
// // // //             itemBuilder: (context, index) {
// // // //               final bill = _filteredBills[index];
// // // //               return ListTile(
// // // //                 title: Text('${bill.id} - ${bill.customerName} - ${bill.date}'),
// // // //                 subtitle: Text(
// // // //                   'الحالة: ${bill.status}',
// // // //                   style: TextStyle(
// // // //                     color: bill.status == 'تم الدفع' ? Colors.green : Colors.orange,
// // // //                   ),
// // // //                 ),
// // // //                 onTap: () => _showBillDetailsDialog(bill),
// // // //               );
// // // //             },
// // // //           );
// // // //         },
// // // //       ),
// // // //       floatingActionButton: FloatingActionButton(
// // // //         onPressed: () {
// // // //           showAddBillDialog(
// // // //             context: context,
// // // //             onAddBill: _addBill,
// // // //           );
// // // //         },
// // // //         child: Icon(Icons.add),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // //
// // import 'package:flutter/material.dart';
// // import 'package:system/features/billes/data/models/bill_model.dart';
// // import 'package:system/features/billes/data/repositories/bill_repository.dart';
// // import 'package:system/features/billes/presentation/Dialog/showAddBillDialog.dart';
// // import 'package:system/features/billes/presentation/Dialog/showBillDetailsDialog.dart';// استيراد الدالة الجديدة
// //
// // class BillingPage extends StatefulWidget {
// //   @override
// //   _BillingPageState createState() => _BillingPageState();
// // }
// //
// // class _BillingPageState extends State<BillingPage> {
// //   final BillRepository _billRepository = BillRepository();
// //   late Future<List<Bill>> _billsFuture;
// //   List<Bill> _bills = [];
// //   List<Bill> _filteredBills = [];
// //   final TextEditingController _searchController = TextEditingController();
// //   String? _selectedStatus;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _billsFuture = _billRepository.getBills();
// //     _billsFuture.then((bills) {
// //       setState(() {
// //         _bills = bills;
// //         _filteredBills = bills;
// //       });
// //     });
// //     _searchController.addListener(_filterBills);
// //   }
// //
// //     void _addBill(Bill bill) async {
// //     try {
// //       await _billRepository.addBill(bill);
// //       _refreshBills();
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Error adding bill: $e')),
// //       );
// //     }
// //   }
// //
// //   void _refreshBills() {
// //     setState(() {
// //       _billsFuture = _billRepository.getBills();
// //       _billsFuture.then((bills) {
// //         setState(() {
// //           _bills = bills;
// //           _filteredBills = bills;
// //         });
// //       });
// //     });
// //   }
// //
// //   void _filterBills() {
// //     final query = _searchController.text.toLowerCase();
// //     setState(() {
// //       _filteredBills = _bills.where((bill) {
// //         final matchesSearch = bill.id.toString().contains(query);
// //         final matchesStatus = _selectedStatus == null || bill.status == _selectedStatus;
// //         return matchesSearch && matchesStatus;
// //       }).toList();
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('الفواتير'),
// //         bottom: PreferredSize(
// //           preferredSize: Size.fromHeight(112.0),
// //           child: Column(
// //             children: [
// //               Padding(
// //                 padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
// //                 child: TextField(
// //                   controller: _searchController,
// //                   decoration: InputDecoration(
// //                     hintText: 'بحث برقم الفاتورة',
// //                     prefixIcon: Icon(Icons.search, color: Colors.white),
// //                     filled: true,
// //                     fillColor: Colors.white,
// //                     border: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(8.0),
// //                       borderSide: BorderSide.none,
// //                     ),
// //                   ),
// //                   style: TextStyle(color: Colors.black),
// //                 ),
// //               ),
// //               Padding(
// //                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     Text('تصفية حسب حالة الدفع:', style: TextStyle(color: Colors.white)),
// //                     DropdownButton<String>(
// //                       value: _selectedStatus,
// //                       hint: Text('اختر حالة الدفع', style: TextStyle(color: Colors.white)),
// //                       dropdownColor: Colors.blue,
// //                       items: [
// //                         DropdownMenuItem(
// //                           value: null,
// //                           child: Text('الكل', style: TextStyle(color: Colors.white)),
// //                         ),
// //                         DropdownMenuItem(
// //                           value: 'تم الدفع',
// //                           child: Text('تم الدفع', style: TextStyle(color: Colors.white)),
// //                         ),
// //                         DropdownMenuItem(
// //                           value: 'آجل',
// //                           child: Text('آجل', style: TextStyle(color: Colors.white)),
// //                         ),
// //                       ],
// //                       onChanged: (value) {
// //                         setState(() {
// //                           _selectedStatus = value;
// //                           _filterBills();
// //                         });
// //                       },
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //       body: FutureBuilder<List<Bill>>(
// //         future: _billsFuture,
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return Center(child: CircularProgressIndicator());
// //           } else if (snapshot.hasError) {
// //             return Center(child: Text('خطأ: ${snapshot.error}'));
// //           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
// //             return Center(child: Text('لا توجد فواتير حالياً.'));
// //           }
// //
// //           return ListView.builder(
// //             itemCount: _filteredBills.length,
// //             itemBuilder: (context, index) {
// //               final bill = _filteredBills[index];
// //               return ListTile(
// //                 title: Text('${bill.id} - ${bill.customerName} - ${bill.date}'),
// //                 subtitle: Text(
// //                   'الحالة: ${bill.status}',
// //                   style: TextStyle(
// //                     color: bill.status == 'تم الدفع' ? Colors.green : Colors.orange,
// //                   ),
// //                 ),
// //                 onTap: () => showBillDetailsDialog(context, bill), // استدعاء الدالة هنا
// //               );
// //             },
// //           );
// //         },
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () {
// //           // إضافة فاتورة جديدة
// //           showAddBillDialog(
// //             context: context,
// //             onAddBill: _addBill,);
// //         },
// //         child: Icon(Icons.add),
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:system/features/billes/data/models/bill_model.dart';
// import 'package:system/features/billes/data/repositories/bill_repository.dart';
// import 'package:system/features/billes/presentation/Dialog/showAddBillDialog.dart';
// import 'package:system/features/billes/presentation/Dialog/showBillDetailsDialog.dart';
//
// class BillingPage extends StatefulWidget {
//   @override
//   _BillingPageState createState() => _BillingPageState();
// }
//
// class _BillingPageState extends State<BillingPage> {
//   final BillRepository _billRepository = BillRepository();
//   late Future<List<Bill>> _billsFuture;
//   List<Bill> _bills = [];
//   List<Bill> _filteredBills = [];
//   final TextEditingController _searchController = TextEditingController();
//   String? _selectedStatus;
//
//   // New controller for date filter
//   final TextEditingController _dateController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _billsFuture = _billRepository.getBills();
//     _billsFuture.then((bills) {
//       setState(() {
//         _bills = bills;
//         _filteredBills = bills;
//       });
//     });
//     _searchController.addListener(_filterBills);
//   }
//
//   void _addBill(Bill bill) async {
//     try {
//       await _billRepository.addBill(bill);
//       _refreshBills();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error adding bill: $e')),
//       );
//     }
//   }
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
//
//   void _filterBills() {
//     final query = _searchController.text.toLowerCase();
//     final dateQuery = _dateController.text.toLowerCase();
//     setState(() {
//       _filteredBills = _bills.where((bill) {
//         final matchesSearch = bill.id.toString().contains(query);
//         final matchesStatus = _selectedStatus == null || bill.status == _selectedStatus;
//         final matchesDate = dateQuery.isEmpty || bill.date.contains(dateQuery);
//         return matchesSearch && matchesStatus && matchesDate;
//       }).toList();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('الفواتير'),
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(140.0),
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                 child: TextField(
//                   controller: _searchController,
//                   decoration: InputDecoration(
//                     hintText: 'بحث برقم الفاتورة',
//                     prefixIcon: Icon(Icons.search, color: Colors.white),
//                     filled: true,
//                     fillColor: Colors.white,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text('تصفية حسب حالة الدفع:', style: TextStyle(color: Colors.white)),
//                     DropdownButton<String>(
//                       value: _selectedStatus,
//                       hint: Text('اختر حالة الدفع', style: TextStyle(color: Colors.white)),
//                       dropdownColor: Colors.blue,
//                       items: [
//                         DropdownMenuItem(
//                           value: null,
//                           child: Text('الكل', style: TextStyle(color: Colors.white)),
//                         ),
//                         DropdownMenuItem(
//                           value: 'تم الدفع',
//                           child: Text('تم الدفع', style: TextStyle(color: Colors.white)),
//                         ),
//                         DropdownMenuItem(
//                           value: 'آجل',
//                           child: Text('آجل', style: TextStyle(color: Colors.white)),
//                         ),
//                       ],
//                       onChanged: (value) {
//                         setState(() {
//                           _selectedStatus = value;
//                           _filterBills();
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: TextField(
//                   controller: _dateController,
//                   decoration: InputDecoration(
//                     hintText: 'بحث بالتاريخ (يوم/شهر/سنة)',
//                     prefixIcon: Icon(Icons.calendar_today, color: Colors.white),
//                     filled: true,
//                     fillColor: Colors.white,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                   style: TextStyle(color: Colors.black),
//                   onChanged: (value) {
//                     _filterBills();
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: FutureBuilder<List<Bill>>(
//         future: _billsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('خطأ: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('لا توجد فواتير حالياً.'));
//           }
//
//           return ListView.builder(
//             itemCount: _filteredBills.length,
//             itemBuilder: (context, index) {
//               final bill = _filteredBills[index];
//               return ListTile(
//                 title: Text('${bill.id} - ${bill.customerName} - ${bill.date}'),
//                 subtitle: Text(
//                   'الحالة: ${bill.status}',
//                   style: TextStyle(
//                     color: bill.status == 'تم الدفع' ? Colors.green : Colors.orange,
//                   ),
//                 ),
//                 onTap: () => showBillDetailsDialog(context, bill),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           showAddBillDialog(
//             context: context,
//             onAddBill: _addBill,
//           );
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:system/features/billes/data/models/bill_model.dart';
// import 'package:system/features/billes/data/repositories/bill_repository.dart';
// import 'package:system/features/billes/presentation/Dialog/showAddBillDialog.dart';
// import 'package:system/features/billes/presentation/Dialog/showBillDetailsDialog.dart';
//
// class BillingPage extends StatefulWidget {
//   @override
//   _BillingPageState createState() => _BillingPageState();
// }
//
// class _BillingPageState extends State<BillingPage> {
//   final BillRepository _billRepository = BillRepository();
//   late Future<List<Bill>> _billsFuture;
//   List<Bill> _bills = [];
//   List<Bill> _filteredBills = [];
//   final TextEditingController _searchController = TextEditingController();
//   String? _selectedStatus;
//
//   @override
//   void initState() {
//     super.initState();
//     _billsFuture = _billRepository.getBills();
//     _billsFuture.then((bills) {
//       setState(() {
//         _bills = bills;
//         _filteredBills = bills;
//       });
//     });
//     _searchController.addListener(_filterBills);
//   }
//
//   void _addBill(Bill bill) async {
//     try {
//       await _billRepository.addBill(bill);
//       _refreshBills();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error adding bill: $e')),
//       );
//     }
//   }
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
//
//   void _filterBills() {
//     final query = _searchController.text.toLowerCase();
//     setState(() {
//       _filteredBills = _bills.where((bill) {
//         final matchesSearch = bill.id.toString().contains(query);
//         final matchesStatus = _selectedStatus == null || bill.status == _selectedStatus;
//         return matchesSearch && matchesStatus;
//       }).toList();
//     });
//   }
//
//   // تغيير حالة الفاتورة بناءً على الفئة المحددة
//   void _onNavBarItemTapped(int index) {
//     setState(() {
//       switch (index) {
//         case 0:
//           _selectedStatus = null; // الكل
//           break;
//         case 1:
//           _selectedStatus = 'تم الدفع'; // تم الدفع
//           break;
//         case 2:
//           _selectedStatus = 'آجل'; // آجل
//           break;
//         case 3:
//           _selectedStatus = 'فاتورة مفتوجة'; // فاتورة مفتوجة
//           break;
//         default:
//           _selectedStatus = null;
//       }
//       _filterBills(); // تحديث الفواتير بناءً على الفئة المحددة
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('الفواتير'),
//       ),
//       body: Column(
//         children: [
//           // إضافة BottomNavigationBar في الأعلى أسفل AppBar
//           Container(
//             padding: EdgeInsets.symmetric(vertical: 8.0),
//             decoration: BoxDecoration(
//               color: Colors.black12,
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(10),
//                 bottomRight: Radius.circular(10),
//               ),
//             ),
//             child: BottomNavigationBar(
//               backgroundColor: Colors.black12,
//               selectedItemColor: Colors.purpleAccent,
//               currentIndex: _selectedStatus == 'تم الدفع'
//                   ? 1
//                   : _selectedStatus == 'آجل'
//                   ? 2
//                   : _selectedStatus == 'فاتورة مفتوحة'
//                   ? 3
//                    : 0,
//               onTap: _onNavBarItemTapped,
//               items: const [
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.all_inclusive),
//                   label: 'الكل',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.check_circle),
//                   label: 'تم الدفع',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.access_time),
//                   label: 'آجل',
//                 ),
//                BottomNavigationBarItem(
//                   icon: Icon(Icons.access_time_filled_sharp),
//                   label: 'فاتورة مفتوحة',
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'بحث برقم الفاتورة',
//                 prefixIcon: Icon(Icons.search, color: Colors.white),
//                 filled: true,
//                 fillColor: Colors.white,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//               style: TextStyle(color: Colors.black),
//             ),
//           ),
//           Expanded(
//             child: FutureBuilder<List<Bill>>(
//               future: _billsFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('خطأ: ${snapshot.error}'));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return Center(child: Text('لا توجد فواتير حالياً.'));
//                 }
//
//                 return ListView.builder(
//                   itemCount: _filteredBills.length,
//                   itemBuilder: (context, index) {
//                     final bill = _filteredBills[index];
//                     return ListTile(
//                       title: Text('${bill.id} - ${bill.customerName} - ${bill.date}'),
//                       subtitle: Text(
//                         'الحالة: ${bill.status}',
//                         style: TextStyle(
//                           color: bill.status == 'تم الدفع' ? Colors.green : Colors.orange,
//                         ),
//                       ),
//                       onTap: () => showBillDetailsDialog(context, bill),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           showAddBillDialog(
//             context: context,
//             onAddBill: _addBill,
//           );
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/billes/data/repositories/bill_repository.dart';
import 'package:system/features/billes/presentation/Dialog/adding/showAddBillDialog.dart';
import 'package:system/features/billes/presentation/Dialog/details-editing-pdf/showBillDetailsDialog.dart';

class BillingPage extends StatefulWidget {
  @override
  _BillingPageState createState() => _BillingPageState();

}

class _BillingPageState extends State<BillingPage> {
  final BillRepository _billRepository = BillRepository();
  late Future<List<Bill>> _billsFuture;
  List<Bill> _bills = [];
  List<Bill> _filteredBills = [];
  final TextEditingController _searchController = TextEditingController();
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _billsFuture = _billRepository.getBills();
    _billsFuture.then((bills) {
      setState(() {
        _bills = bills;
        _filteredBills = bills;
      });
    });
    _searchController.addListener(_filterBills);
  }

  void _addBill(Bill bill,payment) async {
    try {
      // await _billRepository.addBill(bill);
      await _billRepository.addBill(bill,payment);
      // await _billRepository.addPaymentRecord(payment);
      refreshBills();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding bill: $e')),
      );
    }
  }

  void refreshBills() {
    setState(() {
      _billsFuture = _billRepository.getBills();
      _billsFuture.then((bills) {
        setState(() {
          _bills = bills;
          _filteredBills = bills;
        });
      });
    });
  }

  void _filterBills() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredBills = _bills.where((bill) {
        final matchesSearch = bill.id.toString().contains(query);
        final matchesStatus = _selectedStatus == null || bill.status == _selectedStatus;
        return matchesSearch && matchesStatus;
      }).toList();
    });
  }

  // تغيير حالة الفاتورة بناءً على الفئة المحددة
  void _onNavBarItemTapped(int index) {

    setState(() {
      switch (index) {
        case 0:
          _selectedStatus = null; // الكل
          break;
        case 1:
          _selectedStatus = 'تم الدفع'; // تم الدفع
          break;
        case 2:
          _selectedStatus = 'آجل'; // آجل
          break;
        case 3:
          _selectedStatus = 'فاتورة مفتوحة'; // فاتورة مفتوحة
          break;
        default:
          _selectedStatus = null;
      }
      _filterBills(); // تحديث الفواتير بناءً على الفئة المحددة
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الفواتير'),
      ),
      body: Column(
        children: [
          // إضافة BottomNavigationBar في الأعلى أسفل AppBar
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              // color: AppBarTheme.of(context).backgroundColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: BottomNavigationBar(
              // selectedLabelStyle: TextStyle(color: Colors.greenAccent ),
              selectedFontSize: 15,
              // backgroundColor: Colors.cyanAccent,
              // selectedItemColor: Colors.deepPurple,
              currentIndex: _selectedStatus == 'تم الدفع'
                  ? 1
                  : _selectedStatus == 'آجل'
                  ? 2
                  : _selectedStatus == 'فاتورة مفتوحة'
                  ? 3
                  : 0,
              onTap: _onNavBarItemTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.all_inclusive,size: 30,),
                  label: 'الكل',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle,size: 30,),
                  label: 'تم الدفع',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.pending_actions,size: 30,),
                  label: 'آجل',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.hourglass_empty,size: 30,),
                  label: 'فاتورة مفتوحة',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'بحث برقم الفاتورة',
                prefixIcon: Icon(Icons.search, color: Colors.black),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.black),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Bill>>(
              future: _billsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('خطأ: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('لا توجد فواتير حالياً.'));
                }

                return ListView.builder(
                  itemCount: _filteredBills.length,
                  itemBuilder: (context, index) {
                    final bill = _filteredBills[index];
                    return ListTile(
                      title: Text('${bill.id} - ${bill.customerName} - ${bill.date}'),
                      subtitle: Text(
                        'الحالة: ${bill.status}',
                        style: TextStyle(
                          color: bill.status == 'تم الدفع' ? Colors.green : Colors.orange,
                        ),
                      ),
                      onTap: () {
                        showBillDetailsDialog(context, bill);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddBillDialog(
            context: context,
            onAddBill: _addBill,
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
