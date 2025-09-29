import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:system/features/billes/data/models/bill_model.dart';

import '../../../../../core/themes/AppColors/them_constants.dart';

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
              pw.Image(
                logoImage,
                height: 110,
              ),

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
                    // '${_calculateTotal(bill)}',
                    '${bill.total_price}',
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

  static Future<pw.Document> createBillWithQrCode(
      Bill bill, ByteData qrCodeImage) async {
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
                  pw.Container(
                    width: 100,
                    height: 100,
                    child:
                        // pw.Image(qrCodeImage),
                        pw.Image(pw.MemoryImage(qrCodeImageData),
                            width: 80, height: 80),
                  ),
                  pw.Text(
                    'فاتورة',
                    style: pw.TextStyle(
                      fontSize: 24,
                      // fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Image(logoImage, height: 110),
                ],
              ),
              pw.SizedBox(height: 16),

              // Bill Details
              pw.Text('رقم الفاتورة: ${bill.id}'),
              pw.Text(
                  'التاريخ: ${bill.date.year} / ${bill.date.month} / ${bill.date.day}'),
              pw.Text('اسم العميل: ${bill.customerName}'),
              pw.SizedBox(height: 16),

              // Items Table
              _buildItemsTable(bill),

              // Total Section
              pw.SizedBox(height: 32),
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // pw.Text(
                    //   'اجمالي الفاتورة: ',
                    //   style: pw.TextStyle(
                    //     fontSize: 14,
                    //     // fontWeight: pw.FontWeight.bold,
                    //   ),
                    // ),

                    // pw.Row(
                    //   mainAxisAlignment: pw.MainAxisAlignment.start,
                    //   children: [
                    //     pw.Text(
                    //       // '${_calculateTotal(bill)}',
                    //       '${'${bill.total_price}'}',
                    //       style: pw.TextStyle(fontSize: 14),
                    //     ),
                    //     pw.Text(
                    //       'جنيه مصري فقط لا غير ',
                    //       style: pw.TextStyle(
                    //         fontSize: 14,
                    //         // fontWeight: pw.FontWeight.bold,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ])
            ],
          );
        },
      ),
    );

    return pdf;
  }

  /// Builds a table of items for the bill.

