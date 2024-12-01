import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:system/features/billes/data/models/bill_model.dart';

class PdfService {
  // وظيفة لتوليد PDF
  static Future<void> generatePdf(Bill bill) async {
    final pdf = pw.Document();
    final fontData = await rootBundle.load("assets/font/Amiri-Regular.ttf");
    // final boldfontData = await rootBundle.load("assets/font/Amiri-Bold.ttf");
    final arabicFont = pw.Font.ttf(fontData);
    // تحميل الشعار
    final logoImageData = await rootBundle.load('assets/logo/logo-1.jpeg'); // مسار الشعار
    final logoImage = pw.MemoryImage(logoImageData.buffer.asUint8List());

    // إضافة محتوى الفاتورة إلى PDF
    pdf.addPage(
      pw.Page(
        theme: pw.ThemeData.withFont(
          base: arabicFont,
        ),
        textDirection: pw.TextDirection.rtl, // للكتابة من اليمين إلى اليسار
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'فاتورة رقم: ${bill.id}',
              style: pw.TextStyle(
                  fontSize: 20,
                  // fontWeight: pw.FontWeight.bold
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Text('اسم العميل: ${bill.customerName}'),
            pw.Text('التاريخ: ${bill.date}'),
            pw.Text('حالة الدفع: ${bill.status}'),
            pw.SizedBox(height: 16),
            pw.Text('الأصناف:', style: pw.TextStyle(fontSize: 18,
                // fontWeight: pw.FontWeight.bold
            )),
            pw.Table.fromTextArray(
              headers: ['الصنف', 'الكمية', 'السعر', 'الإجمالي'],
              data: bill.items.map((item) {
                return [
                  '${item.categoryName} / ${item.subcategoryName}',
                  item.amount.toString(),
                  item.price_per_unit.toString(),
                  (item.amount * item.price_per_unit).toStringAsFixed(2),
                ];
              }).toList(),
            ),
            pw.Divider(),
            pw.Text(
              'الإجمالي: L.E ${bill.items.fold(0.0, (sum, item) => sum + (item.amount * item.price_per_unit)).toStringAsFixed(2)}',
              style: pw.TextStyle(fontSize: 16,
                  // fontWeight: pw.FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );

    // معاينة أو مشاركة ملف PDF
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}
