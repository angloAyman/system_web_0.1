// // import 'package:flutter/services.dart';
// // import 'package:pdf/pdf.dart';
// // import 'package:pdf/widgets.dart' as pw;
// // import 'package:printing/printing.dart';
// // import 'package:system/features/billes/data/models/bill_model.dart';
// //
// // class PdfService {
// //   // وظيفة لتوليد PDF
// //   static Future<void> generatePdf(Bill bill) async {
// //     final pdf = pw.Document();
// //     final fontData = await rootBundle.load("assets/font/Amiri-Regular.ttf");
// //     // final boldfontData = await rootBundle.load("assets/font/Amiri-Bold.ttf");
// //     final arabicFont = pw.Font.ttf(fontData);
// //     // تحميل الشعار
// //     final logoImageData = await rootBundle.load('assets/logo/logo-1.jpeg'); // مسار الشعار
// //     final logoImage = pw.MemoryImage(logoImageData.buffer.asUint8List());
// //
// //     // إضافة محتوى الفاتورة إلى PDF
// //     pdf.addPage(
// //       pw.Page(
// //         theme: pw.ThemeData.withFont(
// //           base: arabicFont,
// //         ),
// //         textDirection: pw.TextDirection.rtl, // للكتابة من اليمين إلى اليسار
// //         pageFormat: PdfPageFormat.a4,
// //         build: (context) => pw.Column(
// //           crossAxisAlignment: pw.CrossAxisAlignment.start,
// //           children: [
// //             pw.Text(
// //               'فاتورة رقم: ${bill.id}',
// //               style: pw.TextStyle(
// //                   fontSize: 20,
// //                   // fontWeight: pw.FontWeight.bold
// //               ),
// //             ),
// //             pw.SizedBox(height: 8),
// //             pw.Text('اسم العميل: ${bill.customerName}'),
// //             pw.Text('التاريخ: ${bill.date}'),
// //             pw.Text('حالة الدفع: ${bill.status}'),
// //             pw.SizedBox(height: 16),
// //             pw.Text('الأصناف:', style: pw.TextStyle(fontSize: 18,
// //                 // fontWeight: pw.FontWeight.bold
// //             )),
// //             pw.Table.fromTextArray(
// //               headers: ['الصنف', 'الكمية', 'السعر', 'الإجمالي'],
// //               data: bill.items.map((item) {
// //                 return [
// //                   '${item.categoryName} / ${item.subcategoryName}',
// //                   item.amount.toString(),
// //                   item.price_per_unit.toString(),
// //                   (item.amount * item.price_per_unit).toStringAsFixed(2),
// //                 ];
// //               }).toList(),
// //             ),
// //             pw.Divider(),
// //             pw.Text(
// //               'الإجمالي: L.E ${bill.items.fold(0.0, (sum, item) => sum + (item.amount * item.price_per_unit)).toStringAsFixed(2)}',
// //               style: pw.TextStyle(fontSize: 16,
// //                   // fontWeight: pw.FontWeight.bold
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //
// //     // معاينة أو مشاركة ملف PDF
// //     await Printing.layoutPdf(
// //       onLayout: (format) async => pdf.save(),
// //     );
// //   }
// // }
//
// // import 'dart:typed_data';
// // import 'package:flutter/services.dart';
// // import 'package:pdf/pdf.dart';
// // import 'package:pdf/widgets.dart' as pw;
// // import 'package:system/features/billes/data/models/bill_model.dart';
// //
// // class PdfService {
// //   static Future<pw.Document> createPdfDocument(Bill bill) async {
// //     final pdf = pw.Document();
// //     final fontData = await rootBundle.load("assets/font/Amiri-Regular.ttf");
// //     final arabicFont = pw.Font.ttf(fontData);
// //
// //     final logoImageData = await rootBundle.load('assets/logo/logo-1.jpeg');
// //     final logoImage = pw.MemoryImage(logoImageData.buffer.asUint8List());
// //
// //     pdf.addPage(
// //       pw.Page(
// //         theme: pw.ThemeData.withFont(base: arabicFont),
// //         textDirection: pw.TextDirection.rtl,
// //         pageFormat: PdfPageFormat.a4,
// //         build: (context) => pw.Column(
// //           crossAxisAlignment: pw.CrossAxisAlignment.start,
// //           children: [
// //             pw.Image(logoImage, height: 50),
// //             pw.Text(
// //               'فاتورة رقم: ${bill.id}',
// //               style: pw.TextStyle(fontSize: 20),
// //             ),
// //             pw.SizedBox(height: 8),
// //             pw.Text('اسم العميل: ${bill.customerName}'),
// //             pw.Text('التاريخ: ${bill.date}'),
// //             pw.Text('حالة الدفع: ${bill.status}'),
// //             pw.SizedBox(height: 16),
// //             pw.Text('الأصناف:', style: pw.TextStyle(fontSize: 18)),
// //             pw.Table.fromTextArray(
// //               headers: ['الصنف', 'الكمية', 'السعر', 'الإجمالي'],
// //               data: bill.items.map((item) {
// //                 return [
// //                   '${item.categoryName} / ${item.subcategoryName}',
// //                   item.amount.toString(),
// //                   item.price_per_unit.toString(),
// //                   (item.amount * item.price_per_unit).toStringAsFixed(2),
// //                 ];
// //               }).toList(),
// //             ),
// //             pw.Divider(),
// //             pw.Text(
// //               'الإجمالي: L.E ${bill.items.fold(0.0, (sum, item) => sum + (item.amount * item.price_per_unit)).toStringAsFixed(2)}',
// //               style: pw.TextStyle(fontSize: 16),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //
// //     return pdf;
// //   }
// // }
// // // dart:typed_data';
// // import 'package:flutter/services.dart';
// // import 'package:pdf/pdf.dart';
// // import 'package:pdf/widgets.dart' as pw;
// // import 'package:system/features/billes/data/models/bill_model.dart';
// //
// // class PdfService {
// //   static Future<pw.Document> createPdfDocument(Bill bill) async {
// //     final pdf = pw.Document();
// //     final fontData = await rootBundle.load("assets/font/Amiri-Regular.ttf");
// //     final arabicFont = pw.Font.ttf(fontData);
// //
// //     final logoImageData = await rootBundle.load('assets/logo/logo-3.png');
// //     final logoImage = pw.MemoryImage(logoImageData.buffer.asUint8List());
// //
// //     pdf.addPage(
// //       pw.Page(
// //         theme: pw.ThemeData.withFont(base: arabicFont),
// //         textDirection: pw.TextDirection.rtl,
// //         pageFormat: PdfPageFormat.a4,
// //         build: (context) => pw.Column(
// //           crossAxisAlignment: pw.CrossAxisAlignment.start,
// //           children: [
// //         pw.Row(
// //         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
// //           children: [
// //             pw.Image(logoImage, height: 100),
// //             pw.Text(
// //               'فاتورة ',
// //               style: pw.TextStyle(fontSize: 20),
// //             ),
// //           ]),
// //             pw.Text(
// //               'فاتورة رقم: ${bill.id}',
// //               style: pw.TextStyle(fontSize: 20),
// //             ),
// //             pw.SizedBox(height: 8),
// //             pw.Text('اسم العميل: ${bill.customerName}'),
// //             pw.Text('التاريخ: ${bill.date}'),
// //             pw.Text('حالة الدفع: ${bill.status}'),
// //             pw.SizedBox(height: 16),
// //             pw.Text('الأصناف:', style: pw.TextStyle(fontSize: 18)),
// //             pw.Table(
// //               border: pw.TableBorder.all(),
// //               columnWidths: {
// //                 4: pw.FlexColumnWidth(3), // عرض أكبر لاسم الصنف
// //                 1: pw.FlexColumnWidth(2),
// //                 2: pw.FlexColumnWidth(1),
// //                 3: pw.FlexColumnWidth(1),
// //                 0: pw.FlexColumnWidth(2),
// //               },
// //               children: [
// //                 // الصف العلوي (رؤوس الأعمدة)
// //                 pw.TableRow(
// //                   children: [
// //                     //الجمالي
// //                     pw.Padding(
// //                       padding: const pw.EdgeInsets.all(4),
// //                       child: pw.Text('الإجمالي', textDirection: pw.TextDirection.rtl),
// //                     ),
// //
// //                     pw.Padding(
// //                       padding: const pw.EdgeInsets.all(4),
// //                       child: pw.Text(' سعر الوحدة', textDirection: pw.TextDirection.rtl),
// //                     ),
// //                     pw.Padding(
// //                       padding: const pw.EdgeInsets.all(4),
// //                       child: pw.Text('الكمية', textDirection: pw.TextDirection.rtl),
// //                     ),
// //
// //                     pw.Padding(
// //                       padding: const pw.EdgeInsets.all(4),
// //                       child: pw.Text('الوصف', textDirection: pw.TextDirection.rtl),
// //                     ),
// //                     //الصنف
// //                     pw.Padding(
// //                       padding: const pw.EdgeInsets.all(4),
// //                       child: pw.Text('الصنف', textDirection: pw.TextDirection.rtl),
// //                     ),
// //                   ],
// //                 ),
// //                 // صفوف البيانات
// //                 ...bill.items.map((item) {
// //                   return pw.TableRow(
// //                     children: [
// //                       //الجمالي
// //                       pw.Padding(
// //                         padding: const pw.EdgeInsets.all(4),
// //                         child: pw.Text(
// //                           (item.amount * item.price_per_unit).toStringAsFixed(2),
// //                           textDirection: pw.TextDirection.rtl,
// //                         ),
// //                       ),
// //                       // سعر الوحدة
// //                       pw.Padding(
// //                         padding: const pw.EdgeInsets.all(4),
// //                         child: pw.Text(
// //                           item.price_per_unit.toString(),
// //                           textDirection: pw.TextDirection.rtl,
// //                         ),
// //                       ),
// //                       //الكمية
// //                       pw.Padding(
// //                         padding: const pw.EdgeInsets.all(4),
// //                         child: pw.Text(
// //                           item.amount.toString(),
// //                           textDirection: pw.TextDirection.rtl,
// //                         ),
// //                       ),
// //
// //                       //الوصف
// //                       pw.Padding(
// //                         padding: const pw.EdgeInsets.all(4),
// //                         child: pw.Text(
// //                           item.description,
// //                           textDirection: pw.TextDirection.rtl,
// //                         ),
// //                       ),
// //                       //الصنف
// //                       pw.Padding(
// //                         padding: const pw.EdgeInsets.all(4),
// //                         child: pw.Text(
// //                           '${item.categoryName} / ${item.subcategoryName}',
// //                           textDirection: pw.TextDirection.rtl,
// //                         ),
// //                       ),
// //                     ],
// //                   );
// //                 }).toList(),
// //               ],
// //             ),
// //             pw.Divider(),
// //             pw.Text(
// //               'الإجمالي: L.E ${bill.items.fold(0.0, (sum, item) => sum + (item.amount * item.price_per_unit)).toStringAsFixed(2)}',
// //               style: pw.TextStyle(fontSize: 16),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //     return pdf;
// //   }
// // }
//
//
// // import 'dart:typed_data';
// // import 'package:flutter/services.dart';
// // import 'package:pdf/pdf.dart';
// // import 'package:pdf/widgets.dart' as pw;
// // import 'package:qr_flutter/qr_flutter.dart';
// // import 'package:flutter/rendering.dart';
// // import 'dart:ui' as ui;
// // import 'package:system/features/billes/data/models/bill_model.dart';
// //
// // class PdfService {
// //   static Future<pw.Document> createPdfDocument(Bill bill) async {
// //     final pdf = pw.Document();
// //
// //     // Load Arabic Font
// //     final fontData = await rootBundle.load("assets/font/Amiri-Regular.ttf");
// //     final arabicFont = pw.Font.ttf(fontData);
// //
// //     // Load Logo
// //     final logoImageData = await rootBundle.load('assets/logo/logo-3.png');
// //     final logoImage = pw.MemoryImage(logoImageData.buffer.asUint8List());
// //
// //     // Generate QR Code Image
// //     final qrCodeImage = await _generateQrCodeImage(bill.id.toString());
// //
// //     pdf.addPage(
// //       pw.Page(
// //         theme: pw.ThemeData.withFont(base: arabicFont),
// //         textDirection: pw.TextDirection.rtl,
// //         pageFormat: PdfPageFormat.a4,
// //         build: (context) => pw.Column(
// //           crossAxisAlignment: pw.CrossAxisAlignment.start,
// //           children: [
// //             pw.Row(
// //               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
// //               children: [
// //                 pw.Row(children: [
// //                   pw.Center(
// //                     child: pw.Column(
// //                       children: [
// //                         pw.Text(
// //                           'رمز الاستجابة السريع للفاتورة',
// //                           style: pw.TextStyle(fontSize: 10),
// //                         ),
// //                         if (qrCodeImage != null)
// //                           pw.Image(pw.MemoryImage(qrCodeImage), width: 80, height: 80),
// //                       ],
// //                     ),
// //                   ),
// //                 ]),
// //                 pw.Text(
// //                   'فاتورة',
// //                   style: pw.TextStyle(fontSize: 30),
// //                 ),
// //                 pw.Image(logoImage, height: 110),
// //
// //               ],
// //             ),
// //             pw.Text(
// //               'فاتورة رقم: ${bill.id}',
// //               style: pw.TextStyle(fontSize: 20),
// //             ),
// //             pw.SizedBox(height: 8),
// //             pw.Text('اسم العميل: ${bill.customerName}'),
// //             pw.Text('التاريخ: ${bill.date}'),
// //             pw.Text('حالة الدفع: ${bill.status}'),
// //             pw.SizedBox(height: 16),
// //             pw.Text('الأصناف:', style: pw.TextStyle(fontSize: 18)),
// //             pw.Table(
// //               border: pw.TableBorder.all(),
// //               columnWidths: {
// //                 0: pw.FlexColumnWidth(3),
// //                 1: pw.FlexColumnWidth(1),
// //                 2: pw.FlexColumnWidth(1),
// //                 3: pw.FlexColumnWidth(2),
// //                 // 4: pw.FlexColumnWidth(2),
// //               },
// //               children: [
// //                 pw.TableRow(
// //                   children: [
// //                     pw.Padding(
// //                       padding: const pw.EdgeInsets.all(4),
// //                       child: pw.Text('الإجمالي', textDirection: pw.TextDirection.rtl),
// //                     ),
// //                     pw.Padding(
// //                       padding: const pw.EdgeInsets.all(4),
// //                       child: pw.Text('سعر الوحدة', textDirection: pw.TextDirection.rtl),
// //                     ),
// //                     // pw.Padding(
// //                     //   padding: const pw.EdgeInsets.all(4),
// //                     //   child: pw.Text('الكمية', textDirection: pw.TextDirection.rtl),
// //                     // ),
// //                     pw.Padding(
// //                       padding: const pw.EdgeInsets.all(4),
// //                       child: pw.Text('الوصف', textDirection: pw.TextDirection.rtl),
// //                     ),
// //                     pw.Padding(
// //                       padding: const pw.EdgeInsets.all(4),
// //                       child: pw.Text('الصنف', textDirection: pw.TextDirection.rtl),
// //                     ),
// //                   ],
// //                 ),
// //                 ...bill.items.map((item) {
// //                   return pw.TableRow(
// //                     children: [
// //                       pw.Padding(
// //                         padding: const pw.EdgeInsets.all(4),
// //                         child: pw.Text(
// //                           (item.amount * item.price_per_unit).toStringAsFixed(2),
// //                           textDirection: pw.TextDirection.rtl,
// //                         ),
// //                       ),
// //                       pw.Padding(
// //                         padding: const pw.EdgeInsets.all(4),
// //                         child: pw.Text(
// //                           item.price_per_unit.toString(),
// //                           textDirection: pw.TextDirection.rtl,
// //                         ),
// //                       ),
// //                       // pw.Padding(
// //                       //   padding: const pw.EdgeInsets.all(4),
// //                       //   child: pw.Text(
// //                       //     item.amount.toString(),
// //                       //     textDirection: pw.TextDirection.rtl,
// //                       //   ),
// //                       // ),
// //                       pw.Padding(
// //                         padding: const pw.EdgeInsets.all(4),
// //                         child: pw.Text(
// //                           item.description,
// //                           textDirection: pw.TextDirection.rtl,
// //                         ),
// //                       ),
// //                       pw.Padding(
// //                         padding: const pw.EdgeInsets.all(4),
// //                         child: pw.Text(
// //                           '${item.categoryName} / ${item.subcategoryName}',
// //                           textDirection: pw.TextDirection.rtl,
// //                         ),
// //                       ),
// //                     ],
// //                   );
// //                 }).toList(),
// //               ],
// //             ),
// //             pw.Divider(),
// //             pw.Text(
// //               'الإجمالي: جنيه مصري فقط لا غير  ${bill.items.fold(0.0, (sum, item) => sum + (item.amount * item.price_per_unit)).toStringAsFixed(2)}',
// //               style: pw.TextStyle(fontSize: 16),
// //             ),
// //             pw.SizedBox(height: 20),
// //
// //           ],
// //         ),
// //       ),
// //     );
// //
// //     return pdf;
// //   }
// //
// //   // Generate QR Code as Uint8List
// //   static Future<Uint8List?> _generateQrCodeImage(String data) async {
// //     try {
// //       final qrValidationResult = QrValidator.validate(
// //         data: data,
// //         version: QrVersions.auto,
// //         errorCorrectionLevel: QrErrorCorrectLevel.H,
// //       );
// //
// //       if (qrValidationResult.status == QrValidationStatus.valid) {
// //         final painter = QrPainter.withQr(
// //           qr: qrValidationResult.qrCode!,
// //           color: const Color(0xFF000000),
// //           gapless: true,
// //         );
// //
// //         final picture = await painter.toImageData(200); // Adjust size if needed
// //         return picture?.buffer.asUint8List();
// //       }
// //     } catch (e) {
// //       print('Error generating QR code: $e');
// //     }
// //     return null;
// //   }
// // }
// import 'dart:typed_data';
// import 'package:flutter/services.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:flutter/rendering.dart';
// import 'dart:ui' as ui;
// import 'package:system/features/billes/data/models/bill_model.dart';
// import 'package:system/features/billes/presentation/pdf/services/pdf_storage_service.dart';
//
// class PdfService {
//   static Future<pw.Document> createBillWithQrCode(
//       Bill bill,
//       String pdfUrl,
//       Uint8List qrCodeData,
//       ) async {
//
//   final pdf = pw.Document();
//
//     // Load Arabic Font
//     final fontData = await rootBundle.load("assets/font/Amiri-Regular.ttf");
//     final arabicFont = pw.Font.ttf(fontData);
//
//     // Load Logo
//     final logoImageData = await rootBundle.load('assets/logo/logo-3.png');
//     final logoImage = pw.MemoryImage(logoImageData.buffer.asUint8List());
//
//
// //     // Upload PDF and generate public URL
// //     final pdfUrl = await PdfStorageService.uploadPdf(pdfFileName, pdfBytes);
// //
// // // Generate QR code for the PDF URL
// //     final qrCodeImage = await pdfStorageService.generateQrCode(pdfUrl);
//
// // Use `qrCodeData` to display the QR code in your app or include it in the PDF
//
//
//     // Generate QR Code Image
//     // final qrCodeImage = await _generateQrCodeImage(bill.id.toString());
//
//     pdf.addPage(
//       pw.Page(
//         theme: pw.ThemeData.withFont(base: arabicFont),
//         textDirection: pw.TextDirection.rtl,
//         pageFormat: PdfPageFormat.a4,
//         build: (context) => pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//                 pw.Row(children: [
//                   pw.Center(
//                     child: pw.Column(
//                       children: [
//              pw.Container(
//             width: 120,
//               height: 120,
//               child: pw.Image(
//                 pw.MemoryImage(qrCodeData),))
//                         // pw.Text(
//                         //   'رمز الاستجابة السريع للفاتورة',
//                         //   style: pw.TextStyle(fontSize: 10),
//                         // ),
//                         // if (qrCodeImage != null)
//                         //   pw.Image(pw.MemoryImage(qrCodeImage), width: 80, height: 80),
//                       ],
//                     ),
//                   ),
//                 ]),
//                 pw.Text(
//                   'فاتورة',
//                   style: pw.TextStyle(fontSize: 30),
//                 ),
//                 pw.Image(logoImage, height: 110),
//
//               ],
//             ),
//             pw.Text(
//               'فاتورة رقم: ${bill.id}',
//               style: pw.TextStyle(fontSize: 20),
//             ),
//             pw.SizedBox(height: 8),
//             pw.Text('اسم العميل: ${bill.customerName}'),
//             pw.Text('التاريخ: ${bill.date}'),
//             pw.Text('حالة الدفع: ${bill.status}'),
//             pw.SizedBox(height: 16),
//             pw.Text('الأصناف:', style: pw.TextStyle(fontSize: 18)),
//             pw.Table(
//               border: pw.TableBorder.all(),
//               columnWidths: {
//                 0: pw.FlexColumnWidth(3),
//                 1: pw.FlexColumnWidth(1),
//                 2: pw.FlexColumnWidth(1),
//                 3: pw.FlexColumnWidth(2),
//                 // 4: pw.FlexColumnWidth(2),
//               },
//               children: [
//                 pw.TableRow(
//                   children: [
//                     pw.Padding(
//                       padding: const pw.EdgeInsets.all(4),
//                       child: pw.Text('الإجمالي', textDirection: pw.TextDirection.rtl),
//                     ),
//                     pw.Padding(
//                       padding: const pw.EdgeInsets.all(4),
//                       child: pw.Text('سعر الوحدة', textDirection: pw.TextDirection.rtl),
//                     ),
//                     // pw.Padding(
//                     //   padding: const pw.EdgeInsets.all(4),
//                     //   child: pw.Text('الكمية', textDirection: pw.TextDirection.rtl),
//                     // ),
//                     pw.Padding(
//                       padding: const pw.EdgeInsets.all(4),
//                       child: pw.Text('الوصف', textDirection: pw.TextDirection.rtl),
//                     ),
//                     pw.Padding(
//                       padding: const pw.EdgeInsets.all(4),
//                       child: pw.Text('الصنف', textDirection: pw.TextDirection.rtl),
//                     ),
//                   ],
//                 ),
//                 ...bill.items.map((item) {
//                   return pw.TableRow(
//                     children: [
//                       pw.Padding(
//                         padding: const pw.EdgeInsets.all(4),
//                         child: pw.Text(
//                           (item.amount * item.price_per_unit).toStringAsFixed(2),
//                           textDirection: pw.TextDirection.rtl,
//                         ),
//                       ),
//                       pw.Padding(
//                         padding: const pw.EdgeInsets.all(4),
//                         child: pw.Text(
//                           item.price_per_unit.toString(),
//                           textDirection: pw.TextDirection.rtl,
//                         ),
//                       ),
//                       // pw.Padding(
//                       //   padding: const pw.EdgeInsets.all(4),
//                       //   child: pw.Text(
//                       //     item.amount.toString(),
//                       //     textDirection: pw.TextDirection.rtl,
//                       //   ),
//                       // ),
//                       pw.Padding(
//                         padding: const pw.EdgeInsets.all(4),
//                         child: pw.Text(
//                           item.description,
//                           textDirection: pw.TextDirection.rtl,
//                         ),
//                       ),
//                       pw.Padding(
//                         padding: const pw.EdgeInsets.all(4),
//                         child: pw.Text(
//                           '${item.categoryName} / ${item.subcategoryName}',
//                           textDirection: pw.TextDirection.rtl,
//                         ),
//                       ),
//                     ],
//                   );
//                 }).toList(),
//               ],
//             ),
//             pw.Divider(),
//             pw.Text(
//               'الإجمالي: جنيه مصري فقط لا غير  ${bill.items.fold(0.0, (sum, item) => sum + (item.amount * item.price_per_unit)).toStringAsFixed(2)}',
//               style: pw.TextStyle(fontSize: 16),
//             ),
//             pw.SizedBox(height: 20),
//
//           ],
//         ),
//       ),
//     );
//
//     return pdf;
//   }
//
//   // Generate QR Code as Uint8List
//   static Future<Uint8List?> _generateQrCodeImage(String data) async {
//     try {
//       final qrValidationResult = QrValidator.validate(
//         data: data,
//         version: QrVersions.auto,
//         errorCorrectionLevel: QrErrorCorrectLevel.H,
//       );
//
//       if (qrValidationResult.status == QrValidationStatus.valid) {
//         final painter = QrPainter.withQr(
//           qr: qrValidationResult.qrCode!,
//           color: const Color(0xFF000000),
//           gapless: true,
//         );
//
//         final picture = await painter.toImageData(200); // Adjust size if needed
//         return picture?.buffer.asUint8List();
//       }
//     } catch (e) {
//       print('Error generating QR code: $e');
//     }
//     return null;
//   }
// }
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:system/features/billes/data/models/bill_model.dart';

