import 'package:flutter/material.dart';
import 'package:system/features/billes/data/models/bill_model.dart';

Future<void> showEditBillDialog(BuildContext context, Bill bill) async {
  // تحضير البيانات للتعديل
  final TextEditingController customerNameController = TextEditingController(text: bill.customerName);
  final TextEditingController dateController = TextEditingController(text: bill.date);
  String selectedStatus = bill.status; // حالة الدفع
  List<BillItem> updatedItems = List.from(bill.items); // نسخة من الأصناف للتعديل

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('تعديل الفاتورة'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: customerNameController,
                decoration: InputDecoration(labelText: 'اسم العميل'),
              ),
              TextField(
                controller: dateController,
                decoration: InputDecoration(labelText: 'التاريخ'),
              ),
              DropdownButton<String>(
                value: selectedStatus,
                onChanged: (String? newValue) {
                  selectedStatus = newValue!;
                },
                items: <String>['تم الدفع', 'آجل']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              // جدول تعديل الأصناف
              Text('الأصناف:', style: TextStyle(fontWeight: FontWeight.bold)),
              DataTable(
                columns: [
                  DataColumn(label: Text('الصنف')),
                  DataColumn(label: Text('الكمية')),
                  DataColumn(label: Text('السعر')),
                ],
                rows: updatedItems.map((item) {
                  // إعداد الحقول لتعديل الكمية والسعر
                  final TextEditingController amountController = TextEditingController(text: item.amount.toString());
                  final TextEditingController priceController = TextEditingController(text: item.price_per_unit.toString());

                  return DataRow(cells: [
                    DataCell(Text('${item.categoryName} / ${item.subcategoryName}')),
                    DataCell(
                      TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(border: InputBorder.none),
                        onChanged: (value) {
                          // تحديث الكمية عند التعديل
                          item.amount = double.tryParse(value) ?? item.amount;
                        },
                      ),
                    ),
                    DataCell(
                      TextField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(border: InputBorder.none),
                        onChanged: (value) {
                          // تحديث السعر عند التعديل
                          item.price_per_unit = double.tryParse(value) ?? item.price_per_unit;
                        },
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // عند حفظ التعديلات، تحديث الفاتورة
              Bill updatedBill = Bill(
                id: bill.id,
                userId: bill.userId,
                customerName: customerNameController.text,
                date: dateController.text,
                payment: bill.payment,
                status: selectedStatus,
                items: bill.items,
                total_price: bill.total_price,
                vault_id: bill.vault_id,  // يتم الحفاظ على الأصناف كما هي
              );

              // العودة مع الفاتورة المعدلة
              Navigator.of(context).pop(updatedBill);
            },
            child: Text('حفظ التعديلات'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('إلغاء'),
          ),
        ],
      );
    },
  );
}
