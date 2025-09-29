// // import 'dart:io';
// // import 'package:intl/intl.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:pdf/pdf.dart';
// // import 'package:pdf/widgets.dart' as pw;
// // import 'package:share_plus/share_plus.dart';
// //
// // Future<void> generatePaymentPdf(
// //     List<Map<String, dynamic>> payments, DateTime? startDate, DateTime? endDate, int totalAmount) async {
// //   final pdf = pw.Document();
// //
// //   // Format Date
// //   String formatDate(DateTime? date) {
// //     return date != null ? DateFormat('yyyy-MM-dd').format(date) : "N/A";
// //   }
// //
// //   // Calculate Total Payment Amount
// //   // int totalAmount = payments.fold<int>(
// //   //   0,
// //   //       (sum, item) => sum + (item['amount'] as num? ?? 0).toInt(),
// //   // );
// //
// //   // Add content to PDF
// //   pdf.addPage(
// //     pw.Page(
// //       pageFormat: PdfPageFormat.a4,
// //       build: (pw.Context context) {
// //         return pw.Column(
// //           crossAxisAlignment: pw.CrossAxisAlignment.start,
// //           children: [
// //             // Title
// //             pw.Center(
// //               child: pw.Text("Payment Report",
// //                   style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
// //             ),
// //             pw.SizedBox(height: 10),
// //
// //             // Date Range
// //             pw.Text("Report Period: ${formatDate(startDate)} to ${formatDate(endDate)}",
// //                 style: pw.TextStyle(fontSize: 12)),
// //             pw.SizedBox(height: 10),
// //
// //             // Table Headers
// //             pw.TableHelper.fromTextArray(
// //               headers: ['Date', 'Amount', 'Description', 'Vault Name', 'User Name'],
// //               data: payments.map((payment) {
// //                 return [
// //                   formatDate(DateTime.parse(payment['timestamp'])),
// //                   payment['amount'].toString(),
// //                   payment['description'] ?? 'N/A',
// //                   payment['vault_name'] ?? 'N/A',
// //                   payment['userName'] ?? 'N/A'
// //                 ];
// //               }).toList(),
// //               border: pw.TableBorder.all(),
// //               headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
// //               cellAlignment: pw.Alignment.centerLeft,
// //             ),
// //
// //             pw.SizedBox(height: 10),
// //
// //             // Total Amount
// //             pw.Text("Total Payments: \$${totalAmount.toStringAsFixed(2)}",
// //                 style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
// //           ],
// //         );
// //       },
// //     ),
// //   );
// //
// //   // Save PDF file
// //   final output = await getExternalStorageDirectory(); // Android storage
// //   final file = File("${output!.path}/Payment_Report_${formatDate(startDate)}.pdf");
// //   await file.writeAsBytes(await pdf.save());
// //
// //   // Share or Open PDF
// //   await Share.shareXFiles([XFile(file.path)], text: 'Here is the Payment Report PDF');
// // }
//
// // import 'dart:io';
// // import 'package:flutter/services.dart';
// // import 'package:intl/intl.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:pdf/pdf.dart';
// // import 'package:pdf/widgets.dart' as pw;
// // import 'package:share_plus/share_plus.dart';
// //
// // Future<void> generatePaymentPdf(
// //     List<Map<String, dynamic>> payments, DateTime? startDate, DateTime? endDate, int totalAmount) async {
// //   final pdf = pw.Document();
// //
// //   // Format Date
// //   String formatDate(DateTime? date) {
// //     return date != null ? DateFormat('yyyy-MM-dd').format(date) : "N/A";
// //   }
// //
// //   final fontData = await rootBundle.load("assets/font/Amiri-Regular.ttf");
// //   final arabicFont = pw.Font.ttf(fontData);
// //
// //   pdf.addPage(
// //     pw.Page(
// //       theme: pw.ThemeData.withFont(base: arabicFont),
// //       textDirection: pw.TextDirection.rtl,
// //       pageFormat: PdfPageFormat.a4,
// //       build: (pw.Context context) {
// //         return pw.Column(
// //           crossAxisAlignment: pw.CrossAxisAlignment.start,
// //           children: [
// //             // Title
// //             pw.Center(
// //               child: pw.Text("تقرير مصروفات",
// //                   style: pw.TextStyle(fontSize: 25, )),
// //             ),
// //             pw.SizedBox(height: 10),
// //
// //             // Date Range
// //             pw.Text("زمن التقرير: ${formatDate(startDate)} الي ${formatDate(endDate)}",
// //                 style: pw.TextStyle(fontSize: 12)),
// //             pw.SizedBox(height: 10),
// //
// //             // Table Headers & Data
// //             pw.TableHelper.fromTextArray(
// //               headers: ['تاريخ', 'المبلغ', 'الوصف', 'اسم الخزينة', 'اسم المستخدم'],
// //               data: payments.map((payment) {
// //                 String formattedDate = "N/A";
// //                 if (payment['timestamp'] != null) {
// //                   try {
// //                     formattedDate = formatDate(DateTime.parse(payment['timestamp']));
// //                   } catch (e) {
// //                     formattedDate = "Invalid Date";
// //                   }
// //                 }
// //
// //                 return [
// //                   formattedDate,
// //                   payment['amount'].toString(),
// //                   payment['description'] ?? 'N/A',
// //                   payment['vault_name'] ?? 'N/A',
// //                   payment['userName'] ?? 'N/A'
// //                 ];
// //               }).toList(),
// //               border: pw.TableBorder.all(),
// //               cellAlignment: pw.Alignment.center,
// //             ),
// //
// //             pw.SizedBox(height: 10),
// //
// //             // Total Amount
// //             pw.Text("اجمالي المصروفات: ${totalAmount.toString()}",
// //                 style: pw.TextStyle(fontSize: 16, )),
// //           ],
// //         );
// //       },
// //     ),
// //   );
// //
// //   // Get storage directory based on platform
// //   Directory? directory;
// //   if (Platform.isAndroid) {
// //     directory = await getExternalStorageDirectory(); // Android external storage
// //   } else if (Platform.isIOS || Platform.isMacOS) {
// //     directory = await getApplicationDocumentsDirectory(); // iOS/macOS safe storage
// //   } else if (Platform.isWindows) {
// //     directory = Directory('${Platform.environment['USERPROFILE']}\\Documents'); // Windows Documents folder
// //   } else {
// //     throw UnsupportedError("Unsupported platform");
// //   }
// //
// //   final filePath = "${directory!.path}/Payment_Report_${formatDate(startDate)}.pdf";
// //   final file = File(filePath);
// //   await file.writeAsBytes(await pdf.save());
// //
// //   // Open PDF and Print on Windows
// //   if (Platform.isWindows) {
// //     // Open the PDF file in the default viewer
// //     Process.start('explorer', [filePath]);
// //
// //     // Print the PDF file automatically
// //     Process.start('cmd', ['/c', 'print', filePath]);
// //   } else {
// //     // Share or Open PDF on other platforms
// //     await Share.shareXFiles([XFile(file.path)], text: 'Here is the Payment Report PDF');
// //   }
// // }
// //
// //
//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:share_plus/share_plus.dart';
//
// Future<void> generatePaymentPdf(
//     BuildContext context,
//     List<Map<String, dynamic>> payments, DateTime? startDate, DateTime? endDate, int totalAmount) async {
//   final pdf = pw.Document();
//
//   // Format Date
//   String formatDate(DateTime? date) {
//     return date != null ? DateFormat('yyyy-MM-dd').format(date) : "N/A";
//   }
//
//   final fontData = await rootBundle.load("assets/font/Amiri-Regular.ttf");
//   final arabicFont = pw.Font.ttf(fontData);
//
//   pdf.addPage(
//     pw.Page(
//       theme: pw.ThemeData.withFont(base: arabicFont),
//       textDirection: pw.TextDirection.rtl,
//       pageFormat: PdfPageFormat.a4,
//       build: (pw.Context context) {
//         return pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             // Title
//             pw.Center(
//               child: pw.Text("تقرير مصروفات", style: pw.TextStyle(fontSize: 25)),
//             ),
//             pw.SizedBox(height: 10),
//
//             // Date Range
//             pw.Text("زمن التقرير: ${formatDate(startDate)} الي ${formatDate(endDate)}",
//                 style: pw.TextStyle(fontSize: 12)),
//             pw.SizedBox(height: 10),
//
//             // Table Headers & Data
//             pw.TableHelper.fromTextArray(
//               headers: ['تاريخ', 'المبلغ', 'الوصف', 'اسم الخزينة', 'اسم المستخدم'],
//               data: payments.map((payment) {
//                 String formattedDate = "N/A";
//                 if (payment['timestamp'] != null) {
//                   try {
//                     formattedDate = formatDate(DateTime.parse(payment['timestamp']));
//                   } catch (e) {
//                     formattedDate = "Invalid Date";
//                   }
//                 }
//
//                 return [
//                   formattedDate,
//                   payment['amount'].toString(),
//                   payment['description'] ?? 'N/A',
//                   payment['vault_name'] ?? 'N/A',
//                   payment['userName'] ?? 'N/A'
//                 ];
//               }).toList(),
//               border: pw.TableBorder.all(),
//               cellAlignment: pw.Alignment.center,
//             ),
//
//             pw.SizedBox(height: 10),
//
//             // Total Amount
//             pw.Text("اجمالي المصروفات: ${totalAmount.toString()}",
//                 style: pw.TextStyle(fontSize: 16)),
//           ],
//         );
//       },
//     ),
//   );
//
//   // String? selectedDirectory;
//   // if (Platform.isWindows) {
//   //   selectedDirectory = await FilePicker.platform.getDirectoryPath();
//   //   if (selectedDirectory == null) {
//   //     // User canceled the selection
//   //     return;
//   //   }
//   // } else {
//   //   throw UnsupportedError("This function is designed for Windows only.");
//   // }
//   //
//   // // Save PDF in the selected directory
//   // final filePath = "$selectedDirectory/Payment_Report_${formatDate(startDate)}.pdf";
//   // final file = File(filePath);
//   // await file.writeAsBytes(await pdf.save());
//   //
//   // // Open and Print on Windows
//   // if (Platform.isWindows) {
//   //   Process.start('explorer', [filePath]); // Open PDF file
//   //   Process.start('cmd', ['/c', 'print', filePath]); // Print PDF
//   // }
//
//   // حفظ الـ PDF في مجلد مؤقت
//   final tempDir = await getTemporaryDirectory();
//   // final pdfFile = File("${tempDir.path}/statement.pdf");
//   // await pdfFile.writeAsBytes(await pdf.save());
//   final pdfBytes = await pdf.save();
//
//   // عرض معاينة الـ PDF في Dialog
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text("معاينة كشف الحساب"),
//         content: SizedBox(
//           height: 500,
//           width: 350,
//           child: PdfPreview(
//             build: (format) async => pdf.save(),
//             allowSharing: true,
//             allowPrinting: true,
//             canChangePageFormat: false,
//             canChangeOrientation: false,
//             pdfFileName: "كشف_حساب.pdf",
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () async {
//               String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
//               if (selectedDirectory != null) {
//                 final file = File("$selectedDirectory/كشف_حساب.pdf");
//                 await file.writeAsBytes(pdfBytes);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text("تم حفظ الملف في: $selectedDirectory")),
//                 );
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text("لم يتم اختيار مسار حفظ")),
//                 );
//               }
//               Navigator.pop(context);
//             },
//             child: Text("حفظ"),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: Text("إلغاء"),
//           ),
//         ],
//       );
//     },
//   );
// }


