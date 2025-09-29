// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart';
// // import 'package:system/features/billes/data/models/bill_model.dart';
// // import 'package:system/features/billes/data/repositories/bill_repository.dart';
// // import 'package:system/features/billes/presentation/Dialog/adding/bill/AddbillPaymentPage.dart';
// // import 'package:system/features/billes/presentation/Dialog/details-editing-pdf/bill/showBillDetailsDialog.dart';
// // import 'package:system/features/customer/data/model/business_customer_model.dart';
// // import 'package:system/features/customer/data/model/normal_customer_model.dart';
// // import 'package:system/features/customer/presentation/widgets/totalPaymentDialog.dart';
// // import 'package:system/features/report/UI/customer/pdf.dart';
// //
// // class CustomerSelectionPageMobile extends StatefulWidget {
// //   @override
// //   _CustomerSelectionPageMobileState createState() => _CustomerSelectionPageMobileState();
// // }
// //
// // class _CustomerSelectionPageMobileState extends State<CustomerSelectionPageMobile> {
// //   final SupabaseClient _client = Supabase.instance.client;
// //   String? selectedCustomerType;
// //   List<String> customerNames = [];
// //   final customerNameController = TextEditingController();
// //   final NameController = TextEditingController();
// //   List<Bill> bills = [];
// //   Map<String, String> customerDetails = {}; // Store customer details
// //   final BillRepository billRepository = BillRepository();
// //
// //   final dateFormat = DateFormat('dd/MM/yyyy');
// //
// //   List<Bill> allBills = []; // Store all bills
// //   List<Bill> filteredBills = []; // Store filtered bills
// //   DateTime? startDate;
// //   DateTime? endDate;
// //
// //   bool searchByDate = false; // ✅ Checkbox state
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchBills();
// //   }
// //
// //   Future<List<Bill>> getBills(String customerName) async {
// //     try {
// //       final response = await _client
// //           .from('bills')
// //           .select('*, bill_items(*)') // ✅ Fetch related bill_items
// //           .eq('customer_name', customerName);
// //
// //       // Ensure response is properly cast to List<dynamic>
// //       final List<dynamic> data = response as List<dynamic>;
// //
// //       List<Bill> fetchedBills = data
// //           .map((json) => Bill.fromJson(json as Map<String, dynamic>))
// //           .toList();
// //
// //       // ✅ Ensure state is updated safely
// //       setState(() {
// //         bills = fetchedBills;
// //       });
// //
// //       return fetchedBills; // ✅ Return fetched bills
// //     } catch (e) {
// //       print('Error fetching bills: $e');
// //       return []; // ✅ Return an empty list instead of null in case of an error
// //     }
// //   }
// //
// //   // Fetch all normal customer names from Supabase
// //   Future<void> fetchNormalCustomerNames() async {
// //     try {
// //       final response = await _client.from('normal_customers').select('name');
// //       final List<dynamic> data = response;
// //       setState(() {
// //         customerNames =
// //             data.map((customer) => customer['name'] as String).toList();
// //       });
// //     } catch (e) {
// //       print('Error fetching normal customer names: $e');
// //     }
// //   }
// //
// //   // Fetch all business customer names from Supabase
// //   Future<void> fetchBusinessCustomerNames() async {
// //     try {
// //       final response = await _client.from('business_customers').select('*');
// //       final List<dynamic> data = response;
// //       setState(() {
// //         customerNames =
// //             data.map((customer) => customer['name'] as String).toList();
// //         print("customerNames");
// //         print(customerNames);
// //       });
// //     } catch (e) {
// //       print('Error fetching business customer names: $e');
// //     }
// //   }
// //
// //   // put Bill of customer names selected to filteredBills
// //   Future<void> fetchBills() async {
// //     try {
// //       List<Bill> fetchedBills = await getBills(customerNameController.text);
// //       setState(() {
// //         bills = fetchedBills;
// //         filteredBills = fetchedBills; // Initially, show all fetched bills
// //       });
// //     } catch (e) {
// //       print('Error fetching bills: $e');
// //     }
// //   }
// //
// //   void _selectStartDate(BuildContext context) async {
// //     DateTime? pickedDate = await showDatePicker(
// //       context: context,
// //       initialDate: DateTime.now(),
// //       firstDate: DateTime(2000),
// //       lastDate: DateTime(2101),
// //     );
// //
// //     if (pickedDate != null) {
// //       setState(() {
// //         startDate = pickedDate;
// //         _filterBills(); // Apply filter when date changes
// //       });
// //     }
// //   }
// //
// //   void _selectEndDate(BuildContext context) async {
// //     DateTime? pickedDate = await showDatePicker(
// //       context: context,
// //       initialDate: DateTime.now(),
// //       firstDate: DateTime(2000),
// //       lastDate: DateTime(2101),
// //     );
// //
// //     if (pickedDate != null) {
// //       setState(() {
// //         endDate = pickedDate;
// //         _filterBills(); // Apply filter when date changes
// //       });
// //     }
// //   }
// //
// //   // filtter bills by date _selectStartDate and _selectEndDate
// //   void _filterBills() {
// //     setState(() {
// //       filteredBills = bills.where((bill) {
// //         if (startDate != null && bill.date.isBefore(startDate!)) return false;
// //         if (endDate != null && bill.date.isAfter(endDate!)) return false;
// //         return true;
// //       }).toList();
// //     });
// //   }
// //
// //   Future<void> _updateBillStatus(
// //       int billId, int totalPrice, int newPayment) async {
// //     try {
// //       // Fetch all payments for the given bill
// //       final payments = await Supabase.instance.client
// //           .from('payment')
// //           .select('payment')
// //           .eq('bill_id', billId);
// //
// //       // Calculate the total payment amount
// //       int totalPayment = payments
// //           .fold<double>(
// //         0,
// //             (sum, payment) => sum + (payment['payment'] ?? 0),
// //       )
// //           .toInt();
// //
// //       // Determine the new bill status
// //       String status;
// //       if (totalPayment == totalPrice) {
// //         status = 'تم الدفع'; // Fully paid
// //       } else if (totalPayment > totalPrice) {
// //         status = 'فاتورة مفتوحة'; // Overpaid
// //       } else {
// //         status = 'آجل'; // Partially paid
// //       }
// //
// //       // قم بتحديث الحقلين payment و state في جدول bills
// //       await Supabase.instance.client.from('bills').update({
// //         'payment': newPayment, // ✅ تحديث إجمالي المدفوعات
// //         'status': status, // ✅ تحديث الحالة
// //       }).eq('id', billId);
// //
// //       setState(() async {
// //         await fetchBills();
// //       });
// //       await fetchBills();
// //       debugPrint(
// //           'Bill $billId updated: Payment = $newPayment, Status = $status');
// //     } catch (error) {
// //       debugPrint('Failed to update bill status: $error');
// //     }
// //   }
// //
// //   Future<bool> showAddPaymentDialog(
// //       BuildContext context,
// //       int billId,
// //       int payment,
// //       String customerName,
// //       DateTime billDate,
// //       int total_price,
// //       ) async {
// //     return await showDialog<bool>(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AddPaymentDialog(
// //           billId: billId,
// //           payment: payment,
// //           customerName: customerName,
// //           billDate: billDate,
// //           total_price: total_price,
// //         );
// //       },
// //     ) ??
// //         false;
// //   }
// //
// //   Future<bool> showPaymentDialog(
// //       BuildContext context, String customerName) async {
// //     final BillRepository billRepository = BillRepository();
// //     List<Bill> customerBills = [];
// //
// //     try {
// //       customerBills = await getBills(customerName);
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('حدث خطأ أثناء تحميل الفواتير')),
// //       );
// //       return false;
// //     }
// //
// //     return await showDialog<bool>(
// //       context: context,
// //       builder: (context) {
// //         return PaymentDialog(
// //           customerName: customerName,
// //           customerBills: customerBills,
// //           billRepository: billRepository,
// //           updateBillStatus: _updateBillStatus,
// //         );
// //       },
// //     ) ??
// //         false;
// //   }
// //
// //   Future<void> fetchnormalCustomerDetails(String customerName) async {
// //     try {
// //       // Fetch customer details based on the selected customer name
// //       final response = await _client
// //           .from(
// //           'normal_customers') // Assuming you're fetching from the 'normal_customers' table
// //           .select('*') // Fetch all fields, or specify the fields you need
// //           .eq('name', customerName)
// //           .single(); // Assuming customer name is unique
// //
// //       // If customer is found, extract the data
// //       if (response != null) {
// //         setState(() {
// //           customerDetails = {
// //             'name': response['name'],
// //             'email': response['email'], // Add fields as necessary
// //             'phone': response['phone'],
// //             'phonecall': response['phonecall'],
// //             'address': response['address'],
// //           };
// //         });
// //       }
// //     } catch (e) {
// //       print('Error fetching customer details: $e');
// //     }
// //   }
// //
// //   Future<void> fetchbusinessCustomerDetails(String customerName) async {
// //     try {
// //       // Fetch customer details based on the selected customer name
// //       final response = await _client
// //           .from(
// //           'business_customers') // Assuming you're fetching from the 'normal_customers' table
// //           .select('*') // Fetch all fields, or specify the fields you need
// //           .eq('name', customerName)
// //           .single(); // Assuming customer name is unique
// //
// //       // If customer is found, extract the data
// //       if (response != null) {
// //         setState(() {
// //           customerDetails = {
// //             'name': response['name'],
// //             'personName': response['personName'],
// //             'email': response['email'],
// //             'phone': response['phone'],
// //             'personphonecall': response['personphonecall'],
// //             'personPhone': response['personPhone'],
// //             'address': response['address'],
// //           };
// //         });
// //       }
// //     } catch (e) {
// //       print('Error fetching customer details: $e');
// //     }
// //   }
// //
// //   // ✅ Check if response is empty
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
// //       appBar: AppBar(title: Text("كشف حساب عميل")),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: SingleChildScrollView(
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //
// //               // ✅ Dropdown Customer Type
// //               Text("اختار نوع العميل", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
// //               SizedBox(height: 10),
// //               DropdownButtonFormField<String>(
// //                 value: selectedCustomerType,
// //                 items: ["عادي", "تجاري"].map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
// //                 onChanged: (value) async {
// //                   setState(() => selectedCustomerType = value);
// //                   customerNames = [];
// //                   customerNameController.clear();
// //                   if (value == "عادي") {
// //                     await fetchNormalCustomerNames();
// //                   } else {
// //                     await fetchBusinessCustomerNames();
// //                   }
// //                 },
// //                 decoration: InputDecoration(
// //                   border: OutlineInputBorder(),
// //                   contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //                 ),
// //               ),
// //               SizedBox(height: 20),
// //
// //               // ✅ Customer Name Search
// //               if (selectedCustomerType != null) ...[
// //                 Text("اسم العميل", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
// //                 SizedBox(height: 10),
// //                 Autocomplete<String>(
// //                   optionsBuilder: (textEditingValue) {
// //                     if (textEditingValue.text.isEmpty) {
// //                       return const Iterable<String>.empty();
// //                     }
// //                     return customerNames.where((name) => name.toLowerCase().contains(textEditingValue.text.toLowerCase()));
// //                   },
// //                   onSelected: (selection) {
// //                     setState(() => customerNameController.text = selection);
// //                   },
// //                   fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
// //                     return TextField(
// //                       controller: controller,
// //                       focusNode: focusNode,
// //                       decoration: InputDecoration(
// //                         border: OutlineInputBorder(),
// //                         hintText: "اكتب اسم العميل...",
// //                         contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //                       ),
// //                     );
// //                   },
// //                 ),
// //                 SizedBox(height: 20),
// //                 ElevatedButton(
// //                   onPressed: () async {
// //                     if (customerNameController.text.isNotEmpty) {
// //                       if (selectedCustomerType == "عادي") {
// //                         await fetchnormalCustomerDetails(customerNameController.text);
// //                       } else {
// //                         await fetchbusinessCustomerDetails(customerNameController.text);
// //                       }
// //                       await fetchBills();
// //                     }
// //                   },
// //                   child: Text("بحث عن الفواتير"),
// //                 ),
// //               ],
// //
// //               // ✅ Customer Details Section
// //               SizedBox(height: 20),
// //               if (bills.isNotEmpty)
// //                 Center(
// //                   child: Card(
// //                     margin: EdgeInsets.symmetric(vertical: 10),
// //                     child: Padding(
// //                       padding: const EdgeInsets.all(12),
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.center,
// //                         children: customerDetails.entries.map((entry) {
// //                           return Padding(
// //                             padding: const EdgeInsets.symmetric(vertical: 4),
// //                             child: Text('${entry.key}: ${entry.value ?? 'لا يوجد'}'),
// //                           );
// //                         }).toList(),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //
// //               // ✅ Filters and Actions
// //               if (bills.isNotEmpty) ...[
// //                 Row(
// //                   children: [
// //                     Checkbox(
// //                       value: searchByDate,
// //                       onChanged: (value) {
// //                         setState(() => searchByDate = value ?? false);
// //                         _filterBills();
// //                       },
// //                     ),
// //                     Text('تصفية بالتاريخ'),
// //                   ],
// //                 ),
// //                 if (searchByDate) ...[
// //                   SizedBox(height: 10),
// //                   Row(
// //                     children: [
// //                       Expanded(
// //                         child: TextField(
// //                           readOnly: true,
// //                           decoration: InputDecoration(
// //                             labelText: 'تاريخ البداية',
// //                             suffixIcon: Icon(Icons.calendar_today),
// //                           ),
// //                           controller: TextEditingController(
// //                             text: startDate != null ? dateFormat.format(startDate!) : '',
// //                           ),
// //                           onTap: () => _selectStartDate(context),
// //                         ),
// //                       ),
// //                       SizedBox(width: 10),
// //                       Expanded(
// //                         child: TextField(
// //                           readOnly: true,
// //                           decoration: InputDecoration(
// //                             labelText: 'تاريخ النهاية',
// //                             suffixIcon: Icon(Icons.calendar_today),
// //                           ),
// //                           controller: TextEditingController(
// //                             text: endDate != null ? dateFormat.format(endDate!) : '',
// //                           ),
// //                           onTap: () => _selectEndDate(context),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //                 SizedBox(height: 20),
// //                 Row(
// //                   children: [
// //                     ElevatedButton.icon(
// //                       icon: Icon(Icons.payment),
// //                       label: Text("إضافة دفعة للكل"),
// //                       onPressed: () async {
// //                         bool result = await showPaymentDialog(context, customerNameController.text);
// //                         if (result) fetchBills();
// //                       },
// //                     ),
// //                     SizedBox(width: 10),
// //                     ElevatedButton.icon(
// //                       icon: Icon(Icons.picture_as_pdf),
// //                       label: Text("PDF"),
// //                       onPressed: () {
// //                         generateBillsPDF(context, filteredBills, startDate, endDate, customerNameController.text.trim(), searchByDate);
// //                       },
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //
// //               // ✅ Summary
// //               SizedBox(height: 20),
// //               if (bills.isNotEmpty) ...[
// //                 Text('اجمالي الفواتير: ${filteredBills.fold(0.0, (sum, bill) => sum + bill.total_price).toStringAsFixed(2)}'),
// //                 Text('اجمالي المدفوعات: ${filteredBills.fold(0.0, (sum, bill) => sum + bill.payment).toStringAsFixed(2)}'),
// //                 Text('المتبقي: ${(filteredBills.fold(0.0, (sum, bill) => sum + bill.total_price) - filteredBills.fold(0.0, (sum, bill) => sum + bill.payment)).toStringAsFixed(2)}'),
// //               ],
// //
// //               // ✅ Bills List
// //               SizedBox(height: 20),
// //               if (bills.isNotEmpty)
// //                 ListView.builder(
// //                   shrinkWrap: true,
// //                   physics: NeverScrollableScrollPhysics(),
// //                   itemCount: filteredBills.length,
// //                   itemBuilder: (context, index) {
// //                     final bill = filteredBills[index];
// //                     return Card(
// //                       child: ListTile(
// //                         title: Text('فاتورة #${bill.id} - ${bill.customerName}'),
// //                         subtitle: Text('التاريخ: ${dateFormat.format(bill.date)} | اجمالي: ${bill.total_price} | مدفوع: ${bill.payment}'),
// //                         trailing: ElevatedButton(
// //                           child: Text("عرض"),
// //                           onPressed: () => showBillDetailsDialog(context, bill),
// //                         ),
// //                         onTap: () async {
// //                           bool result = await showAddPaymentDialog(
// //                             context,
// //                             bill.id,
// //                             bill.payment,
// //                             bill.customerName,
// //                             bill.date,
// //                             bill.total_price,
// //                           );
// //                           if (result) fetchBills();
// //                         },
// //                       ),
// //                     );
// //                   },
// //                 ),
// //
// //               if (bills.isEmpty)
// //                 Center(child: Text("لا توجد فواتير")),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// // }
// //
// // Future<void> showBillDetailsDialog(BuildContext context, Bill bill) async {
// //   showDialog(
// //     context: context,
// //     builder: (context) {
// //       return BillDetailsDialog(bill: bill);
// //     },
// //   );
// // }
//
//
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:system/features/billes/data/models/bill_model.dart';
// import 'package:system/features/billes/data/repositories/bill_repository.dart';
// import 'package:system/features/billes/presentation/Dialog/adding/bill/AddbillPaymentPage.dart';
// import 'package:system/features/billes/presentation/Dialog/details-editing-pdf/bill/showBillDetailsDialog.dart';
// import 'package:system/features/report/UI/customer/pdf.dart';
//
// class CustomerSelectionPageMobile extends StatefulWidget {
//   @override
//   _CustomerSelectionPageMobileState createState() => _CustomerSelectionPageMobileState();
// }
//
// class _CustomerSelectionPageMobileState extends State<CustomerSelectionPageMobile> {
//   final SupabaseClient _client = Supabase.instance.client;
//   String? selectedCustomerType;
//   List<String> customerNames = [];
//   final customerNameController = TextEditingController();
//   final NameController = TextEditingController();
//   List<Bill> bills = [];
//   Map<String, String> customerDetails = {};
//   final BillRepository billRepository = BillRepository();
//   final dateFormat = DateFormat('dd/MM/yyyy');
//   List<Bill> allBills = [];
//   List<Bill> filteredBills = [];
//   DateTime? startDate;
//   DateTime? endDate;
//   bool searchByDate = false;
//   bool isLoading = false;
//   bool showCustomerDetails = false;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   Future<List<Bill>> getBills(String customerName) async {
//     try {
//       setState(() => isLoading = true);
//       final response = await _client
//           .from('bills')
//           .select('*, bill_items(*)')
//           .eq('customer_name', customerName);
//
//       final List<dynamic> data = response as List<dynamic>;
//       List<Bill> fetchedBills = data
//           .map((json) => Bill.fromJson(json as Map<String, dynamic>))
//           .toList();
//
//       setState(() {
//         bills = fetchedBills;
//         filteredBills = fetchedBills;
//       });
//       return fetchedBills;
//     } catch (e) {
//       print('Error fetching bills: $e');
//       return [];
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }
//
//   Future<void> fetchNormalCustomerNames() async {
//     try {
//       setState(() => isLoading = true);
//       final response = await _client.from('normal_customers').select('name');
//       final List<dynamic> data = response;
//       setState(() {
//         customerNames = data.map((customer) => customer['name'] as String).toList();
//       });
//     } catch (e) {
//       print('Error fetching normal customer names: $e');
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }
//
//   Future<void> fetchBusinessCustomerNames() async {
//     try {
//       setState(() => isLoading = true);
//       final response = await _client.from('business_customers').select('*');
//       final List<dynamic> data = response;
//       setState(() {
//         customerNames = data.map((customer) => customer['name'] as String).toList();
//       });
//     } catch (e) {
//       print('Error fetching business customer names: $e');
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }
//
//   Future<void> fetchBills() async {
//     if (customerNameController.text.isEmpty) return;
//     try {
//       setState(() => isLoading = true);
//       List<Bill> fetchedBills = await getBills(customerNameController.text);
//       setState(() {
//         bills = fetchedBills;
//         filteredBills = fetchedBills;
//       });
//     } catch (e) {
//       print('Error fetching bills: $e');
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }
//
//   void _selectDate(BuildContext context, bool isStartDate) async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//
//     if (pickedDate != null) {
//       setState(() {
//         if (isStartDate) startDate = pickedDate;
//         else endDate = pickedDate;
//         _filterBills();
//       });
//     }
//   }
//
//   void _filterBills() {
//     setState(() {
//       filteredBills = bills.where((bill) {
//         if (startDate != null && bill.date.isBefore(startDate!)) return false;
//         if (endDate != null && bill.date.isAfter(endDate!)) return false;
//         return true;
//       }).toList();
//     });
//   }
//
//   // ... (other methods like _updateBillStatus, showAddPaymentDialog, etc.)
//
//   @override
//   void dispose() {
//     customerNameController.dispose();
//     super.dispose();
//   }
//
//   Widget _buildCustomerTypeSelector() {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("نوع العميل", style: TextStyle(fontWeight: FontWeight.bold)),
//             SizedBox(height: 8),
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
//                   showCustomerDetails = false;
//                   if (value == "عادي") {
//                     fetchNormalCustomerNames();
//                   } else {
//                     fetchBusinessCustomerNames();
//                   }
//                 });
//               },
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCustomerNameSelector() {
//     if (selectedCustomerType == null) return SizedBox.shrink();
//
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("اسم العميل", style: TextStyle(fontWeight: FontWeight.bold)),
//             SizedBox(height: 8),
//             Autocomplete<String>(
//               optionsBuilder: (TextEditingValue textEditingValue) {
//                 if (textEditingValue.text.isEmpty) return const Iterable<String>.empty();
//                 return customerNames.where((name) =>
//                     name.toLowerCase().contains(textEditingValue.text.toLowerCase())
//                 );
//               },
//               onSelected: (String selection) {
//                 setState(() => customerNameController.text = selection);
//               },
//               fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
//                 return TextField(
//                   controller: textEditingController,
//                   focusNode: focusNode,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                     hintText: "اكتب اسم العميل...",
//                     contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//                     suffixIcon: Icon(Icons.search),
//                   ),
//                 );
//               },
//               optionsViewBuilder: (context, onSelected, options) {
//                 return Align(
//                   alignment: Alignment.topLeft,
//                   child: Material(
//                     elevation: 4,
//                     child: ConstrainedBox(
//                       constraints: BoxConstraints(maxHeight: 200),
//                       child: ListView.builder(
//                         padding: EdgeInsets.zero,
//                         itemCount: options.length,
//                         itemBuilder: (context, index) {
//                           final option = options.elementAt(index);
//                           return ListTile(
//                             title: Text(option),
//                             onTap: () => onSelected(option),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//             SizedBox(height: 12),
//             ElevatedButton.icon(
//               onPressed: () async {
//                 if (customerNameController.text.isNotEmpty) {
//                   if (selectedCustomerType == "عادي") {
//                     // await fetchnormalCustomerDetails(customerNameController.text);
//                   } else {
//                     // await fetchbusinessCustomerDetails(customerNameController.text);
//                   }
//                   await fetchBills();
//                   setState(() => showCustomerDetails = true);
//                 }
//               },
//               icon: Icon(Icons.search),
//               label: Text("بحث عن الفواتير"),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: Size(double.infinity, 50),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDateFilterSection() {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Checkbox(
//                   value: searchByDate,
//                   onChanged: (bool? value) {
//                     setState(() => searchByDate = value ?? false);
//                   },
//                 ),
//                 Text('تصفية حسب التاريخ'),
//               ],
//             ),
//
//             if (searchByDate) ...[
//               SizedBox(height: 12),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('تاريخ البداية'),
//                         SizedBox(height: 4),
//                         OutlinedButton(
//                           onPressed: () => _selectDate(context, true),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(startDate != null ? dateFormat.format(startDate!) : 'اختيار تاريخ'),
//                               Icon(Icons.calendar_today, size: 18),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('تاريخ النهاية'),
//                         SizedBox(height: 4),
//                         OutlinedButton(
//                           onPressed: () => _selectDate(context, false),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(endDate != null ? dateFormat.format(endDate!) : 'اختيار تاريخ'),
//                               Icon(Icons.calendar_today, size: 18),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ]
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildActionButtons() {
//     return Row(
//       children: [
//         Expanded(
//           child: ElevatedButton.icon(
//             onPressed: () async {
//               // bool result = await showPaymentDialog(context, customerNameController.text);
//               // if (result) fetchBills();
//             },
//             icon: Icon(Icons.payment),
//             label: Text("دفعة للكل"),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green,
//               foregroundColor: Colors.white,
//             ),
//           ),
//         ),
//         SizedBox(width: 8),
//         Expanded(
//           child: ElevatedButton.icon(
//             onPressed: () {
//               // generateBillsPDF(context, filteredBills, startDate, endDate, customerNameController.text.trim(), searchByDate);
//             },
//             icon: Icon(Icons.picture_as_pdf),
//             label: Text("PDF"),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               foregroundColor: Colors.white,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSummaryCards() {
//     final totalPrice = filteredBills.fold(0.0, (sum, bill) => sum + bill.total_price);
//     final totalPayment = filteredBills.fold(0.0, (sum, bill) => sum + bill.payment);
//     final remaining = totalPrice - totalPayment;
//
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('إجمالي الفواتير:', style: TextStyle(fontWeight: FontWeight.bold)),
//                 Text(totalPrice.toStringAsFixed(2), style: TextStyle(fontWeight: FontWeight.bold)),
//               ],
//             ),
//             SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('إجمالي المدفوعات:', style: TextStyle(fontWeight: FontWeight.bold)),
//                 Text(totalPayment.toStringAsFixed(2), style: TextStyle(color: Colors.green)),
//               ],
//             ),
//             SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('المبلغ المتبقي:', style: TextStyle(fontWeight: FontWeight.bold)),
//                 Text(remaining.toStringAsFixed(2), style: TextStyle(color: remaining > 0 ? Colors.red : Colors.green)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCustomerDetails() {
//     if (!showCustomerDetails || customerDetails.isEmpty) return SizedBox.shrink();
//
//     return Card(
//       elevation: 2,
//       child: ExpansionTile(
//         title: Text('تفاصيل العميل', style: TextStyle(fontWeight: FontWeight.bold)),
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: selectedCustomerType == "عادي"
//                   ? [
//                 _buildDetailRow('الاسم:', customerDetails['name'] ?? 'لا يوجد'),
//                 _buildDetailRow('الإيميل:', customerDetails['email'] ?? 'لا يوجد'),
//                 _buildDetailRow('رقم الهاتف:', customerDetails['phonecall'] ?? 'لا يوجد'),
//                 _buildDetailRow('رقم الواتس:', customerDetails['phone'] ?? 'لا يوجد'),
//                 _buildDetailRow('العنوان:', customerDetails['address'] ?? 'لا يوجد'),
//               ]
//                   : [
//                 _buildDetailRow('اسم الشركة:', customerDetails['name'] ?? 'لا يوجد'),
//                 _buildDetailRow('اسم المسؤول:', customerDetails['personName'] ?? 'لا يوجد'),
//                 _buildDetailRow('الإيميل:', customerDetails['email'] ?? 'لا يوجد'),
//                 _buildDetailRow('هاتف الشركة:', customerDetails['phone'] ?? 'لا يوجد'),
//                 _buildDetailRow('هاتف المسؤول:', customerDetails['personphonecall'] ?? 'لا يوجد'),
//                 _buildDetailRow('واتس المسؤول:', customerDetails['personPhone'] ?? 'لا يوجد'),
//                 _buildDetailRow('العنوان:', customerDetails['address'] ?? 'لا يوجد'),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
//           SizedBox(width: 8),
//           Expanded(child: Text(value)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBillItem(Bill bill) {
//     return Card(
//       elevation: 2,
//       margin: EdgeInsets.symmetric(vertical: 4),
//       child: ExpansionTile(
//         title: Text('فاتورة #${bill.id}', style: TextStyle(fontWeight: FontWeight.bold)),
//         subtitle: Text(dateFormat.format(bill.date)),
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildDetailRow('العميل:', bill.customerName),
//                 _buildDetailRow('التاريخ:', dateFormat.format(bill.date)),
//                 _buildDetailRow('الحالة:', bill.status),
//                 _buildDetailRow('إجمالي الفاتورة:', bill.total_price.toString()),
//                 _buildDetailRow('المدفوعات:', bill.payment.toString()),
//                 SizedBox(height: 12),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton.icon(
//                         onPressed: () => showBillDetailsDialog(context, bill),
//                         icon: Icon(Icons.visibility),
//                         label: Text("عرض"),
//                       ),
//                     ),
//                     SizedBox(width: 8),
//                     Expanded(
//                       child: ElevatedButton.icon(
//                         onPressed: () async {
//                           // bool result = await showAddPaymentDialog(...);
//                           // if (result) fetchBills();
//                         },
//                         icon: Icon(Icons.payment),
//                         label: Text("دفعة"),
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("كشف حساب عميل"),
//         centerTitle: true,
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Padding(
//         padding: const EdgeInsets.all(12),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               _buildCustomerTypeSelector(),
//               SizedBox(height: 12),
//               _buildCustomerNameSelector(),
//               SizedBox(height: 12),
//               _buildDateFilterSection(),
//               SizedBox(height: 12),
//               _buildActionButtons(),
//               SizedBox(height: 12),
//               _buildSummaryCards(),
//               SizedBox(height: 12),
//               _buildCustomerDetails(),
//               SizedBox(height: 12),
//
//               if (filteredBills.isNotEmpty)
//                 ...filteredBills.map((bill) => _buildBillItem(bill)).toList()
//               else if (customerNameController.text.isNotEmpty)
//                 Center(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 24),
//                     child: Column(
//                       children: [
//                         Icon(Icons.receipt_long, size: 48, color: Colors.grey),
//                         SizedBox(height: 16),
//                         Text('لا توجد فواتير', style: TextStyle(fontSize: 16)),
//                       ],
//                     ),
//                   ),
//                 )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // Keep your existing showBillDetailsDialog method
//
// // Future<void> _showBillDetailsDialog(BuildContext context, Bill bill) async {
// //   showDialog(
// //     context: context,
// //     builder: (context) {
// //       return BillDetailsDialog(bill: bill);
// //     },
// //   );
// // }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/billes/data/repositories/bill_repository.dart';
import 'package:system/features/billes/presentation/Dialog/adding/bill/AddbillPaymentPage.dart';
import 'package:system/features/billes/presentation/Dialog/details-editing-pdf/bill/showBillDetailsDialog.dart';
import 'package:system/features/report/UI/customer/pdf.dart';

import '../../../features/customer/presentation/widgets/totalPaymentDialog.dart';

class CustomerSelectionPageMobile extends StatefulWidget {
  @override
  _CustomerSelectionPageMobileState createState() => _CustomerSelectionPageMobileState();
}

class _CustomerSelectionPageMobileState extends State<CustomerSelectionPageMobile> {
  final SupabaseClient _client = Supabase.instance.client;
  String? selectedCustomerType;
  List<String> customerNames = [];
  final customerNameController = TextEditingController();
  List<Bill> bills = [];
  Map<String, String> customerDetails = {};
  final dateFormat = DateFormat('dd/MM/yyyy');
  List<Bill> filteredBills = [];
  DateTime? startDate;
  DateTime? endDate;
  bool searchByDate = false;
  bool isLoading = false;
  bool showCustomerDetails = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  Future<List<Bill>> getBills(String customerName) async {
    try {
      setState(() => isLoading = true);
      final response = await _client
          .from('bills')
          .select('*, bill_items(*)')
          .eq('customer_name', customerName);

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => Bill.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error fetching bills: $e');
      return [];
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchCustomerNames() async {
    try {
      setState(() => isLoading = true);
      final table = selectedCustomerType == "عادي"
          ? 'normal_customers'
          : 'business_customers';

      final response = await _client.from(table).select('name');
      final List<dynamic> data = response;
      setState(() {
        customerNames = data.map((customer) => customer['name'] as String).toList();
      });
    } catch (e) {
      print('Error fetching customer names: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchCustomerDetails() async {
    if (customerNameController.text.isEmpty) return;

    try {
      setState(() => isLoading = true);
      final table = selectedCustomerType == "عادي"
          ? 'normal_customers'
          : 'business_customers';

      final response = await _client
          .from(table)
          .select('*')
          .eq('name', customerNameController.text)
          .single();

      setState(() {
        customerDetails = Map<String, String>.from(response);
        showCustomerDetails = true;
      });
    } catch (e) {
      print('Error fetching customer details: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchBills() async {
    if (customerNameController.text.isEmpty) return;

    try {
      setState(() => isLoading = true);
      final fetchedBills = await getBills(customerNameController.text);
      setState(() {
        bills = fetchedBills;
        filteredBills = fetchedBills;
      });
    } catch (e) {
      print('Error fetching bills: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _selectDate(BuildContext context, bool isStartDate) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) startDate = pickedDate;
        else endDate = pickedDate;
        _filterBills();
      });
    }
  }

  void _filterBills() {
    setState(() {
      filteredBills = bills.where((bill) {
        if (searchByDate) {
          if (startDate != null && bill.date.isBefore(startDate!)) return false;
          if (endDate != null && bill.date.isAfter(endDate!)) return false;
        }
        return true;
      }).toList();
    });
  }

  @override
  void dispose() {
    customerNameController.dispose();
    super.dispose();
  }

  Widget _buildCustomerTypeSelector() {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("نوع العميل", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedCustomerType,
              items: ["عادي", "تجاري"].map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCustomerType = value;
                  customerNames = [];
                  customerNameController.clear();
                  showCustomerDetails = false;
                  fetchCustomerNames();
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                hintText: "اختر نوع العميل",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerNameSelector() {
    if (selectedCustomerType == null) return SizedBox.shrink();

    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("اسم العميل", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Autocomplete<String>(
              optionsBuilder: (textEditingValue) {
                if (textEditingValue.text.isEmpty) return const Iterable<String>.empty();
                return customerNames.where((name) =>
                    name.toLowerCase().contains(textEditingValue.text.toLowerCase())
                );
              },
              onSelected: (selection) => setState(() => customerNameController.text = selection),
              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "ابحث باسم العميل...",
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    suffixIcon: Icon(Icons.search),
                  ),
                );
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 200),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(options.elementAt(index)),
                            onTap: () => onSelected(options.elementAt(index)),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                if (customerNameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("الرجاء إدخال اسم العميل")),
                  );
                  return;
                }
                await Future.wait([fetchCustomerDetails(), fetchBills()]);
              },
              icon: Icon(Icons.search),
              label: Text("بحث عن الفواتير"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateFilterSection() {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: searchByDate,
                  onChanged: (value) => setState(() => searchByDate = value ?? false),
                ),
                Text('تصفية حسب التاريخ', style: TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),

            if (searchByDate) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('تاريخ البداية'),
                        const SizedBox(height: 4),
                        OutlinedButton(
                          onPressed: () => _selectDate(context, true),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                startDate != null
                                    ? dateFormat.format(startDate!)
                                    : 'اختيار تاريخ',
                                style: TextStyle(fontSize: 16),
                              ),
                              Icon(Icons.calendar_today, size: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('تاريخ النهاية'),
                        const SizedBox(height: 4),
                        OutlinedButton(
                          onPressed: () => _selectDate(context, false),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                endDate != null
                                    ? dateFormat.format(endDate!)
                                    : 'اختيار تاريخ',
                                style: TextStyle(fontSize: 16),
                              ),
                              Icon(Icons.calendar_today, size: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _handlePaymentAction(),
                    icon: Icon(Icons.payment),
                    label: Text("دفعة للكل"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _generatePdf(),
                    icon: Icon(Icons.picture_as_pdf),
                    label: Text("PDF"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handlePaymentAction() async {
    if (customerNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("الرجاء إدخال اسم العميل أولاً")),
      );
      return;
    }
    if (filteredBills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("لا توجد فواتير لعمل دفعة")),
      );
      return;
    }

    bool result = await showPaymentDialog(
        context, customerNameController.text);

    if (result) {
      await fetchBills(); // جلب الفواتير بعد نجاح الدفع
      setState(() {}); // تحديث الواجهة
    }
  }

  Future<bool> showPaymentDialog(
      BuildContext context, String customerName) async {
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
    ) ??
        false;
  }

  Future<void> _updateBillStatus(
      int billId, double totalPrice, double newPayment) async {
    try {
      // Fetch all payments for the given bill
      final payments = await Supabase.instance.client
          .from('payment')
          .select('payment')
          .eq('bill_id', billId);

      // Calculate the total payment amount
      double totalPayment = payments
          .fold<double>(
        0.0,
            (sum, payment) => sum + (payment['payment'] ?? 0.0),
      )
          ;

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
      await Supabase.instance.client.from('bills').update({
        'payment': newPayment, // ✅ تحديث إجمالي المدفوعات
        'status': status, // ✅ تحديث الحالة
      }).eq('id', billId);

      setState(() async {
        await fetchBills();
      });
      await fetchBills();
      debugPrint(
          'Bill $billId updated: Payment = $newPayment, Status = $status');
    } catch (error) {
      debugPrint('Failed to update bill status: $error');
    }
  }

  void _generatePdf() {
    if (customerNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("الرجاء إدخال اسم العميل أولاً")),
      );
      return;
    }
    if (filteredBills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("لا توجد فواتير لاستخراج PDF")),
      );
      return;
    }
    // Implement PDF generation
    generateBillsPDF(context, filteredBills, startDate, endDate, customerNameController.text.trim(), searchByDate);
  }

  Widget _buildSummaryCards() {
    final totalPrice = filteredBills.fold(0.0, (sum, bill) => sum + bill.total_price);
    final totalPayment = filteredBills.fold(0.0, (sum, bill) => sum + bill.payment);
    final remaining = totalPrice - totalPayment;

    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSummaryRow('إجمالي الفواتير:', totalPrice.toStringAsFixed(2)),
            const SizedBox(height: 12),
            _buildSummaryRow('إجمالي المدفوعات:', totalPayment.toStringAsFixed(2), color: Colors.green),
            const SizedBox(height: 12),
            _buildSummaryRow(
                'المبلغ المتبقي:',
                remaining.toStringAsFixed(2),
                color: remaining > 0 ? Colors.red : Colors.green
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
        Text(value, style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color
        )),
      ],
    );
  }

  Widget _buildCustomerDetails() {
    if (!showCustomerDetails || customerDetails.isEmpty) return SizedBox.shrink();

    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text('تفاصيل العميل', style: TextStyle(fontWeight: FontWeight.bold)),
        initiallyExpanded: true,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: selectedCustomerType == "عادي"
                  ? [
                _buildDetailRow('الاسم:', customerDetails['name']),
                _buildDetailRow('الإيميل:', customerDetails['email']),
                _buildDetailRow('رقم الهاتف:', customerDetails['phonecall']),
                _buildDetailRow('رقم الواتس:', customerDetails['phone']),
                _buildDetailRow('العنوان:', customerDetails['address']),
              ]
                  : [
                _buildDetailRow('اسم الشركة:', customerDetails['name']),
                _buildDetailRow('اسم المسؤول:', customerDetails['personName']),
                _buildDetailRow('الإيميل:', customerDetails['email']),
                _buildDetailRow('هاتف الشركة:', customerDetails['phone']),
                _buildDetailRow('هاتف المسؤول:', customerDetails['personphonecall']),
                _buildDetailRow('واتس المسؤول:', customerDetails['personPhone']),
                _buildDetailRow('العنوان:', customerDetails['address']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value ?? 'لا يوجد', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildBillItem(Bill bill) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text('فاتورة #${bill.id}', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(dateFormat.format(bill.date)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('العميل:', bill.customerName),
                _buildDetailRow('التاريخ:', dateFormat.format(bill.date)),
                _buildDetailRow('الحالة:', bill.status),
                _buildDetailRow('إجمالي الفاتورة:', bill.total_price.toString()),
                _buildDetailRow('المدفوعات:', bill.payment.toString()),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => showBillDetailsDialog(context, bill),
                        icon: Icon(Icons.visibility),
                        label: Text("عرض"),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _handleBillPayment(bill),
                        icon: Icon(Icons.payment),
                        label: Text("دفعة مبلغ"),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
  void _handleBillPayment(Bill bill) async {
    bool result = await showAddPaymentDialog(
        context,
        bill.id,
        bill.payment,
        bill.customerName,
        bill.date,
        bill.total_price);

    if (result) {
      await fetchBills(); // جلب الفواتير بعد الدفع فقط إذا نجح
      setState(() {});
    }
  }

  Future<bool> showAddPaymentDialog(
      BuildContext context,
      int billId,
      double payment,
      String customerName,
      DateTime billDate,
      double total_price,
      ) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AddPaymentDialog(
          billId: billId,
          payment: payment,
          customerName: customerName,
          billDate: billDate,
          total_price: total_price,
        );
      },
    ) ??
        false;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 20),
            Text(
              'لا توجد فواتير',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            if (customerNameController.text.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'الرجاء البحث عن عميل لعرض فواتيره',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("كشف حساب عميل"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildCustomerTypeSelector(),
                _buildCustomerNameSelector(),
                _buildDateFilterSection(),
                _buildActionButtons(),
                _buildSummaryCards(),
                _buildCustomerDetails(),

                if (filteredBills.isNotEmpty)
                  ...filteredBills.map((bill) => _buildBillItem(bill)).toList()
                else
                  _buildEmptyState()
              ],
            ),
          ),
        ),
      ),
    );
  }
}