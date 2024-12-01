// import 'package:flutter/material.dart';
// import 'package:system/features/customer/data/model/customer_model.dart';
// import 'package:system/features/customer/data/repository/customer_repository.dart';
// import 'package:system/features/customer/presentation/customerDetailsPage.dart';
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
//           return ListView.builder(
//             itemCount: customers.length,
//             itemBuilder: (context, index) {
//               final customer = customers[index];
//               return ListTile(
//                 title: Text(customer.name),
//                 subtitle: Text(customer.email),
//                 onTap: () {
//                   // Navigate to the Customer Details page
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => CustomerDetailsPage(customer: customer),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:system/features/customer/data/model/customer_model.dart';
import 'package:system/features/customer/data/repository/customer_repository.dart';
import 'package:system/features/customer/presentation/customerDetailsPage.dart';

class CustomerPage extends StatefulWidget {
  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final CustomerRepository _customerRepository = CustomerRepository();
  late Future<List<Customer>> _customersFuture;

  @override
  void initState() {
    super.initState();
    _customersFuture = _customerRepository.fetchCustomers();
  }

  // Method to refresh customer data
  void _refreshCustomers() {
    setState(() {
      _customersFuture = _customerRepository.fetchCustomers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customers'),
      ),
      body: FutureBuilder<List<Customer>>(
        future: _customersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No customers available.'));
          }

          final customers = snapshot.data!;
          return ListView.builder(
            itemCount: customers.length,
            itemBuilder: (context, index) {
              final customer = customers[index];
              return ListTile(
                title: Text(customer.name),
                subtitle: Text(customer.email),
                onTap: () {
                  // Navigate to the Customer Details page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomerDetailsPage(customer: customer),
                    ),
                  );
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Update customer
                        _showUpdateDialog(context, customer);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Delete customer
                        _deleteCustomer(customer.id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add a new customer
          showAddDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Show dialog to add a new customer
  void showAddDialog(BuildContext context) {
    final _nameController = TextEditingController();
    final _emailController = TextEditingController();
    final _phoneController = TextEditingController();
    final _addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Customer'),
          content: Column(
            children: [
              TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Name')),
              TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
              TextField(controller: _phoneController, decoration: InputDecoration(labelText: 'Phone')),
              TextField(controller: _addressController, decoration: InputDecoration(labelText: 'Address')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addCustomer(_nameController.text, _emailController.text, _phoneController.text, _addressController.text);
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Add new customer method
  void _addCustomer(String name, String email, String phone, String address) async {
    final newCustomer = Customer(id: '', name: name, email: email, phone: phone, address: address);
    await _customerRepository.addCustomer(newCustomer);
    _refreshCustomers();
  }

  // Show dialog to update existing customer
  void _showUpdateDialog(BuildContext context, Customer customer) {
    final _nameController = TextEditingController(text: customer.name);
    final _emailController = TextEditingController(text: customer.email);
    final _phoneController = TextEditingController(text: customer.phone);
    final _addressController = TextEditingController(text: customer.address);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Customer'),
          content: Column(
            children: [
              TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Name')),
              TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
              TextField(controller: _phoneController, decoration: InputDecoration(labelText: 'Phone')),
              TextField(controller: _addressController, decoration: InputDecoration(labelText: 'Address')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateCustomer(customer.id, _nameController.text, _emailController.text, _phoneController.text, _addressController.text);
                Navigator.pop(context);
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  // Update existing customer method
  void _updateCustomer(String id, String name, String email, String phone, String address) async {
    final updatedCustomer = Customer(id: id, name: name, email: email, phone: phone, address: address);
    await _customerRepository.updateCustomer(updatedCustomer);
    _refreshCustomers();
  }

  // Delete customer method
  void _deleteCustomer(String id) async {
    await _customerRepository.deleteCustomer(id);
    _refreshCustomers();
  }
}
