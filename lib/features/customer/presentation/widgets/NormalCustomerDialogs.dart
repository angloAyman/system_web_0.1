import 'package:flutter/material.dart';
import 'package:system/features/customer/data/model/normal_customer_model.dart';

class NormalCustomerDialogs {
  // Add or Update Customer Dialog
  static void showAddOrUpdateDialog({
    required BuildContext context,
    required bool isBusiness,
    normal_customers? normalCustomer,
    required Function(String name, String email, String phone, String address) onSubmit,
  }) {
    final _nameController = TextEditingController(text: normalCustomer?.name ?? '');
    final _emailController = TextEditingController(text: normalCustomer?.email ?? '');
    final _phoneController = TextEditingController(text: normalCustomer?.phone ?? '');
    final _addressController = TextEditingController(text: normalCustomer?.address ?? '');

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
                  decoration: InputDecoration(labelText: 'اسم العميل'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'الايميل'),
                ),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'رقم الهاتف'),
                ),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'العنوان'),
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
                final email = _emailController.text;
                final phone = _phoneController.text;
                final address = _addressController.text;

                if (name.isNotEmpty && email.isNotEmpty && phone.isNotEmpty && address.isNotEmpty) {
                  onSubmit(name, email, phone, address);
                  Navigator.pop(context);
                } else {
                  // Show error if fields are empty
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('All fields are required')));
                }
              },
              child: Text('حفظ'),
            ),
          ],
        );
      },
    );
  }

  // Delete Customer Confirmation Dialog
  static void showDeleteConfirmation({
    required BuildContext context,
    required Function() onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Customer'),
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
