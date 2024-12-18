// // import 'package:flutter/material.dart';
// // import 'package:system/features/billes/data/models/bill_model.dart';
// // import 'package:system/features/billes/data/repositories/bill_repository.dart';
// //
// // class PaymentPage extends StatefulWidget {
// //   const PaymentPage({Key? key}) : super(key: key);
// //
// //   @override
// //   _PaymentPageState createState() => _PaymentPageState();
// // }
// //
// // class _PaymentPageState extends State<PaymentPage> {
// //   final BillRepository _billRepository = BillRepository();
// //   late Future<List<Bill>> _deferredBillsFuture;
// //
// //   int _totalBills = 0;
// //   int _paidBills = 0;
// //   int _deferredBillsCount = 0;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _deferredBillsFuture = _loadDeferredBills();
// //     _loadBillCounts(); // Fetch dynamic counts
// //   }
// //
// //   Future<List<Bill>> _loadDeferredBills() async {
// //     try {
// //       return await _billRepository.getBills();
// //     } catch (error) {
// //       print("Error loading deferred bills: $error");
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Failed to load deferred bills: $error')),
// //       );
// //       return [];
// //     }
// //   }
// //
// //   Future<void> _loadBillCounts() async {
// //     try {
// //       // Example API calls to fetch counts
// //       final totalBills = await _billRepository.getTotalBillsCount();
// //       final paidBills = await _billRepository.getPaidBillsCount();
// //       final deferredBills = await _billRepository.getDeferredBillsCount();
// //
// //       setState(() {
// //         _totalBills = totalBills;
// //         _paidBills = paidBills;
// //         _deferredBillsCount = deferredBills;
// //       });
// //     } catch (error) {
// //       print("Error loading bill counts: $error");
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Failed to load bill counts: $error')),
// //       );
// //     }
// //   }
// //
// //   void _navigateToAddPaymentPage(int billId, String customerName) {
// //     print('Navigate to payment page for Bill ID: $billId');
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('القسم المالي'
// //             ''),
// //         actions: [
// //           TextButton.icon(onPressed: (){
// //             Navigator.pushReplacementNamed(context, '/adminHome'); // توجيه المستخدم إلى صفحة تسجيل الدخول
// //           }, label: Icon(Icons.home)),
// //         ],
// //       ),
// //       body: Column(
// //         children: [
// //           // Row with 3 Cards
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 _buildCard('Total Bills', '$_totalBills', Icons.description, Colors.blue),
// //                 _buildCard('Paid Bills', '$_paidBills', Icons.check_circle, Colors.green),
// //                 _buildCard('Deferred Bills', '$_deferredBillsCount', Icons.access_time, Colors.orange),
// //               ],
// //             ),
// //           ),
// //           // Deferred Bills List
// //           Expanded(
// //             child: FutureBuilder<List<Bill>>(
// //               future: _deferredBillsFuture,
// //               builder: (context, snapshot) {
// //                 if (snapshot.connectionState == ConnectionState.waiting) {
// //                   return const Center(child: CircularProgressIndicator());
// //                 } else if (snapshot.hasError) {
// //                   return Center(
// //                     child: Text('Error: ${snapshot.error}'),
// //                   );
// //                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
// //                   return const Center(
// //                     child: Text('No deferred bills available at the moment.'),
// //                   );
// //                 }
// //
// //                 final deferredBills = snapshot.data!;
// //                 return Padding(
// //                   padding: const EdgeInsets.all(16.0),
// //                   child: ListView.builder(
// //                     itemCount: deferredBills.length,
// //                     itemBuilder: (context, index) {
// //                       final bill = deferredBills[index];
// //                       return Card(
// //                         margin: const EdgeInsets.symmetric(vertical: 8.0),
// //                         child: ListTile(
// //                           title: Text('Bill ID: ${bill.id}'),
// //                           subtitle: Text('Customer: ${bill.customerName}'),
// //                           trailing: ElevatedButton(
// //                             onPressed: () => _navigateToAddPaymentPage(bill.id as int, bill.customerName),
// //                             child: const Text('Add Payment'),
// //                           ),
// //                         ),
// //                       );
// //                     },
// //                   ),
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildCard(String title, String count, IconData icon, Color color) {
// //     return Expanded(
// //       child: Card(
// //         color: color.withOpacity(0.1),
// //         child: Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: Column(
// //             children: [
// //               Icon(icon, size: 40, color: color),
// //               const SizedBox(height: 8),
// //               Text(
// //                 title,
// //                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
// //               ),
// //               const SizedBox(height: 4),
// //               Text(
// //                 count,
// //                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:system/features/billes/data/models/bill_model.dart';
// import 'package:system/features/billes/data/repositories/bill_repository.dart';
// import 'package:system/features/billes/presentation/payment/AddPaymentPage.dart';
//
// class PaymentPage extends StatefulWidget {
//   const PaymentPage({Key? key}) : super(key: key);
//
//   @override
//   _PaymentPageState createState() => _PaymentPageState();
// }
//
// class _PaymentPageState extends State<PaymentPage> {
//   final BillRepository _billRepository = BillRepository();
//   final TextEditingController _searchController = TextEditingController();
//   late Future<List<Bill>> _billsFuture;
//
//   int _totalBills = 0;
//   int _paidBills = 0;
//   int _deferredBillsCount = 0;
//   String _searchQuery = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _billsFuture = _loadBills();
//     _loadBillCounts();
//   }
//
//   Future<List<Bill>> _loadBills() async {
//     try {
//       return await _billRepository.getBills();
//     } catch (error) {
//       print("Error loading bills: $error");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load bills: $error')),
//       );
//       return [];
//     }
//   }
//
//   Future<void> _loadBillCounts() async {
//     try {
//       final totalBills = await _billRepository.getTotalBillsCount();
//       final paidBills = await _billRepository.getPaidBillsCount();
//       final deferredBills = await _billRepository.getDeferredBillsCount();
//
//       setState(() {
//         _totalBills = totalBills;
//         _paidBills = paidBills;
//         _deferredBillsCount = deferredBills;
//       });
//     } catch (error) {
//       print("Error loading bill counts: $error");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load bill counts: $error')),
//       );
//     }
//   }
//
//   void _filterBills(String query) {
//     setState(() {
//       _searchQuery = query.toLowerCase();
//     });
//   }
//
//   List<Bill> _getFilteredBills(List<Bill> bills) {
//     if (_searchQuery.isEmpty) {
//       return bills;
//     }
//     return bills.where((bill) {
//       final billId = bill.id.toString().toLowerCase();
//       final customerName = bill.customerName.toLowerCase();
//       return billId.contains(_searchQuery) || customerName.contains(_searchQuery);
//     }).toList();
//   }
//
//   void _navigateToAddPaymentPage(int billId, String customerName) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => AddPaymentPage(billId: billId, customerName: customerName),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('القسم المالي'),
//         actions: [
//           TextButton.icon(
//             onPressed: () {
//               Navigator.pushReplacementNamed(context, '/adminHome');
//             },
//             icon: Icon(Icons.home),
//             label: Text('Home'),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Search Bar
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 labelText: 'Search by Bill ID or Customer Name',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.search),
//               ),
//               onChanged: _filterBills,
//             ),
//           ),
//           // Row with 3 Cards
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _buildCard('Total Bills', '$_totalBills', Icons.description, Colors.blue),
//                 _buildCard('Paid Bills', '$_paidBills', Icons.check_circle, Colors.green),
//                 _buildCard('Deferred Bills', '$_deferredBillsCount', Icons.access_time, Colors.orange),
//               ],
//             ),
//           ),
//           // Bills List
//           Expanded(
//             child: FutureBuilder<List<Bill>>(
//               future: _billsFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text('No bills available at the moment.'));
//                 }
//
//                 final filteredBills = _getFilteredBills(snapshot.data!);
//                 if (filteredBills.isEmpty) {
//                   return const Center(child: Text('No matching bills found.'));
//                 }
//
//                 return ListView.builder(
//                   itemCount: filteredBills.length,
//                   itemBuilder: (context, index) {
//                     final bill = filteredBills[index];
//                     return Card(
//                       margin: const EdgeInsets.symmetric(vertical: 8.0),
//                       child: ListTile(
//                         title: Text('Bill ID: ${bill.id}'),
//                         subtitle: Text('Customer: ${bill.customerName}'),
//                         trailing: ElevatedButton(
//                           onPressed: () => _navigateToAddPaymentPage(bill.id, bill.customerName),
//                           child: const Text('Add Payment'),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCard(String title, String count, IconData icon, Color color) {
//     return Expanded(
//       child: Card(
//         color: color.withOpacity(0.1),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               Icon(icon, size: 40, color: color),
//               const SizedBox(height: 8),
//               Text(
//                 title,
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 count,
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:system/features/billes/data/models/bill_model.dart';
// import 'package:system/features/billes/data/repositories/bill_repository.dart';
//
// class PaymentPage extends StatefulWidget {
//   const PaymentPage({Key? key}) : super(key: key);
//
//   @override
//   _PaymentPageState createState() => _PaymentPageState();
// }
//
// class _PaymentPageState extends State<PaymentPage> {
//   final BillRepository _billRepository = BillRepository();
//   late Future<List<Bill>> _allBillsFuture;
//
//   List<Bill> _filteredBills = [];
//   String _selectedStatus = "اجمالي الفواتير"; // Default filter
//
//   int _totalBills = 0;
//   int _paidBills = 0;
//   int _deferredBillsCount = 0;
//   int _OpenBillsCount = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _allBillsFuture = _loadAllBills();
//     _loadBillCounts(); // Fetch dynamic counts
//   }
//
//   Future<List<Bill>> _loadAllBills() async {
//     try {
//       final bills = await _billRepository.getBills();
//       setState(() {
//         _filteredBills = bills; // Default view shows all bills
//       });
//       return bills;
//     } catch (error) {
//       print("Error loading bills: $error");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load bills: $error')),
//       );
//       return [];
//     }
//   }
//
//   Future<void> _loadBillCounts() async {
//     try {
//       // Example API calls to fetch counts
//       final totalBills = await _billRepository.getTotalBillsCount();
//       final paidBills = await _billRepository.getPaidBillsCount();
//       final deferredBills = await _billRepository.getDeferredBillsCount();
//       final OpenBills = await _billRepository.getOpenBillsCount();
//
//       setState(() {
//         _totalBills = totalBills;
//         _paidBills = paidBills;
//         _deferredBillsCount = deferredBills;
//         _OpenBillsCount = OpenBills;
//       });
//     } catch (error) {
//       print("Error loading bill counts: $error");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load bill counts: $error')),
//       );
//     }
//   }
//
//   void _filterBills(String status) async {
//     try {
//       final bills = await _allBillsFuture; // Get the full list of bills
//       setState(() {
//         _selectedStatus = status; // Update the selected status
//
//         // Filter bills based on status
//         _filteredBills = status == "اجمالي الفواتير"
//             ? bills
//             : bills.where((bill) {
//           if (status == "آجل") return bill.status == "آجل";
//           if (status == "تم الدفع") return bill.status == "تم الدفع";
//           if (status == "فاتورة مفتوحة") return bill.status == "فاتورة مفتوحة";
//           return true;
//         }).toList();
//       });
//     } catch (error) {
//       print("Error filtering bills: $error");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to filter bills: $error')),
//       );
//     }
//   }
//
//   void _navigateToAddPaymentPage(int billId, String customerName) {
//     print('Navigate to payment page for Bill ID: $billId');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('القسم المالي'),
//         actions: [
//           TextButton.icon(
//             onPressed: () {
//               Navigator.pushReplacementNamed(context, '/adminHome'); // Navigate to admin home
//             },
//             label: const Icon(Icons.home),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Row with 3 Cards
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 GestureDetector(
//                   onTap: () => _filterBills("All"),
//                   child: _buildCard('اجمالي الفواتير', '$_totalBills', Icons.description, Colors.blue),
//                 ),
//                 GestureDetector(
//                   onTap: () => _filterBills("تم الدفع"),
//                   child: _buildCard('تم الدفع', '$_paidBills', Icons.check_circle, Colors.green),
//                 ),
//                 GestureDetector(
//                   onTap: () => _filterBills("آجل"),
//                   child: _buildCard('آجل', '$_deferredBillsCount', Icons.access_time, Colors.orange),
//                 ),
//                 GestureDetector(
//                   onTap: () => _filterBills("فاتورة مفتوحة"),
//                   child: _buildCard('فاتورة مفتوحة', '', Icons.folder_open, Colors.red),
//                 ),
//               ],
//             ),
//           ),
//           // Filtered Bills List
//           Expanded(
//             child: _filteredBills.isEmpty
//                 ? const Center(
//               child: Text('No bills available for the selected filter.'),
//             )
//                 : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ListView.builder(
//                 itemCount: _filteredBills.length,
//                 itemBuilder: (context, index) {
//                   final bill = _filteredBills[index];
//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8.0),
//                     child: ListTile(
//                       title: Text('Bill ID: ${bill.id}'),
//                       subtitle: Text('Customer: ${bill.customerName}'),
//                       trailing: ElevatedButton(
//                         onPressed: () => _navigateToAddPaymentPage(bill.id as int, bill.customerName),
//                         child: const Text('Add Payment'),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCard(String title, String count, IconData icon, Color color) {
//     return Expanded(
//       child: Card(
//         color: color.withOpacity(0.1),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               Icon(icon, size: 40, color: color),
//               const SizedBox(height: 8),
//               Text(
//                 title,
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 count,
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:system/features/billes/data/models/bill_model.dart';
// import 'package:system/features/billes/data/repositories/bill_repository.dart';
//
// class PaymentPage extends StatefulWidget {
//   const PaymentPage({Key? key}) : super(key: key);
//
//   @override
//   _PaymentPageState createState() => _PaymentPageState();
// }
//
// class _PaymentPageState extends State<PaymentPage> {
//   final BillRepository _billRepository = BillRepository();
//   late Future<List<Bill>> _allBillsFuture;
//   final TextEditingController _searchController = TextEditingController();
//
//   List<Bill> _filteredBills = [];
//   String _selectedStatus = "اجمالي الفواتير"; // Default filter
//
//   int _totalBills = 0;
//   int _paidBills = 0;
//   int _deferredBillsCount = 0;
//   int _openBillsCount = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _allBillsFuture = _loadAllBills();
//     _loadBillCounts(); // Fetch dynamic counts
//   }
//
//   Future<List<Bill>> _loadAllBills() async {
//     try {
//       final bills = await _billRepository.getBills();
//       setState(() {
//         _filteredBills = bills; // Default view shows all bills
//       });
//       return bills;
//     } catch (error) {
//       print("Error loading bills: $error");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load bills: $error')),
//       );
//       return [];
//     }
//   }
//
//   Future<void> _loadBillCounts() async {
//     try {
//       final totalBills = await _billRepository.getTotalBillsCount();
//       final paidBills = await _billRepository.getPaidBillsCount();
//       final deferredBills = await _billRepository.getDeferredBillsCount();
//       final openBills = await _billRepository.getOpenBillsCount();
//
//       setState(() {
//         _totalBills = totalBills;
//         _paidBills = paidBills;
//         _deferredBillsCount = deferredBills;
//         _openBillsCount = openBills;
//       });
//     } catch (error) {
//       print("Error loading bill counts: $error");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load bill counts: $error')),
//       );
//     }
//   }
//
//   void _filterBills(String status) async {
//     try {
//       final bills = await _allBillsFuture; // Get the full list of bills
//       setState(() {
//         _selectedStatus = status; // Update the selected status
//
//         // Filter bills based on status
//         _filteredBills = status == "اجمالي الفواتير"
//             ? bills
//             : bills.where((bill) {
//           if (status == "آجل") return bill.status == "آجل";
//           if (status == "تم الدفع") return bill.status == "تم الدفع";
//           if (status == "فاتورة مفتوحة") return bill.status == "فاتورة مفتوحة";
//           return false;
//         }).toList();
//       });
//     } catch (error) {
//       print("Error filtering bills: $error");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to filter bills: $error')),
//       );
//     }
//   }
//
//   void _navigateToAddPaymentPage(int billId, String customerName) {
//     print('Navigate to payment page for Bill ID: $billId');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('القسم المالي'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.pushReplacementNamed(context, '/adminHome');
//             },
//             icon: const Icon(Icons.home),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//       Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 labelText: 'Search by Bill ID or Customer Name',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.search),
//               ),
//               onChanged: _filterBills,
//             ),
//           ),
//           // Row with Cards
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child:
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _buildCard('اجمالي الفواتير', '$_totalBills', Icons.description, Colors.blue,
//                     _selectedStatus == "اجمالي الفواتير", () => _filterBills("اجمالي الفواتير")),
//                 _buildCard('تم الدفع', '$_paidBills', Icons.check_circle, Colors.green,
//                     _selectedStatus == "تم الدفع", () => _filterBills("تم الدفع")),
//                 _buildCard('آجل', '$_deferredBillsCount', Icons.access_time, Colors.orange,
//                     _selectedStatus == "آجل", () => _filterBills("آجل")),
//                 _buildCard('فاتورة مفتوحة', '$_openBillsCount', Icons.folder_open, Colors.red,
//                     _selectedStatus == "فاتورة مفتوحة", () => _filterBills("فاتورة مفتوحة")),
//               ],
//             ),
//           ),
//           // Filtered Bills List
//           Expanded(
//             child: _filteredBills.isEmpty
//                 ? const Center(
//               child: Text(
//                 'لا توجد فواتير متاحة للفلتر المحدد.',
//                 style: TextStyle(fontSize: 18),
//               ),
//             )
//                 : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ListView.builder(
//                 itemCount: _filteredBills.length,
//                 itemBuilder: (context, index) {
//                   final bill = _filteredBills[index];
//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8.0),
//                     child: ListTile(
//                       title: Text('رقم الفاتورة: ${bill.id}'),
//                       subtitle: Text('العميل: ${bill.customerName}'),
//                       trailing: ElevatedButton(
//                         onPressed: () => _navigateToAddPaymentPage(bill.id as int, bill.customerName),
//                         child: const Text('اضافة الدفع'),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCard(String title, String count, IconData icon, Color color, bool isSelected, VoidCallback onTap) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: Card(
//           color: isSelected ? color.withOpacity(0.3) : color.withOpacity(0.1),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(icon, size: 40, color: color),
//                 const SizedBox(height: 8),
//                 Text(
//                   title,
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   count,
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/billes/data/repositories/bill_repository.dart';
import 'package:system/features/billes/presentation/payment/AddPaymentPage.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final BillRepository _billRepository = BillRepository();
  late Future<List<Bill>> _allBillsFuture;
  final TextEditingController _searchController = TextEditingController();

  List<Bill> _allBills = [];
  List<Bill> _filteredBills = [];
  String _selectedStatus = "اجمالي الفواتير";

  int _totalBills = 0;
  int _paidBills = 0;
  int _deferredBillsCount = 0;
  int _openBillsCount = 0;

  @override
  void initState() {
    super.initState();
    _allBillsFuture = _loadAllBills();
    _loadBillCounts();
    _searchController.addListener(_filterBillsBySearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Bill>> _loadAllBills() async {
    try {
      final bills = await _billRepository.getBills();
      setState(() {
        _allBills = bills;
        _filteredBills = bills; // Default view shows all bills
      });
      return bills;
    } catch (error) {
      print("Error loading bills: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load bills: $error')),
      );
      return [];
    }
  }

  Future<void> _loadBillCounts() async {
    try {
      final totalBills = await _billRepository.getTotalBillsCount();
      final paidBills = await _billRepository.getPaidBillsCount();
      final deferredBills = await _billRepository.getDeferredBillsCount();
      final openBills = await _billRepository.getOpenBillsCount();

      setState(() {
        _totalBills = totalBills;
        _paidBills = paidBills;
        _deferredBillsCount = deferredBills;
        _openBillsCount = openBills;
      });
    } catch (error) {
      print("Error loading bill counts: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load bill counts: $error')),
      );
    }
  }

  void _filterBills(String status) {
    setState(() {
      _selectedStatus = status;
    });
    _applyFilters();
  }

  void _filterBillsBySearch() {
    _applyFilters();
  }

  void _applyFilters() {
    final searchQuery = _searchController.text.toLowerCase();
    setState(() {
      _filteredBills = _allBills.where((bill) {
        // Apply search filter
        final matchesSearch = searchQuery.isEmpty ||
            bill.id.toString().contains(searchQuery) ||
            bill.customerName.toLowerCase().contains(searchQuery);

        // Apply status filter
        final matchesStatus = _selectedStatus == "اجمالي الفواتير" ||
            (_selectedStatus == "آجل" && bill.status == "آجل") ||
            (_selectedStatus == "تم الدفع" && bill.status == "تم الدفع") ||
            (_selectedStatus == "فاتورة مفتوحة" && bill.status == "فاتورة مفتوحة");

        return matchesSearch && matchesStatus;
      }).toList();
    });
  }

  void _showAddPaymentDialog(int billId, String customerName,DateTime billDate,double total_price,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddPaymentDialog(billId: billId, customerName: customerName,billDate:billDate,total_price:total_price,);
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('القسم المالي'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/adminHome');
            },
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'البحث عن طريق رقم الفاتورة أو اسم العميل',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          // Row with Cards
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCard('اجمالي الفواتير', '$_totalBills', Icons.description, Colors.blue,
                    _selectedStatus == "اجمالي الفواتير", () => _filterBills("اجمالي الفواتير")),
                _buildCard('تم الدفع', '$_paidBills', Icons.check_circle, Colors.green,
                    _selectedStatus == "تم الدفع", () => _filterBills("تم الدفع")),
                _buildCard('آجل', '$_deferredBillsCount', Icons.access_time, Colors.orange,
                    _selectedStatus == "آجل", () => _filterBills("آجل")),
                _buildCard('فاتورة مفتوحة', '$_openBillsCount', Icons.folder_open, Colors.red,
                    _selectedStatus == "فاتورة مفتوحة", () => _filterBills("فاتورة مفتوحة")),
              ],
            ),
          ),
          // Filtered Bills List
          Expanded(
            child: _filteredBills.isEmpty
                ? const Center(
              child: Text(
                'لا توجد فواتير متاحة للفلتر المحدد.',
                style: TextStyle(fontSize: 18),
              ),
            )
                : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: _filteredBills.length,
                itemBuilder: (context, index) {
                  final bill = _filteredBills[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text('رقم الفاتورة: ${bill.id}'),
                      subtitle: Text('العميل: ${bill.customerName}'),
                      trailing: ElevatedButton(
                        onPressed: () =>
                            _showAddPaymentDialog(bill.id as int, bill.customerName,bill.date as DateTime,bill.total_price as double),
                        child: const Text('اضافة الدفع'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String title, String count, IconData icon, Color color, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: isSelected ? color.withOpacity(0.3) : color.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 40, color: color),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
                ),
                const SizedBox(height: 4),
                Text(
                  count,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
