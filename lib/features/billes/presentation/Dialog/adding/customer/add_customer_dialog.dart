// add_customer_dialog.dart
import 'package:flutter/material.dart';
import 'package:system/features/billes/data/repositories/bill_repository.dart';
import 'package:system/features/customer/data/model/normal_customer_model.dart';

Future<void> showAddNormalcustomerDialog(BuildContext context,
    {required Function onAdd}) async {
  final BillRepository billRepository = BillRepository();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _phonecallController = TextEditingController();
  final _addressController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('اضافة عميل'),
        content: Column(
          children: [
            TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'الاسم')),
            TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'الاميل')),
            TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: ' رقم الهاتف الوتس')),
            TextField(
                controller: _phonecallController,
                decoration: InputDecoration(labelText: 'رقم الهاتف')),
            TextField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'العنوان')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('الغاء'),
          ),
          TextButton(
            onPressed: () async {
              _addCustomer(
                _nameController.text,
                _emailController.text,
                _phoneController.text,
                _addressController.text,
                billRepository,
                _phonecallController.text,
              );
              await onAdd();

              Navigator.pop(context);
            },
            child: Text('اضافة العميل'),
          ),
        ],
      );
    },
  );
}

void _addCustomer(String name, String email, String phone, String address,
    BillRepository billRepository, String phonecall) async {
  final newCustomer = normal_customers(
      id: '',
      name: name,
      email: email,
      phone: phone,
      address: address,
      phonecall: phonecall
  );
  await billRepository.addCustomer(newCustomer);
}
