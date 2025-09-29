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
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../billes/data/models/bill_model.dart';

Future<void> createPDF(
    BuildContext context,
    Bill bill,
    Map<String, dynamic> paymentDetails,
    String customerName,
    DateTime billDate,
    double total_price,
    totalPayments,
    double remainingAmount) async {
  final pdf = pw.Document();

  // Load Arabic font
  final fontData = await rootBundle.load("assets/font/Amiri-Regular.ttf");
  final arabicFont = pw.Font.ttf(fontData);

  // Format dates
  final dateFormatter = DateFormat('dd/MM/yyyy');
  final formattedBillDate = dateFormatter.format(billDate);
  final formattedPaymentDate =
      dateFormatter.format(DateTime.parse(paymentDetails['date']));

  // Load Logo
  final logoImageData = await rootBundle.load('assets/logo/logo_00.jpg');
  final logoImage = pw.MemoryImage(logoImageData.buffer.asUint8List());

  // Create PDF Page
  // pdf.addPage(
  //   pw.Page(
  //     theme: pw.ThemeData.withFont(base: arabicFont),
  //     textDirection: pw.TextDirection.rtl,
  //     build: (pw.Context context) {
  //       return pw.Padding(
  //         padding: const pw.EdgeInsets.all(16),
  //         child: pw.Column(
  //             crossAxisAlignment: pw.CrossAxisAlignment.end,
  //             children: [
  //               pw.Row(children: [
  //                 pw.Column(children: [
  //                   pw.Center(
  //                     child: pw.Text('ايصال دفع',
  //                         style: const pw.TextStyle(fontSize: 20)),
  //                   ),
  //                   pw.Text('اسم العميل: ${customerName}',
  //                       style: const pw.TextStyle(fontSize: 20)),
  //                 ]),
  //                 pw.SizedBox(width: 100),
  //                 pw.Image(
  //                   logoImage,
  //                   height: 90,
  //                 ),
  //               ]),
  //
  //               pw.Row(
  //                 crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                 children: [
  //                   pw.Column(children: [
  //                     pw.Text('____________________',
  //                         style: const pw.TextStyle(fontSize: 20)),
  //                     // Payment Details
  //                     // pw.Text('اسم العميل: ${customerName}', style: const pw.TextStyle(fontSize: 14)),
  //                     pw.Text('رقم الفاتورة: ${paymentDetails['bill_id']}',
  //                         style: const pw.TextStyle(fontSize: 20)),
  //                     pw.SizedBox(height: 16),
  //
  //                     pw.Text(' التاريخ الفاتورة: $formattedBillDate',
  //                         style: const pw.TextStyle(fontSize: 14)),
  //                     // pw.Text('رقم الخزنة: ${paymentDetails['vault_id'] ?? 'غير متوفر'}', style: const pw.TextStyle(fontSize: 14)),
  //                     pw.Text(
  //                         'المبلغ المدفوع: ${paymentDetails['payment']} جنيه',
  //                         style: const pw.TextStyle(fontSize: 14)),
  //                     pw.Text('التاريخ الدفع: $formattedPaymentDate ',
  //                         style: const pw.TextStyle(fontSize: 14)),
  //                     pw.Text(
  //                         'المستخدم: ${paymentDetails['users']['name'] ?? 'غير معروف'}',
  //                         style: const pw.TextStyle(fontSize: 14)),
  //                     pw.SizedBox(height: 16),
  //                     pw.Divider(thickness: 2),
  //                   ]),
  //
  //                   pw.SizedBox(width: 40),
  //                   // pw.Divider(indent: 20),
  //                   pw.Column(children: [
  //                     pw.Text('____________________',
  //                         style: const pw.TextStyle(fontSize: 20)),
  //
  //                     // Bill Details
  //                     pw.Text('تفاصيل الفاتورة',
  //                         style: pw.TextStyle(
  //                           fontSize: 20,
  //                         )),
  //                     pw.SizedBox(height: 16),
  //                     pw.Text('إجمالي سعر الفاتورة : ${total_price} جنيه',
  //                         style: const pw.TextStyle(fontSize: 14)),
  //                     pw.Text('إجمالي المدفوع: $totalPayments جنيه',
  //                         style: const pw.TextStyle(fontSize: 14)),
  //                     pw.Text('المبلغ المتبقي: $remainingAmount جنيه',
  //                         style: const pw.TextStyle(fontSize: 14)),
  //                     pw.SizedBox(height: 16),
  //                     pw.Divider(thickness: 2),
  //                   ]),
  //                 ],
  //               ),
  //               pw.Row(children: [
  //                 pw.Text("تاريخ الاستلام :    /    /    "),
  //               ]),
  //               // Footer
  //               pw.Divider(thickness: 2),
  //               pw.Table.fromTextArray(
  //                 tableWidth: pw.TableWidth.max,
  //                 headers: [
  //                   'الحالة',
  //                   'الخصم',
  //                   'الإجمالي',
  //                   'السعر',
  //                   'الكمية',
  //                   'الصنف',
  //                 ],
  //                 data: [
  //                   [
  //                     bill.status, // الحالة
  //
  //                     // ✅ الخصم (مع خط فاصل بين القيم)
  //                     bill.items.isNotEmpty
  //                         ? bill.items
  //                             .map((item) =>
  //                                 "${item.discountType} - ${item.discount}")
  //                             .join("\n———\n")
  //                         : "لا يوجد خصم",
  //
  //                     // ✅ إجمالي كل عنصر (مع خط فاصل بين القيم)
  //                     bill.items.isNotEmpty
  //                         ? bill.items
  //                             .map((item) => item.total_Item_price.toString())
  //                             .join("\n———\n")
  //                         : "—",
  //
  //                     // ✅ سعر الوحدة لكل عنصر (مع خط فاصل بين القيم)
  //                     bill.items.isNotEmpty
  //                         ? bill.items
  //                             .map((item) => item.price_per_unit.toString())
  //                             .join("\n———\n")
  //                         : "—",
  //
  //                     // ✅ الكمية لكل عنصر (مع خط فاصل بين القيم)
  //                     bill.items.isNotEmpty
  //                         ? bill.items
  //                             .map((item) => item.quantity.toString())
  //                             .join("\n———\n")
  //                         : "—",
  //
  //                     // ✅ التصنيف الفرعي لكل عنصر (مع خط فاصل بين القيم)
  //                     bill.items.isNotEmpty
  //                         ? bill.items
  //                             .map((item) => item.description)
  //                             .join("\n——————\n")
  //                         : "—",
  //                   ]
  //                 ],
  //
  //                 border: pw.TableBorder.all(),
  //                 cellAlignment: pw.Alignment.center,
  //                 cellStyle: pw.TextStyle(
  //                   fontSize: 7,
  //                 ),
  //                 // ✅ Add Header Styling
  //                 headerStyle:
  //                     pw.TextStyle(fontSize: 9, color: PdfColors.white),
  //                 headerDecoration: pw.BoxDecoration(
  //                   color: PdfColor.fromInt(0xFF932570),
  //                 ), // ✅ Change to any color (e.g., PdfColors.grey)
  //               ),
  //
  //               pw.Text(' شكراً لاختياركم      ',
  //                   style: pw.TextStyle(fontSize: 14, color: PdfColors.green)),
  //
  //               pw.Text(' رتوش للاعلان و الطباعة الرقمية!',
  //                   style: pw.TextStyle(fontSize: 14, color: PdfColors.green)),
  //             ]),
  //       );
  //     },
  //   ),
  // );
  pdf.addPage(
    pw.Page(
      theme: pw.ThemeData.withFont(base: arabicFont),
      textDirection: pw.TextDirection.rtl,
      build: (pw.Context context) {
        return pw.Stack(
          children: [
            // ✅ العلامة المائية - شعار شفاف في الخلفية
            pw.Positioned(
              top: 100, // تحريك الصورة للأسفل قليلاً
              left: 50, // توسيط الصورة
              child: pw.Opacity(
                opacity: 0.10, // جعل الصورة شفافة
                child: pw.Image(
                  logoImage,
                  width: 300, // يمكنك تعديل الحجم حسب الحاجة
                ),
              ),
            ),

            // ✅ المحتوى الفعلي فوق العلامة المائية
            pw.Padding(
              padding: const pw.EdgeInsets.all(16),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Row(children: [
                    pw.Expanded(
                      flex: 4,

                      child:
              pw.Column(children: [
              pw.Center(
              child: pw.Text('ايصال دفع',
                  style: const pw.TextStyle(fontSize: 20)),
            ),
            pw.Text('اسم العميل: ${customerName}',
                style: const pw.TextStyle(fontSize: 20)),
          ]),

        ),
                    // pw.SizedBox(width: 100),
                    pw.Expanded(
                      child:
                    pw.Image(
                      logoImage,
                      height: 90,
                    ),
                    ),

                  ]),

                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Column(children: [
                        pw.Text('____________________',
                            style: const pw.TextStyle(fontSize: 20)),
                        pw.Text('رقم الفاتورة: ${paymentDetails['bill_id']}',
                            style: const pw.TextStyle(fontSize: 20)),
                        pw.SizedBox(height: 16),
                        pw.Text(' التاريخ الفاتورة: $formattedBillDate',
                            style: const pw.TextStyle(fontSize: 14)),
                        pw.Text(
                            'المبلغ المدفوع: ${paymentDetails['payment']} جنيه',
                            style: const pw.TextStyle(fontSize: 14)),
                        pw.Text('التاريخ الدفع: $formattedPaymentDate ',
                            style: const pw.TextStyle(fontSize: 14)),
                        pw.Text(
                            'المستخدم: ${paymentDetails['users']['name'] ?? 'غير معروف'}',
                            style: const pw.TextStyle(fontSize: 14)),
                        pw.SizedBox(height: 16),
                        pw.Divider(thickness: 2),
                      ]),

                      pw.SizedBox(width: 40),
                      pw.Column(children: [
                        pw.Text('____________________',
                            style: const pw.TextStyle(fontSize: 20)),

                        pw.Text('تفاصيل الفاتورة',
                            style: pw.TextStyle(fontSize: 20)),
                        pw.SizedBox(height: 16),
                        pw.Text('إجمالي سعر الفاتورة : ${total_price} جنيه',
                            style: const pw.TextStyle(fontSize: 14)),
                        pw.Text('إجمالي المدفوع: $totalPayments جنيه',
                            style: const pw.TextStyle(fontSize: 14)),
                        pw.Text('المبلغ المتبقي: ${remainingAmount.toStringAsFixed(2)} جنيه',
                            style: const pw.TextStyle(fontSize: 14)),
                        pw.SizedBox(height: 16),
                        pw.Divider(thickness: 2),
                      ]),
                    ],
                  ),

                  pw.Row(children: [
                    pw.Text("تاريخ الاستلام :    /    /    "),
                  ]),

                  pw.Divider(thickness: 2),
                  pw.Table.fromTextArray(
                    tableWidth: pw.TableWidth.max,
                    headers: [
                      'الحالة',
                      'الخصم',
                      'الإجمالي',
                      'السعر',
                      'الكمية',
                      'وذلك قيمة: ',
                    ],
                    data: [
                      [
                        bill.status,
                        bill.items.isNotEmpty
                            ? bill.items
                            .map((item) =>
                        "${item.discountType} - ${item.discount}")
                            .join("\n———\n")
                            : "لا يوجد خصم",
                        bill.items.isNotEmpty
                            ? bill.items
                            .map((item) => item.total_Item_price.toString())
                            .join("\n———\n")
                            : "—",
                        bill.items.isNotEmpty
                            ? bill.items
                            .map((item) => item.price_per_unit.toString())
                            .join("\n———\n")
                            : "—",
                        bill.items.isNotEmpty
                            ? bill.items
                            .map((item) => item.quantity.toString())
                            .join("\n———\n")
                            : "—",
                        bill.items.isNotEmpty
                            ? bill.items
                            .map((item) => item.description)
                            .join("\n——————\n")
                            : "—",
                      ]
                    ],
                    border: pw.TableBorder.all(),
                    cellAlignment: pw.Alignment.center,
                    cellStyle: pw.TextStyle(fontSize: 7),
                    headerStyle:
                    pw.TextStyle(fontSize: 9, color: PdfColors.white),
                    headerDecoration:
                    pw.BoxDecoration(color: PdfColor.fromInt(0xFF932570)),
                  ),

                  pw.Text(' شكراً لاختياركم      ',
                      style: pw.TextStyle(fontSize: 14, color: PdfColors.green)),
                  pw.Text(' رتوش للاعلان و الطباعة الرقمية!',
                      style: pw.TextStyle(fontSize: 14, color: PdfColors.green)),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );

  final pdfBytes = await pdf.save();

  // عرض معاينة الـ PDF في Dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("معاينة الايصال"),
        content: SizedBox(
          height: 500,
          width: 350,
          child: PdfPreview(
            build: (format) async => pdf.save(),
            allowSharing: true,
            allowPrinting: true,
            canChangePageFormat: false,
            canChangeOrientation: false,
            pdfFileName: "ايصال.pdf",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String? selectedDirectory =
                  await FilePicker.platform.getDirectoryPath();
              if (selectedDirectory != null) {
                final file = File("$selectedDirectory/كشف_حساب.pdf");
                await file.writeAsBytes(pdfBytes);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text("تم حفظ الملف في: $selectedDirectory")),
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