//   static pw.Widget _buildItemsTable(Bill bill) {
//     return pw.Table(
//       border: pw.TableBorder.all(),
//       tableWidth: pw.TableWidth.max,
//
//       columnWidths: {
//         0: pw.FlexColumnWidth(2),
//         1: pw.FlexColumnWidth(2),
//         2: pw.FlexColumnWidth(1),
//         3: pw.FlexColumnWidth(2),
//         // 4: pw.FlexColumnWidth(2),
//       },
//       children: [
//         // Table Header
//         pw.TableRow(
//           decoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFF932570)),
//           children: [
//             // 1 الاجمالي
//             pw.Padding(
//               padding: const pw.EdgeInsets.all(8.0),
//               child: pw.Text(
//                 'الإجمالي',
//                 textAlign: pw.TextAlign.center,
//                 style: pw.TextStyle(color: PdfColors.white),
//               ),
//             ),
//
//             pw.Padding(
//               padding: const pw.EdgeInsets.all(8.0),
//               child: pw.Text(
//                 'الخصم ',
//                 textAlign: pw.TextAlign.center,
//                 style: pw.TextStyle(color: PdfColors.white),
//               ),
//             ),
//
//             pw.Padding(
//               padding: const pw.EdgeInsets.all(8.0),
//               child: pw.Text(
//                 'الكمية',
//                 textAlign: pw.TextAlign.center,
//                 style: pw.TextStyle(color: PdfColors.white),
//               ),
//             ),
//
//             // السعر القطعة
//             pw.Padding(
//               padding: const pw.EdgeInsets.all(8.0),
//               child: pw.Text(
//                 'سعر القطعة',
//                 textAlign: pw.TextAlign.center,
//                 style: pw.TextStyle(color: PdfColors.white),
//               ),
//             ),
//             // الوصف
//             pw.Padding(
//               padding: const pw.EdgeInsets.all(8.0),
//               child: pw.Text(
//                 'الوصف',
//                 textAlign: pw.TextAlign.center,
//                 style: pw.TextStyle(color: PdfColors.white),
//               ),
//             ),
//             // اسم العنصر الفرعي
//             pw.Padding(
//               padding: const pw.EdgeInsets.all(8.0),
//               child: pw.Text(
//                 'الصنف',
//                 textAlign: pw.TextAlign.center,
//                 style: pw.TextStyle(color: PdfColors.white),
//               ),
//             ),
//           ],
//         ),
//         // Table Rows for Items
//         ...bill.items.map((item) {
//           final total = item.total_Item_price;
//           return pw.TableRow(
//             children: [
//               //  الاجمالي
//               pw.Padding(
//                 padding: const pw.EdgeInsets.all(8.0),
//                 child: pw.Text('${(total).toStringAsFixed(2)} ج م',
//                     textAlign: pw.TextAlign.center,
//                     style: pw.TextStyle(fontSize: 10)),
//               ),
//
//               //   نوع خصم
//               pw.Padding(
//                 padding: const pw.EdgeInsets.all(8.0),
//                 child: pw.Text(
//                     '${(item.discount).toStringAsFixed(2) + " ${item.discountType.toString()}"} ',
//                     textDirection: pw.TextDirection.rtl,
//                     textAlign: pw.TextAlign.center,
//                     style: pw.TextStyle(fontSize: 10)),
//
//               ),
//
//               //كمية
//               pw.Padding(
//                 padding: const pw.EdgeInsets.all(8.0),
//                 child: pw.Text(item.quantity.toString(),
//                     textAlign: pw.TextAlign.center  ,
//           style: pw.TextStyle(fontSize: 10)),
//
//           ),
//
// // السعر القطعة
//               pw.Padding(
//                 padding: const pw.EdgeInsets.all(8.0),
//                 // DataCell(Text('\جنيه${(item.amount * item.price_per_unit)}')),
//
//                 child: pw.Text(
//                     '${(item.amount * item.price_per_unit).toStringAsFixed(2)} ج م',
//                     textAlign: pw.TextAlign.center      ,
//                     style: pw.TextStyle(fontSize: 10)),
//
//               ),
//               //    الوصف
//               pw.Padding(
//                 padding: const pw.EdgeInsets.all(8.0),
//                 child:
//                     pw.Text(item.description, textAlign: pw.TextAlign.center,                    style: pw.TextStyle(fontSize: 10)),
//
//               ),
//               //    اسم العنصر الفرعي
//               pw.Padding(
//                 padding: const pw.EdgeInsets.all(8.0),
//                 child: pw.Text(item.subcategoryName,
//                     textAlign: pw.TextAlign.center,                    style: pw.TextStyle(fontSize: 10)),
//
//               ),
//             ],
//           );
//         }).toList(),
//       ],
//     );
//   }

  static pw.Widget _buildItemsTable(Bill bill) {
    // Calculate the sum of all item totals
    final double totalSum =
        bill.items.fold(0.0, (sum, item) => sum + item.total_Item_price);
    return pw.Table(
        border: pw.TableBorder.all(),
        tableWidth: pw.TableWidth.max,
        columnWidths: {
          0: pw.FlexColumnWidth(2),
          1: pw.FlexColumnWidth(2),
          2: pw.FlexColumnWidth(1),
          3: pw.FlexColumnWidth(2),
        },
        children: [
          // Table Header
          pw.TableRow(
            decoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFF932570)),
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(
                  'الإجمالي',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(color: PdfColors.white),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(
                  'الخصم',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(color: PdfColors.white),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(
                  'الكمية',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(color: PdfColors.white),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(
                  'سعر القطعة',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(color: PdfColors.white),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(
                  'الوصف',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(color: PdfColors.white),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(
                  'الصنف',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(color: PdfColors.white),
                ),
              ),
            ],
          ),
          // Table Rows for Items
          ...bill.items.map((item) {
            final total = item.total_Item_price;
            return pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text('${total.toStringAsFixed(2)} ج م',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 10)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                      '${item.discount.toStringAsFixed(2)} ${item.discountType.toString()}',
                      textDirection: pw.TextDirection.rtl,
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 10)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(item.quantity.toString(),
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 10)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                      '${(item.amount * item.price_per_unit).toStringAsFixed(2)} ج م',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 10)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(item.description,
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 10)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(item.subcategoryName,
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 10)),
                ),
              ],
            );
          }).toList(),
          // Total Sum Row
          // Footer Row alternative implementation

          pw.TableRow(
            // decoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFF932570)),
            children: [
              // First cell - Total
            pw.Container(
            color: PdfColor.fromInt(0xFFFFE0E0),
              child: pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(
                  textAlign: pw.TextAlign.center,
                  ' ${totalSum.toStringAsFixed(2)} ج م',
                  style: pw.TextStyle(
                    // textAlign: pw.TextAlign.center,
                    fontSize: 12,
                    // fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),),
              // This will occupy the space of the remaining 5 columns
              pw.Container(
                decoration: const pw.BoxDecoration(
                  color: PdfColor.fromInt(0xFFFFE0E0),
                  border: pw.Border(
                    left: pw.BorderSide
                        .none, // Remove left border for merged effect
                  ),
                ),
                child: pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                    'الاجمالي',
                    textAlign: pw.TextAlign.center,
                  ),
                ),
              ),
              // Empty placeholders for the remaining columns
              // These will be hidden behind the merged cell
              // for (int i = 2; i < columnCount; i++)
              //   pw.Container(width: 0, height: 0), // Invisible placeholders
            ],
          )
        ]);
  }
}
