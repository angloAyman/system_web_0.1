// // import 'dart:io';
// // import 'package:easy_localization/easy_localization.dart';
// // import 'package:flutter/services.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:pdf/pdf.dart';
// // import 'package:pdf/widgets.dart' as pw;
// // import 'package:printing/printing.dart';
// //
// // Future<void> generateallPaymentDetailsPdf(List<Map<String, dynamic>> payments,) async {
// //   final pdf = pw.Document();
// //
// //   // Load Arabic font
// //   final fontData = await rootBundle.load("assets/font/Amiri-Regular.ttf");
// //   final arabicFont = pw.Font.ttf(fontData);
// //
// //
// //   // Add the table to the PDF
// //   pdf.addPage(
// //     pw.Page(
// //       theme: pw.ThemeData.withFont(base: arabicFont),
// //       textDirection: pw.TextDirection.rtl,
// //       build: (context) {
// //         return pw.Column(
// //           crossAxisAlignment: pw.CrossAxisAlignment.start,
// //           children: [
// //             pw.Text(
// //               'بيان بجميع المصروفات ',
// //               style: pw.TextStyle(fontSize: 18, ),
// //             ),
// //             pw.SizedBox(height: 20),
// //             pw.Table(
// //               border: pw.TableBorder.all(),
// //               children: [
// //                 // Header Row
// //                 pw.TableRow(
// //                   decoration: pw.BoxDecoration(color: PdfColors.grey300),
// //                   children: [
// //                     pw.Padding(
// //                       padding: const pw.EdgeInsets.all(8),
// //                       child: pw.Text('الخزينة', ),
// //                     ),
// //
// //                     pw.Padding(
// //                       padding: const pw.EdgeInsets.all(8),
// //                       child: pw.Text('الوصف', ),
// //                     ),
// //                     pw.Padding(
// //                       padding: const pw.EdgeInsets.all(8),
// //                       child: pw.Text('المبلغ',),
// //                     ),
// //
// //                     pw.Padding(
// //                       padding: const pw.EdgeInsets.all(8),
// //                       child: pw.Text('اسم المستخدم', ),
// //                     ),
// //
// //
// //                     pw.Padding(
// //                       padding: const pw.EdgeInsets.all(8),
// //                       child: pw.Text('التاريخ', ),
// //                     ),
// //
// //                     pw.Padding(
// //                       padding: const pw.EdgeInsets.all(8),
// //                       child: pw.Text('المسلسل', ),
// //                     ),
// //
// //                   ],
// //                 ),
// //                 // Data Rows
// //                 ...payments.map((payment) {
// //                   return pw.TableRow(
// //                     children: [
// //                       pw.Padding(
// //                         padding: const pw.EdgeInsets.all(8),
// //                         child: pw.Text(payment['vault_name'] ?? 'لا يوجد اسم خزينة'),
// //                       ),
// //
// //                       pw.Padding(
// //                         padding: const pw.EdgeInsets.all(8),
// //                         child: pw.Text(payment['description'] ?? 'لا يوجد وصف'),
// //                       ),
// //
// //                       pw.Padding(
// //                         padding: const pw.EdgeInsets.all(8),
// //                         child: pw.Text('${payment['amount']}'),
// //                       ),
// //
// //
// //                       pw.Padding(
// //                         padding: const pw.EdgeInsets.all(8),
// //                         child: pw.Text(payment['userName'] ?? 'غير معروف'),
// //                       ),
// //
// //
// //                       pw.Padding(
// //                         padding: const pw.EdgeInsets.all(8),
// //                         child: pw.Text(
// //                           payment['timestamp'] != null
// //                               ? DateFormat('dd/MM/yyyy').format(DateTime.parse(payment['timestamp']))
// //                               : 'غير معروف',
// //                         ),
// //                       ),
// //                       pw.Padding(
// //                         padding: const pw.EdgeInsets.all(8),
// //                         child: pw.Text('${payment['id']}'),
// //                       ),
// //
// //
// //
// //
// //                     ],
// //                   );
// //                 }).toList(),
// //               ],
// //             ),
// //           ],
// //         );
// //       },
// //     ),
// //   );
// //   print('Payments Data: $payments');
// //
// //   // // Save the PDF to a file
// //   // final output = await getTemporaryDirectory();
// //   // final file = File('${output.path}/payment_details_$vaultName.pdf');
// //   // await file.writeAsBytes(await pdf.save());
// //   //
// //   // print('PDF saved at: ${file.path}');
// //
// //   // Generate PDF
// //   await Printing.layoutPdf(
// //     onLayout: (PdfPageFormat format) async => pdf.save(),
// //   );
// //
// // }
//
// import 'dart:io';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
//
// Future<void> generateallPaymentDetailsPdf(List<Map<String, dynamic>> payments) async {
//   final pdf = pw.Document();
//
//   // Load Arabic font
//   final fontData = await rootBundle.load("assets/font/Amiri-Regular.ttf");
//   final arabicFont = pw.Font.ttf(fontData);
//
//   // Debugging: Check if payments list is empty
//   print('Payments Data: $payments');
//
//
//   // Add the table to the PD
//
//   // Check if there are payments to display
//   if (payments.isEmpty) {
//     pdf.addPage(
//       pw.Page(
//         theme: pw.ThemeData.withFont(base: arabicFont),
//         textDirection: pw.TextDirection.rtl,
//         build: (context) => pw.Center(
//           child: pw.Text('لا توجد بيانات متاحة', style: pw.TextStyle(fontSize: 20)),
//         ),
//       ),
//     );
//   } else {
//     // Add the table to the PDF
//     pdf.addPage(
//       pw.Page(
//         theme: pw.ThemeData.withFont(base: arabicFont),
//         textDirection: pw.TextDirection.rtl,
//         margin: const pw.EdgeInsets.all(16),
//         build: (context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Text(
//                 'بيان بجميع المصروفات',
//                 style: pw.TextStyle(fontSize: 18, ),
//               ),
//               pw.SizedBox(height: 20),
//               pw.Container(
//                 child: pw.Table(
//                   border: pw.TableBorder.all(),
//                   columnWidths: {
//                     0: pw.FlexColumnWidth(1),
//                     1: pw.FlexColumnWidth(2),
//                     2: pw.FlexColumnWidth(1),
//                     3: pw.FlexColumnWidth(2),
//                     4: pw.FlexColumnWidth(2),
//                     5: pw.FlexColumnWidth(1),
//                   },
//                   children: [
//                     // Header Row
//                     pw.TableRow(
//                       decoration: pw.BoxDecoration(color: PdfColors.grey300),
//                       children: [
//                         _tableHeaderCell('الخزينة'),
//                         _tableHeaderCell('الوصف'),
//                         _tableHeaderCell('المبلغ'),
//                         _tableHeaderCell('اسم المستخدم'),
//                         _tableHeaderCell('التاريخ'),
//                         _tableHeaderCell('المسلسل'),
//                       ],
//                     ),
//                     // Data Rows
//                     ...payments.map((payment) {
//                       return pw.TableRow(
//                         children: [
//                           _tableCell(payment['vault_name'] ?? 'لا يوجد اسم خزينة'),
//                           _tableCell(payment['description'] ?? 'لا يوجد وصف'),
//                           _tableCell('${payment['amount'] ?? '0'}'),
//                           _tableCell(payment['userName'] ?? 'غير معروف'),
//                           _tableCell(
//                             payment['timestamp'] != null
//                                 ? DateFormat('dd/MM/yyyy').format(DateTime.parse(payment['timestamp']))
//                                 : 'غير معروف',
//                           ),
//                           _tableCell('${payment['id'] ?? ''}'),
//                         ],
//                       );
//                     }).toList(),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   // Generate PDF
//   await Printing.layoutPdf(
//     onLayout: (PdfPageFormat format) async => pdf.save(),
//   );
// }
//
// // Helper function for table header cell
// pw.Widget _tableHeaderCell(String text) {
//   return pw.Padding(
//     padding: const pw.EdgeInsets.all(8),
//     child: pw.Text(text,),
//   );
// }
//
// // Helper function for table data cell
// pw.Widget _tableCell(String text) {
//   return pw.Padding(
//     padding: const pw.EdgeInsets.all(8),
//     child: pw.Text(text),
//   );
// }

