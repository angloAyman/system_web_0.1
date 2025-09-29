// //
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
// //
// // class CustomerSelectionPage2 extends StatefulWidget {
// //   @override
// //   _CustomerSelectionPage2State createState() => _CustomerSelectionPage2State();
// // }
// //
// // class _CustomerSelectionPage2State extends State<CustomerSelectionPage2> {
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
// //
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
// //
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
// //   Future<void> _updateBillStatus(int billId, int totalPrice, int newPayment) async {
// //     try {
// //       // Fetch all payments for the given bill
// //       final payments = await Supabase.instance.client
// //           .from('payment')
// //           .select('payment')
// //           .eq('bill_id', billId);
// //
// //       // Calculate the total payment amount
// //       final totalPayment = payments.fold<double>(
// //         0,
// //         (sum, payment) => sum + (payment['payment'] ?? 0),
// //       );
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
// //       await Supabase.instance.client
// //           .from('bills')
// //           .update({
// //         'payment': newPayment, // ✅ تحديث إجمالي المدفوعات
// //         'status': status, // ✅ تحديث الحالة
// //       })
// //           .eq('id', billId);
// //
// //       debugPrint('Bill $billId updated: Payment = $newPayment, Status = $status');
// //     } catch (error) {
// //       debugPrint('Failed to update bill status: $error');
// //     }
// //   }
//
// //
// //   Future<bool> showPaymentDialog(BuildContext context, String customerName) async {
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
// //     ) ?? false;
// //   }
// //
// //   Future<void> fetchnormalCustomerDetails(String customerName) async {
// //     try {
// //       // Fetch customer details based on the selected customer name
// //       final response = await _client
// //           .from(
// //               'normal_customers') // Assuming you're fetching from the 'normal_customers' table
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
// //       appBar: AppBar(
// //           title: Text("كشف حساب عميل"),
// //         actions: [
// //           TextButton.icon(onPressed: (){
// //             Navigator.pushReplacementNamed(context, '/userMainScreen2'); // توجيه المستخدم إلى صفحة تسجيل الدخول
// //           }, label: Icon(Icons.home,size: 25,)),
// //         ],
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Row(
// //               children: [
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       // Customer Type Dropdown
// //                       Text("اختار نوع العميل",
// //                           style: TextStyle(
// //                               fontSize: 16, fontWeight: FontWeight.bold)),
// //                       SizedBox(height: 10),
// //                       Container(
// //                         width: 400,
// //                         child: DropdownButtonFormField<String>(
// //                           value: selectedCustomerType,
// //                           items: ["عادي"].map((String type) {
// //                             return DropdownMenuItem<String>(
// //                               value: type,
// //                               child: Text(type),
// //                             );
// //                           }).toList(),
// //                           onChanged: (value) {
// //                             setState(() async {
// //                               selectedCustomerType = value;
// //                               customerNames = [];
// //                               customerNameController.clear();
// //                               if (value == "عادي") {
// //                                 fetchNormalCustomerNames();
// //                                 await fetchnormalCustomerDetails(
// //                                     customerNameController.text);
// //                               }
// //                             });
// //                           },
// //                           decoration: InputDecoration(
// //                             border: OutlineInputBorder(),
// //                             contentPadding:
// //                                 EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //                           ),
// //                         ),
// //                       ),
// //
// //                       SizedBox(height: 20),
// //                       if (selectedCustomerType != null)
// //                         Container(
// //                           width: 400,
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               Text("اسم العميل",
// //                                   style: TextStyle(
// //                                       fontSize: 16, fontWeight: FontWeight.bold)),
// //                               SizedBox(height: 10),
// //                               Autocomplete<String>(
// //                                 optionsBuilder:
// //                                     (TextEditingValue textEditingValue) {
// //                                   if (textEditingValue.text.isEmpty) {
// //                                     return const Iterable<String>.empty();
// //                                   }
// //                                   return customerNames.where((name) {
// //                                     return name.toLowerCase().contains(
// //                                         textEditingValue.text.toLowerCase());
// //                                   });
// //                                 },
// //                                 onSelected: (String selection) {
// //                                   setState(() {
// //                                     customerNameController.text = selection;
// //                                   });
// //                                 },
// //                                 fieldViewBuilder: (context, textEditingController,
// //                                     focusNode, onFieldSubmitted) {
// //                                   return TextField(
// //                                     controller: textEditingController,
// //                                     focusNode: focusNode,
// //                                     decoration: InputDecoration(
// //                                       border: OutlineInputBorder(),
// //                                       hintText: "اكتب اسم العميل...",
// //                                       contentPadding: EdgeInsets.symmetric(
// //                                           horizontal: 12, vertical: 8),
// //                                     ),
// //                                   );
// //                                 },
// //                                 optionsViewBuilder:
// //                                     (context, onSelected, options) {
// //                                   return Material(
// //                                     child: ListView.builder(
// //                                       padding: EdgeInsets.zero,
// //                                       itemCount: options.length,
// //                                       itemBuilder: (context, index) {
// //                                         final option = options.elementAt(index);
// //                                         return ListTile(
// //                                           title: Text(option),
// //                                           onTap: () => onSelected(option),
// //                                         );
// //                                       },
// //                                     ),
// //                                   );
// //                                 },
// //                               ),
// //                               SizedBox(height: 20),
// //                               ElevatedButton(
// //                                 onPressed: () async {
// //                                   if (customerNameController.text.isNotEmpty) {
// //                                     if (selectedCustomerType == "عادي") {
// //                                       await fetchnormalCustomerDetails(
// //                                           customerNameController.text);
// //                                     }
// //
// //                                     await fetchBills();
// //                                   }
// //                                 },
// //                                 child: Text("بحث عن الفواتير"),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       // ✅ Checkbox for Date Filtering
// //                       Column(
// //                         children: [
// //                           Row(
// //                             children: [
// //                               Checkbox(
// //                                 value: searchByDate,
// //                                 onChanged: (bool? value) {
// //                                   setState(() {
// //                                     searchByDate = value ?? false;
// //                                     _filterBills();
// //                                   });
// //                                 },
// //                               ),
// //                               Text('تصفية حسب التاريخ'),
// //                               SizedBox(
// //                                 width: 8,
// //                               ),
// //                               TextButton(
// //                                 child: Row(
// //                                   children: [
// //                                     Icon(Icons.payment, color: Colors.green),
// //                                     SizedBox(
// //                                       width: 8,
// //                                     ),
// //                                     Text("إدخال دفعة للكل مرة واحدة"),
// //                                   ],
// //                                 ),
// //                                 onPressed: () async {
// //                                   bool result = await showPaymentDialog(context, customerNameController.text);
// //                                   await fetchBills();
// //                                   await fetchBills();
// //
// //                                 },
// //                               ),
// //                             ],
// //                           ),
// //                           SizedBox(
// //                             width: 5,
// //                           ),
// //                           Text(
// //                             'اجمالي الفواتير : ${filteredBills.fold(0.0, (sum, bill) => sum + bill.total_price).toStringAsFixed(2)}',
// //                             style: TextStyle(
// //                                 fontSize: 18, fontWeight: FontWeight.bold,
// //                               color: Colors.blue,
// //                             ),
// //                           ),
// //                           Text(
// //                             'اجمالي المدفوعات: ${filteredBills.fold(0.0, (sum, bill) => sum + bill.payment).toStringAsFixed(2)}',
// //                             style: TextStyle(
// //                                 fontSize: 18, fontWeight: FontWeight.bold,color: Colors.blue, ),
// //                           ),
// //                           Text(
// //                             'المبلغ المتبقي: ${(filteredBills.fold(0.0, (sum, bill) => sum + bill.total_price) - filteredBills.fold(0.0, (sum, bill) => sum + bill.payment)).toStringAsFixed(2)}',
// //                             style: TextStyle(
// //                               fontSize: 18,
// //                               fontWeight: FontWeight.bold,
// //                               color: Colors.blue, // يمكنك تغيير اللون لجذب الانتباه
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //
// //                 if (bills.isNotEmpty && selectedCustomerType == "عادي")
// //                   Padding(
// //                     padding: const EdgeInsets.fromLTRB(90,0,0,0),
// //                     child: Container(
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(" تفاصيل العميل",
// //                               style: TextStyle(
// //                                   fontSize: 25, fontWeight: FontWeight.bold)),
// //                           SizedBox(
// //                             height: 20,
// //                           ),
// //                           Text(
// //                               'اسم العميل: ${customerDetails['name'] ?? 'لا يوجد'}',
// //                               style: TextStyle(fontSize: 16)),
// //                           SizedBox(height: 8),
// //                           Text(
// //                               'الايميل: ${customerDetails['email'] ?? 'لا يوجد'}',
// //                               style: TextStyle(fontSize: 16)),
// //                           SizedBox(height: 8),
// //                           Text(
// //                               'رقم الهاتف: ${customerDetails['phonecall'] ?? 'لا يوجد'}',
// //                               style: TextStyle(fontSize: 16)),
// //                           SizedBox(height: 8),
// //                           Text(
// //                               'رقم الوتس: ${customerDetails['phone'] ?? 'لا يوجد'}',
// //                               style: TextStyle(fontSize: 16)),
// //                           SizedBox(height: 8),
// //                           Text(
// //                               'العنوان: ${customerDetails['address'] ?? 'لا يوجد'}',
// //                               style: TextStyle(fontSize: 16)),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //
// //               ],
// //             ),
// //             // SizedBox(height: 20),
// //             if (bills.isNotEmpty)
// //               Expanded(
// //                 child: Column(
// //                   children: [
// //                     if (searchByDate == true)
// //                       Row(
// //                         children: [
// //                           Expanded(
// //                             child: TextField(
// //                               readOnly: true,
// //                               decoration: InputDecoration(
// //                                 labelText: 'تاريخ البداية',
// //                                 suffixIcon: Icon(Icons.calendar_today),
// //                               ),
// //                               controller: TextEditingController(
// //                                 text: startDate != null
// //                                     ? dateFormat.format(startDate!)
// //                                     : '',
// //                               ),
// //                               onTap: () => _selectStartDate(context),
// //                             ),
// //                           ),
// //                           SizedBox(width: 16),
// //                           Expanded(
// //                             child: TextField(
// //                               readOnly: true,
// //                               decoration: InputDecoration(
// //                                 labelText: 'تاريخ النهاية',
// //                                 suffixIcon: Icon(Icons.calendar_today),
// //                               ),
// //                               controller: TextEditingController(
// //                                 text: endDate != null
// //                                     ? dateFormat.format(endDate!)
// //                                     : '',
// //                               ),
// //                               onTap: () => _selectEndDate(context),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     SizedBox(height: 20),
// //                     Expanded(
// //                       child: SingleChildScrollView(
// //                         scrollDirection: Axis.vertical,
// //                         child: DataTable(
// //                           columnSpacing: 20, // Improve spacing
// //                           headingTextStyle: TextStyle(
// //                               fontWeight: FontWeight.bold, color: Colors.blue),
// //                           columns: [
// //                             DataColumn(label: Text('رقم الفاتورة')),
// //                             DataColumn(label: Text('اسم العميل')),
// //                             DataColumn(label: Text('التاريخ')),
// //                             DataColumn(label: Text('الحالة')),
// //                             DataColumn(label: Text('اجمالي الفاتورة')),
// //                             DataColumn(label: Text('المدفوعات')),
// //                             DataColumn(label: Text('إجراء')),
// //                           ],
// //                           rows: filteredBills.map((bill) {
// //                             return DataRow(cells: [
// //                               DataCell(Text(bill.id.toString())),
// //                               // ✅ Ensure id is converted to text
// //                               DataCell(Text(bill.customerName)),
// //                               // ✅ Ensure customer name exists
// //                               DataCell(Text(
// //                                 // "${bill.date.day}/${bill.date.month}/${bill.date.year}"
// //                                 bill.date != null
// //                                     ? dateFormat.format(bill.date)
// //                                     : "N/A",
// //                               )),
// //                               // ✅ Proper date formatting
// //                               DataCell(Text(bill.status,
// //                                   style: TextStyle(
// //                                     color: bill.status == 'تم الدفع'
// //                                         ? Colors.green
// //                                         : Colors.red, // ✅ Add color for status
// //                                   ))),
// //                               DataCell(Text(bill.total_price.toString())),
// //                               DataCell(Text(bill.payment.toString())),
// //
// //                               DataCell(
// //                                 Row(
// //                                   children: [
// //                                     //عرض الفاتورة
// //                                     ElevatedButton(
// //                                       onPressed: () {
// //                                         // print("Action on bill ${bill.id}");
// //                                         // TODO: Handle navigation to bill details
// //                                         showBillDetailsDialog(context,
// //                                             bill); // ✅ Navigate to details
// //                                       },
// //                                       child: Text("عرض"),
// //                                     ),
// //                                     //اضافة مدفوات
// //                                     ElevatedButton(
// //                                       onPressed: () {
// //                                         // print("Action on bill ${bill.id}");
// //                                         // TODO: Handle navigation to bill details
// //                                         showAddPaymentDialog(
// //                                             context,
// //                                             bill.id,
// //                                             bill.payment,
// //                                             bill.customerName,
// //                                             bill.date as DateTime,
// //                                             bill.total_price );
// //                                       },
// //                                       child: Text("اضافة مدفوعات"),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //                             ]);
// //                           }).toList(),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //
// //                 // Data Table
// //               ),
// //
// //             if (bills.isEmpty)
// //               Center(
// //                 child: Text("لا يوحد فواتير"),
// //               )
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Future<List<Map<String, dynamic>>> _fetchPayments(int billId) async {
// //     final response = await Supabase.instance.client
// //         .from('payment')
// //         .select('*, users(name)')
// //         .eq('bill_id', billId)
// //         .order('date', ascending: false);
// //
// //     if (response == null) {
// //       throw Exception('Failed to fetch payments.');
// //     }
// //
// //     return List<Map<String, dynamic>>.from(response);
// //   }
// // }
// //
// // void showAddPaymentDialog(
// //   BuildContext context,
// //   int billId,
// //   int payment,
// //   String customerName,
// //   DateTime billDate,
// //   int total_price,
// // ) {
// //   showDialog(
// //     context: context,
// //     builder: (BuildContext context) {
// //       return AddPaymentDialog(
// //         billId: billId,
// //         payment: payment,
// //         customerName: customerName,
// //         billDate: billDate,
// //         total_price: total_price,
// //       );
// //     },
// //   );
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
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// import '../../../../features/billes/data/models/bill_model.dart';
//
// class CustomerAccountStatement extends StatefulWidget {
//   @override
//   _CustomerAccountStatementState createState() => _CustomerAccountStatementState();
// }
//
// class _CustomerAccountStatementState extends State<CustomerAccountStatement> {
//   final SupabaseClient _supabase = Supabase.instance.client;
//   final TextEditingController _customerNameController = TextEditingController();
//   final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
//
//   // State variables
//   List<Bill> _bills = [];
//   Map<String, String> _customerDetails = {};
//   DateTime? _startDate;
//   DateTime? _endDate;
//   bool _searchByDate = false;
//   bool _isLoading = false;
//   List<String> _customerNames = [];
//
//   // Computed properties
//   double get _totalInvoices => _filteredBills.fold(0, (sum, bill) => sum + bill.total_price);
//   double get _totalPayments => _filteredBills.fold(0, (sum, bill) => sum + bill.payment);
//   double get _remainingBalance => _totalInvoices - _totalPayments;
//
//   List<Bill> get _filteredBills {
//     if (!_searchByDate || (_startDate == null && _endDate == null)) {
//       return _bills;
//     }
//     return _bills.where((bill) {
//       if (_startDate != null && bill.date.isBefore(_startDate!)) return false;
//       if (_endDate != null && bill.date.isAfter(_endDate!)) return false;
//       return true;
//     }).toList();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _loadCustomerNames();
//   }
//
//   @override
//   void dispose() {
//     _customerNameController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _loadCustomerNames() async {
//     try {
//       final response = await _supabase.from('normal_customers').select('name');
//       setState(() => _customerNames = List<String>.from(response.map((c) => c['name'])));
//     } catch (e) {
//       _showError('فشل تحميل العملاء: ${e.toString()}');
//     }
//   }
//
//   Future<void> _loadCustomerData() async {
//     if (_customerNameController.text.isEmpty) return;
//
//     setState(() => _isLoading = true);
//     try {
//       await Future.wait([
//         _fetchCustomerDetails(),
//         _fetchCustomerBills(),
//       ]);
//     } catch (e) {
//       _showError('فشل تحميل البيانات: ${e.toString()}');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   Future<void> _fetchCustomerDetails() async {
//     final response = await _supabase
//         .from('normal_customers')
//         .select()
//         .eq('name', _customerNameController.text)
//         .single();
//
//     setState(() {
//       _customerDetails = {
//         'name': response['name'] ?? 'غير معروف',
//         'phone': response['phone'] ?? 'غير متوفر',
//         'address': response['address'] ?? 'غير متوفر',
//       };
//     });
//   }
//
//   Future<void> _fetchCustomerBills() async {
//     final response = await _supabase
//         .from('bills')
//         .select('*, bill_items(*)')
//         .eq('customer_name', _customerNameController.text);
//
//     setState(() {
//       _bills = List<Bill>.from(response.map((json) => Bill.fromJson(json)));
//     });
//   }
//
//   Future<void> _selectDate(BuildContext context, bool isStartDate) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//
//     if (picked != null) {
//       setState(() => isStartDate ? _startDate = picked : _endDate = picked);
//     }
//   }
//
//   void _showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: Colors.red),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('كشف حساب العميل'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.home),
//             onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             _buildCustomerSearchSection(),
//             const SizedBox(height: 20),
//             _buildSummaryCards(),
//             const SizedBox(height: 20),
//             Checkbox(
//                                 value: _searchByDate,
//                                 onChanged: (bool? value) {
//                                   setState(() {
//                                     _searchByDate = value ?? false;
//                                     // _filterBills();
//                                   });
//                                 },
//                               ),
//                               Text('تصفية حسب التاريخ'),
//                               SizedBox(
//                                 width: 8,
//                               ),
//                               // TextButton(
//                               //   child: Row(
//                               //     children: [
//                               //       Icon(Icons.payment, color: Colors.green),
//                               //       SizedBox(
//                               //         width: 8,
//                               //       ),
//                               //       Text("إدخال دفعة للكل مرة واحدة"),
//                               //     ],
//                               //   ),
//                               //   onPressed: () async {
//                               //     bool result = await showPaymentDialog(context, customerNameController.text);
//                               //     await fetchBills();
//                               //     await fetchBills();
//                               //
//                               //   },
//                               // ),
//
//
//             if (_searchByDate) _buildDateFilterSection(),
//             const SizedBox(height: 20),
//             Expanded(child: _buildBillsTable()),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCustomerSearchSection() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Autocomplete<String>(
//               optionsBuilder: (textValue) => _customerNames.where(
//                     (name) => name.toLowerCase().contains(textValue.text.toLowerCase()),
//               ),
//               onSelected: (name) {
//                 _customerNameController.text = name;
//                 _loadCustomerData();
//               },
//               fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
//                 return TextField(
//                   controller: controller,
//                   focusNode: focusNode,
//                   decoration: InputDecoration(
//                     labelText: 'اسم العميل',
//                     suffixIcon: Icon(Icons.search),
//                     border: OutlineInputBorder(),
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 16),
//             if (_customerDetails.isNotEmpty) _buildCustomerInfoSection(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCustomerInfoSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Divider(),
//         const Text('معلومات العميل', style: TextStyle(fontWeight: FontWeight.bold)),
//         _buildInfoRow('الاسم', _customerDetails['name']),
//         _buildInfoRow('الهاتف', _customerDetails['phone']),
//         _buildInfoRow('العنوان', _customerDetails['address']),
//       ],
//     );
//   }
//
//   Widget _buildInfoRow(String label, String? value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
//           Text(value ?? 'غير متوفر'),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSummaryCards() {
//     return Row(
//       children: [
//         _buildSummaryCard('الإجمالي', _totalInvoices, Colors.blue),
//         _buildSummaryCard('المدفوع', _totalPayments, Colors.green),
//         _buildSummaryCard('المتبقي', _remainingBalance,
//             _remainingBalance > 0 ? Colors.orange : Colors.green),
//       ],
//     );
//   }
//
//   Widget _buildSummaryCard(String title, double amount, Color color) {
//     return Expanded(
//       child: Card(
//         color: color.withOpacity(0.1),
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             children: [
//               Text(title, style: const TextStyle(fontSize: 14)),
//               Text(
//                 amount.toStringAsFixed(2),
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: color,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDateFilterSection() {
//     return Row(
//       children: [
//         Expanded(
//           child: TextField(
//             readOnly: true,
//             controller: TextEditingController(
//               text: _startDate != null ? _dateFormat.format(_startDate!) : '',
//             ),
//             decoration: InputDecoration(
//               labelText: 'من تاريخ',
//               suffixIcon: IconButton(
//                 icon: const Icon(Icons.calendar_today),
//                 onPressed: () => _selectDate(context, true),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: TextField(
//             readOnly: true,
//             controller: TextEditingController(
//               text: _endDate != null ? _dateFormat.format(_endDate!) : '',
//             ),
//             decoration: InputDecoration(
//               labelText: 'إلى تاريخ',
//               suffixIcon: IconButton(
//                 icon: const Icon(Icons.calendar_today),
//                 onPressed: () => _selectDate(context, false),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildBillsTable() {
//     if (_bills.isEmpty) {
//       return const Center(child: Text('لا يوجد فواتير'));
//     }
//
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: DataTable(
//         columns: const [
//           DataColumn(label: Text('الفاتورة')),
//           DataColumn(label: Text('التاريخ')),
//           DataColumn(label: Text('الحالة')),
//           DataColumn(label: Text('الإجمالي')),
//           DataColumn(label: Text('المدفوع')),
//           DataColumn(label: Text('الباقي')),
//           DataColumn(label: Text('خيارات')),
//         ],
//         rows: _filteredBills.map((bill) {
//           return DataRow(
//             cells: [
//               DataCell(Text(bill.id.toString())),
//               DataCell(Text(_dateFormat.format(bill.date))),
//               DataCell(
//                 Chip(
//                   label: Text(bill.status),
//                   backgroundColor: _getStatusColor(bill.status),
//                 ),
//               ),
//               DataCell(Text(bill.total_price.toStringAsFixed(2))),
//               DataCell(Text(bill.payment.toStringAsFixed(2))),
//               DataCell(Text((bill.total_price - bill.payment).toStringAsFixed(2))),
//               DataCell(
//                 Row(
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.visibility, color: Colors.blue),
//                       onPressed: () => _showBillDetails(bill),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.payment, color: Colors.green),
//                       onPressed: () => _addPayment(bill),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         }).toList(),
//       ),
//     );
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'تم الدفع': return Colors.green[100]!;
//       case 'آجل': return Colors.orange[100]!;
//       default: return Colors.grey[100]!;
//     }
//   }
//
//   void _showBillDetails(Bill bill) {
//     // Implement bill details dialog
//   }
//
//   void _addPayment(Bill bill) {
//     // Implement payment dialog
//   }
// }
//
// // class Bill {
// //   final int id;
// //   final DateTime date;
// //   final String status;
// //   final double totalPrice;
// //   final double payment;
// //
// //   Bill({
// //     required this.id,
// //     required this.date,
// //     required this.status,
// //     required this.totalPrice,
// //     required this.payment,
// //   });
// //
// //   factory Bill.fromJson(Map<String, dynamic> json) {
// //     return Bill(
// //       id: json['id'] ?? 0,
// //       date: DateTime.parse(json['date']),
// //       status: json['status'] ?? 'غير معروف',
// //       totalPrice: (json['total_price'] ?? 0).toDouble(),
// //       payment: (json['payment'] ?? 0).toDouble(),
// //     );
// //   }
// // }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/billes/presentation/Dialog/adding/bill/AddbillPaymentPage.dart';
import 'package:system/features/billes/presentation/Dialog/details-editing-pdf/bill/showBillDetailsDialog.dart';
import 'package:system/features/customer/presentation/widgets/totalPaymentDialog.dart';

import '../../../../features/billes/data/repositories/bill_repository.dart';
import '../../../../features/report/UI/customer/pdf.dart';

class CustomerAccountStatement extends StatefulWidget {
  @override
  _CustomerAccountStatementState createState() =>
      _CustomerAccountStatementState();
}

class _CustomerAccountStatementState extends State<CustomerAccountStatement> {
  final SupabaseClient _supabase = Supabase.instance.client;
  final TextEditingController _customerNameController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  // State variables
  List<Bill> _bills = [];
  Map<String, String> _customerDetails = {};
  DateTime? _startDate;
  DateTime? _endDate;
  bool _searchByDate = false;
  bool _isLoading = false;
  List<String> _customerNames = [];

  // Computed properties
  double get _totalInvoices =>
      _filteredBills.fold(0, (sum, bill) => sum + bill.total_price);

  double get _totalPayments =>
      _filteredBills.fold(0, (sum, bill) => sum + bill.payment);

  double get _remainingBalance => _totalInvoices - _totalPayments;

  List<Bill> get _filteredBills {
    if (!_searchByDate || (_startDate == null && _endDate == null)) {
      return _bills;
    }
    return _bills.where((bill) {
      if (_startDate != null && bill.date.isBefore(_startDate!)) return false;
      if (_endDate != null && bill.date.isAfter(_endDate!)) return false;
      return true;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadCustomerNames();
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    super.dispose();
  }

  Future<void> _loadCustomerNames() async {
    try {
      final response = await _supabase.from('normal_customers').select('name');
      setState(() =>
          _customerNames = List<String>.from(response.map((c) => c['name'])));
    } catch (e) {
      _showError('فشل تحميل العملاء: ${e.toString()}');
    }
  }

  Future<void> _loadCustomerData() async {
    if (_customerNameController.text.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      await Future.wait([
        _fetchCustomerDetails(),
        _fetchCustomerBills(),
      ]);
    } catch (e) {
      _showError('فشل تحميل البيانات: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchCustomerDetails() async {
    final response = await _supabase
        .from('normal_customers')
        .select()
        .eq('name', _customerNameController.text)
        .single();

    setState(() {
      _customerDetails = {
        'name': response['name'] ?? 'غير معروف',
        'phone': response['phone'] ?? 'غير متوفر',
        'address': response['address'] ?? 'غير متوفر',
      };
    });
  }

  Future<void> _fetchCustomerBills() async {
    final response = await _supabase
        .from('bills')
        .select('*, bill_items(*)')
        .eq('customer_name', _customerNameController.text);

    setState(() {
      _bills = List<Bill>.from(response.map((json) => Bill.fromJson(json)));
    });
  }

  void _selectStartDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _startDate = pickedDate;
        if (_endDate != null && _startDate!.isAfter(_endDate!)) {
          _endDate = null;
        }
        _filterBills();
      });
    }
  }

  void _selectEndDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _endDate = pickedDate;
        _filterBills();
      });
    }
  }

  void _filterBills() {
    setState(() {
      // The filtered bills getter will automatically update
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<bool> showPaymentDialog(
      BuildContext context, String customerName) async {
    try {
      return await showDialog<bool>(
            context: context,
            builder: (context) {
              return PaymentDialog(
                customerName: customerName,
                customerBills: _bills,
                billRepository: BillRepository(),
                updateBillStatus: _updateBillStatus,
              );
            },
          ) ??
          false;
    } catch (e) {
      _showError('حدث خطأ أثناء تحميل الفواتير');
      return false;
    }
  }

  Future<void> _updateBillStatus(
      int billId, double totalPrice, double newPayment) async {
    try {
      final payments = await _supabase
          .from('payment')
          .select('payment')
          .eq('bill_id', billId);

      final totalPayment = payments.fold<double>(
        0,
        (sum, payment) => sum + (payment['payment'] ?? 0),
      );

      String status;
      if (totalPayment == totalPrice) {
        status = 'تم الدفع';
      } else if (totalPayment > totalPrice) {
        status = 'فاتورة مفتوحة';
      } else {
        status = 'آجل';
      }

      await _supabase.from('bills').update({
        'payment': newPayment,
        'status': status,
      }).eq('id', billId);

      await _fetchCustomerBills();
    } catch (error) {
      _showError('Failed to update bill status: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('كشف حساب العميل'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.pushReplacementNamed(context, '/userMainScreen2'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Fixed search section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildCustomerSearchSection(),
          ),

          // Scrollable content section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  _buildSummaryCards(),
                  const SizedBox(height: 20),
                  _buildDateFilterControls(),
                  if (_searchByDate) _buildDateFilterSection(),
                  const SizedBox(height: 20),
                  _buildBillsTable(),
                  const SizedBox(height: 20), // Extra space at bottom
                ],
              ),
            ),
          ),
        ],
      ),
    );  }

  Widget _buildDateFilterControls() {
    return Row(
      children: [
        Checkbox(
          value: _searchByDate,
          onChanged: (bool? value) {
            setState(() {
              _searchByDate = value ?? false;
            });
          },
        ),
        const Text('تصفية حسب التاريخ'),
        const Spacer(),
        ElevatedButton.icon(
          icon: const Icon(Icons.payment, color: Colors.white),
          label: const Text("إدخال دفعة للكل"),
          onPressed: () async {
            if (_customerNameController.text.isEmpty) {
              _showError('الرجاء اختيار عميل أولاً');
              return;
            }
            await showPaymentDialog(context, _customerNameController.text);
            await _fetchCustomerBills();
          },
        ),

        SizedBox(width: 8,),
        ElevatedButton.icon(
          icon: const Icon(Icons.payment, color: Colors.white),
          label: const Text("استخراج PDF"),
          onPressed: () async {
            if (_customerNameController.text.isEmpty) {
              _showError('الرجاء اختيار عميل أولاً');
              return;
            }
           await generateBillsPDF(context, _filteredBills, _startDate, _endDate, _customerNameController.text.trim(),_searchByDate);

            // await _fetchCustomerBills();
          },
        ),
      ],
    );
  }

  // [Rest of your widget building methods remain the same...]
  Widget _buildCustomerSearchSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Autocomplete<String>(
              optionsBuilder: (textValue) => _customerNames.where(
                    (name) => name.toLowerCase().contains(textValue.text.toLowerCase()),
              ),
              onSelected: (name) {
                _customerNameController.text = name;
                _loadCustomerData();
              },
              fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: _customerDetails['name'] ?? 'اسم العميل',  // Updated this line
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            if (_customerDetails.isNotEmpty) _buildCustomerInfoSection(),
          ],
        ),
      ),
    );
  }
  bool _isCustomerInfoExpanded = true;

  Widget _buildCustomerInfoSection() {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.person_outline, color: Colors.blue),
            title: Text(
              'معلومات العميل',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                _isCustomerInfoExpanded
                    ? Icons.expand_less
                    : Icons.expand_more,
                color: Colors.blue,
              ),
              onPressed: () {
                setState(() {
                  _isCustomerInfoExpanded = !_isCustomerInfoExpanded;
                });
              },
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            child: Container(
              height: _isCustomerInfoExpanded ? null : 0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: [
                    Divider(height: 1),
                    SizedBox(height: 12),
                    _buildInfoRowWithIcon(Icons.person, 'اسم العميل', _customerDetails['name']),
                    _buildInfoRowWithIcon(Icons.email, 'البريد الإلكتروني', _customerDetails['email']),
                    _buildInfoRowWithIcon(Icons.phone, 'رقم الهاتف', _customerDetails['phonecall']),
                    _buildInfoRowWithIcon(Icons.chat, 'رقم الواتساب', _customerDetails['phone']),
                    _buildInfoRowWithIcon(Icons.location_on, 'العنوان', _customerDetails['address']),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRowWithIcon(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value ?? 'غير متوفر',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value ?? 'غير متوفر'),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        _buildSummaryCard('الإجمالي', _totalInvoices, Colors.blue),
        _buildSummaryCard('المدفوع', _totalPayments, Colors.green),
        _buildSummaryCard('المتبقي', _remainingBalance,
            _remainingBalance > 0 ? Colors.orange : Colors.green),
      ],
    );
  }

  Widget _buildSummaryCard(String title, double amount, Color color) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(title, style: const TextStyle(fontSize: 14)),
              Text(
                amount.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateFilterSection() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            readOnly: true,
            controller: TextEditingController(
              text: _startDate != null ? _dateFormat.format(_startDate!) : '',
            ),
            decoration: InputDecoration(
              labelText: 'من تاريخ',
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _selectStartDate(context),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            readOnly: true,
            controller: TextEditingController(
              text: _endDate != null ? _dateFormat.format(_endDate!) : '',
            ),
            decoration: InputDecoration(
              labelText: 'إلى تاريخ',
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _selectEndDate(context),
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            setState(() {
              _startDate = null;
              _endDate = null;
              _filterBills();
            });
          },
          tooltip: 'مسح التواريخ',
        ),
      ],
    );
  }

  Widget _buildBillsTable() {
    if (_bills.isEmpty) {
      return const Center(child: Text('لا يوجد فواتير'));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('الفاتورة')),
          DataColumn(label: Text('التاريخ')),
          DataColumn(label: Text('الحالة')),
          DataColumn(label: Text('الإجمالي')),
          DataColumn(label: Text('المدفوع')),
          DataColumn(label: Text('الباقي')),
          DataColumn(label: Text('إجراءات')),
        ],
        rows: _filteredBills.map((bill) {
          return DataRow(
            cells: [
              DataCell(Text(bill.id.toString())),
              DataCell(Text(_dateFormat.format(bill.date))),
              DataCell(
                Chip(
                  label: Text(bill.status),
                  backgroundColor: _getStatusColor(bill.status),
                ),
              ),
              DataCell(Text(bill.total_price.toStringAsFixed(2))),
              DataCell(Text(bill.payment.toStringAsFixed(2))),
              DataCell(
                  Text((bill.total_price - bill.payment).toStringAsFixed(2))),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility, color: Colors.blue),
                      onPressed: () => showBillDetailsDialog(context, bill),
                    ),
                    IconButton(
                      icon: const Icon(Icons.payment, color: Colors.green),
                      onPressed: () => showAddPaymentDialog(
                        context,
                        bill.id,
                        bill.payment,
                        bill.customerName,
                        bill.date,
                        bill.total_price,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'تم الدفع':
        return Colors.green[100]!;
      case 'آجل':
        return Colors.orange[100]!;
      default:
        return Colors.grey[100]!;
    }
  }
}

void showAddPaymentDialog(
  BuildContext context,
  int billId,
    double payment,
  String customerName,
  DateTime billDate,
    double total_price,
) {
  showDialog(
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
