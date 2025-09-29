import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
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
    // final initialPdfDocument = await PdfService.createBillWithoutQrCode(bill);
    // final initialPdfBytes = await initialPdfDocument.save();

    // 2. Upload the PDF to Supabase and get the public URL
    // final pdfUrl =
    //     await pdfStorageService.uploadPdf(pdfFileName, initialPdfBytes);

    // 3. Generate QR code data for the uploaded PDF URL
    // final qrCodeData = await pdfStorageService.generateQrCode(pdfUrl);
    final qrCodeData = await pdfStorageService.generateQrCode('${bill.id}');

    // 4. Generate the final PDF document with the QR code
    // final finalPdfDocument = // await PdfService.createBillWithQrCode(bill, pdfUrl, qrCodeData);
    final finalPdfDocument =  await PdfService.createBillWithQrCode(bill, qrCodeData);
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
    // Future<void> _shareToWhatsApp(
    //     String senderPhone, String receiverPhone, String pdfUrl) async {
    //   try {
    //     final message = 'فاتورتك: $pdfUrl';
    //     final encodedMessage = Uri.encodeComponent(message);
    //     final whatsappUrl = 'https://wa.me/$receiverPhone?text=$encodedMessage';
    //
    //     if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
    //       await launchUrl(Uri.parse(whatsappUrl));
    //       print('WhatsApp launched successfully with message: $message');
    //     } else {
    //       throw 'Could not launch WhatsApp';
    //     }
    //   } catch (e) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('خطأ في مشاركة الفاتورة عبر واتساب: $e')),
    //     );
    //   }
    // }



    // Future<void> _shareToWhatsApp(String senderPhone, String receiverPhone, Uint8List finalPdfBytes) async {
    //   try {
    //     // Get the temporary directory
    //     final directory = await getTemporaryDirectory();
    //     final filePath = '${directory.path}/invoice.pdf';
    //
    //     // Save the generated PDF to a file
    //     final file = File(filePath);
    //     await file.writeAsBytes(finalPdfBytes);
    //
    //     // Create XFile instance for sharing
    //     final xFile = XFile(filePath, mimeType: 'application/pdf');
    //
    //     // Share the PDF via WhatsApp
    //     await Share.shareXFiles([xFile], text: 'فاتورتك من $senderPhone');
    //   } catch (e) {
    //     print('خطأ في مشاركة الفاتورة عبر واتساب: $e');
    //   }
    // }




    // Future<void> _shareToWhatsApp(String senderPhone, String receiverPhone, Bill bill,) async {
    //   try {
    //     final qrCodeData = await pdfStorageService.generateQrCode('${bill.id}');
    //
    //     // Step 1: Generate the PDF
    //     final finalPdfDocument = await PdfService.createBillWithQrCode(bill, qrCodeData);
    //     final Uint8List finalPdfBytes = await finalPdfDocument.save();
    //
    //     // Step 2: Get the temporary directory
    //     final directory = await getTemporaryDirectory();
    //     final filePath = '${directory.path}/invoice.pdf';
    //
    //     // Step 3: Save the generated PDF to a file
    //     final file = File(filePath);
    //     await file.writeAsBytes(finalPdfBytes);
    //
    //     // Step 4: Create an XFile instance for sharing
    //     final xFile = XFile(filePath, mimeType: 'application/pdf');
    //
    //     // Step 5: Share the PDF via WhatsApp
    //     // Step 4: Share the PDF via WhatsApp with file path in subject
    //     await Share.shareXFiles(
    //       [xFile],
    //         // [file.path], // Using the File instance directly
    //         // text: '📄 فاتورتك من $senderPhone',
    //         subject: '📄 فاتورتك من $senderPhone' // File path in subject
    //     );
    //
    //
    //     // final message = 'فاتورتك: $xFile';
    //     //     final encodedMessage = Uri.encodeComponent(message);
    //     //     final whatsappUrl = 'https://wa.me/$receiverPhone?text=$encodedMessage';
    //     //
    //     //     if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
    //     //       await launchUrl(Uri.parse(whatsappUrl));
    //     //       print('WhatsApp launched successfully with message: $message');
    //     //     } else {
    //     //       throw 'Could not launch WhatsApp';
    //     //     }
    //
    //
    //   } catch (e) {
    //     print('⚠️ خطأ في مشاركة الفاتورة عبر واتساب: $e');
    //   }
    // }




    Future<void> _shareToWhatsApp(String senderPhone, String receiverPhone, Bill bill) async {
      try {
        final qrCodeData = await pdfStorageService.generateQrCode('${bill.id}');

        // Step 1: Generate the PDF
        final finalPdfDocument = await PdfService.createBillWithQrCode(bill, qrCodeData);
        final Uint8List finalPdfBytes = await finalPdfDocument.save();

        // Step 2: Get the temporary directory
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/invoice.pdf';

        // Step 3: Save the generated PDF to a file
        final file = File(filePath);
        await file.writeAsBytes(finalPdfBytes);

        // Step 4: Open WhatsApp Web with the number
        final whatsappUrl = 'https://wa.me/$receiverPhone?text=📄 فاتورتك من $senderPhone';

        if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
          await launchUrl(Uri.parse(whatsappUrl));
        } else {
          throw 'Could not launch WhatsApp';
        }

        // Step 5: Open the PDF manually (User has to upload it in WhatsApp manually)
        Process.run('xdg-open', [filePath]); // For Linux
        Process.run('open', [filePath]); // For macOS
        Process.run('start', [filePath], runInShell: true); // For Windows

      } catch (e) {
        print('⚠️ خطأ في مشاركة الفاتورة عبر واتساب: $e');
      }
    }


    // Function to display the input dialog
    Future<void> _showPhoneNumberDialog(Bill bill) async {
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
                  _shareToWhatsApp(senderPhone, receiverPhone, bill);
                  // _shareToWhatsApp(senderPhone, receiverPhone, pdfUrl);
                },
                child: Text('مشاركة'),
              ),
            ],
          );
        },
      );
      return;
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
              onPressed: (){
                _showPhoneNumberDialog(bill);
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
