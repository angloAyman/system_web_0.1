// import 'package:flutter/material.dart';
// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// import 'package:system/core/constants/app_constants.dart';
// import 'package:system/core/themes/AppColors/them_constants.dart';
// import 'package:system/features/billes/FavoriteBillsPage.dart';
// import 'package:system/features/billes/data/models/bill_model.dart';
// import 'package:system/features/billes/data/repositories/bill_repository.dart';
// import 'package:system/features/billes/presentation/Dialog/adding/bill/showAddBillDialog.dart';
// import 'package:system/features/billes/presentation/Dialog/details-editing-pdf/bill/showBillDetailsDialog.dart';
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
//   String _searchCriteria = 'id'; // Default search by ID
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
//
//   void refreshBills() {
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
//
//     setState(() {
//       _filteredBills = _bills.where((bill) {
//         final matchesQuery = _searchCriteria == 'id'
//             ? bill.id.toString().contains(query)
//             : bill.customerName.toLowerCase().contains(query);
//
//         final matchesStatus =
//             _selectedStatus == null || bill.status == _selectedStatus;
//
//         return matchesQuery && matchesStatus;
//       }).toList();
//     });
//   }
//
// // Dialog to update the bill description
//   Future<String?> _showDescriptionDialog(
//       BuildContext context, int billId, String currentDescription) {
//     TextEditingController _descriptionController =
//         TextEditingController(text: currentDescription);
//
//     return showDialog<String>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('تحديث تفاصيل الفاتورة'),
//           content: TextField(
//             controller: _descriptionController,
//             decoration: const InputDecoration(hintText: 'أدخل تفاصيل الفاتورة'),
//             maxLines: null,
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(_descriptionController
//                     .text); // Return the updated description
//                 // Navigator.of(context).pop();
//               },
//               child: const Text('حفظ'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog without saving
//               },
//               child: const Text('إلغاء'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _toggleFavoriteStatusAndUpdateDescription(Bill bill) async {
//     final updatedDescription =
//         await _showDescriptionDialog(context, bill.id, bill.description);
//
//     if (updatedDescription != null) {
//       try {
//         await _billRepository.updateFavoriteStatusAndDescription(
//           billId: bill.id,
//           isFavorite: !bill.isFavorite, // Toggle the favorite status
//           description: updatedDescription, // Set the updated description
//         );
//
//         // Update the UI
//         setState(() {
//           bill.isFavorite = !bill.isFavorite;
//           bill.description = updatedDescription;
//         });
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text(
//                   'تمت ${bill.isFavorite ? "إضافة" : "إزالة"} الفاتورة للمفضلة')),
//         );
//       } catch (e) {
//         print(e);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('حدث خطأ أثناء تحديث الفاتورة: $e')),
//         );
//       }
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('الفواتير'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.account_balance),
//             onPressed: () async {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => FavoriteBillsPage(),
//                 ),
//               );
//             },
//           ),
//
//         ],
//       ),
//       body: Column(
//         children: [
//           Container(
//             padding: EdgeInsets.symmetric(vertical: 8.0),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(10),
//                 bottomRight: Radius.circular(10),
//               ),
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
// //لترتيب القائمة تنازليا حسب رقم الفاتورة (bill.id)،
//                 _filteredBills.sort((a, b) => b.id.compareTo(a.id));
//
//                 return ListView.builder(
//                   itemCount: _filteredBills.length,
//                   itemBuilder: (context, index) {
//                     final bill = _filteredBills[index];
//                     return ListTile(
//                       title: Text(
//                         '${bill.id} -'
//                         ' ${bill.customerName} -'
//                       ),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Text(" المبلغ المتبقي "),
//                               Text('  ${bill.total_price - bill.payment}',),
//                             ],
//                           ),
//                           Text(
//                             'الحالة: ${bill.status}',
//                             style: TextStyle(
//                               color: bill.status == 'تم الدفع'
//                                   ? Colors.green
//                                   : Colors.orange,
//                             ),
//                           ),
//
//                         ],
//                       ),
//                       trailing: IconButton(
//                         icon: Icon(
//                           bill.isFavorite
//                               ? Icons.account_balance
//                               : Icons.account_balance_outlined,
//                           color: bill.isFavorite ? AppColors.primary : null,
//                         ),
//                         onPressed: () async {
//                           try {
//                             if (bill.isFavorite) {
//                               // Call the method to remove from favorites
//                               _billRepository.removeFromFavorites(bill);
//                               // Update the UI
//                               setState(() {
//                                 bill.isFavorite = false;
//                               });
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                     content:
//                                         Text('تمت إزالة الفاتورة من المفضلة')),
//                               );
//                             } else {
//                               // Call the method to add to favorites and update description
//                               _toggleFavoriteStatusAndUpdateDescription(bill);
//                             }
//                           } catch (e) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                   content: Text('حدث خطأ: ${e.toString()}')),
//                             );
//                           }
//                         },
//                       ),
//                       onTap: () {
//                         showBillDetailsDialog(context, bill);
//                         refreshBills();
//                       },
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//
//         },
//         child: Icon(Icons.add),
//         tooltip: 'إضافة فاتورة جديدة',
//       ),
//     );
//   }
// }
