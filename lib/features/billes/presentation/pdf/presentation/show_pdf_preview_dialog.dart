import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
    final pdfUrl =
        await pdfStorageService.uploadPdf(pdfFileName, initialPdfBytes);

    // 3. Generate QR code data for the uploaded PDF URL
    final qrCodeData = await pdfStorageService.generateQrCode(pdfUrl);

    // 4. Generate the final PDF document with the QR code
    final finalPdfDocument =
        await PdfService.createBillWithQrCode(bill, pdfUrl, qrCodeData);
    final finalPdfBytes = await finalPdfDocument.save();

    // Future<String?> fetchCustomerPhoneNumber(String customerName) async {
    //   final response = await Supabase.instance.client
    //       .from('customers')
    //       .select('phone_number')
    //       .eq('customer_name', customerName)
    //       .single();
    //
    //   if (response != null) {
    //     print('Error fetching phone number: ${response}');
    //     return null;
    //   }
    //
    //   return response['phone_number'] as String?;
    // }

    Future<String?> fetchCustomerPhoneNumber(String customerName) async {
      final supabase = Supabase.instance.client;

      // Check in normal_customers table
      final normalCustomerResponse = await supabase
          .from('normal_customers')
          .select('phone')
          .eq('name', customerName)
          .maybeSingle();

      if (normalCustomerResponse != null) {
        return normalCustomerResponse['phone'] as String?;
      }

      // Check in business_customers table
      final businessCustomerResponse = await supabase
          .from('business_customers')
          .select('phone')
          .eq('name', customerName)
          .maybeSingle();

      if (businessCustomerResponse != null) {
        return businessCustomerResponse['phone'] as String?;
      }

      // Customer not found in either table
      return null;
    }


    // 5. Function to share the PDF URL via WhatsApp
    Future<void> _shareToWhatsApp(
        String senderPhone, String receiverPhone, String pdfUrl) async {
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

    // Function to display the input dialog
    Future<void> _showPhoneNumberDialog() async {
      final senderController = TextEditingController();
      final receiverPhoneController = TextEditingController();

      final receiverPhone = await fetchCustomerPhoneNumber(bill.customerName);

      if (receiverPhone != null) {
        receiverPhoneController.text = receiverPhone;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في جلب رقم هاتف العميل')),
        );
        return;
      }

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('أدخل أرقام الهواتف'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: senderController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'رقم هاتف المرسل',
                    hintText: 'أدخل رقم هاتف المرسل',
                  ),
                ),
                TextField(
                  controller: receiverPhoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'رقم هاتف المستلم',
                    hintText: 'أدخل رقم هاتف المستلم',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  final senderPhone =  senderController.text.trim() ;
                  final receiverPhone = '+2' + receiverPhoneController.text.trim();
                  Navigator.of(context).pop();
                  _shareToWhatsApp(senderPhone, receiverPhone, pdfUrl);
                },
                child: Text('مشاركة'),
              ),
            ],
          );
        },
      );
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
              onPressed: _showPhoneNumberDialog,
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
