import 'package:flutter/material.dart';
import 'package:system/Adminfeatures/customer/data/model/business_customer_model.dart';
import 'package:system/Adminfeatures/customer/data/repository/business_customer_repository.dart';
import 'package:system/Adminfeatures/customer/presentation/widgets/BusinessCustomerDialogs.dart';

class BusinessCustomerPage extends StatefulWidget {
  final String searchQuery;

  const BusinessCustomerPage({Key? key, required this.searchQuery})
      : super(key: key);

  @override
  _BusinessCustomerPageState createState() => _BusinessCustomerPageState();
}

class _BusinessCustomerPageState extends State<BusinessCustomerPage> {
  final BusinessCustomerRepository _repository = BusinessCustomerRepository();
  late Future<List<business_customers>> _customersFuture;
  List<business_customers> _customers = [];
  List<business_customers> _filteredCustomers = [];

  @override
  void initState() {
    super.initState();
    _customersFuture = _repository.fetchCustomers();
  }

  void _refreshCustomers() {
    setState(() {
      _customersFuture = _repository.fetchCustomers();
    });
  }

  void _filterCustomers(String query) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _filteredCustomers = _customers
            .where((customer) =>
                customer.name.contains(query) ||
                customer.personName.contains(query) ||
                customer.email.contains(query))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('العملاء التجارين'), backgroundColor: Colors.transparent),
      body: FutureBuilder<List<business_customers>>(
        future: _customersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('لا يوجد عملاء متاحين .'));
          }

          final bcustomers = snapshot.data!;
          _customers = bcustomers;

          // Apply the filter after data is loaded
          _filterCustomers(widget.searchQuery);

          return Container(
            alignment: AlignmentDirectional.topStart,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columnSpacing: 20,
                columns: [
                  DataColumn(
                      label: Text('اسم الشركة',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('اسم المسؤول',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('اليميل',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('رقم الهاتف ',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('رقم هاتف المسؤول',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text(' رقم هاتف المسؤول الوتس',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('العنوان',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  // DataColumn(
                  //     label: Text('الخصم',
                  //         style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('المهام',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: _filteredCustomers.map((customer) {
                  return DataRow(cells: [
                    DataCell(Text(customer.name)),
                    DataCell(Text(customer.personName)),
                    DataCell(Text(customer.email)),
                    DataCell(Text(customer.phone)),
                    DataCell(Text(customer.personphonecall)),
                    DataCell(Text(customer.personPhone)),
                    DataCell(Text(customer.address)),
                    // DataCell(Text(customer.discount)),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              BusinessCustomerDialogs.showAddOrUpdateDialog(
                                context: context,
                                businessCustomer: customer,
                                isBusiness: true,
                                onSubmit: (name, personName, email, phone,
                                        personPhone, address, discount,personphonecall) =>
                                    _updateCustomer(
                                        customer.id,
                                        name,
                                        personName,
                                        email,
                                        phone,
                                        personPhone,
                                        address,
                                        discount,
                                        personphonecall
                                    ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              BusinessCustomerDialogs.showDeleteConfirmation(
                                context: context,
                                onConfirm: () => _deleteCustomer(customer.id),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          BusinessCustomerDialogs.showAddOrUpdateDialog(
            context: context,
            isBusiness: true,
            onSubmit: (name, personName, email, phone, personPhone, address,
                    discount,personphonecall) =>
                _addCustomer(name, personName, email, phone, personPhone,
                    address, discount,personphonecall),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _addCustomer(String name, String personName, String email, String phone,
      String personPhone, String address, String discount, String personphonecall ) async {
    final newCustomer = business_customers(
      id: '',
      name: name,
      personName: personName,
      email: email,
      phone: phone,
      personPhone: personPhone,
      address: address,
      discount: discount,
      personphonecall: personphonecall,
    );
    await _repository.addCustomer(newCustomer);
    _refreshCustomers();
  }

  void _updateCustomer(String id, String name, String personName, String email,
      String phone, String personPhone, String address, String discount, String personphonecall) async {
    final updatedCustomer = business_customers(
      id: id,
      name: name,
      personName: personName,
      email: email,
      phone: phone,
      personPhone: personPhone,
      personphonecall: personphonecall,
      address: address,
      discount: discount,
    );
    await _repository.updateCustomer(updatedCustomer);
    _refreshCustomers();
  }

  void _deleteCustomer(String id) async {
    await _repository.deleteCustomer(id);
    _refreshCustomers();
  }
}
