import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

Future<void> generatePDF(List<Map<String, dynamic?>> attendanceLogs) async {
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
          children: [
            pw.Text(
              "تقرير الحضور والانصراف",
              style: pw.TextStyle(fontSize: 20,),
            ),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: ['عدد ساعات العمل', 'آخر تسجيل خروج', 'أول تسجيل دخول', 'التاريخ'],
              // headers: ['التاريخ', 'أول تسجيل دخول', 'آخر تسجيل خروج', 'عدد ساعات العمل'],
              data: attendanceLogs.map((log) {
                return [
                  // log['date'] ?? 'N/A',
                  // log['first_login']?.split('T')[1].split('.')[0] ?? 'لا يوجد',
                  // log['last_logout']?.split('T')[1].split('.')[0] ?? 'لا يوجد',
                  // log['time_difference'] ?? 'غير متاح',

                  log['time_difference'] ?? 'غير متاح',
                  log['last_logout']?.split('T')[1].split('.')[0] ?? 'لا يوجد',
                  log['first_login']?.split('T')[1].split('.')[0] ?? 'لا يوجد',
                  log['date'] ?? 'N/A',

                ];
              }).toList(),
              // headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
              cellAlignment: pw.Alignment.center,
              cellStyle: pw.TextStyle(fontSize: 12),
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
