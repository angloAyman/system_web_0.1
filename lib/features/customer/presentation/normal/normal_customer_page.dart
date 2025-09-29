import 'package:flutter/material.dart';
import 'package:system/Adminfeatures/customer/data/model/normal_customer_model.dart';
import 'package:system/Adminfeatures/customer/data/repository/normal_customer_repository.dart';
import 'package:system/Adminfeatures/customer/presentation/widgets/NormalCustomerDialogs.dart';

class NormalCustomerPage extends StatefulWidget {
  final String searchQuery;
  const NormalCustomerPage({Key? key, required this.searchQuery}) : super(key: key);

  @override
  _NormalCustomerPageState createState() => _NormalCustomerPageState();
}

class _NormalCustomerPageState extends State<NormalCustomerPage> {
  final NormalCustomerRepository _repository = NormalCustomerRepository();
  late Future<List<normal_customers>> _customersFuture;
  List<normal_customers> _customers = [];
  List<normal_customers> _filteredCustomers = [];

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
            customer.email.contains(query) ||
            customer.phone.contains(query))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('العملاء'), backgroundColor: Colors.transparent),
      body: FutureBuilder<List<normal_customers>>(
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
          _customers = customers;

          // Apply the filter after data is loaded
          _filterCustomers(widget.searchQuery);

          return Container(
            alignment: AlignmentDirectional.topStart,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('الاسم', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('الايميل', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('رقم الهاتف', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('رقم الهاتف الوتس', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('العنوان', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('مهام', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: _filteredCustomers.map((customer) {
                  return DataRow(cells: [
                    DataCell(Text(customer.name)),
                    DataCell(Text(customer.email)),
                    DataCell(Text(customer.phonecall)),
                    DataCell(Text(customer.phone)),
                    DataCell(Text(customer.address)),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              NormalCustomerDialogs.showAddOrUpdateDialog(
                                context: context,
                                normalCustomer: customer,
                                isBusiness: false,
                                onSubmit: (name, email, phone, address,phonecall) => _updateCustomer(customer.id, name, email, phone, address,phonecall),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              NormalCustomerDialogs.showDeleteConfirmation(
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
          NormalCustomerDialogs.showAddOrUpdateDialog(
            context: context,
            isBusiness: false,
            onSubmit: (name, email, phone, address, phonecall) => _addCustomer(name, email, phone, address,phonecall),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _addCustomer(String name, String email, String phone, String address,String phonecall) async {
    final newCustomer = normal_customers(id: '', name: name, email: email, phone: phone, address: address, phonecall: phonecall);
    await _repository.addCustomer(newCustomer);
    _refreshCustomers();
  }

  void _updateCustomer(String id, String name, String email, String phone, String address,String phonecall) async {
    final updatedCustomer = normal_customers(id: id, name: name, email: email, phone: phone, address: address, phonecall: phonecall);
    await _repository.updateCustomer(updatedCustomer);
    _refreshCustomers();
  }

  void _deleteCustomer(String id) async {
    await _repository.deleteCustomer(id);
    _refreshCustomers();
  }
}
