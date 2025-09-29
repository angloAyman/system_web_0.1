import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/report/UI/paymentout//pdf/generatePaymentPdf.dart'; // Update the path as needed

class PaymentReportPage extends StatefulWidget {
  @override
  _PaymentReportPageState createState() => _PaymentReportPageState();
}

class _PaymentReportPageState extends State<PaymentReportPage> {
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  bool isLoading = false;
  List<Map<String, dynamic>> payments = [];
  double totalAmount = 0.0;

  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedStartDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedEndDate = picked;
      });
    }
  }

  void _fetchPayments() async {
    if (selectedStartDate == null || selectedEndDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select start and end dates')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await Supabase.instance.client
          .from('paymentsOut')
          .select()
          .gte('timestamp', selectedStartDate!.toIso8601String())
          .lte('timestamp', selectedEndDate!.toIso8601String())
          .order('timestamp', ascending: false);

      double total = response.fold(0.0, (sum, item) => sum + (item['amount'] ?? 0.0));

      setState(() {
        payments = response;
        totalAmount = total;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching payments: $error')),
      );
    }
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
      appBar: AppBar(title: Text('Payment Report')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Payment Report for Selected Period", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),

            // Date Pickers
            Row(
              children: [
                Text('Start Date: '),
                TextButton(
                  onPressed: () => _selectStartDate(context),
                  child: Text(selectedStartDate == null ? 'Select Date' : formatDate(selectedStartDate!)),
                ),
                Text('End Date: '),
                TextButton(
                  onPressed: () => _selectEndDate(context),
                  child: Text(selectedEndDate == null ? 'Select Date' : formatDate(selectedEndDate!)),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Fetch Payments Button
            Row(
              children: [
                ElevatedButton(onPressed: _fetchPayments, child: Text('Generate Report')),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    generatePaymentPdf(payments, selectedStartDate, selectedEndDate);
                  },
                  child: Text("Export PDF"),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Total Payment Amount
            Center(
              child: Text(
                '💰 Total Payment: $totalAmount',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),

            // Payment Table
            isLoading
                ? Center(child: CircularProgressIndicator())
                : payments.isEmpty
                ? Center(child: Text('No payments found.'))
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
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('Amount')),
                          DataColumn(label: Text('Description')),
                          DataColumn(label: Text('Vault Name')),
                          DataColumn(label: Text('User Name')),
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
