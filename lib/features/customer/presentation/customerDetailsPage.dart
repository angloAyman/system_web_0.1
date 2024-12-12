// // import 'package:flutter/material.dart';
// // import 'package:system/features/customer/data/model/customer_model.dart';
// //
// // class CustomerDetailsPage extends StatelessWidget {
// //   final Customer customer;
// //
// //   CustomerDetailsPage({required this.customer});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Customer Details'),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text('Name: ${customer.name}', style: TextStyle(fontSize: 18)),
// //             SizedBox(height: 10),
// //             Text('Email: ${customer.email}', style: TextStyle(fontSize: 18)),
// //             SizedBox(height: 10),
// //             Text('Phone: ${customer.phone}', style: TextStyle(fontSize: 18)),
// //             SizedBox(height: 10),
// //             Text('Address: ${customer.address}', style: TextStyle(fontSize: 18)),
// //             SizedBox(height: 20),
// //             ElevatedButton(
// //               onPressed: () {
// //                 // Optionally allow editing or other actions
// //               },
// //               child: Text('Edit Customer'),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:system/features/customer/data/model/customer_model.dart';
//
// class CustomerDetailsPage extends StatelessWidget {
//   final Customer customer;
//
//   CustomerDetailsPage({required this.customer});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Customer Details'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Name: ${customer.name}', style: TextStyle(fontSize: 18)),
//             SizedBox(height: 10),
//             Text('Email: ${customer.email}', style: TextStyle(fontSize: 18)),
//             SizedBox(height: 10),
//             Text('Phone: ${customer.phone}', style: TextStyle(fontSize: 18)),
//             SizedBox(height: 10),
//             Text('Address: ${customer.address}', style: TextStyle(fontSize: 18)),
//             SizedBox(height: 20),
//             ElevatedButton.icon(
//               onPressed: () {
//                 // Logic to edit the customer can go here.
//               },
//               icon: Icon(Icons.edit),
//               label: Text('Edit Customer'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