class PdfService {
  /// Creates a PDF document for the given bill without embedding a QR code.
  static Future<pw.Document> createBillWithoutQrCode(Bill bill) async {
    final pdf = pw.Document();

    final fontData = await rootBundle.load("assets/font/Amiri-Regular.ttf");
    final arabicFont = pw.Font.ttf(fontData);

    // Load Logo
    final logoImageData = await rootBundle.load('assets/logo/logo-3.png');
    final logoImage = pw.MemoryImage(logoImageData.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        theme: pw.ThemeData.withFont(base: arabicFont),
        textDirection: pw.TextDirection.rtl,
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [

              // Header Section
              pw.Text(
                'فاتورة',
                style: pw.TextStyle(
                  fontSize: 24,
                  // fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Image(logoImage, height: 110,),

              // Bill Details
              pw.Text('رقم الفاتورة: ${bill.id}'),
              pw.Text('التاريخ: ${bill.date}'),
              pw.Text('اسم العميل: ${bill.customerName}'),
              pw.SizedBox(height: 16),

              // Items Table
              _buildItemsTable(bill),

              // Total Section
              pw.SizedBox(height: 32),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    'الإجمالي: ',
                    style: pw.TextStyle(
                      fontSize: 14,
                      // fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    '${_calculateTotal(bill)}',
                    style: pw.TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  /// Creates a PDF document for the given bill with an embedded QR code for the provided URL.
  static Future<pw.Document> createBillWithQrCode(
      Bill bill, String pdfUrl, ByteData qrCodeImage) async {
    final pdf = pw.Document();

    final fontData = await rootBundle.load("assets/font/Amiri-Regular.ttf");
    final arabicFont = pw.Font.ttf(fontData);
//
    final logoImageData = await rootBundle.load('assets/logo/logo-3.png');
    final logoImage = pw.MemoryImage(logoImageData.buffer.asUint8List());

    final qrCodeImageData = qrCodeImage.buffer.asUint8List();


    pdf.addPage(
      pw.Page(
        theme: pw.ThemeData.withFont(base: arabicFont),
        textDirection: pw.TextDirection.rtl,
        pageFormat: PdfPageFormat.a4,
        // pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header Section with QR Code
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(logoImage, height: 110),

                  pw.Text(
                    'فاتورة',
                    style: pw.TextStyle(
                      fontSize: 24,
                      // fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Container(
                    width: 100,
                    height: 100,
                    child:
                        // pw.Image(qrCodeImage),
                        pw.Image(pw.MemoryImage(qrCodeImageData),
                            width: 80, height: 80),
                  ),
                ],
              ),
              pw.SizedBox(height: 16),

              // Bill Details
              pw.Text('رقم الفاتورة: ${bill.id}'),
              pw.Text('التاريخ: ${bill.date.year} / ${ bill.date.month} / ${bill.date.day}'),
              pw.Text('اسم العميل: ${bill.customerName}'),
              pw.SizedBox(height: 16),

              // Items Table
              _buildItemsTable(bill),

              // Total Section
              pw.SizedBox(height: 32),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
          pw.Text(
          'اجالي الفاتورة: ',
          style: pw.TextStyle(
          fontSize: 14,
          // fontWeight: pw.FontWeight.bold,
          ),
          ),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [

                  pw.Text(
                    '${_calculateTotal(bill)}',
                    style: pw.TextStyle(fontSize: 14),
                  ),
                  pw.Text(
                    'جنيه مصري فقط لا غير ',
                    style: pw.TextStyle(
                      fontSize: 14,
                      // fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
        ])
            ],
          );
        },
      ),
    );

    return pdf;
  }

  /// Builds a table of items for the bill.

  static pw.Widget _buildItemsTable(Bill bill) {
    return pw.Table(
      border: pw.TableBorder.all(),
      columnWidths: {
        0: pw.FlexColumnWidth(1),
        1: pw.FlexColumnWidth(1),
        // 2: pw.FlexColumnWidth(1),
        2: pw.FlexColumnWidth(1),
        3: pw.FlexColumnWidth(1),
        4: pw.FlexColumnWidth(2),
        // 6: pw.FlexColumnWidth(2),
      },
      children: [
        // Table Header
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            // 1 الاجمالي
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text(
                'الإجمالي',
                textAlign: pw.TextAlign.center,
                // style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),

            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text(
                'الخصم (%)',
                textAlign: pw.TextAlign.center,
                // style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),

            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text(
                'الكمية',
                textAlign: pw.TextAlign.center,
                // style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),


            // السعر القطعة
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text(
                'السعر القطعة',
                textAlign: pw.TextAlign.center,
                // style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            // // سعر الوحدة
            // pw.Padding(
            //   padding: const pw.EdgeInsets.all(8.0),
            //   child: pw.Text(
            //     'السعر للوحدة',
            //     textAlign: pw.TextAlign.center,
            //     // style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            //   ),
            // ),
           // الوصف
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text(
                'الوصف',
                textAlign: pw.TextAlign.center,
                // style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            // اسم العنصر الفرعي
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text(
                'اسم العنصر الفرعي',
                textAlign: pw.TextAlign.center,
                // style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            // اسم العنصر
            // pw.Padding(
            //   padding: const pw.EdgeInsets.all(8.0),
            //   child: pw.Text(
            //     'اسم العنصر',
            //     textAlign: pw.TextAlign.center,
            //     // style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            //   ),
            // ),
          ],
        ),
        // Table Rows for Items
        ...bill.items.map((item) {
          final total = _calculateItemTotal(
            amount: item.amount,
            pricePerUnit: item.price_per_unit,
            quantity: item.quantity,
            discount: item.discount,
          );
          return pw.TableRow(
            children: [
              //  الاجمالي
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(
                    // total.toStringAsFixed(2),
                    '${(total).toStringAsFixed(2)} جنيه مصري',

                    textAlign: pw.TextAlign.center),
              ),
              // خصم
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),

                child: pw.Text(
                    // item.discount.toString(),
                    '${(item.discount ).toStringAsFixed(2)} %',

                    textAlign: pw.TextAlign.center),
              ),
              //كمية
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(item.quantity.toString(), textAlign: pw.TextAlign.center),
              ),


// السعر القطعة
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                // DataCell(Text('\جنيه${(item.amount * item.price_per_unit)}')),

                child: pw.Text(
          '${(item.amount * item.price_per_unit).toStringAsFixed(2)} جنيه مصري',
                    textAlign: pw.TextAlign.center),
              ),
              // // سعر الوحدة
              // pw.Padding(
              //   padding: const pw.EdgeInsets.all(8.0),
              //   child: pw.Text(item.price_per_unit.toStringAsFixed(2), textAlign: pw.TextAlign.center),
              // ),

            //    الوصف
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(item.description, textAlign: pw.TextAlign.center),
              ),
              //    اسم العنصر الفرعي
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(item.subcategoryName, textAlign: pw.TextAlign.center),
              ),
              //   اسم العنصر
              // pw.Padding(
              //   padding: const pw.EdgeInsets.all(8.0),
              //   child: pw.Text(item.categoryName, textAlign: pw.TextAlign.center),
              // ),

            ],
          );
        }).toList(),
      ],
    );
  }

  static double _calculateItemTotal({
    required double amount,
    required double pricePerUnit,
    required double quantity,
    required double discount,
  }) {
    final subtotal = amount * pricePerUnit * quantity;
    final discountAmount = subtotal * (discount / 100);
    return subtotal - discountAmount;
  }

  static double _calculateTotal(Bill bill) {
    return bill.items.fold(0.0, (sum, item) {
      return sum + _calculateItemTotal(
        amount: item.amount,
        pricePerUnit: item.price_per_unit,
        quantity: item.quantity,
        discount: item.discount,
      );
    });
  }


// /// Calculates the total price of the bill.
  // static double _calculateTotal(Bill bill) {
  //   return bill.items.fold(0, (sum, item) => sum + bill.total_price);
  // }
}
