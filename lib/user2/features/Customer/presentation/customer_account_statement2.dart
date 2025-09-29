// // import 'package:flutter/material.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart';
// //
// // class CustomerSelectionPage extends StatefulWidget {
// //   @override
// //   _CustomerSelectionPageState createState() => _CustomerSelectionPageState();
// // }
// //
// // class _CustomerSelectionPageState extends State<CustomerSelectionPage> {
// //   final SupabaseClient _client = Supabase.instance.client;
// //   String? selectedCustomerType;
// //   List<String> customerNames = [];
// //   final customerNameController = TextEditingController();
// //
// //   // Fetch normal customer names from Supabase
// //   Future<void> fetchNormalCustomerNames() async {
// //     try {
// //       final response = await _client.from('normal_customers').select('name');
// //       if (response == null) {
// //         throw Exception('Error fetching customer names');
// //       }
// //       final List<dynamic> data = response;
// //       setState(() {
// //         customerNames = data.map((customer) => customer['name'] as String).toList();
// //       });
// //     } catch (e) {
// //       print('Error: $e');
// //     }
// //   }
// //
// //   // Fetch business customer names from Supabase
// //   Future<void> fetchBusinessCustomerNames() async {
// //     try {
// //       final response = await _client.from('business_customers').select('name');
// //       if (response == null) {
// //         throw Exception('Error fetching customer names');
// //       }
// //       final List<dynamic> data = response;
// //       setState(() {
// //         customerNames = data.map((customer) => customer['name'] as String).toList();
// //       });
// //     } catch (e) {
// //       print('Error: $e');
// //     }
// //   }
// //
// //   @override
// //   void dispose() {
// //     customerNameController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text("اختار نوع العميل")),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             // Customer Type Dropdown
// //             Text("اختار نوع العميل", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
// //             SizedBox(height: 10),
// //             DropdownButtonFormField<String>(
// //               value: selectedCustomerType,
// //               items: ["عادي", "تجاري"].map((String type) {
// //                 return DropdownMenuItem<String>(
// //                   value: type,
// //                   child: Text(type),
// //                 );
// //               }).toList(),
// //               onChanged: (value) {
// //                 setState(() {
// //                   selectedCustomerType = value;
// //                   customerNames = []; // Clear previous names
// //                   customerNameController.clear();
// //                   if (value == "عادي") {
// //                     fetchNormalCustomerNames();
// //                   } else {
// //                     fetchBusinessCustomerNames();
// //                   }
// //                 });
// //               },
// //               decoration: InputDecoration(
// //                 border: OutlineInputBorder(),
// //                 contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //               ),
// //             ),
// //             SizedBox(height: 20),
// //
// //             // Customer Name Autocomplete
// //             if (selectedCustomerType != null)
// //               Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text("اسم العميل", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
// //                   SizedBox(height: 10),
// //                   Autocomplete<String>(
// //                     optionsBuilder: (TextEditingValue textEditingValue) {
// //                       if (textEditingValue.text.isEmpty) {
// //                         return const Iterable<String>.empty();
// //                       }
// //                       return customerNames.where((name) {
// //                         return name.toLowerCase().contains(textEditingValue.text.toLowerCase());
// //                       });
// //                     },
// //                     onSelected: (String selection) {
// //                       setState(() {
// //                         customerNameController.text = selection;
// //                       });
// //                     },
// //                     fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
// //                       return TextField(
// //                         controller: textEditingController,
// //                         focusNode: focusNode,
// //                         decoration: InputDecoration(
// //                           border: OutlineInputBorder(),
// //                           hintText: "اكتب اسم العميل...",
// //                           contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //                         ),
// //                       );
// //                     },
// //                     optionsViewBuilder: (context, onSelected, options) {
// //                       return Material(
// //                         child: ListView.builder(
// //                           padding: EdgeInsets.zero,
// //                           itemCount: options.length,
// //                           itemBuilder: (context, index) {
// //                             final option = options.elementAt(index);
// //                             return ListTile(
// //                               title: Text(option),
// //                               onTap: () => onSelected(option),
// //                             );
// //                           },
// //                         ),
// //                       );
// //                     },
// //                   ),
// //                 ],
// //               ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:system/features/billes/data/models/bill_model.dart';
//
// // Bill Model
// // class Bill {
// //   final int id;
// //   final String customerName;
// //   final String date;
// //   final String status;
// //
// //   Bill({required this.id, required this.customerName, required this.date, required this.status});
// //
// //   factory Bill.fromJson(Map<String, dynamic> json) {
// //     return Bill(
// //       id: json['id'],
// //       customerName: json['customer_name'],
// //       date: json['date'],
// //       status: json['status'],
// //     );
// //   }
// // }
//
// class CustomerSelectionPage extends StatefulWidget {
//   @override
//   _CustomerSelectionPageState createState() => _CustomerSelectionPageState();
// }
//
// class _CustomerSelectionPageState extends State<CustomerSelectionPage> {
//   final SupabaseClient _client = Supabase.instance.client;
//   String? selectedCustomerType;
//   List<String> customerNames = [];
//   final customerNameController = TextEditingController();
//   List<Bill> bills = [];
//
//   // Fetch normal customer names from Supabase
//   Future<void> fetchNormalCustomerNames() async {
//     try {
//       final response = await _client.from('normal_customers').select('name');
//       final List<dynamic> data = response;
//       setState(() {
//         customerNames = data.map((customer) => customer['name'] as String).toList();
//       });
//     } catch (e) {
//       print('Error fetching normal customer names: $e');
//     }
//   }
//
//   // Fetch business customer names from Supabase
//   Future<void> fetchBusinessCustomerNames() async {
//     try {
//       final response = await _client.from('business_customers').select('name');
//       final List<dynamic> data = response;
//       setState(() {
//         customerNames = data.map((customer) => customer['name'] as String).toList();
//       });
//     } catch (e) {
//       print('Error fetching business customer names: $e');
//     }
//   }
//
//   // Fetch all bills for a specific customer
//   Future<void> getBills(String customerName) async {
//     try {
//       final response = await _client
//           .from('bills')
//           .select('id, customer_name, date, state')
//           .eq('customer_name', customerName);
//
//       final List<dynamic> data = response;
//       setState(() {
//         bills = data.map((json) => Bill.fromJson(json)).toList();
//       });
//     } catch (e) {
//       print('Error fetching bills: $e');
//     }
//   }
//
//   @override
//   void dispose() {
//     customerNameController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("اختار نوع العميل")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Customer Type Dropdown
//             Text("اختار نوع العميل", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             SizedBox(height: 10),
//             DropdownButtonFormField<String>(
//               value: selectedCustomerType,
//               items: ["عادي", "تجاري"].map((String type) {
//                 return DropdownMenuItem<String>(
//                   value: type,
//                   child: Text(type),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedCustomerType = value;
//                   customerNames = [];
//                   customerNameController.clear();
//                   if (value == "عادي") {
//                     fetchNormalCustomerNames();
//                   } else {
//                     fetchBusinessCustomerNames();
//                   }
//                 });
//               },
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               ),
//             ),
//             SizedBox(height: 20),
//
//             // Customer Name Autocomplete
//             if (selectedCustomerType != null)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("اسم العميل", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                   SizedBox(height: 10),
//                   Autocomplete<String>(
//                     optionsBuilder: (TextEditingValue textEditingValue) {
//                       if (textEditingValue.text.isEmpty) {
//                         return const Iterable<String>.empty();
//                       }
//                       return customerNames.where((name) {
//                         return name.toLowerCase().contains(textEditingValue.text.toLowerCase());
//                       });
//                     },
//                     onSelected: (String selection) {
//                       setState(() {
//                         customerNameController.text = selection;
//                       });
//                     },
//                     fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
//                       return TextField(
//                         controller: textEditingController,
//                         focusNode: focusNode,
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(),
//                           hintText: "اكتب اسم العميل...",
//                           contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                         ),
//                       );
//                     },
//                     optionsViewBuilder: (context, onSelected, options) {
//                       return Material(
//                         child: ListView.builder(
//                           padding: EdgeInsets.zero,
//                           itemCount: options.length,
//                           itemBuilder: (context, index) {
//                             final option = options.elementAt(index);
//                             return ListTile(
//                               title: Text(option),
//                               onTap: () => onSelected(option),
//                             );
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                   SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: () {
//                       if (customerNameController.text.isNotEmpty) {
//                         getBills(customerNameController.text);
//                       }
//                     },
//                     child: Text("بحث عن الفواتير"),
//                   ),
//                 ],
//               ),
//             SizedBox(height: 20),
//
//             // Bills Table
//             if (bills.isNotEmpty)
//               Expanded(
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: DataTable(
//                     columns: [
//                       DataColumn(label: Text('رقم الفاتورة')),
//                       DataColumn(label: Text('اسم العميل')),
//                       DataColumn(label: Text('التاريخ')),
//                       DataColumn(label: Text('الحالة')),
//                       DataColumn(label: Text('إجراء')),
//                     ],
//                     rows: bills.map((bill) {
//                       return DataRow(cells: [
//                         DataCell(Text(bill.id.toString())),
//                         DataCell(Text(bill.customerName)),
//                         DataCell(Text(bill.date.toUtc().toString())),
//                         DataCell(Text(bill.status)),
//                         DataCell(
//                           ElevatedButton(
//                             onPressed: () {
//                               // TODO: Handle action (View, Edit, Delete)
//                               print("Action on bill ${bill.id}");
//                             },
//                             child: Text("عرض"),
//                           ),
//                         ),
//                       ]);
//                     }).toList(),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/billes/data/repositories/bill_repository.dart';
import 'package:system/features/billes/presentation/Dialog/adding/bill/AddbillPaymentPage.dart';
import 'package:system/features/billes/presentation/Dialog/details-editing-pdf/bill/showBillDetailsDialog.dart';
import 'package:system/features/customer/data/model/business_customer_model.dart';
import 'package:system/features/customer/data/model/normal_customer_model.dart';
import 'package:system/features/customer/presentation/widgets/totalPaymentDialog.dart';

class CustomerSelectionPage extends StatefulWidget {
  @override
  _CustomerSelectionPageState createState() => _CustomerSelectionPageState();
}

class _CustomerSelectionPageState extends State<CustomerSelectionPage> {
  final SupabaseClient _client = Supabase.instance.client;
  String? selectedCustomerType;
  List<String> customerNames = [];
  final customerNameController = TextEditingController();
  final NameController = TextEditingController();
  List<Bill> bills = [];
  Map<String, String> customerDetails = {}; // Store customer details
  final BillRepository billRepository = BillRepository();

  final dateFormat = DateFormat('dd/MM/yyyy');

  List<Bill> allBills = []; // Store all bills
  List<Bill> filteredBills = []; // Store filtered bills
  DateTime? startDate;
  DateTime? endDate;

  bool searchByDate = false; // ✅ Checkbox state

  @override
  void initState() {
    super.initState();
    fetchBills();
  }

  Future<List<Bill>> getBills(String customerName) async {
    try {
      final response = await _client
          .from('bills')
          .select('*, bill_items(*)') // ✅ Fetch related bill_items
          .eq('customer_name', customerName);

      // Ensure response is properly cast to List<dynamic>
      final List<dynamic> data = response as List<dynamic>;

      List<Bill> fetchedBills = data
          .map((json) => Bill.fromJson(json as Map<String, dynamic>))
          .toList();

      // ✅ Ensure state is updated safely
      setState(() {
        bills = fetchedBills;
      });

      return fetchedBills; // ✅ Return fetched bills
    } catch (e) {
      print('Error fetching bills: $e');
      return []; // ✅ Return an empty list instead of null in case of an error
    }
  }

  // Fetch all normal customer names from Supabase
  Future<void> fetchNormalCustomerNames() async {
    try {
      final response = await _client.from('normal_customers').select('name');
      final List<dynamic> data = response;
      setState(() {
        customerNames =
            data.map((customer) => customer['name'] as String).toList();
      });
    } catch (e) {
      print('Error fetching normal customer names: $e');
    }
  }

  // Fetch all business customer names from Supabase
  Future<void> fetchBusinessCustomerNames() async {
    try {
      final response = await _client.from('business_customers').select('*');
      final List<dynamic> data = response;
      setState(() {
        customerNames =
            data.map((customer) => customer['name'] as String).toList();
        print("customerNames");
        print(customerNames);
      });
    } catch (e) {
      print('Error fetching business customer names: $e');
    }
  }

  // put Bill of customer names selected to filteredBills
  Future<void> fetchBills() async {
    try {
      List<Bill> fetchedBills = await getBills(customerNameController.text);
      setState(() {
        bills = fetchedBills;
        filteredBills = fetchedBills; // Initially, show all fetched bills
      });
    } catch (e) {
      print('Error fetching bills: $e');
    }
  }

  void _selectStartDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        startDate = pickedDate;
        _filterBills(); // Apply filter when date changes
      });
    }
  }

  void _selectEndDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        endDate = pickedDate;
        _filterBills(); // Apply filter when date changes
      });
    }
  }



  // filtter bills by date _selectStartDate and _selectEndDate
  void _filterBills() {
    setState(() {
      filteredBills = bills.where((bill) {
        if (startDate != null && bill.date.isBefore(startDate!)) return false;
        if (endDate != null && bill.date.isAfter(endDate!)) return false;
        return true;
      }).toList();
    });
  }

  Future<void> _updateBillStatus(int billId, double totalPrice, double newPayment) async {
    try {
      // Fetch all payments for the given bill
      final payments = await Supabase.instance.client
          .from('payment')
          .select('payment')
          .eq('bill_id', billId);

      // Calculate the total payment amount
      final totalPayment = payments.fold<double>(
        0.0,
        (sum, payment) => sum + (payment['payment'] ?? 0),
      );

      // Determine the new bill status
      String status;
      if (totalPayment == totalPrice) {
        status = 'تم الدفع'; // Fully paid
      } else if (totalPayment > totalPrice) {
        status = 'فاتورة مفتوحة'; // Overpaid
      } else {
        status = 'آجل'; // Partially paid
      }

      // قم بتحديث الحقلين payment و state في جدول bills
      await Supabase.instance.client
          .from('bills')
          .update({
        'payment': newPayment, // ✅ تحديث إجمالي المدفوعات
        'status': status, // ✅ تحديث الحالة
      })
          .eq('id', billId);

      debugPrint('Bill $billId updated: Payment = $newPayment, Status = $status');
    } catch (error) {
      debugPrint('Failed to update bill status: $error');
    }
  }

  // Widget _buildSummaryInfo(double total, double paid, double remaining) {
  //   return Column(
  //     children: [
  //       _buildInfoText('إجمالي الفواتير', total, Colors.black),
  //       _buildInfoText('إجمالي المدفوعات', paid, Colors.blue),
  //       _buildInfoText('المبلغ المتبقي', remaining,
  //           remaining > 0 ? Colors.red : Colors.green),
  //     ],
  //   );
  // }

  //
  // Widget _buildInfoText(String label, double amount, Color color) {
  //   return Text(
  //     '$label: ${amount.toStringAsFixed(2)} L.E',
  //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
  //   );
  // }
  //
  //
  // Widget _buildBillTable(List<Bill> bills, Map<int, double> updatedPayments) {
  //   return DataTable(
  //     columnSpacing: 12.0,
  //     columns: [
  //       DataColumn(label: Text('رقم الفاتورة')),
  //       DataColumn(label: Text('إجمالي الفاتورة')),
  //       DataColumn(label: Text('المدفوع')),
  //       DataColumn(label: Text('المتبقي')),
  //     ],
  //     rows: bills.map((bill) {
  //       double remainingAmount = bill.total_price - updatedPayments[bill.id]!;
  //       return DataRow(cells: [
  //         DataCell(Text(bill.id.toString())),
  //         DataCell(Text('${bill.total_price.toStringAsFixed(2)} L.E')),
  //         DataCell(Text('${updatedPayments[bill.id]!.toStringAsFixed(2)} L.E')),
  //         DataCell(Text('${remainingAmount.toStringAsFixed(2)} L.E',
  //             style: TextStyle(
  //                 color: remainingAmount > 0 ? Colors.red : Colors.green))),
  //       ]);
  //     }).toList(),
  //   );
  // }

  // Future<bool> showPaymentDialog(
  //     BuildContext context, String customerName) async {
  //   List<Bill> customerBills = [];
  //   bool isPaymentMade = false;
  //
  //   try {
  //     customerBills = await getBills(customerName);
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('حدث خطأ أثناء تحميل الفواتير')),
  //     );
  //     return false; // Exit early if there's an error
  //   }
  //
  //   List<Map<String, String>> vaults = []; // Holds vaults fetched from Supabase
  //   String? selectedVaultId; // Holds the selected vault ID
  //
  //   TextEditingController totalPaymentController = TextEditingController();
  //   // TextEditingController vault_idController = TextEditingController();
  //   Map<int, double> updatedPayments = {
  //     for (var bill in customerBills) bill.id: bill.payment ?? 0.0
  //   };
  //
  //   bool isDistributed =
  //       false; // Ensures "Save Payments" is only enabled after distribution
  //
  //   double getTotalAmount() =>
  //       customerBills.fold(0.0, (sum, bill) => sum + bill.total_price);
  //   double getTotalPaid() =>
  //       customerBills.fold(0.0, (sum, bill) => sum + updatedPayments[bill.id]!);
  //   double getRemainingAmount() => getTotalAmount() - getTotalPaid();
  //
  //   // ✅ Fetch vaults BEFORE opening the dialog
  //   try {
  //     vaults = await billRepository.fetchVaultList();
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('حدث خطأ أثناء تحميل الخزن')),
  //     );
  //     return false;
  //   }
  //
  //   /// Distributes the entered amount across bills from oldest to newest
  //   void applyPayment(double enteredAmount, StateSetter setDialogState) {
  //     if (enteredAmount <= 0) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('يرجى إدخال مبلغ صالح')),
  //       );
  //       return;
  //     }
  //
  //     double remainingPayment = enteredAmount;
  //
  //     for (var bill in customerBills) {
  //       if (remainingPayment <= 0) break;
  //
  //       double remainingAmountForBill =
  //           bill.total_price - updatedPayments[bill.id]!;
  //
  //       if (remainingPayment >= remainingAmountForBill) {
  //         updatedPayments[bill.id] = bill.total_price;
  //         remainingPayment -= remainingAmountForBill;
  //       } else {
  //         updatedPayments[bill.id] =
  //             updatedPayments[bill.id]! + remainingPayment;
  //         remainingPayment = 0;
  //       }
  //     }
  //
  //     if (remainingPayment > 0 && customerBills.isNotEmpty) {
  //       var lastBill = customerBills.last;
  //       updatedPayments[lastBill.id] =
  //           updatedPayments[lastBill.id]! + remainingPayment;
  //     }
  //
  //     isDistributed = true;
  //     setDialogState(() {}); // UI updates only after successful distribution
  //   }
  //
  //   return await showDialog<bool>(
  //         context: context,
  //         builder: (context) {
  //           return StatefulBuilder(
  //             builder: (context, setDialogState) {
  //               return AlertDialog(
  //                 title: Text('إضافة دفعات - $customerName'),
  //                 content: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     TextField(
  //                       controller: totalPaymentController,
  //                       keyboardType: TextInputType.number,
  //                       decoration: InputDecoration(
  //                         labelText: 'أدخل المبلغ',
  //                         border: OutlineInputBorder(),
  //                       ),
  //                     ),
  //                     SizedBox(height: 10),
  //                     DropdownButtonFormField<String>(
  //                       value: selectedVaultId,
  //                       hint: Text(
  //                         'اختر الخزنة',
  //                         style: TextStyle(
  //                           color:
  //                               AppBarTheme.of(context).titleTextStyle?.color,
  //                         ),
  //                       ),
  //                       onChanged: (value) {
  //                         setDialogState(() {
  //                           selectedVaultId = value;
  //                         });
  //                       },
  //                       items: vaults.map((vault) {
  //                         return DropdownMenuItem<String>(
  //                           value: vault['id'],
  //                           child: Text(vault['name']!),
  //                         );
  //                       }).toList(),
  //                     ),
  //                     SizedBox(height: 10),
  //                     ElevatedButton(
  //                       onPressed: () {
  //                         double enteredAmount =
  //                             double.tryParse(totalPaymentController.text) ??
  //                                 0.0;
  //                         applyPayment(enteredAmount, setDialogState);
  //                       },
  //                       child: Text('توزيع المبلغ'),
  //                     ),
  //                     SizedBox(height: 10),
  //                     _buildSummaryInfo(getTotalAmount(), getTotalPaid(),
  //                         getRemainingAmount()),
  //                     _buildBillTable(customerBills, updatedPayments),
  //                   ],
  //                 ),
  //                 actions: [
  //                   TextButton(
  //                       onPressed: () => Navigator.pop(context, false),
  //                       child: Text('إلغاء')),
  //                   ElevatedButton(
  //                     onPressed: !isDistributed
  //                         ? null
  //                         : () async {
  //                             final BillRepository billRepository =
  //                                 BillRepository(); // Assuming dependency injection is handled
  //
  //                             for (var bill in customerBills) {
  //                               double newPayment = updatedPayments[bill.id]!;
  //                               if (newPayment > bill.payment) {
  //                                 billRepository.addPayment(
  //                                   billId: bill.id,
  //                                   amount:  (newPayment - bill.payment!).toInt(),
  //                                   userId: Supabase.instance.client.auth.currentUser?.id ??        '',
  //                                   paymentStatus: 'إيداع',
  //                                   vaultId: selectedVaultId!,
  //                                 );
  //                                 // ✅ Update the bill status after payment is inserted
  //                                 _updateBillStatus(bill.id, bill.total_price,newPayment);
  //                               }
  //                             }
  //                             isPaymentMade = true;
  //                             Navigator.pop(context, true);
  //                           },
  //                     child: Text('حفظ الدفعات'),
  //                   ),
  //                 ],
  //               );
  //             },
  //           );
  //         },
  //       ) ??
  //       false; // Ensures false is returned if dialog is dismissed
  // }


  Future<bool> showPaymentDialog(BuildContext context, String customerName) async {
    final BillRepository billRepository = BillRepository();
    List<Bill> customerBills = [];

    try {
      customerBills = await getBills(customerName);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء تحميل الفواتير')),
      );
      return false;
    }

    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return PaymentDialog(
          customerName: customerName,
          customerBills: customerBills,
          billRepository: billRepository,
          updateBillStatus: _updateBillStatus,
        );
      },
    ) ?? false;
  }

  Future<void> fetchnormalCustomerDetails(String customerName) async {
    try {
      // Fetch customer details based on the selected customer name
      final response = await _client
          .from(
              'normal_customers') // Assuming you're fetching from the 'normal_customers' table
          .select('*') // Fetch all fields, or specify the fields you need
          .eq('name', customerName)
          .single(); // Assuming customer name is unique

      // If customer is found, extract the data
      if (response != null) {
        setState(() {
          customerDetails = {
            'name': response['name'],
            'email': response['email'], // Add fields as necessary
            'phone': response['phone'],
            'phonecall': response['phonecall'],
            'address': response['address'],
          };
        });
      }
    } catch (e) {
      print('Error fetching customer details: $e');
    }
  }

  Future<void> fetchbusinessCustomerDetails(String customerName) async {
    try {
      // Fetch customer details based on the selected customer name
      final response = await _client
          .from(
              'business_customers') // Assuming you're fetching from the 'normal_customers' table
          .select('*') // Fetch all fields, or specify the fields you need
          .eq('name', customerName)
          .single(); // Assuming customer name is unique

      // If customer is found, extract the data
      if (response != null) {
        setState(() {
          customerDetails = {
            'name': response['name'],
            'personName': response['personName'],
            'email': response['email'],
            'phone': response['phone'],
            'personphonecall': response['personphonecall'],
            'personPhone': response['personPhone'],
            'address': response['address'],
          };
        });
      }
    } catch (e) {
      print('Error fetching customer details: $e');
    }
  }

  // ✅ Check if response is empty

  @override
  void dispose() {
    customerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("كشف حساب عميل")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Customer Type Dropdown
                      Text("اختار نوع العميل",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Container(
                        width: 400,
                        child: DropdownButtonFormField<String>(
                          value: selectedCustomerType,
                          items: ["عادي", "تجاري"].map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() async {
                              selectedCustomerType = value;
                              customerNames = [];
                              customerNameController.clear();
                              if (value == "عادي") {
                                fetchNormalCustomerNames();
                                await fetchnormalCustomerDetails(
                                    customerNameController.text);
                              } else {
                                fetchBusinessCustomerNames();
                                await fetchbusinessCustomerDetails(
                                    customerNameController.text);
                              }
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),
                      if (selectedCustomerType != null)
                        Container(
                          width: 400,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("اسم العميل",
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),
                              Autocomplete<String>(
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text.isEmpty) {
                                    return const Iterable<String>.empty();
                                  }
                                  return customerNames.where((name) {
                                    return name.toLowerCase().contains(
                                        textEditingValue.text.toLowerCase());
                                  });
                                },
                                onSelected: (String selection) {
                                  setState(() {
                                    customerNameController.text = selection;
                                  });
                                },
                                fieldViewBuilder: (context, textEditingController,
                                    focusNode, onFieldSubmitted) {
                                  return TextField(
                                    controller: textEditingController,
                                    focusNode: focusNode,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "اكتب اسم العميل...",
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                    ),
                                  );
                                },
                                optionsViewBuilder:
                                    (context, onSelected, options) {
                                  return Material(
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: options.length,
                                      itemBuilder: (context, index) {
                                        final option = options.elementAt(index);
                                        return ListTile(
                                          title: Text(option),
                                          onTap: () => onSelected(option),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () async {
                                  if (customerNameController.text.isNotEmpty) {
                                    if (selectedCustomerType == "عادي") {
                                      await fetchnormalCustomerDetails(
                                          customerNameController.text);
                                    } else {
                                      await fetchbusinessCustomerDetails(
                                          customerNameController.text);
                                    }
                                    // await getBills(customerNameController.text);
                                    await fetchBills();
                                  }
                                },
                                child: Text("بحث عن الفواتير"),
                              ),
                            ],
                          ),
                        ),
                      // ✅ Checkbox for Date Filtering
                      Column(
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: searchByDate,
                                onChanged: (bool? value) {
                                  setState(() {
                                    searchByDate = value ?? false;
                                    _filterBills();
                                  });
                                },
                              ),
                              Text('تصفية حسب التاريخ'),
                              SizedBox(
                                width: 8,
                              ),
                              TextButton(
                                child: Row(
                                  children: [
                                    Icon(Icons.payment, color: Colors.green),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text("إدخال دفعة للكل مرة واحدة"),
                                  ],
                                ),
                                onPressed: () async {
                                  bool result = await showPaymentDialog(context, customerNameController.text);
                                  await fetchBills();
                                  await fetchBills();


                                  // filteredBills;

                                  // setState(() {
                                  //
                                  //
                                  // });

                                  // setState(() {
                                  //
                                  // });
                                  // if (result) {
                                  //   setState(() async {
                                  //     fetchBills();
                                  //   }); // Refresh UI only after async work is completed
                                  // }
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'اجمالي الفاتير : ${filteredBills.fold(0.0, (sum, bill) => sum + bill.total_price).toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            'اجمالي المدفوعات: ${filteredBills.fold(0.0, (sum, bill) => sum + bill.payment).toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold,color: Colors.blue, ),
                          ),
                          Text(
                            'المبلغ المتبقي: ${(filteredBills.fold(0.0, (sum, bill) => sum + bill.total_price) - filteredBills.fold(0.0, (sum, bill) => sum + bill.payment)).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue, // يمكنك تغيير اللون لجذب الانتباه
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // SizedBox(
                //   width: 10,
                // ),
                if (bills.isNotEmpty && selectedCustomerType == "عادي")
                  Padding(
                    padding: const EdgeInsets.fromLTRB(90,0,0,0),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(" تفاصيل العميل",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                              'اسم العميل: ${customerDetails['name'] ?? 'لا يوجد'}',
                              style: TextStyle(fontSize: 16)),
                          SizedBox(height: 8),
                          Text(
                              'الايميل: ${customerDetails['email'] ?? 'لا يوجد'}',
                              style: TextStyle(fontSize: 16)),
                          SizedBox(height: 8),
                          Text(
                              'رقم الهاتف: ${customerDetails['phonecall'] ?? 'لا يوجد'}',
                              style: TextStyle(fontSize: 16)),
                          SizedBox(height: 8),
                          Text(
                              'رقم الوتس: ${customerDetails['phone'] ?? 'لا يوجد'}',
                              style: TextStyle(fontSize: 16)),
                          SizedBox(height: 8),
                          Text(
                              'العنوان: ${customerDetails['address'] ?? 'لا يوجد'}',
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                if (bills.isNotEmpty && selectedCustomerType == "تجاري")
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("تفاصيل العميل",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'اسم الشركة: ${customerDetails['name'] ?? 'لا يوجد'}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                              'اسم الشخص المسوؤل: ${customerDetails['personName'] ?? 'لا يوجد'}',
                              style: TextStyle(fontSize: 16)),
                          SizedBox(height: 8),
                          Text(
                              'الايميل: ${customerDetails['email'] ?? 'لا يوجد'}',
                              style: TextStyle(fontSize: 16)),
                          SizedBox(height: 8),
                          Text(
                              'رقم الهاتف للشركة: ${customerDetails['phone'] ?? 'لا يوجد'}',
                              style: TextStyle(fontSize: 16)),
                          SizedBox(height: 8),
                          Text(
                              'رقم الهاتف الشخص المسوؤل: ${customerDetails['personphonecall'] ?? 'لا يوجد'}',
                              style: TextStyle(fontSize: 16)),
                          SizedBox(height: 8),
                          Text(
                              'رقم الوتس: ${customerDetails['personPhone'] ?? 'لا يوجد'}',
                              style: TextStyle(fontSize: 16)),
                          SizedBox(height: 8),
                          Text(
                              'العنوان: ${customerDetails['address'] ?? 'لا يوجد'}',
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            // SizedBox(height: 20),
            if (bills.isNotEmpty)
              Expanded(
                child: Column(
                  children: [
                    if (searchByDate == true)
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'تاريخ البداية',
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                              controller: TextEditingController(
                                text: startDate != null
                                    ? dateFormat.format(startDate!)
                                    : '',
                              ),
                              onTap: () => _selectStartDate(context),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'تاريخ النهاية',
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                              controller: TextEditingController(
                                text: endDate != null
                                    ? dateFormat.format(endDate!)
                                    : '',
                              ),
                              onTap: () => _selectEndDate(context),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          columnSpacing: 20, // Improve spacing
                          headingTextStyle: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue),
                          columns: [
                            DataColumn(label: Text('رقم الفاتورة')),
                            DataColumn(label: Text('اسم العميل')),
                            DataColumn(label: Text('التاريخ')),
                            DataColumn(label: Text('الحالة')),
                            DataColumn(label: Text('اجمالي الفاتورة')),
                            DataColumn(label: Text('المدفوعات')),
                            DataColumn(label: Text('إجراء')),
                          ],
                          rows: filteredBills.map((bill) {
                            return DataRow(cells: [
                              DataCell(Text(bill.id.toString())),
                              // ✅ Ensure id is converted to text
                              DataCell(Text(bill.customerName)),
                              // ✅ Ensure customer name exists
                              DataCell(Text(
                                // "${bill.date.day}/${bill.date.month}/${bill.date.year}"
                                bill.date != null
                                    ? dateFormat.format(bill.date)
                                    : "N/A",
                              )),
                              // ✅ Proper date formatting
                              DataCell(Text(bill.status,
                                  style: TextStyle(
                                    color: bill.status == 'تم الدفع'
                                        ? Colors.green
                                        : Colors.red, // ✅ Add color for status
                                  ))),
                              DataCell(Text(bill.total_price.toString())),
                              DataCell(Text(bill.payment.toString())),

                              DataCell(
                                Row(
                                  children: [
                                    //عرض الفاتورة
                                    ElevatedButton(
                                      onPressed: () {
                                        // print("Action on bill ${bill.id}");
                                        // TODO: Handle navigation to bill details
                                        showBillDetailsDialog(context,
                                            bill); // ✅ Navigate to details
                                      },
                                      child: Text("عرض"),
                                    ),
                                    //اضافة مدفوات
                                    ElevatedButton(
                                      onPressed: () {
                                        // print("Action on bill ${bill.id}");
                                        // TODO: Handle navigation to bill details
                                        showAddPaymentDialog(
                                            context,
                                            bill.id,
                                            bill.customerName,
                                            bill.date as DateTime,
                                            bill.total_price as double);
                                      },
                                      child: Text("اضافة مدفوعات"),
                                    ),
                                  ],
                                ),
                              ),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),

                // Data Table
              ),

            if (bills.isEmpty)
              Center(
                child: Text("لا يوحد فواتير"),
              )
          ],
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchPayments(int billId) async {
    final response = await Supabase.instance.client
        .from('payment')
        .select('*, users(name)')
        .eq('bill_id', billId)
        .order('date', ascending: false);

    if (response == null) {
      throw Exception('Failed to fetch payments.');
    }

    return List<Map<String, dynamic>>.from(response);
  }
}

void showAddPaymentDialog(
  BuildContext context,
  int billId,
  String customerName,
  DateTime billDate,
  double total_price,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AddPaymentDialog(
        billId: billId,
        customerName: customerName,
        billDate: billDate,
        total_price: total_price,
      );
    },
  );
}

Future<void> showBillDetailsDialog(BuildContext context, Bill bill) async {
  showDialog(
    context: context,
    builder: (context) {
      return BillDetailsDialog(bill: bill);
    },
  );
}
