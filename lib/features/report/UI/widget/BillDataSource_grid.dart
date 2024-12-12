// // DataSource for SfDataGrid
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:system/features/billes/data/models/bill_model.dart';

class BillDataSource extends DataGridSource {
  late List<Bill> bills;
  late final bool showBillId;
  late final bool showCustomerName;
  late final bool showDate;
  late final bool showStatus;
  final bool showTotalPrice;
  final bool showPayment;
  final bool showCategoryName;
  final bool showSubcategoryName;
  final bool showPricePerUnit;
  final bool showQuantity;
  final bool showDescription;
  BillDataSource(
      this.bills, {
        required this.showBillId,
        required this.showCustomerName,
        required this.showDate,
        required this.showStatus,
        required this.showTotalPrice,
        required this.showPayment,
        required this.showCategoryName,
        required this.showSubcategoryName,
        required this.showPricePerUnit,
        required this.showQuantity,
        required this.showDescription,
      });

  void applyFilter(List<Bill> filteredBills) {
    bills = filteredBills;
    notifyListeners(); // Refreshes the DataGrid
  }

  @override
  List<DataGridRow> get rows {
    return bills.map<DataGridRow>((bill) {
      final cells = [
        if (showBillId) DataGridCell<int>(columnName: 'billId', value: bill.id),
        if (showCustomerName) DataGridCell<String>(columnName: 'customerName', value: bill.customerName),
        // if (showDate) DataGridCell<String>(columnName: 'date', value: DateFormat('yyyy-MM-dd').format(bill.date)),
        if (showDate) DataGridCell<DateTime>(columnName: 'date', value: bill.date),
        if (showStatus) DataGridCell<String>(columnName: 'status', value: bill.status),
        if (showTotalPrice) DataGridCell<double>(columnName: 'totalPrice', value: bill.total_price),
        if (showPayment) DataGridCell<String>(columnName: 'payment', value: bill.payment.toString()),
        if (showCategoryName) DataGridCell<String>(columnName: 'categoryName', value:  bill.items.first.categoryName ),
        if (showSubcategoryName) DataGridCell<String>(columnName: 'subcategoryName',value:  bill.items.first.subcategoryName ),
        if (showPricePerUnit) DataGridCell<double>(columnName: 'pricePerUnit', value:  bill.items.first.price_per_unit ),
        if (showQuantity) DataGridCell<int>(columnName: 'quantity',value: bill.items.first.quantity.toInt()),
        if (showDescription) DataGridCell<String>(columnName: 'description', value:  bill.items.first.description),
      ];
      return DataGridRow(cells: cells);
    }).toList();
  }
  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          padding: EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(dataGridCell.value.toString()),
        );
      }).toList(),
    );
  }
}

