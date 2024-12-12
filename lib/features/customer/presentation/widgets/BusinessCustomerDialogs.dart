import 'package:flutter/material.dart';
import 'package:system/features/customer/data/model/business_customer_model.dart';

class BusinessCustomerDialogs {
  // Add or Update Business Customer Dialog
  static void showAddOrUpdateDialog({
    required BuildContext context,
    required bool isBusiness,
    business_customers? businessCustomer,
    required Function(String name, String personName, String email, String phone, String personPhone, String address, String discount) onSubmit,
  }) {
    final _nameController = TextEditingController(text: businessCustomer?.name ?? '');
    final _personNameController = TextEditingController(text: businessCustomer?.personName ?? '');
    final _emailController = TextEditingController(text: businessCustomer?.email ?? '');
    final _phoneController = TextEditingController(text: businessCustomer?.phone ?? '');
    final _personPhoneController = TextEditingController(text: businessCustomer?.personPhone ?? '');
    final _addressController = TextEditingController(text: businessCustomer?.address ?? '');
    final _discountController = TextEditingController(text: businessCustomer?.discount ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isBusiness ? 'Add or Update Business Customer' : 'Add or Update Normal Customer'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'اسم الشركة'),
                ),
                TextField(
                  controller: _personNameController,
                  decoration: InputDecoration(labelText: 'اسم الشخص المسؤول'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'الايميل'),
                ),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'رقم الهاتف للشركة'),
                ),
                TextField(
                  controller: _personPhoneController,
                  decoration: InputDecoration(labelText: 'رقم الهاتف الشخص المسوؤل'),
                ),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'العنوان'),
                ),
                TextField(
                  controller: _discountController,
                  decoration: InputDecoration(labelText: 'نسبة الخصم (%)'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Close dialog
                Navigator.pop(context);
              },
              child: Text('الغاء'),
            ),
            TextButton(
              onPressed: () {
                final name = _nameController.text;
                final personName = _personNameController.text;
                final email = _emailController.text;
                final phone = _phoneController.text;
                final personPhone = _personPhoneController.text;
                final address = _addressController.text;
                final discount = _discountController.text;

                if (name.isNotEmpty && email.isNotEmpty && phone.isNotEmpty && address.isNotEmpty) {
                  onSubmit(name, personName, email, phone, personPhone, address, discount);
                  Navigator.pop(context);
                } else {
                  // Show error if fields are empty
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('جميع الحقول مطلوبة')));
                }
              },
              child: Text('حفظ'),
            ),
          ],
        );
      },
    );
  }

  // Delete Business Customer Confirmation Dialog
  static void showDeleteConfirmation({
    required BuildContext context,
    required Function() onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Business Customer'),
          content: Text('Are you sure you want to delete this customer? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onConfirm();
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