// import 'dart:io';
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:share_plus/share_plus.dart';
//
// Future<void> generatePaymentPdf(
//     List<Map<String, dynamic>> payments, DateTime? startDate, DateTime? endDate, int totalAmount) async {
//   final pdf = pw.Document();
//
//   // Format Date
//   String formatDate(DateTime? date) {
//     return date != null ? DateFormat('yyyy-MM-dd').format(date) : "N/A";
//   }
//
//   // Calculate Total Payment Amount
//   // int totalAmount = payments.fold<int>(
//   //   0,
//   //       (sum, item) => sum + (item['amount'] as num? ?? 0).toInt(),
//   // );
//
//   // Add content to PDF
//   pdf.addPage(
//     pw.Page(
//       pageFormat: PdfPageFormat.a4,
//       build: (pw.Context context) {
//         return pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             // Title
//             pw.Center(
//               child: pw.Text("Payment Report",
//                   style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
//             ),
//             pw.SizedBox(height: 10),
//
//             // Date Range
//             pw.Text("Report Period: ${formatDate(startDate)} to ${formatDate(endDate)}",
//                 style: pw.TextStyle(fontSize: 12)),
//             pw.SizedBox(height: 10),
//
//             // Table Headers
//             pw.TableHelper.fromTextArray(
//               headers: ['Date', 'Amount', 'Description', 'Vault Name', 'User Name'],
//               data: payments.map((payment) {
//                 return [
//                   formatDate(DateTime.parse(payment['timestamp'])),
//                   payment['amount'].toString(),
//                   payment['description'] ?? 'N/A',
//                   payment['vault_name'] ?? 'N/A',
//                   payment['userName'] ?? 'N/A'
//                 ];
//               }).toList(),
//               border: pw.TableBorder.all(),
//               headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//               cellAlignment: pw.Alignment.centerLeft,
//             ),
//
//             pw.SizedBox(height: 10),
//
//             // Total Amount
//             pw.Text("Total Payments: \$${totalAmount.toStringAsFixed(2)}",
//                 style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
//           ],
//         );
//       },
//     ),
//   );
//
//   // Save PDF file
//   final output = await getExternalStorageDirectory(); // Android storage
//   final file = File("${output!.path}/Payment_Report_${formatDate(startDate)}.pdf");
//   await file.writeAsBytes(await pdf.save());
//
//   // Share or Open PDF
//   await Share.shareXFiles([XFile(file.path)], text: 'Here is the Payment Report PDF');
// }

