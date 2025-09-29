import 'package:flutter/material.dart';
import 'package:system/features/customer/data/model/business_customer_model.dart';

class BusinessCustomerDialogs {
  // Add or Update Business Customer Dialog
  static void showAddOrUpdateDialog({
    required BuildContext context,
    required bool isBusiness,
    business_customers? businessCustomer,
    required Function(String name, String personName, String email,
            String phone, String personPhone, String address,
        // String discount,
        String personphonecall)
        onSubmit,
  }) {
    final _nameController =
        TextEditingController(text: businessCustomer?.name ?? '');
    final _personNameController =
        TextEditingController(text: businessCustomer?.personName ?? '');
    final _emailController =
        TextEditingController(text: businessCustomer?.email ?? 'لم يتم الادخال');
    final _phoneController =
        TextEditingController(text: businessCustomer?.phone ?? 'لم يتم الادخال');
    final _personPhoneController =
        TextEditingController(text: businessCustomer?.personPhone ?? 'لم يتم الادخال');
    final _personphonecallController =
        TextEditingController(text: businessCustomer?.personphonecall ?? 'لم يتم الادخال');
    final _addressController =
        TextEditingController(text: businessCustomer?.address ?? 'لم يتم الادخال');
    // final _discountController =
    //     TextEditingController(text: businessCustomer?.discount ?? 'لم يتم الادخال');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isBusiness
              ? 'اضافة او تحديث عميل تجاري'
              : 'اضافة او تحديث عميل عادي'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      labelText: 'اسم الشركة'
                      , suffixText: "اجباري"
                  ),

                ),
                TextField(
                  controller: _personNameController,
                  decoration: InputDecoration(labelText: 'اسم الشخص المسؤول'
                      , suffixText: "اجباري"
                  ),
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'الايميل'),
                ),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'رقم الهاتف للشركة'
                      // , suffixText: "اجباري"
                  ),
                ),
                TextField(
                  controller: _personPhoneController,
                  decoration:
                      InputDecoration(labelText: 'رقم الهاتف الوتس الشخص المسوؤل'),
                ),
                TextField(
                  controller: _personphonecallController,
                  decoration:
                      InputDecoration(labelText: 'رقم الهاتف الشخص المسوؤل'
                          // , suffixText: "اجباري",
                      ),

                ),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'العنوان'),
                ),
                // TextField(
                //   controller: _discountController,
                //   decoration: InputDecoration(labelText: 'نسبة الخصم (%)'),
                //   keyboardType: TextInputType.number,
                // ),
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
                // final discount = _discountController.text;
                final personphonecall = _personphonecallController.text;

                if (name.isNotEmpty &&
                    personName.isNotEmpty
                // &&
                    // phone.isNotEmpty &&
                    // address.isNotEmpty &&
                    // personphonecall.isNotEmpty
                ) {
                  onSubmit(name, personName, email, phone, personPhone, address,personphonecall
                      // discount
                    );
                  Navigator.pop(context);
                } else {
                  // Show error if fields are empty
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('اسم الشركة و اسم الشخص المسوؤل الحقول مطلوبة')));
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
          title: Text(' حذف عميل تجاري '),
          content: Text(
              'هل أنت متأكد أنك تريد حذف هذا العميل؟ لا يمكن التراجع عن هذا الإجراء'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('الغاء'),
            ),
            TextButton(
              onPressed: () {
                onConfirm();
                Navigator.pop(context); // Close the dialog
              },
              child: Text('حذف'),
            ),
          ],
        );
      },
    );
  }
}
