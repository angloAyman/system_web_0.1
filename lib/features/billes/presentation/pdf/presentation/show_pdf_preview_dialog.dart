import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/billes/presentation/pdf/services/pdf_storage_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/pdf_service.dart';

Future<void> showPdfPreviewDialog(BuildContext context, Bill bill) async {
  final pdfStorageService = PdfStorageService();
  final pdfFileName = 'Invoice_${bill.id}.pdf';

  try {
    // 1. Generate the initial PDF document
    final initialPdfDocument = await PdfService.createBillWithoutQrCode(bill);
    final initialPdfBytes = await initialPdfDocument.save();

    // 2. Upload the PDF to Supabase and get the public URL
    final pdfUrl = await pdfStorageService.uploadPdf(pdfFileName, initialPdfBytes);

    // 3. Generate QR code data for the uploaded PDF URL
    final qrCodeData = await pdfStorageService.generateQrCode(pdfUrl) ;

    // 4. Generate the final PDF document with the QR code
    final finalPdfDocument = await PdfService.createBillWithQrCode(bill, pdfUrl, qrCodeData);
    final finalPdfBytes = await finalPdfDocument.save();

    // 5. Function to share the PDF URL via WhatsApp
    Future<void> _shareToWhatsApp(String senderPhone, String receiverPhone, String pdfUrl) async {
      try {
        final message = 'فاتورتك: $pdfUrl';
        final encodedMessage = Uri.encodeComponent(message);
        final whatsappUrl = 'https://wa.me/$receiverPhone?text=$encodedMessage';

        if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
          await launchUrl(Uri.parse(whatsappUrl));
          print('WhatsApp launched successfully with message: $message');
        } else {
          throw 'Could not launch WhatsApp';
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في مشاركة الفاتورة عبر واتساب: $e')),
        );
      }
    }

    // 6. Show the PDF preview dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('معاينة الفاتورة'),
          content: Container(
            width: double.maxFinite,
            height: 400,
            child: PdfPreview(
              build: (format) async => finalPdfBytes,
              allowSharing: true,
              allowPrinting: true,
              canChangePageFormat: false,
              canChangeOrientation: false,
              initialPageFormat: PdfPageFormat.a4,
              pdfFileName: pdfFileName,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('إغلاق'),
            ),
            TextButton(
              onPressed: () async {
                await Printing.sharePdf(
                  bytes: finalPdfBytes,
                  filename: pdfFileName,
                );
              },
              child: Text('حفظ'),
            ),
            TextButton(
              onPressed: () async {
                await Printing.layoutPdf(
                  onLayout: (format) async => finalPdfBytes,
                );
              },
              child: Text('طباعة'),
            ),
            TextButton(
              onPressed: () async {
                await _shareToWhatsApp('+201200078558', '+201023211175', pdfUrl);
              },
              child: Text('مشاركة عبر واتساب'),
            ),
          ],
        );
      },
    );
  } catch (e) {
    // Handle errors gracefully
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('حدث خطأ أثناء إنشاء الفاتورة: $e')),
    );
  }
}
