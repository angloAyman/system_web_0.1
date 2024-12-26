import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:system/features/billes/data/models/bill_model.dart';

Future<void> generateArabicPdf(Bill bill, BuildContext context) async {
  try {
    // تحميل الخط العربي
    final fontData = await rootBundle.load("assets/fonts/Amiri-Regular.ttf");
    final arabicFont = pw.Font.ttf(fontData);

    // إنشاء مستند PDF
    final pdf = pw.Document();

    // تحميل الشعار
    final logoImageData = await rootBundle.load('assets/logo/logo-1.jpeg'); // مسار الشعار
    final logoImage = pw.MemoryImage(logoImageData.buffer.asUint8List());

    // إضافة صفحة PDF
    pdf.addPage(
      pw.Page(
        theme: pw.ThemeData.withFont(
          base: arabicFont,
        ),
        textDirection: pw.TextDirection.rtl, // للكتابة من اليمين إلى اليسار
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              // الشعار والعنوان
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(logoImage, height: 50), // الشعار
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'ROTOSH',
                        style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(
                        'فاتورة',
                        style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              // معلومات العميل والتاريخ
              pw.Text(
                'اسم العميل: ${bill.customerName}',
                style: pw.TextStyle(fontSize: 16),
              ),
              pw.Text(
                'التاريخ: ${bill.date}',
                style: pw.TextStyle(fontSize: 16),
              ),
              pw.SizedBox(height: 16),

              // تفاصيل العناصر
              pw.Text(
                'تفاصيل العناصر:',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.Table.fromTextArray(
                headers: ['التصنيف', 'الفرع', 'الكمية', 'السعر', 'الإجمالي'],
                data: bill.items.map((item) {
                  return [
                    item.categoryName,
                    item.subcategoryName,
                    item.amount.toString(),
                    '${item.price_per_unit.toStringAsFixed(2)} جنيه',
                    '${(item.amount * item.price_per_unit).toStringAsFixed(2)} جنيه',
                  ];
                }).toList(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                border: pw.TableBorder.all(),
              ),
              pw.SizedBox(height: 16),

              // الإجمالي الكلي
              pw.Text(
                'الإجمالي: ${(bill.items.fold(0.0, (sum, item) => sum + (item.amount * item.price_per_unit))).toStringAsFixed(2)} جنيه',
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
              ),
            ],
          );
        },
      ),
    );

    // تحديد مسار التخزين
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/فاتورة_${bill.customerName}.pdf';
    final file = File(filePath);

    // حفظ ملف PDF
    await file.writeAsBytes(await pdf.save());

    // إشعار المستخدم بالمكان
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم حفظ ملف PDF في: $filePath')),
    );
    print('PDF تم حفظه في: $filePath');
  } catch (e) {
    // التعامل مع الأخطاء
    print('حدث خطأ أثناء إنشاء PDF: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('حدث خطأ أثناء إنشاء PDF: $e')),
    );
  }
}
