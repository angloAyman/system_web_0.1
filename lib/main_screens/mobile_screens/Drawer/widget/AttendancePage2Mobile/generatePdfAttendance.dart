// import 'dart:io';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:pdf/pdf.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:open_file/open_file.dart';
//
// Future<void> generatePDFMobile(List<Map<String, dynamic?>> attendanceLogs) async {
//   final pdf = pw.Document();
//
//   // Load Arabic font
//   final fontData = await rootBundle.load("assets/font/Amiri-Regular.ttf");
//   final arabicFont = pw.Font.ttf(fontData);
//
//   // DateTime formatter
//   final timeFormatter = DateFormat.Hms(); // HH:mm:ss
//
//   pdf.addPage(
//     pw.Page(
//       theme: pw.ThemeData.withFont(base: arabicFont),
//       textDirection: pw.TextDirection.rtl,
//       pageFormat: PdfPageFormat.a4,
//       build: (pw.Context context) {
//         return pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.center,
//           children: [
//             pw.Text(
//               "تقرير الحضور والانصراف",
//               style: pw.TextStyle(fontSize: 20),
//             ),
//             pw.SizedBox(height: 20),
//             pw.Table.fromTextArray(
//               headers: ['عدد ساعات العمل', 'آخر تسجيل خروج', 'أول تسجيل دخول', 'التاريخ'],
//               data: attendanceLogs.map((log) {
//                 return [
//                   log['time_difference'] ?? 'غير متاح',
//                   log['last_logout'] != null
//                       ? timeFormatter.format(log['last_logout'])
//                       : 'لا يوجد',
//                   log['first_login'] != null
//                       ? timeFormatter.format(log['first_login'])
//                       : 'لا يوجد',
//                   log['date'] ?? 'N/A',
//                 ];
//               }).toList(),
//               headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
//               cellAlignment: pw.Alignment.center,
//               cellStyle: pw.TextStyle(fontSize: 12),
//             ),
//           ],
//         );
//       },
//     ),
//   );
//
//   // Save PDF file
//   final output = await getTemporaryDirectory();
//   final file = File("${output.path}/attendance_report.pdf");
//   await file.writeAsBytes(await pdf.save());
//
//   // Open PDF file automatically
//   await OpenFile.open(file.path);
// }

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

Future<void> generatePDFMobile(
    List<Map<String, dynamic?>> attendanceLogs,
    DateTime? startDate,
    DateTime? endDate,
    String employeeName,

    ) async {
  final pdf = pw.Document();

  // Load Arabic font
  final fontData = await rootBundle.load("assets/font/Amiri-Regular.ttf");
  final arabicFont = pw.Font.ttf(fontData);

  // DateTime formatter
  final timeFormatter = DateFormat.Hms(); // HH:mm:ss

  pdf.addPage(
    pw.Page(
      theme: pw.ThemeData.withFont(base: arabicFont),
      textDirection: pw.TextDirection.rtl,
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Text(
                "تقرير الحضور والانصراف",
                style: pw.TextStyle(fontSize: 20),
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              "اسم الموظف: $employeeName",
              style: pw.TextStyle(fontSize: 14),
            ),
            pw.Text(
              "من: $startDate",
              style: pw.TextStyle(fontSize: 14),
            ),  pw.Text(
              "الي: $endDate",
              style: pw.TextStyle(fontSize: 14),
            ),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: ['عدد ساعات العمل', 'آخر تسجيل خروج', 'أول تسجيل دخول', 'التاريخ'],
              data: attendanceLogs.map((log) {
                return [
                  log['time_difference'] ?? 'غير متاح',
                  log['last_logout'] != null
                      ? timeFormatter.format(log['last_logout'])
                      : 'لا يوجد',
                  log['first_login'] != null
                      ? timeFormatter.format(log['first_login'])
                      : 'لا يوجد',
                  log['date'] ?? 'N/A',
                ];
              }).toList(),
              headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
              cellAlignment: pw.Alignment.center,
              cellStyle: pw.TextStyle(fontSize: 12),
            ),
          ],
        );
      },
    ),
  );

  // Save PDF file
  final output = await getTemporaryDirectory();
  final file = File("${output.path}/attendance_report.pdf");
  await file.writeAsBytes(await pdf.save());

  // Open PDF file automatically
  await OpenFile.open(file.path);
}
