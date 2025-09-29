import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:system/Adminfeatures/billes/data/models/bill_model.dart';

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
