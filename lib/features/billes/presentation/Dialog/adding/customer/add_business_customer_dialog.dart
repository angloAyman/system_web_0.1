import 'package:flutter/material.dart';
import 'package:system/Adminfeatures/billes/data/repositories/bill_repository.dart';
import 'package:system/Adminfeatures/customer/data/model/business_customer_model.dart';

Future<void> showAddBusinessCustomerDialog(
    BuildContext context, {
      required Function onAdd,
    }) async {
  final BillRepository billRepository = BillRepository();
  final _nameController = TextEditingController();
  final _personNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _personPhoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _discountController = TextEditingController();
  final _personPhonecallController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('إضافة عميل تجاري'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'اسم الشركة'),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _personNameController,
                decoration: InputDecoration(labelText: 'اسم الشخص المسؤول'),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'الإيميل'),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'رقم هاتف الشركة'),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 8),
              TextField(
                controller: _personPhoneController,
                decoration: InputDecoration(labelText: 'رقم هاتف الشخص المسؤول'),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 8),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'العنوان'),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _discountController,
                decoration: InputDecoration(labelText: 'نسبة الخصم (%)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 8),
              TextField(
                controller: _personPhonecallController,
                decoration: InputDecoration(labelText: 'نسبة الخصم (%)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              _addBusinessCustomer(
                _nameController.text,
                _personNameController.text,
                _emailController.text,
                _phoneController.text,
                _personPhoneController.text,
                _addressController.text,
                _discountController.text,
                _personPhonecallController.text,
                billRepository,
              );
              await onAdd();

              Navigator.pop(context);
            },
            child: Text('إضافة العميل'),
          ),
        ],
      );
    },
  );
}

void _addBusinessCustomer(
    String name,
    String personName,
    String email,
    String phone,
    String personPhone,
    String address,
    String discount,
    String personphonecall,
    BillRepository billRepository,
    ) async {
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
  await billRepository.addBusinessCustomer(newCustomer);
}
