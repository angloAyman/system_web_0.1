//the table with syncfusion

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/billes/data/repositories/bill_repository.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:system/features/report/UI/widget/BillDataSource_grid.dart';

class billsReportPage extends StatefulWidget {
  @override
  _billsReportPageState createState() => _billsReportPageState();
}

class _billsReportPageState extends State<billsReportPage> {

  final BillRepository _billRepository = BillRepository();
  late Future<List<Bill>> _billsFuture;
  List<Bill> _bills = [];
  List<Bill> _filteredBills = [];
  final TextEditingController _searchController = TextEditingController();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();

  String _searchCriteria = 'id'; // Default search by ID
  // late BillDataSource _billDataSource;

  // Variables to control column visibility
  bool _showBillId = true;
  bool _showCustomerName = true;
  bool _showDate = true;
  bool _showStatus = true;
  bool _showTotalPrice = true;
  bool _showPayment = true;
  bool _showCategoryName = true;
  bool _showSubcategoryName = true;
  bool _showPricePerUnit = true;
  bool _showQuantity = true;
  bool _showDescription = true;

  @override
  void initState() {
    super.initState();
    _billsFuture = _billRepository.getBills();
    _billsFuture.then((bills) {
      setState(() {
        _bills = bills;
        _filteredBills = bills;
      });
    });
    _searchController.addListener(_filterBills);

  }

  void _filterBills() {
    final query = _searchController.text.toLowerCase();
    final startDate = DateTime.tryParse(_startDateController.text);
    final endDate = DateTime.tryParse(_endDateController.text);

    setState(() {
      _filteredBills = _bills.where((bill) {
        // Determine if the bill matches the search query based on criteria
        final matchesQuery = _searchCriteria == 'id'
            ? bill.id.toString().contains(query)  // Match by bill ID
            : bill.customerName.toLowerCase().contains(query);  // Match by customer name

        // Parse the bill's date for comparison
        DateTime billDate = bill.date;  // Assuming bill.date is in a valid string format

        // Check if the bill falls within the specified date range
        final withinDateRange = (startDate == null || !billDate.isBefore(startDate)) &&
            (endDate == null || !billDate.isAfter(endDate));

        // Return true if both the query and date range match
        return matchesQuery && withinDateRange;
      }).toList();

      // Update the data source to reflect the filtered data
      // _billDataSource.applyFilter(_filteredBills);
    });
  }

