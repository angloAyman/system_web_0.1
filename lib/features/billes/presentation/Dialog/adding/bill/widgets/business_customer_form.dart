import 'package:flutter/material.dart';
import 'package:system/features/customer/presentation/business/AddBusinessCustomerDialogs.dart';
// import 'package:your_project_name/core/services/business_customer_dialogs.dart';

class BusinessCustomerForm extends StatefulWidget {
  final TextEditingController customerNameController;
  final TextEditingController dateController;
  final bool customerExists;
  final List<String> businessCustomerNames;
  final Function(String) updateCustomerExistence;
  final Function(String, String, String, String, String, String, String,) addBusinessCustomer;
  final Function(void Function()) setDialogState;

  const BusinessCustomerForm({
    Key? key,
    required this.customerNameController,
    required this.dateController,
    required this.customerExists,
    required this.businessCustomerNames,
    required this.updateCustomerExistence,
    required this.addBusinessCustomer,
    required this.setDialogState,
  }) : super(key: key);

  @override
  _BusinessCustomerFormState createState() => _BusinessCustomerFormState();
}

class _BusinessCustomerFormState extends State<BusinessCustomerForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppBarTheme.of(context).surfaceTintColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.maxFinite,
            child: Autocomplete<String>(
              initialValue: TextEditingValue(text: widget.customerNameController.text),
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                } else {
                  return widget.businessCustomerNames.where((customer) {
                    return customer.toLowerCase().contains(
                      textEditingValue.text.toLowerCase(),
                    );
                  });
                }
              },
              onSelected: (String selection) {
                widget.setDialogState(() {
                  widget.customerNameController.text = selection;
                  widget.updateCustomerExistence(selection);
                });
              },
              fieldViewBuilder:
                  (context, textEditingController, focusNode, onFieldSubmitted) {
                textEditingController.addListener(() {
                  widget.customerNameController.text = textEditingController.text;
                });
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  onChanged: (value) {
                    widget.setDialogState(() {
                      widget.updateCustomerExistence("");
                    });
                  },
                  onSubmitted: (value) => onFieldSubmitted?.call(),
                  decoration: InputDecoration(
                    labelText: 'أسم الشركة',
                    hintText: 'اكتب اسم الشركة .....',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
                    ),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  ),
                );
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Material(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);
                      return ListTile(
                        title: Text(option),
                        onTap: () {
                          onSelected(option);
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 5),
          if (widget.customerExists)
            const Text(
              'العميل موجود بالفعل',
              style: TextStyle(color: Colors.green),
            )
          else if (widget.customerNameController.text.isNotEmpty)
            const Text(
              'العميل ليس موجود',
              style: TextStyle(color: Colors.red),
            ),
          const SizedBox(height: 5),
          if (!widget.customerExists)
            SafeArea(
              child: TextButton(


                onPressed: () {
    widget.setDialogState(() async {
      BusinessCustomerDialogs.showAddOrUpdateDialog(
        context: context,
        isBusiness: true,
        onSubmit: (name, personName, email, phone, personPhone, address,
            personphonecall) {
          widget.addBusinessCustomer(
              name,
              personName,
              email,
              phone,
              personPhone,
              address,
              personphonecall);
        },
      );



    });


                },
                child: const Text('اضافة عميل تجاري جديد'),
              ),
            ),
          TextField(
            controller: widget.dateController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'التاريخ (يوم/شهر/سنة)',
              suffixIcon: Icon(Icons.calendar_today),
            ),
            onTap: () => _selectDate(context),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        widget.dateController.text =
        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }
}
