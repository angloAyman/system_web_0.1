
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../../../billes/data/models/bill_model.dart';

Future<void> generateBillsPDF(
    BuildContext context,
    List<Bill> bills,
    DateTime? startDate,
    DateTime? endDate,
    String customerName,
    bool searchByDate) async {
  final pdf = pw.Document();
  final logo =
  (await rootBundle.load("assets/logo/logo_00.jpg")).buffer.asUint8List();

  // تحميل الخط العربي
  final fontData = await rootBundle.load("assets/font/Amiri-Regular.ttf");
  final arabicFont = pw.Font.ttf(fontData);

  // تنسيق التاريخ
  String formatDate(DateTime? date) {
    return date != null ? DateFormat('yyyy-MM-dd').format(date) : "N/A";
  }

  // حساب إجمالي الفواتير
  int totalBills = bills.length;
  double totalPayments = bills.fold(0, (sum, bill) => sum + bill.payment);
  double totalRemaining = bills.fold(0, (sum, bill) => sum + (bill.total_price - bill.payment));

  pdf.addPage(
    pw.Page(
      theme: pw.ThemeData.withFont(base: arabicFont),
      textDirection: pw.TextDirection.rtl,
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          children: [
            // الشعار والعنوان
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Image(pw.MemoryImage(logo), height: 60),
              ],
            ),
            pw.Center(
              child: pw.Text(
                "كشف حساب",
                style: pw.TextStyle(fontSize: 25, ),
              ),
            ),
            pw.Row(
            children: [

            ],),
            pw.SizedBox(height: 10),
            pw.Row(
              children: [
                pw.Text("اسم العميل: $customerName", style: pw.TextStyle(fontSize: 14)),
              ],),
            // اسم العميل

            // التاريخ
            if (searchByDate)
        pw.Row(
        children: [    pw.Text(
                "من: ${formatDate(startDate)} إلى: ${formatDate(endDate)}",
                style: pw.TextStyle(fontSize: 12),
              ),]),
            pw.SizedBox(height: 15),
            // جدول الفواتير
            pw.Table.fromTextArray(
              tableWidth: pw.TableWidth.max ,
              headers: [
                // 'الحالة',
                // 'المتبقي',
                // 'المدفوع',
                // 'إجمالي الفاتورة',
                // 'الخصم',
                // 'الأصناف',
                // 'رقم الفاتورة',
                // 'التاريخ',
                'الحالة',
                'المتبقي',
                'المدفوع',
                'إجمالي الفاتورة',
                'الخصم',



                'الإجمالي',
                'السعر',
                'الكمية',
                // 'التصنيف',
                'الصنف',
                // ✅ تم إضافة عمود الصنف هنا
               // ✅ تم إضافة عمود التصنيف هنا
                // ✅ تم إضافة عمود الكمية هنا
                 // ✅ تم إضافة عمود السعر هنا
                 //
                // ✅ تم إضافة عمود الإجمالي هنا
                'رقم الفاتورة',
                'التاريخ',
              ],
              // data: bills.map((bill) {
              //   return [
              //     // الحالة
              //     bill.status,
              //     //المتبقي
              //     (bill.total_price - bill.payment).toString(),
              //     // 'المدفوع',
              //     bill.payment.toString(),
              //     //'إجمالي الفاتورة',
              //     bill.total_price.toString(),
              //
              //     //'الخصم',
              //     bill.items.isNotEmpty
              //         ? bill.items
              //         .map((item) =>
              //     "${item.discountType} - ${item.discount} " )
              //         .join("\n")
              //         : "لا يوجد خصم",
              //     // 'الأصناف',
              //     // bill.items.isNotEmpty
              //     //     ? bill.items
              //     //     .map((item) =>
              //     // "${item.categoryName} - ${item.subcategoryName} \n"
              //     //     "(الكمية: ${item.quantity}, سعر القطعة: ${item.price_per_unit}, السعر: ${item.total_Item_price})")
              //     //     .join("\n\n")
              //     //     : "لا يوجد أصناف",
              //
              //   // ✅ **Nested Table for الأصناف**
              //   bill.items.isNotEmpty
              //   ? pw.Container(
              //   padding: pw.EdgeInsets.all(4),
              //   decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),
              //   child: pw.Table.fromTextArray(
              //   headers: ['الصنف', 'التصنيف', 'الكمية', 'السعر', 'الإجمالي'],
              //   data: bill.items.map((item) => [
              //   item.categoryName,
              //   item.subcategoryName,
              //   item.quantity.toString(),
              //   item.price_per_unit.toString(),
              //   item.total_Item_price.toString(),
              //   ]).toList(),
              //   cellAlignment: pw.Alignment.center,
              //   headerStyle: pw.TextStyle(fontSize: 8, color: PdfColors.white),
              //   headerDecoration: pw.BoxDecoration(color: PdfColors.blue),
              //   cellStyle: pw.TextStyle(fontSize: 8),
              //   ),
              //   )
              //       : "لا يوجد أصناف", // I
              //     // 'رقم الفاتورة',
              //     bill.id.toString(),
              //     // 'التاريخ',
              //     bill.date != null
              //         ? "${bill.date.day}/${bill.date.month}/${bill.date.year}"
              //         : "N/A",
              //
              //   ];
              // }).toList(),
              data: bills.map((bill) {
                return [
                  bill.status, // الحالة
                  (bill.total_price - bill.payment).toString(), // المتبقي
                  bill.payment.toString(), // المدفوع
                  bill.total_price.toString(), // إجمالي الفاتورة
                  bill.items.isNotEmpty
                      ? bill.items.map((item) => "${item.discountType} - ${item.discount}").join("\n———\n")
                      : "لا يوجد خصم", // الخصم

                  bill.items.isNotEmpty
                      ? bill.items.map((item) => item.total_Item_price.toString()).join("\n———\n")
                      : "—", // الإجمالي

                  bill.items.isNotEmpty
                      ? bill.items.map((item) => item.price_per_unit.toString()).join("\n———\n")
                      : "—", // السعر

                  bill.items.isNotEmpty
                      ? bill.items.map((item) => item.quantity.toString()).join("\n———\n")
                      : "—", // الكمية

                  bill.items.isNotEmpty
                      ? bill.items.map((item) {
                        return item.subcategoryName;
                      }).join("\n——————\n")
                      : "—", // التصنيف

                  // // ✅ عرض بيانات الأصناف في نفس الصف، كل صنف بسطر جديد
                  // bill.items.isNotEmpty
                  //     ? bill.items.map((item) {
                  //       return "${item.categoryName} - ${item.subcategoryName} ";
                  //     }).join("\n———\n")
                  //     : "لا يوجد أصناف", // الصنف


                  bill.id.toString(), // رقم الفاتورة
                  bill.date != null ? "${bill.date.day}/${bill.date.month}/${bill.date.year}" : "N/A", // التاريخ
                ];
              }).toList(),
              border: pw.TableBorder.all(),
              cellAlignment: pw.Alignment.center,
              cellStyle: pw.TextStyle(fontSize: 7, ),
              // ✅ Add Header Styling
              headerStyle: pw.TextStyle(fontSize: 9, color: PdfColors.white),
              headerDecoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFF932570),), // ✅ Change to any color (e.g., PdfColors.grey)
            ),
            pw.SizedBox(height: 15),
            pw.Row(children: [
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("إجمالي الفواتير: $totalBills", style: pw.TextStyle(fontSize: 14, )),
                    pw.Text("إجمالي المدفوعات: $totalPayments", style: pw.TextStyle(fontSize: 14, color: PdfColors.green)),
                    pw.Text("إجمالي المتبقي: $totalRemaining", style: pw.TextStyle(fontSize: 14, color: PdfColors.red)),

                  ]),
            ]),
           ],
        );
      },
    ),
  );

  // حفظ الـ PDF في مجلد مؤقت
  final tempDir = await getTemporaryDirectory();
  // final pdfFile = File("${tempDir.path}/statement.pdf");
  // await pdfFile.writeAsBytes(await pdf.save());
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

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/services.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:pdf/pdf.dart';
// import 'package:printing/printing.dart';
// import '../../../billes/data/models/bill_model.dart';
//
// Future<void> generateBillsPDF(
//     BuildContext context,
//     List<Bill> bills,
//     DateTime? startDate,
//     DateTime? endDate,
//     String customerName,
//     bool searchByDate) async {
//   final pdf = pw.Document();
//   final logo =
//       (await rootBundle.load("assets/logo/logo_00.jpg")).buffer.asUint8List();
//
//   // Format Date
//   String formatDate(DateTime? date) {
//     return date != null ? DateFormat('yyyy-MM-dd').format(date) : "N/A";
//   }
//
//   final fontData = await rootBundle.load("assets/font/Amiri-Regular.ttf");
//   final arabicFont = pw.Font.ttf(fontData);
//
//   // Get total bills count
//   int totalBills = bills.length;
//
//   pdf.addPage(
//     pw.Page(
//       theme: pw.ThemeData.withFont(base: arabicFont),
//       textDirection: pw.TextDirection.rtl,
//       pageFormat: PdfPageFormat.a4,
//       build: (pw.Context context) {
//         return pw.Column(
//           children: [
//             pw.Row(
//               children: [
//                 pw.Image(pw.MemoryImage(logo), height: 60),
//               ],
//             ),
//             pw.SizedBox(height: 10),
//             pw.Text(
//               "كشف حساب",
//               style: pw.TextStyle(fontSize: 25),
//             ),
//             pw.Row(children: [
//               pw.Text("اسم العميل: $customerName"),
//             ]),
//             // Conditionally add the date range if startDate and endDate are not null
//             if (searchByDate == true)
//               pw.Row(children: [
//                 pw.Text(
//                     "من: ${formatDate(startDate)} الي ${formatDate(endDate)}",
//                     style: pw.TextStyle(fontSize: 12))
//               ]),
//
//             pw.SizedBox(height: 20),
//             pw.Table.fromTextArray(
//               headers: [
//                 'الحالة',
//                 'اجمالي الفاتورة',
//                 'المدفوعات',
//
//                 ' الاصناف',
//                 'رقم الفاتورة',
//                 'التاريخ',
//               ],
//               data: bills.map((bill) {
//                 return [
//                   bill.status,
//                   bill.total_price.toString(),
//                   bill.payment.toString(),
//
//                   // الاصناف
//                   // Convert bill items to a formatted string
//                   bill.items.isNotEmpty
//                       ? bill.items
//                           .map((item) =>
//                               "${item.categoryName + item.subcategoryName } (الكمية: ${item.quantity},سعر القطعة: ${item.price_per_unit}, السعر: ${item.total_Item_price})")
//                           .join("\n")
//                       : "لا يوجد أصناف",// If no items, display a placeholder text
//                   // رقم الفاتورة
//                   bill.id.toString(),
//                   // التاريخ
//                   bill.date != null
//                       ? "${bill.date.day}/${bill.date.month}/${bill.date.year}"
//                       : "N/A",
//                 ];
//               }).toList(),
//               border: pw.TableBorder.all(),
//               cellAlignment: pw.Alignment.center,
//             ),
//             pw.SizedBox(height: 20),
//             pw.Text("إجمالي الفواتير: $totalBills",
//                 style: pw.TextStyle(
//                   fontSize: 20,
//                 )),
//           ],
//         );
//       },
//     ),
//   );
//
//   // Save PDF to temporary directory
//   final tempDir = await getTemporaryDirectory();
//   final pdfFile = File("${tempDir.path}/statement.pdf");
//   await pdfFile.writeAsBytes(await pdf.save());
//
//   // Show Dialog with PDF Preview
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text("معاينة الفاتورة"),
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
//               final directory = await getApplicationDocumentsDirectory();
//               final savedFile = File("${directory.path}/كشف_حساب.pdf");
//               await pdfFile.copy(savedFile.path);
//               ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text("تم حفظ الملف في المستندات")));
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
