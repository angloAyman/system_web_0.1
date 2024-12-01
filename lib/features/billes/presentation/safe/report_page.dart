// //
// // import 'package:flutter/material.dart';
// // import 'package:system/features/billes/data/models/bill_model.dart';
// // import 'package:system/features/billes/data/models/reportbill_model.dart';
// // import 'package:system/features/billes/data/repositories/bill_repository.dart';
// //
// // class SafeReportPage extends StatefulWidget {
// //   @override
// //   _SafeReportPageState createState() => _SafeReportPageState();
// // }
// //
// // class _SafeReportPageState extends State<SafeReportPage> {
// //   final BillRepository _billRepository = BillRepository();
// //   late Future<List<ReportbillBill>> _RbillsFuture;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _RbillsFuture = _billRepository.getBills_with_users();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Report'),
// //       ),
// //       body: FutureBuilder<List<ReportbillBill>>(
// //         future: _RbillsFuture,
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return Center(child: CircularProgressIndicator());
// //           } else if (snapshot.hasError) {
// //             return Center(child: Text('Error: ${snapshot.error}'));
// //           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
// //             return Center(child: Text('No data available.'));
// //           }
// //
// //           final bills = snapshot.data!;
// //           return SingleChildScrollView(
// //             child: SingleChildScrollView(
// //               scrollDirection: Axis.horizontal,
// //               child: DataTable(
// //                 columns: [
// //                   DataColumn(label: Text('ID')),
// //                   DataColumn(label: Text('Customer')),
// //                   DataColumn(label: Text('Date')),
// //                   DataColumn(label: Text('User')), // New Column for User
// //                   DataColumn(label: Text('payment')),
// //                 ],
// //                 rows: bills.map((bill) {
// //                   double total = bill.items.fold(0.0, (sum, item) => sum + (item.amount * item.price));
// //                   return DataRow(cells: [
// //                     DataCell(Text(bill.bill_id.toString())),
// //                     DataCell(Text(bill.customerName)),
// //                     DataCell(Text(bill.date)),
// //                     DataCell(Text(bill.userName)), // Display User Name
// //                     DataCell(Text(total.toStringAsFixed(2))),
// //                   ]);
// //                 }).toList(),
// //               ),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
//
//
// import 'package:flutter/material.dart';
// import 'package:system/features/billes/data/models/bill_model.dart';
// import 'package:system/features/billes/data/models/reportbill_model.dart';
// import 'package:system/features/billes/data/repositories/bill_repository.dart';
//
// class SafeReportPage extends StatefulWidget {
//   @override
//   _SafeReportPageState createState() => _SafeReportPageState();
// }
//
// class _SafeReportPageState extends State<SafeReportPage> {
//   final BillRepository _billRepository = BillRepository();
//   late Future<List<ReportbillBill>> _RbillsFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _RbillsFuture = _billRepository.getBills_with_users();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Report'),
//       ),
//       body: FutureBuilder<List<ReportbillBill>>(
//         future: _RbillsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No data available.'));
//           }
//
//           final bills = snapshot.data!;
//           double totalPayment = bills.fold(
//               0.0,
//                   (sum, bill) =>
//               sum +
//                   bill.items.fold(
//                       0.0, (itemSum, item) => itemSum + (item.amount * item.price)));
//
//           return SingleChildScrollView(
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: DataTable(
//                 columns: [
//                   DataColumn(label: Text('ID')),
//                   DataColumn(label: Text('Customer')),
//                   DataColumn(label: Text('Date')),
//                   DataColumn(label: Text('User')), // New Column for User
//                   DataColumn(label: Text('Payment')),
//                 ],
//                 rows: [
//                   ...bills.map((bill) {
//                     double billTotal = bill.items.fold(
//                         0.0, (sum, item) => sum + (item.amount * item.price));
//                     return DataRow(cells: [
//                       DataCell(Text(bill.bill_id.toString())),
//                       DataCell(Text(bill.customerName)),
//                       DataCell(Text(bill.date)),
//                       DataCell(Text(bill.userName)), // Display User Name
//                       DataCell(Text(billTotal.toStringAsFixed(2))),
//                     ]);
//                   }).toList(),
//                   DataRow(
//                     cells: [
//                       DataCell(Text('')),
//                       DataCell(Text('')),
//                       DataCell(Text('')),
//                       DataCell(Text('Total Payment', style: TextStyle(fontWeight: FontWeight.bold))),
//                       DataCell(Text(totalPayment.toStringAsFixed(2), style: TextStyle(fontWeight: FontWeight.bold))),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