import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> generateallPaymentDetailsPdf(List<Map<String, dynamic>> payments) async {
  final pdf = pw.Document();

  // Load Arabic font
  final fontData = await rootBundle.load("assets/font/Amiri-Regular.ttf");
  final arabicFont = pw.Font.ttf(fontData);

  // Debug payments data
  print('Payments Data: $payments');

  // Helper for header cell
  pw.Widget tableHeaderCell(String text) => pw.Padding(
    padding: const pw.EdgeInsets.all(4),
    child: pw.Text(text, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: arabicFont)),
  );

  // Helper for data cell
  pw.Widget tableCell(String text) => pw.Padding(
    padding: const pw.EdgeInsets.all(4),
    child: pw.Text(text, style: pw.TextStyle(font: arabicFont)),
  );

  if (payments.isEmpty) {
    pdf.addPage(
      pw.Page(
        theme: pw.ThemeData.withFont(base: arabicFont),
        textDirection: pw.TextDirection.rtl,
        build: (context) => pw.Center(
          child: pw.Text('لا توجد بيانات متاحة', style: pw.TextStyle(fontSize: 20, font: arabicFont)),
        ),
      ),
    );
  } else {
    // Build header row
    final headerRow = pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.grey300),
      children: [
        tableHeaderCell('الخزينة'),
        tableHeaderCell('الوصف'),
        tableHeaderCell('المبلغ'),
        tableHeaderCell('اسم المستخدم'),
        tableHeaderCell('التاريخ'),
        tableHeaderCell('المسلسل'),
      ],
    );

    // Build data rows
    final dataRows = payments.map((payment) {
      String formattedDate = 'غير معروف';
      if (payment['timestamp'] != null) {
        try {
          formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.parse(payment['timestamp']));
        } catch (e) {
          print('Date parse error: $e');
        }
      }

      return pw.TableRow(
        children: [
          tableCell(payment['vault_name'] ?? 'لا يوجد'),
          tableCell(payment['description'] ?? 'لا يوجد وصف'),
          tableCell('${payment['amount'] ?? '0'}'),
          tableCell(payment['userName'] ?? 'غير معروف'),
          tableCell(formattedDate),
          tableCell('${payment['id'] ?? ''}'),
        ],
      );
    }).toList();

    // Pagination: split dataRows into chunks per page
    const rowsPerPage = 20;
    final totalPages = (dataRows.length / rowsPerPage).ceil();

    for (var i = 0; i < totalPages; i++) {
      final chunk = dataRows.skip(i * rowsPerPage).take(rowsPerPage).toList();

      pdf.addPage(
        pw.Page(
          theme: pw.ThemeData.withFont(base: arabicFont),
          textDirection: pw.TextDirection.rtl,
          pageFormat: PdfPageFormat.a4.portrait, // landscape for wide tables
          margin: const pw.EdgeInsets.all(16),
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('بيان بجميع المصروفات', style: pw.TextStyle(fontSize: 18, font: arabicFont)),
                pw.SizedBox(height: 10),
                pw.Table(
                  border: pw.TableBorder.all(),
                  defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                  columnWidths: {
                    0: pw.FlexColumnWidth(1),
                    1: pw.FlexColumnWidth(2),
                    2: pw.FlexColumnWidth(1),
                    3: pw.FlexColumnWidth(2),
                    4: pw.FlexColumnWidth(2),
                    5: pw.FlexColumnWidth(1),
                  },
                  children: [headerRow, ...chunk],
                ),
                pw.SizedBox(height: 10),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text('صفحة ${i + 1} من $totalPages', style: pw.TextStyle(font: arabicFont)),
                ),
              ],
            );
          },
        ),
      );
    }
  }

  // Generate and display PDF
  await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
}