// import 'dart:io';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:share_plus/share_plus.dart';
//
// Future<void> generatePaymentPdf(
//     List<Map<String, dynamic>> payments, DateTime? startDate, DateTime? endDate, int totalAmount) async {
//   final pdf = pw.Document();
//
//   // Format Date
//   String formatDate(DateTime? date) {
//     return date != null ? DateFormat('yyyy-MM-dd').format(date) : "N/A";
//   }
//
//   final fontData = await rootBundle.load("assets/font/Amiri-Regular.ttf");
//   final arabicFont = pw.Font.ttf(fontData);
//
//   pdf.addPage(
//     pw.Page(
//       theme: pw.ThemeData.withFont(base: arabicFont),
//       textDirection: pw.TextDirection.rtl,
//       pageFormat: PdfPageFormat.a4,
//       build: (pw.Context context) {
//         return pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             // Title
//             pw.Center(
//               child: pw.Text("تقرير مصروفات",
//                   style: pw.TextStyle(fontSize: 25, )),
//             ),
//             pw.SizedBox(height: 10),
//
//             // Date Range
//             pw.Text("زمن التقرير: ${formatDate(startDate)} الي ${formatDate(endDate)}",
//                 style: pw.TextStyle(fontSize: 12)),
//             pw.SizedBox(height: 10),
//
//             // Table Headers & Data
//             pw.TableHelper.fromTextArray(
//               headers: ['تاريخ', 'المبلغ', 'الوصف', 'اسم الخزينة', 'اسم المستخدم'],
//               data: payments.map((payment) {
//                 String formattedDate = "N/A";
//                 if (payment['timestamp'] != null) {
//                   try {
//                     formattedDate = formatDate(DateTime.parse(payment['timestamp']));
//                   } catch (e) {
//                     formattedDate = "Invalid Date";
//                   }
//                 }
//
//                 return [
//                   formattedDate,
//                   payment['amount'].toString(),
//                   payment['description'] ?? 'N/A',
//                   payment['vault_name'] ?? 'N/A',
//                   payment['userName'] ?? 'N/A'
//                 ];
//               }).toList(),
//               border: pw.TableBorder.all(),
//               cellAlignment: pw.Alignment.center,
//             ),
//
//             pw.SizedBox(height: 10),
//
//             // Total Amount
//             pw.Text("اجمالي المصروفات: ${totalAmount.toString()}",
//                 style: pw.TextStyle(fontSize: 16, )),
//           ],
//         );
//       },
//     ),
//   );
//
//   // Get storage directory based on platform
//   Directory? directory;
//   if (Platform.isAndroid) {
//     directory = await getExternalStorageDirectory(); // Android external storage
//   } else if (Platform.isIOS || Platform.isMacOS) {
//     directory = await getApplicationDocumentsDirectory(); // iOS/macOS safe storage
//   } else if (Platform.isWindows) {
//     directory = Directory('${Platform.environment['USERPROFILE']}\\Documents'); // Windows Documents folder
//   } else {
//     throw UnsupportedError("Unsupported platform");
//   }
//
//   final filePath = "${directory!.path}/Payment_Report_${formatDate(startDate)}.pdf";
//   final file = File(filePath);
//   await file.writeAsBytes(await pdf.save());
//
//   // Open PDF and Print on Windows
//   if (Platform.isWindows) {
//     // Open the PDF file in the default viewer
//     Process.start('explorer', [filePath]);
//
//     // Print the PDF file automatically
//     Process.start('cmd', ['/c', 'print', filePath]);
//   } else {
//     // Share or Open PDF on other platforms
//     await Share.shareXFiles([XFile(file.path)], text: 'Here is the Payment Report PDF');
//   }
// }
//
//

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

