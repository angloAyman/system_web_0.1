// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart';
// // import 'package:system/features/report/UI/paymentout//pdf/generatePaymentPdf.dart'; // Update the path as needed
// //
// // class PaymentReportPage extends StatefulWidget {
// //   @override
// //   _PaymentReportPageState createState() => _PaymentReportPageState();
// // }
// //
// // class _PaymentReportPageState extends State<PaymentReportPage> {
// //   DateTime? selectedStartDate;
// //   DateTime? selectedEndDate;
// //   bool isLoading = false;
// //   List<Map<String, dynamic>> payments = [];
// //   int totalAmount = 0;
// //
// //   final ScrollController _verticalScrollController = ScrollController();
// //   final ScrollController _horizontalScrollController = ScrollController();
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //   }
// //
// //   Future<void> _selectStartDate(BuildContext context) async {
// //     final DateTime? picked = await showDatePicker(
// //       context: context,
// //       initialDate: DateTime.now(),
// //       firstDate: DateTime(2000),
// //       lastDate: DateTime.now(),
// //     );
// //     if (picked != null) {
// //       setState(() {
// //         selectedStartDate = picked;
// //       });
// //     }
// //   }
// //
// //   Future<void> _selectEndDate(BuildContext context) async {
// //     final DateTime? picked = await showDatePicker(
// //       context: context,
// //       initialDate: DateTime.now(),
// //       firstDate: DateTime(2000),
// //       lastDate: DateTime.now(),
// //     );
// //     if (picked != null) {
// //       setState(() {
// //         selectedEndDate = picked;
// //       });
// //     }
// //   }
// //
// //   void _fetchPayments() async {
// //     if (selectedStartDate == null || selectedEndDate == null) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Please select start and end dates')),
// //       );
// //       return;
// //     }
// //
// //     setState(() {
// //       isLoading = true;
// //     });
// //
// //     try {
// //       final response = await Supabase.instance.client
// //           .from('paymentsOut')
// //           .select()
// //           .gte('timestamp', selectedStartDate!.toIso8601String())
// //           .lte('timestamp', selectedEndDate!.toIso8601String())
// //           .order('timestamp', ascending: false);
// //
// //       int total = response.fold<int>(0, (sum, item) => sum + (item['amount'] as num).toInt());
// //
// //       setState(() {
// //         payments = response;
// //         totalAmount = total;
// //         isLoading = false;
// //       });
// //     } catch (error) {
// //       setState(() {
// //         isLoading = false;
// //       });
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Error fetching payments: $error')),
// //       );
// //     }
// //   }
// //
// //   String formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);
// //
// //   @override
// //   void dispose() {
// //     _verticalScrollController.dispose();
// //     _horizontalScrollController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text('المصروفات')),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(":تقرير المصروفات خلال مدة زمنية ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
// //             SizedBox(height: 16),
// //
// //             // Date Pickers
// //             Row(
// //               children: [
// //                 Text('تاريخ البداية: '),
// //                 TextButton(
// //                   onPressed: () => _selectStartDate(context),
// //                   child: Text(selectedStartDate == null ? 'اختار تاريخ' : formatDate(selectedStartDate!)),
// //                 ),
// //                 Text('تاريخ النهاية: '),
// //                 TextButton(
// //                   onPressed: () => _selectEndDate(context),
// //                   child: Text(selectedEndDate == null ? 'اختار تاريخ' : formatDate(selectedEndDate!)),
// //                 ),
// //               ],
// //             ),
// //             SizedBox(height: 16),
// //
// //             // Fetch Payments Button
// //             Row(
// //               children: [
// //                 ElevatedButton(onPressed: _fetchPayments, child: Text('انشاء التقرير')),
// //                 SizedBox(width: 16),
// //                 ElevatedButton(
// //                   onPressed: () {
// //                     generatePaymentPdf(payments, selectedStartDate, selectedEndDate,totalAmount);
// //                   },
// //                   child: Text(" PDF"),
// //                 ),
// //               ],
// //             ),
// //             SizedBox(height: 16),
// //
// //             // Total Payment Amount
// //             Center(
// //               child: Text(
// //                 '💰 اجمالي المصروفات: $totalAmount ج م',
// //                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //               ),
// //             ),
// //             SizedBox(height: 16),
// //
// //             // Payment Table
// //             isLoading
// //                 ? Center(child: CircularProgressIndicator())
// //                 : payments.isEmpty
// //                 ? Center(child: Text('لا يوجد مصروفات.'))
// //                 : Expanded(
// //               child: Scrollbar(
// //                 controller: _verticalScrollController,
// //                 thumbVisibility: true,
// //                 trackVisibility: true,
// //                 child: SingleChildScrollView(
// //                   controller: _verticalScrollController,
// //                   scrollDirection: Axis.vertical,
// //                   child: Scrollbar(
// //                     controller: _horizontalScrollController,
// //                     trackVisibility: true,
// //                     thumbVisibility: true,
// //                     child: SingleChildScrollView(
// //                       controller: _horizontalScrollController,
// //                       scrollDirection: Axis.horizontal,
// //                       child: DataTable(
// //                         showBottomBorder: true,
// //                         columnSpacing: 30,
// //                         columns: const [
// //                           DataColumn(label: Text('تاريخ')),
// //                           DataColumn(label: Text('المبلغ')),
// //                           DataColumn(label: Text('الوصف')),
// //                           DataColumn(label: Text('اسم الخزينة')),
// //                           DataColumn(label: Text('اسم المستخدم')),
// //                         ],
// //                         rows: payments.map((payment) {
// //                           return DataRow(cells: [
// //                             DataCell(Text(DateFormat('yyyy-MM-dd').format(DateTime.parse(payment['timestamp'])))),
// //                             DataCell(Text(payment['amount'].toString())),
// //                             DataCell(Text(payment['description'] ?? 'N/A')),
// //                             DataCell(Text(payment['vault_name'] ?? 'N/A')),
// //                             DataCell(Text(payment['userName'] ?? 'N/A')),
// //                           ]);
// //                         }).toList(),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/report/UI/paymentout/pdf/generatePaymentPdf.dart'; // Update the path as needed