  // Add this method to export the data to PDF
  Future<void> _exportToPDF() async {
    final pdf = pw.Document();
    final fontData = await rootBundle.load("assets/font/Amiri-Regular.ttf");
    final arabicFont = pw.Font.ttf(fontData);

    final headerStyle = pw.TextStyle(fontSize: 12);
    final cellStyle = pw.TextStyle(fontSize: 10);

    // Create headers dynamically based on visibility flags
    List<String> headers = [];
    if (_showDescription) headers.add('الوصف');
    if (_showQuantity) headers.add('الكمية');
    if (_showPricePerUnit) headers.add('سعر الوحدة');
    if (_showSubcategoryName) headers.add('اسم العنصر الفرعي');
    if (_showCategoryName) headers.add('اسم العنصر');
    if (_showPayment) headers.add('الدفع');
    if (_showTotalPrice) headers.add('اجمالي الفاتورة');
    if (_showStatus) headers.add('الحالة');
    if (_showDate) headers.add('التاريخ');
    if (_showCustomerName) headers.add('اسم العميل');
    if (_showBillId) headers.add('رقم الفاتورة');



    // Add the table headers
    pdf.addPage(pw.Page(
      theme: pw.ThemeData.withFont(base: arabicFont),
      textDirection: pw.TextDirection.rtl,
      build: (pw.Context context) {
        return

          pw.Column(
            children: [
              // Add introductory text before the table
              pw.Text(
                'تقرير الفواتير',
                style: pw.TextStyle(fontSize: 16,),
              ),
              pw.SizedBox(height: 10), // Space between text and table

              pw.Text(
                'تقرير يحتوي على تفاصيل الفواتير والمنتجات.',
                style: pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 20), // Space between text and table

              // Add the table with the dynamic headers and data
              pw.Table.fromTextArray(
                headers: headers,
                data: _getTableData(),
                cellHeight: 25,
                headerStyle: headerStyle,
                cellStyle: cellStyle,
                border: pw.TableBorder.all(width: 0.5),
                headerAlignment: pw.Alignment.centerRight,  // Header alignment to the right
                cellAlignment: pw.Alignment.centerRight,    // Cell content alignment to the right


              ),
            ],
          );
      },
    ));



    // Save or print the PDF
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  // Prepare the data for the table in the PDF
  List<List<String>> _getTableData() {
    List<List<String>> rows = [];
    for (var bill in _filteredBills) {
      for (var item in bill.items) {
        List<String> row = [];
        // Add data for each column based on visibility
        if (_showDescription) row.add(item.description ?? '');
        if (_showQuantity) row.add(item.quantity.toString());
        if (_showPricePerUnit) row.add(item.price_per_unit.toString());
        if (_showSubcategoryName) row.add(item.subcategoryName);
        if (_showCategoryName) row.add(item.categoryName);
        if (_showPayment) row.add(bill.payment.toString());
        if (_showTotalPrice) row.add(bill.total_price.toString());
        if (_showStatus) row.add(bill.status);
        if (_showDate) row.add(bill.date.toString());
        if (_showCustomerName) row.add(bill.customerName);
        if (_showBillId) row.add(bill.id.toString());

        rows.add(row);
      }
    }
    return rows;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('انشاء تقرير'),
        actions: [
          TextButton.icon(onPressed: (){
            Navigator.pushReplacementNamed(context, '/adminHome'); // توجيه المستخدم إلى صفحة تسجيل الدخول
          }, label: Icon(Icons.home)),

          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: _exportToPDF,  // Export button to generate PDF
          ),
        ],
      ),
      body:
      Column(
        children: [
          // Dropdown for search criteria
          DropdownButton<String>(
            value: _searchCriteria,
            onChanged: (String? newValue) {
              setState(() {
                _searchCriteria = newValue!;
                _filterBills(); // Reapply filter when criteria changes
              });
            },
            items: <String>['id', 'customerName', 'dateRange'] // Add dateRange option
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value == 'id'
                      ? 'رقم الفاتورة'
                      : value == 'customerName'
                      ? 'اسم العميل'
                      : 'تاريخ الفاتورة',
                ),
              );
            }).toList(),
          ),

