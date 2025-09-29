import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/category/data/models/category_model.dart';
import 'package:system/features/category/data/models/subCategory_model.dart';

Future<void> generatePdf(List<Bill> bills, Category? selectedCategory, Subcategory? selectedSubcategory) async {
  final pdf = pw.Document();

  final fontData = await rootBundle.load("assets/font/Amiri-Regular.ttf");
  final arabicFont = pw.Font.ttf(fontData);

  pdf.addPage(
    pw.Page(
      theme: pw.ThemeData.withFont(base: arabicFont),
      textDirection: pw.TextDirection.rtl,
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("قائمة الفواتير", style: pw.TextStyle(fontSize: 20, )),
            pw.SizedBox(height: 10),
            pw.Row(children:[
              pw.Text( selectedCategory?.name ?? 'N/A' +"___"),
              pw.Text("___"),
              pw.Text( selectedSubcategory?.name ?? 'N/A' ),
            ]),
            pw.Table.fromTextArray(
              border: pw.TableBorder.all(),
              cellAlignment: pw.Alignment.center,
              headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
              // headerStyle: pw.TextStyle(),
              headers: [
                // "رقم الفاتورة",
                // "تاريخ",
                // "اسم العميل",
                // "الصنف الرئسي",
                // "الصنف الفرعي",
                // "الكمية",
                // "الوحدة",
                // "عدد مرات الاستخدام",
                // "السعر داخل الفاتورة"
                "السعر داخل الفاتورة",
                    "عدد مرات الاستخدام",
                "الوحدة",
                "الكمية",
                // "الصنف الفرعي",
                // "الصنف الرئسي",
                "اسم العميل",
                "تاريخ",
                "رقم الفاتورة",
              ],
              data: bills.where((bill) {
                final categoryMatch = bill.items.any((item) => item.categoryName == selectedCategory?.name);
                final subcategoryMatch = selectedSubcategory == null ||
                    bill.items.any((item) => item.subcategoryName == selectedSubcategory?.name);
                return categoryMatch && subcategoryMatch;
              }).map((bill) {
                final matchingItem = bill.items.firstWhere(
                      (item) =>
                  item.categoryName == selectedCategory?.name &&
                      (selectedSubcategory == null || item.subcategoryName == selectedSubcategory?.name),
                );

                return [
                  matchingItem != null ? matchingItem.total_Item_price.toString() : 'N/A',
                  bill.items.length.toString(),
                  selectedSubcategory?.unit?.toString() ?? 'N/A',
                  bill.items.isNotEmpty ? bill.items.first.quantity.toString() : 'N/A',
                  // selectedSubcategory?.name ?? 'N/A',
                  // selectedCategory?.name ?? 'N/A',
                  bill.customerName.toString(),
                  DateFormat('yyyy-MM-dd').format(bill.date),
                  bill.id.toString(),
                ];
              }).toList(),
            ),
          ],
        );
      },
    ),
  );

  // حفظ الملف وفتحه
  final output = await getTemporaryDirectory();
  final file = File("${output.path}/attendance_report.pdf");
  await file.writeAsBytes(await pdf.save());

  // فتح الملف تلقائيًا
  OpenFile.open(file.path);

}