class PaymentReportPage extends StatefulWidget {
  @override
  _PaymentReportPageState createState() => _PaymentReportPageState();
}

class _PaymentReportPageState extends State<PaymentReportPage> {
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  DateTime? adjustedEndDate;
  bool isLoading = false;
  List<Map<String, dynamic>> payments = [];
  int totalAmount = 0;

  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();

  Future<void> _selectStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => selectedStartDate = picked);
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => selectedEndDate = picked);
    }
  }

  Future<void> _fetchPayments() async {
    if (selectedStartDate == null || selectedEndDate == null) {
      _showMessage('يرجى اختيار تاريخ البداية والنهاية.');
      return;
    }

    setState(() => isLoading = true);

    try {
      // ضبط تاريخ النهاية ليشمل اليوم بالكامل
       adjustedEndDate = DateTime(
        selectedEndDate!.year,
        selectedEndDate!.month,
        selectedEndDate!.day,
        23, 59, 59, 999,
      );

      final response = await Supabase.instance.client
          .from('paymentsOut')
          .select()
          .gte('timestamp', selectedStartDate!.toIso8601String())
          .lte('timestamp', adjustedEndDate!.toIso8601String())
          .order('timestamp', ascending: false);

      int total = response.fold<int>(0, (sum, item) => sum + (item['amount'] as num).toInt());

      setState(() {
        payments = response;
        totalAmount = total;
        isLoading = false;
      });
    } catch (error) {
      setState(() => isLoading = false);
      _showMessage('حدث خطأ أثناء تحميل البيانات: $error');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  String formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  @override
  void dispose() {
    _verticalScrollController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('المصروفات')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("📋 تقرير المصروفات خلال مدة زمنية ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),

            // اختيار التواريخ
            Row(
              children: [
                Text('📅 تاريخ البداية: '),
                TextButton(
                  onPressed: () => _selectStartDate(context),
                  child: Text(selectedStartDate == null ? 'اختار تاريخ' : formatDate(selectedStartDate!)),
                ),
                Text('📅 تاريخ النهاية: '),
                TextButton(
                  onPressed: () => _selectEndDate(context),
                  child: Text(selectedEndDate == null ? 'اختار تاريخ' : formatDate(selectedEndDate!)),
                ),
              ],
            ),
            SizedBox(height: 16),

            // أزرار تحميل البيانات وإنشاء التقرير
            Row(
              children: [

                ElevatedButton(onPressed: _fetchPayments, child: Text('📊 انشاء التقرير')),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (payments.isEmpty) {
                      _showMessage('🚫 لا يوجد بيانات لإنشاء PDF. الرجاء إنشاء التقرير أولًا.');
                      return;
                    }

                    print("📄 يتم إنشاء ملف PDF...");
                    print("📊 عدد المصروفات: ${payments.length}");
                    for (var payment in payments) {
                      print("✅ بيانات المصروفات: $payment");
                    }

                    generatePaymentPdf(context, payments, selectedStartDate, adjustedEndDate, totalAmount);
                  },
                  child: Text("📄 PDF"),
                ),
              ],
            ),
            SizedBox(height: 16),

            // إجمالي المصروفات
            Center(
              child: Text(
                '💰 اجمالي المصروفات: $totalAmount ج م',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),

            // جدول المصروفات
            isLoading
                ? Center(child: CircularProgressIndicator())
                : payments.isEmpty
                ? Center(child: Text('🚫 لا يوجد مصروفات.'))
                : Expanded(
              child: Scrollbar(
                controller: _verticalScrollController,
                thumbVisibility: true,
                trackVisibility: true,
                child: SingleChildScrollView(
                  controller: _verticalScrollController,
                  scrollDirection: Axis.vertical,
                  child: Scrollbar(
                    controller: _horizontalScrollController,
                    trackVisibility: true,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _horizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        showBottomBorder: true,
                        columnSpacing: 30,
                        columns: const [
                          DataColumn(label: Text('📅 التاريخ')),
                          DataColumn(label: Text('💵 المبلغ')),
                          DataColumn(label: Text('📜 الوصف')),
                          DataColumn(label: Text('🏦 اسم الخزينة')),
                          DataColumn(label: Text('👤 اسم المستخدم')),
                        ],
                        rows: payments.map((payment) {
                          return DataRow(cells: [
                            DataCell(Text(DateFormat('yyyy-MM-dd').format(DateTime.parse(payment['timestamp'])))),
                            DataCell(Text(payment['amount'].toString())),
                            DataCell(Text(payment['description'] ?? 'N/A')),
                            DataCell(Text(payment['vault_name'] ?? 'N/A')),
                            DataCell(Text(payment['userName'] ?? 'N/A')),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:system/features/report/UI/paymentout/pdf/generatePaymentPdf.dart';
//
// class PaymentReportPage extends StatefulWidget {
//   @override
//   _PaymentReportPageState createState() => _PaymentReportPageState();
// }
//
// class _PaymentReportPageState extends State<PaymentReportPage> {
//   DateTime? selectedStartDate;
//   DateTime? selectedEndDate;
//   late Future<List<Map<String, dynamic>>> paymentsFuture;
//   int totalAmount = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     paymentsFuture = Future.value([]);
//   }
//
//   Future<void> _selectDate(BuildContext context, bool isStartDate) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime.now(),
//     );
//     if (picked != null) {
//       setState(() {
//         if (isStartDate) {
//           selectedStartDate = picked;
//         } else {
//           selectedEndDate = picked;
//         }
//       });
//     }
//   }
//
//   Future<List<Map<String, dynamic>>> _fetchPayments() async {
//     if (selectedStartDate == null || selectedEndDate == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('يرجى اختيار تاريخ البداية والنهاية.')));
//       return [];
//     }
//
//     DateTime adjustedEndDate = DateTime(
//       selectedEndDate!.year,
//       selectedEndDate!.month,
//       selectedEndDate!.day,
//       23, 59, 59, 999,
//     );
//
//     final response = await Supabase.instance.client
//         .from('paymentsOut')
//         .select()
//         .gte('timestamp', selectedStartDate!.toIso8601String())
//         .lte('timestamp', adjustedEndDate.toIso8601String())
//         .order('timestamp', ascending: false);
//
//     totalAmount = response.fold<int>(0, (sum, item) => sum + (item['amount'] as num).toInt());
//     return response;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('المصروفات')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("📋 تقرير المصروفات خلال مدة زمنية ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             SizedBox(height: 16),
//
//             Row(
//               children: [
//                 Text('📅 تاريخ البداية: '),
//                 TextButton(
//                   onPressed: () => _selectDate(context, true),
//                   child: Text(selectedStartDate == null ? 'اختيار تاريخ' : DateFormat('yyyy-MM-dd').format(selectedStartDate!)),
//                 ),
//                 Text('📅 تاريخ النهاية: '),
//                 TextButton(
//                   onPressed: () => _selectDate(context, false),
//                   child: Text(selectedEndDate == null ? 'اختيار تاريخ' : DateFormat('yyyy-MM-dd').format(selectedEndDate!)),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//
//             Row(
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       paymentsFuture = _fetchPayments();
//                     });
//                   },
//                   child: Text('📊 انشاء التقرير'),
//                 ),
//                 SizedBox(width: 16),
//                 ElevatedButton(
//                   onPressed: () async {
//                     final payments = await paymentsFuture; // تحميل البيانات أولًا
//                     if (payments.isEmpty) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('🚫 لا يوجد بيانات لإنشاء PDF.')),
//                       );
//                       return;
//                     }
//                     generatePaymentPdf(context, payments , selectedStartDate, selectedEndDate, totalAmount);
//                   },
//                   child: Text("📄 PDF"),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//
//             Center(
//               child: Text(
//                 '💰 اجمالي المصروفات: $totalAmount ج م',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//             SizedBox(height: 16),
//
//             Expanded(
//               child: FutureBuilder<List<Map<String, dynamic>>>(
//                 future: paymentsFuture,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   }
//                   if (snapshot.hasError) {
//                     return Center(child: Text('حدث خطأ أثناء تحميل البيانات.'));
//                   }
//                   if (snapshot.data!.isEmpty) {
//                     return Center(child: Text('🚫 لا يوجد مصروفات.'));
//                   }
//
//                   return SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: DataTable(
//                       showBottomBorder: true,
//                       columnSpacing: 30,
//                       columns: const [
//                         DataColumn(label: Text('📅 التاريخ')),
//                         DataColumn(label: Text('💵 المبلغ')),
//                         DataColumn(label: Text('📜 الوصف')),
//                         DataColumn(label: Text('🏦 اسم الخزينة')),
//                         DataColumn(label: Text('👤 اسم المستخدم')),
//                       ],
//                       rows: snapshot.data!.map((payment) {
//                         return DataRow(cells: [
//                           DataCell(Text(DateFormat('yyyy-MM-dd').format(DateTime.parse(payment['timestamp'])))),
//                           DataCell(Text(payment['amount'].toString())),
//                           DataCell(Text(payment['description'] ?? 'N/A')),
//                           DataCell(Text(payment['vault_name'] ?? 'N/A')),
//                           DataCell(Text(payment['userName'] ?? 'N/A')),
//                         ]);
//                       }).toList(),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
