import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/core/themes/AppColors/them_constants.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/billes/data/repositories/bill_repository.dart';
import 'package:system/features/billes/presentation/Dialog/adding/customer/add_business_customer_dialog.dart';
import 'package:system/features/billes/presentation/Dialog/adding/customer/add_customer_dialog.dart';
import 'package:system/features/billes/presentation/Dialog/adding/item/showAddItemDialog.dart';
import 'package:system/features/billes/presentation/Dialog/details-editing-pdf/item/showEditItemDialog.dart';
import 'package:system/features/customer/data/model/business_customer_model.dart';
import 'package:system/features/report/data/model/report_model.dart';

Future<void> showAddBillDialog({
  required BuildContext context,
  required Function(Bill, Payment, Report) onAddBill,
}) async {
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController paymentController = TextEditingController();

  final TextEditingController dateController = TextEditingController();
  DateTime? selectedDate; // To hold the selected date

  final List<BillItem> items = [];
  final BillRepository billRepository = BillRepository();
  String _selectedPaymentStatus = "تم الدفع"; // default status
  double _totalPrice = 0.0; // Initialize total price
  List<String> normalCustomerNames = [];
  List<String> businesscustomernames = [];
  bool customerExists = false;

  List<Map<String, String>> vaults = []; // Holds vaults fetched from Supabase
  String? selectedVaultId; // Holds the selected vault ID

  String _selectedCustomerType = "عميل عادي"; // النوع الافتراضي

  // Fetch Normalcustomer names
  await billRepository.getNormalCustomerNames().then((normal_customer_names) {
    normalCustomerNames = normal_customer_names;
  });
  // Fetch businesscustomer names
  await billRepository
      .getBusinessCustomerNames()
      .then((business_customer_names) {
    businesscustomernames = business_customer_names;
  });

  // Fetch vaults names
  await billRepository.fetchVaultList().then((fetchedVaults) {
    vaults = fetchedVaults;
  });


  double calculateTotalPrice({
    required double amount,
    required double pricePerUnit,
    required double quantity,
    required double discount,
  }) {
    // Calculate the subtotal
    double subtotal = amount * pricePerUnit * quantity;

    // Calculate the discount amount
    double discountAmount = subtotal * (discount / 100);

    // Calculate the total price after applying the discount
    double totalPrice = subtotal - discountAmount;

    return totalPrice;
  }

  void addItemCallback(BillItem item) {
    items.add(item);
    // Update total price whenever a new item is added
    _totalPrice = items.fold(0.0, (sum, item) {
      return sum + calculateTotalPrice(
        amount: item.amount,
        pricePerUnit: item.price_per_unit,
        quantity: item.quantity,
        discount: item.discount,
      );
    });
  }

  // Function to return the appropriate icon based on the payment status
  IconData _getPaymentStatusIcon() {
    switch (_selectedPaymentStatus) {
      case "تم الدفع":
        return Icons.check_circle; // Green check icon
      case "فاتورة مفتوحة":
        return Icons.hourglass_empty; // Hourglass icon for open invoice
      case "آجل":
      default:
        return Icons.pending_actions; // Pending actions icon
    }
  }

  // Function to return the color based on the payment status
  Color _getPaymentStatusColor() {
    switch (_selectedPaymentStatus) {
      case "تم الدفع":
        return Colors.green;
      case "فاتورة مفتوحة":
        return Colors.blue;
      case "آجل":
      default:
        return Colors.orange;
    }
  }

  // Function to check if the customer exists after adding a new one
  void _updateCustomerExistence(String customerName) {
    if (_selectedCustomerType == "عميل عادي") {
      customerExists = normalCustomerNames.contains(customerName);
    }
    ;
    if (_selectedCustomerType == "عميل تجاري") {
      customerExists = businesscustomernames.contains(customerName);
    }
    ;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      selectedDate = picked; // Save the selected date
      dateController.text =
      "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}"; // Format as DD/MM/YYYY
    }
  }


  DateTime? _parseDate(String input) {
    try {
      final parts = input.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (e) {
      // Optionally log the error
    }
    return null; // Return null if parsing fails
  }




  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Column(
              children: [
                // Add the toggle buttons for customer type
                ToggleButtons(
                  isSelected: [
                    _selectedCustomerType == "عميل عادي",
                    _selectedCustomerType == "عميل تجاري",
                  ],
                  onPressed: (index) {
                    setDialogState(() {
                      _selectedCustomerType =
                          (index == 0) ? "عميل عادي" : "عميل تجاري";
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  borderWidth: 2,
                  selectedBorderColor: Colors.green,
                  selectedColor: Colors.white,
                  fillColor: Colors.green,
                  borderColor: Colors.green,
                  color: Colors.green,
                  // color: Colors.black,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text("عميل عادي"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text("عميل تجاري"),
                    ),
                  ],
                ),
                SizedBox(height: 16), // Spacing below the toggle buttons
                Text(
                    '------------------------------ انشاء فاتورة جديدة ------------------------------', style: TextStyle(color: Colors.blue),),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  if (_selectedCustomerType == "عميل عادي")
                    Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color:AppBarTheme.of(context).surfaceTintColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: customerNameController,
                            decoration: InputDecoration(
                              labelText: 'أسم العميل',
                            ),
                            onChanged: (value) {
                              setDialogState(() {
                                _updateCustomerExistence(value);
                              });
                            },
                          ),
                          SizedBox(height: 5),
                          if (customerExists)
                            Text(
                              'العميل موجود بالفعل',
                              style: TextStyle(color: Colors.green),
                            )
                          else if (customerNameController.text.isNotEmpty)
                            Text(
                              'العميل ليس موجود',
                              style: TextStyle(color: Colors.red),
                            ),
                          SizedBox(height: 5),
                          if (!customerExists)
                            SafeArea(
                              child: TextButton(
                                onPressed: () {
                                  showAddNormalcustomerDialog(
                                    context,
                                    onAdd: () {
                                      billRepository
                                          .getNormalCustomerNames()
                                          .then((names) {
                                        normalCustomerNames = names;
                                        setDialogState(() {
                                          _updateCustomerExistence(
                                              customerNameController.text);
                                        });
                                      });
                                    },
                                  );
                                },
                                child: Text('اضافة عميل جديد'),
                              ),
                            ),
                          TextField(
                            controller: dateController,
                            readOnly: true, // Prevent manual input
                            decoration: InputDecoration(
                              labelText: 'التاريخ (يوم/شهر/سنة)',
                              suffixIcon: Icon(Icons.calendar_today), // Add a calendar icon
                            ),
                            onTap: () => _selectDate(context), // Show the date picker on tap
                          )
                        ],
                      ),
                    ),
                  if (_selectedCustomerType == "عميل تجاري")
                    Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: AppBarTheme.of(context).surfaceTintColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: customerNameController,
                            decoration: InputDecoration(
                              labelText: 'أسم الشركة',
                            ),
                            onChanged: (value) {
                              setDialogState(() {
                                _updateCustomerExistence(value);
                              });
                            },
                          ),
                          SizedBox(height: 5),
                          if (customerExists)
                            Text(
                              'العميل موجود بالفعل',
                              style: TextStyle(color: Colors.green),
                            )
                          else if (customerNameController.text.isNotEmpty)
                            Text(
                              'العميل ليس موجود',
                              style: TextStyle(color: Colors.red),
                            ),
                          SizedBox(height: 5),
                          if (!customerExists)
                            SafeArea(
                              child: TextButton(
                                onPressed: () {
                                  showAddBusinessCustomerDialog(
                                    context,
                                    onAdd: () {
                                      billRepository
                                          .getBusinessCustomerNames()
                                          .then((names) {
                                        businesscustomernames = names;
                                        setDialogState(() {
                                          _updateCustomerExistence(
                                              customerNameController.text);
                                        });
                                      });
                                    },
                                  );
                                },
                                child: Text('اضافة عميل تجاري جديد'),
                              ),
                            ),
                          TextField(
                            controller: dateController,
                            readOnly: true, // Prevent manual input
                            decoration: InputDecoration(
                              labelText: 'التاريخ (يوم/شهر/سنة)',
                              suffixIcon: Icon(Icons.calendar_today), // Add a calendar icon
                            ),
                            onTap: () => _selectDate(context), // Show the date picker on tap
                          )
                        ],
                      ),
                    ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      showAddItemDialog(
                        context: context,
                        onAddItem: (item) {
                          setDialogState(() {
                            addItemCallback(item);
                          });
                        },
                      );
                    },
                    child: Text('اضافة عناصر الفاتورة'),
                  ),
                  if (items.isNotEmpty) ...[
                    Text('عناصر الفاتورة:',
                        style: TextStyle(fontWeight: FontWeight.bold,)),
                    Table(
                      border: TableBorder.all(),
                      columnWidths: {
                        0: FlexColumnWidth(3),
                        1: FlexColumnWidth(3),
                        2: FlexColumnWidth(2),
                        3: FlexColumnWidth(2),
                        4: FlexColumnWidth(2),
                        5: FlexColumnWidth(2),
                        6: FlexColumnWidth(2),
                        7: FlexColumnWidth(2),
                        8: FlexColumnWidth(3), // العمود الجديد
                      },
                      children: [
                        TableRow(
                          children: [
                            // 1- الفئة / الفئة الفرعية
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('الفئة / الفئة الفرعية',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            // 2- الوصف
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('الوصف داخل الفاتورة',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            // 3- سعر الوحدة
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('سعر الوحدة',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            // 4- عدد الوحدات
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('عدد الوحدات',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),

                            // 5- سعر القطعة
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('السعر القطعة',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            // 6- العدد
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('العدد',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            // 7- نسبة الخصم
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('نسبة الخصم',
                                  style:
                                  TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            // 8- الإجمالي
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('السعر الإجمالي',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            // 9- الإجراءات
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('الإجراءات',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        ...items.map((item) {
                          return TableRow(
                            children: [
                              // 1- الفئة / الفئة الفرعية
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    '${item.categoryName} / ${item.subcategoryName}'),
                              ),
                              // 2- الوصف
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${item.description}'),
                              ),
                              // 3- سعر الوحدة
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${item.price_per_unit}'),
                              ),
                              // 4- عدد الوحدات
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${item.amount}'),
                              ),

                              // 5- سعر القطعة
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    '\جنيه${(item.amount * item.price_per_unit)}'),
                              ),
                              // 6- العدد
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${item.quantity}'),
                              ),
                              // 7- سعر القطعة
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${item.discount}'),
                              ),

                              //8- الإجمالي
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Text(
                              //       '\جنيه${(item.amount * item.price_per_unit * item.quantity) *
                              //           (1 - (item.discount / 100))}'),
                              // ),

                              Padding(
                              padding: const EdgeInsets.all(8.0),
                          child: Text(
                          calculateTotalPrice(
                          amount: item.amount,
                          pricePerUnit: item.price_per_unit,
                          quantity: item.quantity,
                          discount: item.discount,
                          ) .toString(),
                          style: TextStyle(fontSize: 16.0),
                          ),
                          ),

                          //9- الإجراءات
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon:
                                          Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () {
                                        showEditItemDialog(
                                            item: item,
                                            context: context,
                                            onUpdateItem: (updatedItem) {
                                              setDialogState(() {
                                                int index = items.indexWhere(
                                                    (i) => i == item);
                                                items[index] = updatedItem;
                                              });
                                            });

                                        // وظيفة التعديل
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Edit clicked for ${item.categoryName}')),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        // وظيفة الحذف
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Delete clicked for ${item.categoryName}')),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ],
                  Divider(),
                  Text(
                    'الإجمالي: L.E ${
                        items.fold(0.0, (sum, item) {
                          return sum + calculateTotalPrice(
                            amount: item.amount,
                            pricePerUnit: item.price_per_unit,
                            quantity: item.quantity,
                            discount: item.discount,
                          );
                        })
                    }',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: AppBarTheme.of(context).surfaceTintColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: paymentController,
                          decoration: InputDecoration(
                            labelText: 'المبلغ المدفوع',
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setDialogState(() {
                              final paymentAmount =
                                  double.tryParse(value) ?? 0.0;

                              if (_totalPrice == paymentAmount) {
                                _selectedPaymentStatus = "تم الدفع";
                              } else if (_totalPrice < paymentAmount) {
                                _selectedPaymentStatus = "فاتورة مفتوحة";
                              } else {
                                _selectedPaymentStatus = "آجل";
                              }
                            });
                          },
                        ),
                        DropdownButtonFormField<String>(
                          value: selectedVaultId,
                          hint: Text('اختر الخزنة',style: TextStyle(color: AppBarTheme.of(context).titleTextStyle?.color,),),
                          onChanged: (value) {
                            setDialogState(() {
                              selectedVaultId = value;
                            });
                          },
                          items: vaults.map((vault) {
                            return DropdownMenuItem<String>(
                              value: vault['id'],
                              child: Text(vault['name']!),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                children: [
                  IconButton(
                    icon: Row(
                      children: [
                        Icon(
                          _getPaymentStatusIcon(),
                          color: _getPaymentStatusColor(),
                        ),
                        SizedBox(width: 8),
                        Text(
                          _selectedPaymentStatus,
                          style: TextStyle(
                            color: _getPaymentStatusColor(),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      final paymentAmount =
                          double.tryParse(paymentController.text) ?? 0.0;

                      if (_totalPrice == paymentAmount) {
                        setDialogState(() {
                          _selectedPaymentStatus = "تم الدفع";
                        });
                      } else if (_totalPrice < paymentAmount) {
                        setDialogState(() {
                          _selectedPaymentStatus = "فاتورة مفتوحة";
                        });
                      } else {
                        setDialogState(() {
                          _selectedPaymentStatus = "آجل";
                        });
                      }
                    },
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('الغاء'),
                  ),

                  TextButton(
                    onPressed: customerExists
                        ? () async {
                      final user = Supabase.instance.client.auth.currentUser;
                      if (user != null) {
                        // Parse the date using custom parsing logic
                        final parsedDate = dateController.text.isNotEmpty
                            ? _parseDate(dateController.text)
                            : null;

                        // Handle null date case
                        if (parsedDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Invalid date format. Please use DD/MM/YYYY.'),
                            ),
                          );
                          return; // Exit early if the date is invalid
                        }

                        final bill = Bill(
                          status: _selectedPaymentStatus,
                          id: 0,
                          userId: user.id,
                          customerName: customerNameController.text,
                          date: parsedDate, // Use parsed date
                          items: items,
                          payment: double.parse(paymentController.text),
                          total_price: _totalPrice,
                          vault_id: selectedVaultId!,
                        );

                        final payment = Payment(
                          id: Supabase.instance.client.auth.currentUser!.id,
                          billId: bill.id,
                          date: DateTime.now(),
                          userId: user.id,
                          payment: bill.payment,
                          payment_status: 'إيداع',
                          createdAt: DateTime.now(),
                        );

                        final billreport = Report(
                          id: Supabase.instance.client.auth.currentUser!.id,
                          title: "اضافة فاتورة",
                          user_name: user.id,
                          date: DateTime.now(),
                          description:
                          'رقم الفاتورة: (${bill.id.toString()}) - اسم العميل : ${bill.customerName} - اجمالي الفاتورة: ${bill.total_price.toStringAsFixed(2)}',
                          operationNumber: 0,
                        );

                        await onAddBill(bill, payment, billreport);
                        final repository = BillRepository();
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: User not authenticated'),
                          ),
                        );
                      }
                    }
                        : null, // Disable button if customer doesn't exist
                    child: Text('اضف الفاتورة'),
                  ),


                ],
              ),
            ],
          );
        },
      );
    },
  );
}
