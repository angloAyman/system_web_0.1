// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
//
// Future<void> createPDF(Map<String, dynamic> paymentDetails) async {
//   final pdf = pw.Document();
//   final fontData = await rootBundle.load("assets/font/Amiri-Regular.ttf");
//   final arabicFont = pw.Font.ttf(fontData);
//
//   pdf.addPage(
//     pw.Page(
//       theme: pw.ThemeData.withFont(base: arabicFont),
//       textDirection: pw.TextDirection.rtl,
//       build: (pw.Context context) {
//         return pw.Padding(
//           padding: pw.EdgeInsets.all(16),
//           child: pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Text('إيصال دفع', style: pw.TextStyle(fontSize: 24,)),
//               pw.Divider(thickness: 2),
//               pw.SizedBox(height: 16),
//               pw.Text('اسم العميل: ${paymentDetails['customerName']}', style: pw.TextStyle(fontSize: 14)),
//               pw.Text('رقم الفاتورة: ${paymentDetails['billId']}', style: pw.TextStyle(fontSize: 14)),
//               pw.Text('التاريخ: ${paymentDetails['date']}', style: pw.TextStyle(fontSize: 14)),
//               pw.Text('رقم الخزنة: ${paymentDetails['vault_id'] ?? 'غير متوفر'}', style: pw.TextStyle(fontSize: 14)),
//               pw.Text('المبلغ المدفوع: ${paymentDetails['payment']} جنيه', style: pw.TextStyle(fontSize: 14)),
//               pw.Text('المستخدم: ${paymentDetails['userName'] ?? 'غير معروف'}', style: pw.TextStyle(fontSize: 14)),
//               pw.SizedBox(height: 16),
//               pw.Divider(thickness: 2),
//               pw.Text('تفاصيل الفاتورة', style: pw.TextStyle(fontSize: 18,)),
//               pw.SizedBox(height: 8),
//               pw.Text('إجمالي السعر: ${paymentDetails['totalPrice']} جنيه', style: pw.TextStyle(fontSize: 14)),
//               pw.Text('إجمالي المدفوع: ${paymentDetails['totalPayment']} جنيه', style: pw.TextStyle(fontSize: 14)),
//               pw.Text('الرصيد المتبقي: ${paymentDetails['remaining']} جنيه', style: pw.TextStyle(fontSize: 14)),
//               pw.SizedBox(height: 16),
//               pw.Text('وصف الفاتورة: ${paymentDetails['description'] ?? 'لا يوجد وصف'}', style: pw.TextStyle(fontSize: 14)),
//               pw.SizedBox(height: 16),
//               pw.Divider(thickness: 2),
//               pw.Text('شكراً لتعاملكم معنا!', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.green)),
//             ],
//           ),
//         );
//       },
//     ),
//   );
//
//   // Save or share the PDF
//   await Printing.layoutPdf(
//     onLayout: (PdfPageFormat format) async => pdf.save(),
//   );
// }
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> createPDF(Map<String, dynamic> paymentDetails,String customerName,DateTime billDate,double total_price,totalPayments,remainingAmount) async {
  final pdf = pw.Document();

  // Load Arabic font
  final fontData = await rootBundle.load("assets/font/Amiri-Regular.ttf");
  final arabicFont = pw.Font.ttf(fontData);

  // Format dates
  final dateFormatter = DateFormat('dd/MM/yy');
  final formattedBillDate = dateFormatter.format(billDate);
  final formattedPaymentDate =
  dateFormatter.format(DateTime.parse(paymentDetails['date']));

  // Create PDF Page
  pdf.addPage(
    pw.Page(
      theme: pw.ThemeData.withFont(base: arabicFont),
      textDirection: pw.TextDirection.rtl,
      build: (pw.Context context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(16),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Text('إيصال دفع', style: pw.TextStyle(fontSize: 24,)),
              pw.Divider(thickness: 2),
              pw.SizedBox(height: 16),

              // Payment Details
              pw.Text('اسم العميل: ${customerName}', style: const pw.TextStyle(fontSize: 14)),
              pw.Text('رقم الفاتورة: ${paymentDetails['bill_id']}', style: const pw.TextStyle(fontSize: 14)),
              pw.Text(' التاريخ الفاتورة: $formattedBillDate', style: const pw.TextStyle(fontSize: 14)),
              // pw.Text('رقم الخزنة: ${paymentDetails['vault_id'] ?? 'غير متوفر'}', style: const pw.TextStyle(fontSize: 14)),
              pw.Text('المبلغ المدفوع: ${paymentDetails['payment']} جنيه', style: const pw.TextStyle(fontSize: 14)),
              pw.Text('التاريخ الدفع: $formattedPaymentDate ', style: const pw.TextStyle(fontSize: 14)),
              pw.Text('المستخدم: ${paymentDetails['users']['name'] ?? 'غير معروف'}', style: const pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 16),
              pw.Divider(thickness: 2),

              // Bill Details
              pw.Text('تفاصيل الفاتورة', style: pw.TextStyle(fontSize: 18,)),
              pw.SizedBox(height: 8),
              pw.Text('إجمالي سعر الفاتورة : ${total_price} جنيه', style: const pw.TextStyle(fontSize: 14)),
              pw.Text('إجمالي المدفوع: $totalPayments جنيه', style: const pw.TextStyle(fontSize: 14)),
              pw.Text('المبلغ المتبقي: $remainingAmount جنيه', style: const pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 16),
              // pw.Text('وصف الفاتورة: ${paymentDetails['description'] ?? 'لا يوجد وصف'}', style: const pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 16),

              // Footer
              pw.Divider(thickness: 2),
              pw.Text('شكراً لتعاملكم معنا!',
                  style: pw.TextStyle(
                      fontSize: 14,
                      color: PdfColors.green)),
            ],
          ),
        );
      },
    ),
  );

  // Generate PDF
  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}
