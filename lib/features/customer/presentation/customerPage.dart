// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:system/features/customer/data/model/customer_model.dart';
// // // // // import 'package:system/features/customer/data/repository/normal_customer_repository.dart';
// // // // // import 'package:system/features/customer/presentation/customerDetailsPage.dart';
// // // // //
// // // // // class CustomerPage extends StatefulWidget {
// // // // //   @override
// // // // //   _CustomerPageState createState() => _CustomerPageState();
// // // // // }
// // // // //
// // // // // class _CustomerPageState extends State<CustomerPage> {
// // // // //   final CustomerRepository _customerRepository = CustomerRepository();
// // // // //   late Future<List<Customer>> _customersFuture;
// // // // //
// // // // //   @override
// // // // //   void initState() {
// // // // //     super.initState();
// // // // //     _customersFuture = _customerRepository.fetchCustomers();
// // // // //   }
// // // // //
// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Scaffold(
// // // // //       appBar: AppBar(
// // // // //         title: Text('Customers'),
// // // // //       ),
// // // // //       body: FutureBuilder<List<Customer>>(
// // // // //         future: _customersFuture,
// // // // //         builder: (context, snapshot) {
// // // // //           if (snapshot.connectionState == ConnectionState.waiting) {
// // // // //             return Center(child: CircularProgressIndicator());
// // // // //           } else if (snapshot.hasError) {
// // // // //             return Center(child: Text('Error: ${snapshot.error}'));
// // // // //           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
// // // // //             return Center(child: Text('No customers available.'));
// // // // //           }
// // // // //
// // // // //           final customers = snapshot.data!;
// // // // //           return ListView.builder(
// // // // //             itemCount: customers.length,
// // // // //             itemBuilder: (context, index) {
// // // // //               final customer = customers[index];
// // // // //               return ListTile(
// // // // //                 title: Text(customer.name),
// // // // //                 subtitle: Text(customer.email),
// // // // //                 onTap: () {
// // // // //                   // Navigate to the Customer Details page
// // // // //                   Navigator.push(
// // // // //                     context,
// // // // //                     MaterialPageRoute(
// // // // //                       builder: (context) => CustomerDetailsPage(customer: customer),
// // // // //                     ),
// // // // //                   );
// // // // //                 },
// // // // //               );
// // // // //             },
// // // // //           );
// // // // //         },
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }
// // // //
// // // // import 'package:flutter/material.dart';
// // // // import 'package:system/features/customer/data/model/customer_model.dart';
// // // // import 'package:system/features/customer/data/repository/normal_customer_repository.dart';
// // // // import 'package:system/features/customer/presentation/customerDetailsPage.dart';
// // // //
// // // // class CustomerPage extends StatefulWidget {
// // // //   @override
// // // //   _CustomerPageState createState() => _CustomerPageState();
// // // // }
// // // //
// // // // class _CustomerPageState extends State<CustomerPage> {
// // // //   final CustomerRepository _customerRepository = CustomerRepository();
// // // //   late Future<List<Customer>> _customersFuture;
// // // //
// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     _customersFuture = _customerRepository.fetchCustomers();
// // // //   }
// // // //
// // // //   // Method to refresh customer data
// // // //   void _refreshCustomers() {
// // // //     setState(() {
// // // //       _customersFuture = _customerRepository.fetchCustomers();
// // // //     });
// // // //   }
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(
// // // //         title: Text('Customers'),
// // // //       ),
// // // //       body: FutureBuilder<List<Customer>>(
// // // //         future: _customersFuture,
// // // //         builder: (context, snapshot) {
// // // //           if (snapshot.connectionState == ConnectionState.waiting) {
// // // //             return Center(child: CircularProgressIndicator());
// // // //           } else if (snapshot.hasError) {
// // // //             return Center(child: Text('Error: ${snapshot.error}'));
// // // //           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
// // // //             return Center(child: Text('No customers available.'));
// // // //           }
// // // //
// // // //           final customers = snapshot.data!;
// // // //           return ListView.builder(
// // // //             itemCount: customers.length,
// // // //             itemBuilder: (context, index) {
// // // //               final customer = customers[index];
// // // //               return ListTile(
// // // //                 title: Text(customer.name),
// // // //                 subtitle: Text(customer.email),
// // // //                 onTap: () {
// // // //                   // Navigate to the Customer Details page
// // // //                   Navigator.push(
// // // //                     context,
// // // //                     MaterialPageRoute(
// // // //                       builder: (context) => CustomerDetailsPage(customer: customer),
// // // //                     ),
// // // //                   );
// // // //                 },
// // // //                 trailing: Row(
// // // //                   mainAxisSize: MainAxisSize.min,
// // // //                   children: [
// // // //                     IconButton(
// // // //                       icon: Icon(Icons.edit),
// // // //                       onPressed: () {
// // // //                         // Update customer
// // // //                         _showUpdateDialog(context, customer);
// // // //                       },
// // // //                     ),
// // // //                     IconButton(
// // // //                       icon: Icon(Icons.delete),
// // // //                       onPressed: () {
// // // //                         // Delete customer
// // // //                         _deleteCustomer(customer.id);
// // // //                       },
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               );
// // // //             },
// // // //           );
// // // //         },
// // // //       ),
// // // //       floatingActionButton: FloatingActionButton(
// // // //         onPressed: () {
// // // //           // Add a new customer
// // // //           showAddDialog(context);
// // // //         },
// // // //         child: Icon(Icons.add),
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   // Show dialog to add a new customer
// // // //   void showAddDialog(BuildContext context) {
// // // //     final _nameController = TextEditingController();
// // // //     final _emailController = TextEditingController();
// // // //     final _phoneController = TextEditingController();
// // // //     final _addressController = TextEditingController();
// // // //
// // // //     showDialog(
// // // //       context: context,
// // // //       builder: (context) {
// // // //         return AlertDialog(
// // // //           title: Text('Add Customer'),
// // // //           content: Column(
// // // //             children: [
// // // //               TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Name')),
// // // //               TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
// // // //               TextField(controller: _phoneController, decoration: InputDecoration(labelText: 'Phone')),
// // // //               TextField(controller: _addressController, decoration: InputDecoration(labelText: 'Address')),
// // // //             ],
// // // //           ),
// // // //           actions: [
// // // //             TextButton(
// // // //               onPressed: () {
// // // //                 Navigator.pop(context);
// // // //               },
// // // //               child: Text('Cancel'),
// // // //             ),
// // // //             TextButton(
// // // //               onPressed: () {
// // // //                 _addCustomer(_nameController.text, _emailController.text, _phoneController.text, _addressController.text);
// // // //                 Navigator.pop(context);
// // // //               },
// // // //               child: Text('Add'),
// // // //             ),
// // // //           ],
// // // //         );
// // // //       },
// // // //     );
// // // //   }
// // // //
// // // //   // Add new customer method
// // // //   void _addCustomer(String name, String email, String phone, String address) async {
// // // //     final newCustomer = Customer(id: '', name: name, email: email, phone: phone, address: address);
// // // //     await _customerRepository.addCustomer(newCustomer);
// // // //     _refreshCustomers();
// // // //   }
// // // //
// // // //   // Show dialog to update existing customer
// // // //   void _showUpdateDialog(BuildContext context, Customer customer) {
// // // //     final _nameController = TextEditingController(text: customer.name);
// // // //     final _emailController = TextEditingController(text: customer.email);
// // // //     final _phoneController = TextEditingController(text: customer.phone);
// // // //     final _addressController = TextEditingController(text: customer.address);
// // // //
// // // //     showDialog(
// // // //       context: context,
// // // //       builder: (context) {
// // // //         return AlertDialog(
// // // //           title: Text('Update Customer'),
// // // //           content: Column(
// // // //             children: [
// // // //               TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Name')),
// // // //               TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
// // // //               TextField(controller: _phoneController, decoration: InputDecoration(labelText: 'Phone')),
// // // //               TextField(controller: _addressController, decoration: InputDecoration(labelText: 'Address')),
// // // //             ],
// // // //           ),
// // // //           actions: [
// // // //             TextButton(
// // // //               onPressed: () {
// // // //                 Navigator.pop(context);
// // // //               },
// // // //               child: Text('Cancel'),
// // // //             ),
// // // //             TextButton(
// // // //               onPressed: () {
// // // //                 _updateCustomer(customer.id, _nameController.text, _emailController.text, _phoneController.text, _addressController.text);
// // // //                 Navigator.pop(context);
// // // //               },
// // // //               child: Text('Update'),
// // // //             ),
// // // //           ],
// // // //         );
// // // //       },
// // // //     );
// // // //   }
// // // //
// // // //   // Update existing customer method
// // // //   void _updateCustomer(String id, String name, String email, String phone, String address) async {
// // // //     final updatedCustomer = Customer(id: id, name: name, email: email, phone: phone, address: address);
// // // //     await _customerRepository.updateCustomer(updatedCustomer);
// // // //     _refreshCustomers();
// // // //   }
// // // //
// // // //   // Delete customer method
// // // //   void _deleteCustomer(String id) async {
// // // //     await _customerRepository.deleteCustomer(id);
// // // //     _refreshCustomers();
// // // //   }
// // // // }
// // //
// // // import 'package:flutter/material.dart';
// // // import 'package:system/features/customer/data/model/customer_model.dart';
// // // import 'package:system/features/customer/data/repository/normal_customer_repository.dart';
// // // import 'package:system/features/customer/presentation/customerDetailsPage.dart';
// // //
// // // class CustomerPage extends StatefulWidget {
// // //   @override
// // //   _CustomerPageState createState() => _CustomerPageState();
// // // }
// // //
// // // class _CustomerPageState extends State<CustomerPage> {
// // //   final CustomerRepository _customerRepository = CustomerRepository();
// // //   late Future<List<Customer>> _customersFuture;
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _customersFuture = _customerRepository.fetchCustomers();
// // //   }
// // //
// // //   void _refreshCustomers() {
// // //     setState(() {
// // //       _customersFuture = _customerRepository.fetchCustomers();
// // //     });
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text('Customers'),
// // //       ),
// // //       body: FutureBuilder<List<Customer>>(
// // //         future: _customersFuture,
// // //         builder: (context, snapshot) {
// // //           if (snapshot.connectionState == ConnectionState.waiting) {
// // //             return Center(child: CircularProgressIndicator());
// // //           } else if (snapshot.hasError) {
// // //             return Center(child: Text('Error: ${snapshot.error}'));
// // //           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
// // //             return Center(child: Text('No customers available.'));
// // //           }
// // //
// // //           final customers = snapshot.data!;
// // //           return ListView.separated(
// // //             itemCount: customers.length,
// // //             separatorBuilder: (_, __) => Divider(),
// // //             itemBuilder: (context, index) {
// // //               final customer = customers[index];
// // //               return ListTile(
// // //                 title: Text(customer.name),
// // //                 subtitle: Text(customer.email),
// // //                 onTap: () {
// // //                   Navigator.push(
// // //                     context,
// // //                     MaterialPageRoute(
// // //                       builder: (context) => CustomerDetailsPage(customer: customer),
// // //                     ),
// // //                   );
// // //                 },
// // //                 trailing: Row(
// // //                   mainAxisSize: MainAxisSize.min,
// // //                   children: [
// // //                     IconButton(
// // //                       icon: Icon(Icons.edit, color: Colors.blue),
// // //                       onPressed: () => _showCustomerDialog(context, customer: customer),
// // //                     ),
// // //                     IconButton(
// // //                       icon: Icon(Icons.delete, color: Colors.red),
// // //                       onPressed: () => _deleteCustomer(customer.id),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               );
// // //             },
// // //           );
// // //         },
// // //       ),
// // //       floatingActionButton: FloatingActionButton(
// // //         onPressed: () => _showCustomerDialog(context),
// // //         child: Icon(Icons.add),
// // //       ),
// // //     );
// // //   }
// // //
// // //   void _showCustomerDialog(BuildContext context, {Customer? customer}) {
// // //     final _formKey = GlobalKey<FormState>();
// // //     final _nameController = TextEditingController(text: customer?.name ?? '');
// // //     final _emailController = TextEditingController(text: customer?.email ?? '');
// // //     final _phoneController = TextEditingController(text: customer?.phone ?? '');
// // //     final _addressController = TextEditingController(text: customer?.address ?? '');
// // //
// // //     showDialog(
// // //       context: context,
// // //       builder: (context) {
// // //         return AlertDialog(
// // //           title: Text(customer == null ? 'Add Customer' : 'Update Customer'),
// // //           content: Form(
// // //             key: _formKey,
// // //             child: SingleChildScrollView(
// // //               child: Column(
// // //                 mainAxisSize: MainAxisSize.min,
// // //                 children: [
// // //                   TextFormField(
// // //                     controller: _nameController,
// // //                     decoration: InputDecoration(labelText: 'Name'),
// // //                     validator: (value) => value!.isEmpty ? 'Name is required' : null,
// // //                   ),
// // //                   TextFormField(
// // //                     controller: _emailController,
// // //                     decoration: InputDecoration(labelText: 'Email'),
// // //                     validator: (value) =>
// // //                     value!.isEmpty || !value.contains('@') ? 'Enter a valid email' : null,
// // //                   ),
// // //                   TextFormField(
// // //                     controller: _phoneController,
// // //                     decoration: InputDecoration(labelText: 'Phone'),
// // //                     validator: (value) => value!.isEmpty ? 'Phone is required' : null,
// // //                   ),
// // //                   TextFormField(
// // //                     controller: _addressController,
// // //                     decoration: InputDecoration(labelText: 'Address'),
// // //                     validator: (value) => value!.isEmpty ? 'Address is required' : null,
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ),
// // //           actions: [
// // //             TextButton(
// // //               onPressed: () => Navigator.pop(context),
// // //               child: Text('Cancel'),
// // //             ),
// // //             TextButton(
// // //               onPressed: () {
// // //                 if (_formKey.currentState!.validate()) {
// // //                   if (customer == null) {
// // //                     _addCustomer(
// // //                       _nameController.text,
// // //                       _emailController.text,
// // //                       _phoneController.text,
// // //                       _addressController.text,
// // //                     );
// // //                   } else {
// // //                     _updateCustomer(
// // //                       customer.id,
// // //                       _nameController.text,
// // //                       _emailController.text,
// // //                       _phoneController.text,
// // //                       _addressController.text,
// // //                     );
// // //                   }
// // //                   Navigator.pop(context);
// // //                 }
// // //               },
// // //               child: Text(customer == null ? 'Add' : 'Update'),
// // //             ),
// // //           ],
// // //         );
// // //       },
// // //     );
// // //   }
// // //
// // //   void _addCustomer(String name, String email, String phone, String address) async {
// // //     final newCustomer = Customer(id: '', name: name, email: email, phone: phone, address: address);
// // //     await _customerRepository.addCustomer(newCustomer);
// // //     _refreshCustomers();
// // //   }
// // //
// // //   void _updateCustomer(String id, String name, String email, String phone, String address) async {
// // //     final updatedCustomer = Customer(id: id, name: name, email: email, phone: phone, address: address);
// // //     await _customerRepository.updateCustomer(updatedCustomer);
// // //     _refreshCustomers();
// // //   }
// // //
// // //   void _deleteCustomer(String id) async {
// // //     await _customerRepository.deleteCustomer(id);
// // //     _refreshCustomers();
// // //   }
// // // }
// // import 'package:flutter/material.dart';
// // import 'package:system/features/customer/data/model/customer_model.dart';
// // import 'package:system/features/customer/data/repository/normal_customer_repository.dart';
// // import 'package:system/features/customer/presentation/customerDetailsPage.dart';
// //
// // class CustomerPage extends StatefulWidget {
// //   @override
// //   _CustomerPageState createState() => _CustomerPageState();
// // }
// //
// // class _CustomerPageState extends State<CustomerPage> {
// //   final CustomerRepository _customerRepository = CustomerRepository();
// //   late Future<List<Customer>> _customersFuture;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _customersFuture = _customerRepository.fetchCustomers();
// //   }
// //
// //   void _refreshCustomers() {
// //     setState(() {
// //       _customersFuture = _customerRepository.fetchCustomers();
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Customers'),
// //       ),
// //       body: FutureBuilder<List<Customer>>(
// //         future: _customersFuture,
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return Center(child: CircularProgressIndicator());
// //           } else if (snapshot.hasError) {
// //             return Center(child: Text('Error: ${snapshot.error}'));
// //           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
// //             return Center(child: Text('No customers available.'));
// //           }
// //
// //           final customers = snapshot.data!;
// //           return SingleChildScrollView(
// //             scrollDirection: Axis.horizontal,
// //             child: DataTable(
// //               columns: [
// //                 DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
// //                 DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
// //                 DataColumn(label: Text('Phone', style: TextStyle(fontWeight: FontWeight.bold))),
// //                 DataColumn(label: Text('Address', style: TextStyle(fontWeight: FontWeight.bold))),
// //                 DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
// //               ],
// //               rows: customers.map((customer) {
// //                 return DataRow(cells: [
// //                   DataCell(Text(customer.name)),
// //                   DataCell(Text(customer.email)),
// //                   DataCell(Text(customer.phone)),
// //                   DataCell(Text(customer.address)),
// //                   DataCell(
// //                     Row(
// //                       children: [
// //                         IconButton(
// //                           icon: Icon(Icons.edit, color: Colors.blue),
// //                           onPressed: () => _showCustomerDialog(context, customer: customer),
// //                         ),
// //                         IconButton(
// //                           icon: Icon(Icons.delete, color: Colors.red),
// //                           onPressed: () => _deleteCustomer(customer.id),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ]);
// //               }).toList(),
// //             ),
// //           );
// //         },
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () => _showCustomerDialog(context),
// //         child: Icon(Icons.add),
// //       ),
// //     );
// //   }
// //
// //   void _showCustomerDialog(BuildContext context, {Customer? customer}) {
// //     final _formKey = GlobalKey<FormState>();
// //     final _nameController = TextEditingController(text: customer?.name ?? '');
// //     final _emailController = TextEditingController(text: customer?.email ?? '');
// //     final _phoneController = TextEditingController(text: customer?.phone ?? '');
// //     final _addressController = TextEditingController(text: customer?.address ?? '');
// //
// //     showDialog(
// //       context: context,
// //       builder: (context) {
// //         return AlertDialog(
// //           title: Text(customer == null ? 'Add Customer' : 'Update Customer'),
// //           content: Form(
// //             key: _formKey,
// //             child: SingleChildScrollView(
// //               child: Column(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   TextFormField(
// //                     controller: _nameController,
// //                     decoration: InputDecoration(labelText: 'Name'),
// //                     validator: (value) => value!.isEmpty ? 'Name is required' : null,
// //                   ),
// //                   TextFormField(
// //                     controller: _emailController,
// //                     decoration: InputDecoration(labelText: 'Email'),
// //                     validator: (value) =>
// //                     value!.isEmpty || !value.contains('@') ? 'Enter a valid email' : null,
// //                   ),
// //                   TextFormField(
// //                     controller: _phoneController,
// //                     decoration: InputDecoration(labelText: 'Phone'),
// //                     validator: (value) => value!.isEmpty ? 'Phone is required' : null,
// //                   ),
// //                   TextFormField(
// //                     controller: _addressController,
// //                     decoration: InputDecoration(labelText: 'Address'),
// //                     validator: (value) => value!.isEmpty ? 'Address is required' : null,
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.pop(context),
// //               child: Text('Cancel'),
// //             ),
// //             TextButton(
// //               onPressed: () {
// //                 if (_formKey.currentState!.validate()) {
// //                   if (customer == null) {
// //                     _addCustomer(
// //                       _nameController.text,
// //                       _emailController.text,
// //                       _phoneController.text,
// //                       _addressController.text,
// //                     );
// //                   } else {
// //                     _updateCustomer(
// //                       customer.id,
// //                       _nameController.text,
// //                       _emailController.text,
// //                       _phoneController.text,
// //                       _addressController.text,
// //                     );
// //                   }
// //                   Navigator.pop(context);
// //                 }
// //               },
// //               child: Text(customer == null ? 'Add' : 'Update'),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// //
// //   void _addCustomer(String name, String email, String phone, String address) async {
// //     final newCustomer = Customer(id: '', name: name, email: email, phone: phone, address: address);
// //     await _customerRepository.addCustomer(newCustomer);
// //     _refreshCustomers();
// //   }
// //
// //   void _updateCustomer(String id, String name, String email, String phone, String address) async {
// //     final updatedCustomer = Customer(id: id, name: name, email: email, phone: phone, address: address);
// //     await _customerRepository.updateCustomer(updatedCustomer);
// //     _refreshCustomers();
// //   }
// //
// //   void _deleteCustomer(String id) async {
// //     await _customerRepository.deleteCustomer(id);
// //     _refreshCustomers();
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:system/features/customer/data/model/customer_model.dart';
// import 'package:system/features/customer/data/repository/normal_customer_repository.dart';
// import 'package:system/features/customer/presentation/customerDetailsPage.dart';
// import 'package:system/features/customer/presentation/widgets/customer_dialogs.dart';
//
// class CustomerPage extends StatefulWidget {
//   @override
//   _CustomerPageState createState() => _CustomerPageState();
// }
//
// class _CustomerPageState extends State<CustomerPage> {
//   final CustomerRepository _customerRepository = CustomerRepository();
//   late Future<List<Customer>> _customersFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _customersFuture = _customerRepository.fetchCustomers();
//   }
//
//   void _refreshCustomers() {
//     setState(() {
//       _customersFuture = _customerRepository.fetchCustomers();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Customers'),
//       ),
//       body: FutureBuilder<List<Customer>>(
//         future: _customersFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No customers available.'));
//           }
//
//           final customers = snapshot.data!;
//           return SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: DataTable(
//               columns: [
//                 DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
//                 DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
//                 DataColumn(label: Text('Phone', style: TextStyle(fontWeight: FontWeight.bold))),
//                 DataColumn(label: Text('Address', style: TextStyle(fontWeight: FontWeight.bold))),
//                 DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
//               ],
//               rows: customers.map((customer) {
//                 return DataRow(cells: [
//                   DataCell(Text(customer.name)),
//                   DataCell(Text(customer.email)),
//                   DataCell(Text(customer.phone)),
//                   DataCell(Text(customer.address)),
//                   DataCell(
//                     Row(
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.edit, color: Colors.blue),
//                           onPressed: () {
//                             CustomerDialogs.showAddOrUpdateDialog(
//                               context: context,
//                               customer: customer,
//                               onSubmit: (name, email, phone, address) =>
//                                   _updateCustomer(customer.id, name, email, phone, address),
//                             );
//                           },
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.delete, color: Colors.red),
//                           onPressed: () {
//                             CustomerDialogs.showDeleteConfirmation(
//                               context: context,
//                               onConfirm: () => _deleteCustomer(customer.id),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ]);
//               }).toList(),
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           CustomerDialogs.showAddOrUpdateDialog(
//             context: context,
//             onSubmit: (name, email, phone, address) =>
//                 _addCustomer(name, email, phone, address),
//           );
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
//
//   void _addCustomer(String name, String email, String phone, String address) async {
//     final newCustomer = Customer(id: '', name: name, email: email, phone: phone, address: address);
//     await _customerRepository.addCustomer(newCustomer);
//     _refreshCustomers();
//   }
//
//   void _updateCustomer(String id, String name, String email, String phone, String address) async {
//     final updatedCustomer = Customer(id: id, name: name, email: email, phone: phone, address: address);
//     await _customerRepository.updateCustomer(updatedCustomer);
//     _refreshCustomers();
//   }
//
//   void _deleteCustomer(String id) async {
//     await _customerRepository.deleteCustomer(id);
//     _refreshCustomers();
//   }
// }

import 'package:flutter/material.dart';
import 'normal/normal_customer_page.dart';
import 'business/business_customer_page.dart';

class CustomerPage extends StatefulWidget {
  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  String _selectedCustomerType = 'normal'; // Default type: normal customers
  String _searchQuery = ''; // Search query to filter customers

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إدارة العملاء'),
        actions: [
          TextButton.icon(onPressed: (){
            Navigator.pushReplacementNamed(context, '/adminHome'); // توجيه المستخدم إلى صفحة تسجيل الدخول
          }, label: Icon(Icons.home)),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
              decoration: InputDecoration(
                labelText: 'ابحث عن عميل',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(" نوع العملاء",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                SizedBox(width: 20,),
                // Dropdown to select customer type
                DropdownButton<String>(
                  value: _selectedCustomerType,
                  items: [
                    DropdownMenuItem(
                      value: 'normal',
                      child: Text('العملاء'),
                    ),
                    DropdownMenuItem(
                      value: 'business',
                      child: Text('العملاء التجارين'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCustomerType = value!;
                    });
                  },
                ),
              ],
            ),
          ),

          // Display the selected table
          Expanded(
            child: _selectedCustomerType == 'normal'
                ? NormalCustomerPage(searchQuery: _searchQuery) // Page for normal customers
                : BusinessCustomerPage(searchQuery: _searchQuery), // Page for business customers
          ),
        ],
      ),
    );
  }
}