// Search Bar or Date Range Input based on selected criteria
          Padding(
            padding: EdgeInsets.all(8.0),
            child: _searchCriteria == 'dateRange'
                ? Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _startDateController,
                    decoration: InputDecoration(
                      hintText: 'تاريخ البداية (YYYY-MM-DD)',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.datetime,
                    onChanged: (value) {
                      _filterBills(); // Reapply filter when date changes
                    },
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _endDateController,
                    decoration: InputDecoration(
                      hintText: 'تاريخ النهاية (YYYY-MM-DD)',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.datetime,
                    onChanged: (value) {
                      _filterBills(); // Reapply filter when date changes
                    },
                  ),
                ),
              ],
            )
                : TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: _searchCriteria == 'id'
                    ? 'بحث برقم الفاتورة'
                    : 'بحث باسم العميل',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _filterBills(); // Reapply filter when text changes
              },
            ),
          ),
          // Column visibility controls (Checkboxes)
          Row(
            children: [
              _buildCheckbox('رقم الفاتورة', _showBillId, (value) {
                setState(() {
                  _showBillId = value!;
                });
              }),
              _buildCheckbox('اسم العميل', _showCustomerName, (value) {
                setState(() {
                  _showCustomerName = value!;
                });
              }),
              _buildCheckbox('التاريخ', _showDate, (value) {
                setState(() {
                  _showDate = value!;
                });
              }),
              _buildCheckbox('الحالة', _showStatus, (value) {
                setState(() {
                  _showStatus = value!;
                });
              }),
              _buildCheckbox('اجمالي الفاتورة', _showTotalPrice, (value) {
                setState(() {
                  _showTotalPrice = value!;
                });
              }),
            ],
          ),
          Row(
            children: [
              _buildCheckbox('الدفع', _showPayment, (value) {
                setState(() {
                  _showPayment = value!;
                });
              }),
              _buildCheckbox('اسم العنصر', _showCategoryName, (value) {
                setState(() {
                  _showCategoryName = value!;
                });
              }),
              _buildCheckbox('اسم العنصر الفرعي', _showSubcategoryName, (value) {
                setState(() {
                  _showSubcategoryName = value!;
                });
              }),
              _buildCheckbox('سعر الوحدة', _showPricePerUnit, (value) {
                setState(() {
                  _showPricePerUnit = value!;
                });
              }),
              _buildCheckbox('الكمية', _showQuantity, (value) {
                setState(() {
                  _showQuantity = value!;
                });
              }),
            ],
          ),
          Row(
            children: [
              _buildCheckbox('الوصف', _showDescription, (value) {
                setState(() {
                  _showDescription = value!;
                });
              }),
            ],
          ),

          // SfDataGrid to display the filtered data
          Expanded(
            child: FutureBuilder<List<Bill>>(
              future: _billsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('خطأ: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('لا توجد فواتير حالياً.'));
                }

                return Container(
                  alignment: AlignmentDirectional.center,
                  padding: EdgeInsets.fromLTRB(25,10,30,0),
                  child: SfDataGrid(
                    allowColumnsResizing: true,
                    allowColumnsDragging: true,
                    allowFiltering: true,
                    source:
                    BillDataSource(
                      _filteredBills,  // Using filtered bills
                      showBillId: _showBillId,
                      showCustomerName: _showCustomerName,
                      showDate: _showDate,
                      showStatus: _showStatus,
                      showTotalPrice: _showTotalPrice,
                      showPayment: _showPayment,
                      showCategoryName: _showCategoryName,
                      showSubcategoryName: _showSubcategoryName,
                      showPricePerUnit: _showPricePerUnit,
                      showQuantity: _showQuantity,
                      showDescription: _showDescription,
                    ),
                    columns: _getGridColumns(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Create checkbox for each column header
  Widget _buildCheckbox(String label, bool value, ValueChanged<bool?> onChanged) {
    return Expanded(
      child: Row(
        children: [
          Checkbox(value: value, onChanged: onChanged),
          Text(label),
        ],
      ),
    );
  }

  // Returns the columns for SfDataGrid
  List<GridColumn> _getGridColumns() {
    List<GridColumn> columns = [];
    if (_showBillId) columns.add(GridColumn(columnName: 'billId', label: Text('رقم الفاتورة',),));
    if (_showCustomerName) columns.add(GridColumn(columnName: 'customerName', label: Text('اسم العميل')));
    if (_showDate) columns.add(GridColumn(columnName: 'date', label: Text('التاريخ')));
    if (_showStatus) columns.add(GridColumn(columnName: 'status', label: Text('الحالة')));
    if (_showTotalPrice) columns.add(GridColumn(columnName: 'totalPrice', label: Text('اجمالي الفاتورة')));
    if (_showPayment) columns.add(GridColumn(columnName: 'payment', label: Text('الدفع')));
    if (_showCategoryName) columns.add(GridColumn(columnName: 'categoryName', label: Text('اسم العنصر')));
    if (_showSubcategoryName) columns.add(GridColumn(columnName: 'subcategoryName', label: Text('اسم العنصر الفرعي')));
    if (_showPricePerUnit) columns.add(GridColumn(columnName: 'pricePerUnit', label: Text('سعر الوحدة')));
    if (_showQuantity) columns.add(GridColumn(columnName: 'quantity', label: Text('الكمية')));
    if (_showDescription) columns.add(GridColumn(columnName: 'description', label: Text('الوصف')));
    return columns;
  }
}


