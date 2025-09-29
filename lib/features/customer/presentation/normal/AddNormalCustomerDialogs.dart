import 'package:flutter/material.dart';
import 'package:system/features/customer/data/model/normal_customer_model.dart';

class NormalCustomerDialogs {

  // Add or Update Customer Dialog
  static void showAddOrUpdateDialog({
    required BuildContext context,
    required bool isBusiness,
    normal_customers? normalCustomer,
    required Function(String name, String email, String phone, String address , String phonecall) onSubmit,
  }) {
    final _nameController = TextEditingController(text: normalCustomer?.name ?? '');
    final _emailController = TextEditingController(text: normalCustomer?.email ?? 'لم يتم الادخال');
    final _phoneController = TextEditingController(text: normalCustomer?.phone ?? 'لم يتم الادخال');
    final _phonecallController = TextEditingController(text: normalCustomer?.phonecall ?? 'لم يتم الادخال');
    final _addressController = TextEditingController(text: normalCustomer?.address ?? 'لم يتم الادخال');
    bool _isLoading = false;

    showDialog(
      context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                  builder: (context, setDialogState)  {
                return AlertDialog(
                  title: Text(isBusiness ? 'اضافة او تحديث عميل تجاري' : 'اضافة او تحديث عميل عادي'),
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(labelText: 'اسم العميل'
                            , suffixText: "اجباري",

                          ),
                        ),
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(labelText: 'الايميل'),
                        ),
                        TextField(
                          controller: _phonecallController,
                          decoration: InputDecoration(labelText: 'رقم الهاتف'
                            // , suffixText: "اجباري",
                          ),
                        ),
                        TextField(
                          controller: _phoneController,
                          decoration: InputDecoration(labelText: ' رقم الهاتف الوتس'),
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
                      onPressed: () async {
                        final name = _nameController.text;
                        final email = _emailController.text;
                        final phone = _phoneController.text;
                        final phonecall = _phonecallController.text;
                        final address = _addressController.text;
                        if (name.isNotEmpty) {
                              setDialogState(()  {
                             onSubmit(name, email, phone, address,phonecall);
                          });
                          Navigator.pop(context);
                        } else {
                          // Show error if fields are empty
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('برجاء ادخال الاسم اجباري')));
                        }
                      },
                      child: Text('حفظ'),
                    ),
                  ],
                );
              }
            );
          }
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
          title: Text('حذف العميل'),
          content: Text('هل أنت متأكد أنك تريد حذف هذا العميل؟ لا يمكن التراجع عن هذا الإجراء.'),
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
              child: Text('مسح'),
            ),
          ],
        );
      },
    );
  }
}