Future<void> generatePaymentPdf(
    BuildContext context,
    List<Map<String, dynamic>> payments,
    DateTime? startDate,
    DateTime? endDate,
    int totalAmount) async {
  final pdf = pw.Document();

  // Format Date
  String formatDate(DateTime? date) {
    return date != null ? DateFormat('yyyy-MM-dd').format(date) : "N/A";
  }

  final fontData = await rootBundle.load("assets/font/Amiri-Regular.ttf");
  final arabicFont = pw.Font.ttf(fontData);

  const int rowsPerPage = 19; // حدد عدد الصفوف في كل صفحة

  List<List<Map<String, dynamic>>> splitPayments(List<Map<String, dynamic>> payments, int chunkSize) {
    List<List<Map<String, dynamic>>> chunks = [];
    for (int i = 0; i < payments.length; i += chunkSize) {
      chunks.add(payments.sublist(i, i + chunkSize > payments.length ? payments.length : i + chunkSize));
    }
    return chunks;
  }

  pdf.addPage(
    pw.MultiPage(
      theme: pw.ThemeData.withFont(base: arabicFont),
      textDirection: pw.TextDirection.rtl,
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        List<pw.Widget> pages = [];
// تقسيم البيانات إلى دفعات صغيرة
  List<List<Map<String, dynamic>>> paymentChunks = splitPayments(payments, rowsPerPage);

  for (var chunk in paymentChunks) {

    pages.add(
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text("تقرير المصروفات", style: pw.TextStyle(fontSize: 25)),
          ),
          pw.SizedBox(height: 10),
          pw.Text("زمن التقرير: ${formatDate(startDate)} إلى ${formatDate(endDate)}",
              style: pw.TextStyle(fontSize: 12)),
          pw.SizedBox(height: 10),
          pw.TableHelper.fromTextArray(
            headers: ['تاريخ', 'المبلغ', 'الوصف', 'اسم الخزينة', 'اسم المستخدم'],
            data: chunk.map((payment) {
              String formattedDate = "N/A";
              if (payment['timestamp'] != null) {
                try {
                  formattedDate = formatDate(DateTime.parse(payment['timestamp']));
                } catch (e) {
                  formattedDate = "Invalid Date";
                }
              }
              return [
                formattedDate,
                payment['amount'].toString(),
                payment['description'] ?? 'N/A',
                payment['vault_name'] ?? 'N/A',
                payment['userName'] ?? 'N/A'
              ];
            }).toList(),
            border: pw.TableBorder.all(),
            cellAlignment: pw.Alignment.center,
          ),
          pw.SizedBox(height: 10),
        ],
      ),
    );
  }

        // إضافة إجمالي المصروفات في الصفحة الأخيرة فقط
        pages.add(pw.Text("إجمالي المصروفات: ${totalAmount.toString()}",
            style: pw.TextStyle(fontSize: 16)));

        return pages;


        // return [
        //   pw.Column(
        //   crossAxisAlignment: pw.CrossAxisAlignment.start,
        //   children: [
        //
        //     // Title
        //     pw.Center(
        //       child: pw.Text("تقرير مصروفات", style: pw.TextStyle(fontSize: 25)),
        //     ),
        //     pw.SizedBox(height: 10),
        //
        //     // Date Range
        //     pw.Text("زمن التقرير: ${formatDate(startDate)} الي ${formatDate(endDate)}",
        //         style: pw.TextStyle(fontSize: 12)),
        //     pw.SizedBox(height: 10),
        //
        //
        //     // Table Headers & Data
        //     pw.TableHelper.fromTextArray(
        //       headers: ['تاريخ', 'المبلغ', 'الوصف', 'اسم الخزينة', 'اسم المستخدم'],
        //       data: payments.map((payment) {
        //         String formattedDate = "N/A";
        //
        //
        //
        //         if (payment['timestamp'] != null) {
        //           try {
        //             formattedDate = formatDate(DateTime.parse(payment['timestamp']));
        //           } catch (e) {
        //             formattedDate = "Invalid Date";
        //           }
        //         }
        //
        //         return [
        //           formattedDate,
        //           payment['amount'].toString(),
        //           payment['description'] ?? 'N/A',
        //           payment['vault_name'] ?? 'N/A',
        //           payment['userName'] ?? 'N/A'
        //         ];
        //       }).toList(),
        //       border: pw.TableBorder.all(),
        //       cellAlignment: pw.Alignment.center,
        //     ),
        //
        //
        //     // pw.Table(
        //     //   border: pw.TableBorder.all(),
        //     //   columnWidths: {
        //     //     0: pw.FlexColumnWidth(2), // التاريخ
        //     //     1: pw.FlexColumnWidth(2), // المبلغ
        //     //     2: pw.FlexColumnWidth(3), // الوصف
        //     //     3: pw.FlexColumnWidth(3), // اسم الخزينة
        //     //     4: pw.FlexColumnWidth(3), // اسم المستخدم
        //     //   },
        //     //   children: [
        //     //     // رأس الجدول
        //     //     pw.TableRow(
        //     //       decoration: pw.BoxDecoration(color: PdfColors.grey300),
        //     //       children: [
        //     //
        //     //         pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text('تاريخ', style: pw.TextStyle(fontSize: 12, ))),
        //     //         pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text('المبلغ', style: pw.TextStyle(fontSize: 12,))),
        //     //         pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text('الوصف', style: pw.TextStyle(fontSize: 12,))),
        //     //         pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text('اسم الخزينة', style: pw.TextStyle(fontSize: 12,))),
        //     //         pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text('اسم المستخدم', style: pw.TextStyle(fontSize: 12, ))),
        //     //       ],
        //     //     ),
        //     //
        //     //     // بيانات الجدول
        //     //     ...payments.map((payment) {
        //     //       return pw.TableRow(
        //     //         children: [
        //     //           pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text(formatDate(DateTime.parse(payment['timestamp'] ?? '')))),
        //     //           pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text(payment['amount'].toString())),
        //     //           pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text(payment['description'] ?? 'N/A')),
        //     //           pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text(payment['vault_name'] ?? 'N/A')),
        //     //           pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text(payment['userName'] ?? 'N/A')),
        //     //         ],
        //     //       );
        //     //     }).toList(),
        //     //   ],
        //     // ),
        //     //
        //
        //     pw.SizedBox(height: 10),
        //
        //     // Total Amount
        //     pw.Text("اجمالي المصروفات: ${totalAmount.toString()}",
        //         style: pw.TextStyle(fontSize: 16)),
        //   ],
        // )
        // ];
      },
    ),
  );



  // حفظ الـ PDF في مجلد مؤقت
  final tempDir = await getTemporaryDirectory();
  final pdfBytes = await pdf.save();

  // عرض معاينة الـ PDF في Dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("معاينة كشف الحساب"),
        content: SizedBox(
          height: 500,
          width: 350,
          child: PdfPreview(
            build: (format) async => pdf.save(),
            allowSharing: true,
            allowPrinting: true,
            canChangePageFormat: false,
            canChangeOrientation: false,
            pdfFileName: "كشف_حساب.pdf",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
              if (selectedDirectory != null) {
                final file = File("$selectedDirectory/كشف_حساب.pdf");
                await file.writeAsBytes(pdfBytes);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("تم حفظ الملف في: $selectedDirectory")),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("لم يتم اختيار مسار حفظ")),
                );
              }
              Navigator.pop(context);
            },
            child: Text("حفظ"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("إلغاء"),
          ),
        ],
      );
    },
  );
}
