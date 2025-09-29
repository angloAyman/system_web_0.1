import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> generatePaymentDetailsPdf(List<Map<String, dynamic>> payments, String vaultName) async {
  final pdf = pw.Document();

  // Load Arabic font
  final fontData = await rootBundle.load("assets/font/Amiri-Regular.ttf");
  final arabicFont = pw.Font.ttf(fontData);


  // Add the table to the PDF
  pdf.addPage(
    pw.Page(
      theme: pw.ThemeData.withFont(base: arabicFont),
      textDirection: pw.TextDirection.rtl,
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'تفاصيل المدفوعات للخزنة: $vaultName',
              style: pw.TextStyle(fontSize: 18, ),
            ),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                // Header Row
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('الوصف', ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('المبلغ',),
                    ),

                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('اسم المستخدم', ),
                    ),


                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('التاريخ', ),
                    ),

                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('المسلسل', ),
                    ),




                  ],
                ),
                // Data Rows
                ...payments.map((payment) {
                  return pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(payment['description'] ?? 'لا يوجد وصف'),
                      ),

                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('${payment['amount']}'),
                      ),


                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(payment['userName'] ?? 'غير معروف'),
                      ),


                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          payment['timestamp'] != null
                              ? DateFormat('dd/MM/yyyy').format(DateTime.parse(payment['timestamp']))
                              : 'غير معروف',
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('${payment['id']}'),
                      ),




                    ],
                  );
                }).toList(),
              ],
            ),
          ],
        );
      },
    ),
  );

  // // Save the PDF to a file
  // final output = await getTemporaryDirectory();
  // final file = File('${output.path}/payment_details_$vaultName.pdf');
  // await file.writeAsBytes(await pdf.save());
  //
  // print('PDF saved at: ${file.path}');

  // Generate PDF
  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );

}
