import 'package:flutter/material.dart';
import 'package:system/features/customer/presentation/normal/AddNormalCustomerDialogs.dart';

class NormalCustomerForm extends StatefulWidget {
  final TextEditingController customerNameController;
  final TextEditingController dateController;
  final bool customerExists;
  final List<String> normalCustomerNames;
  final Function(String) updateCustomerExistence;
  final Function(String, String, String, String, String) addNormalCustomer;
  final Function(void Function()) setDialogState;

  const NormalCustomerForm({
    Key? key,
    required this.customerNameController,
    required this.dateController,
    required this.customerExists,
    required this.normalCustomerNames,
    required this.updateCustomerExistence,
    required this.addNormalCustomer,
    required this.setDialogState,
  }) : super(key: key);

  @override
  _NormalCustomerFormState createState() => _NormalCustomerFormState();
}

class _NormalCustomerFormState extends State<NormalCustomerForm> {

  @override
  void initState() {
    super.initState();
  }


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
          Autocomplete<String>(
            initialValue:
            TextEditingValue(text: widget.customerNameController.text),
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<String>.empty();
              } else {
                return widget.normalCustomerNames.where((customer) {
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
              return TextField(
                onChanged: (value) {
                  widget.setDialogState(() {
                    widget.updateCustomerExistence("");
                  });
                },
                controller: textEditingController,
                focusNode: focusNode,
                onSubmitted: (value) => onFieldSubmitted?.call(),
                decoration: InputDecoration(
                  labelText: 'أسم العميل',
                  hintText: 'اكتب اسم العميل .....',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 16.0,
                  ),
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
          const SizedBox(height: 8),
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
          const SizedBox(height: 8),
          if (!widget.customerExists)
            TextButton(
              onPressed: ()  {
                widget.setDialogState(() async {
                 NormalCustomerDialogs.showAddOrUpdateDialog(
                   context: context,
                   isBusiness: false,
                   onSubmit: (name, email, phone, address, phonecall) {
                     widget.addNormalCustomer(name, email, phone, address, phonecall);
                   },
                 );
               });
              },
              child: const Text('اضافة عميل جديد'),
            ),
          const SizedBox(height: 8),
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
