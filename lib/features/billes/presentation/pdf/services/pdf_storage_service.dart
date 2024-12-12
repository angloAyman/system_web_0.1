import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:math';

class PdfStorageService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final String _bucketName = 'pdf_bills';

  String _generateUniqueFileName(String baseName) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random();
    return '$timestamp-${random.nextInt(1000)}_$baseName';
  }

  Future<String> uploadPdf(String fileName, List<int> pdfBytes) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      final uniqueFileName = _generateUniqueFileName(fileName);
      final storage = _supabaseClient.storage.from(_bucketName);

      final response = await storage.upload(uniqueFileName, file);
      if (response == null) throw response;

      final publicUrl = storage.getPublicUrl(uniqueFileName);
      return publicUrl;
    } catch (e) {
      throw Exception('Error uploading PDF: $e');
    }
  }

  Future<void> deletePdf(String fileName) async {
    try {
      final storage = _supabaseClient.storage.from(_bucketName);
      final response = await storage.remove([fileName]);
      if (response == null) throw response;
    } catch (e) {
      throw Exception('Error deleting PDF: $e');
    }
  }

  // Method to generate QR code for the PDF URL
  Future<ByteData> generateQrCode(String pdfUrl) async {
    try {
      // Generate QR code as a PNG byte array
      final qrCode = await QrPainter(
        data: pdfUrl,
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.L,
      ).toImageData(200);

      if (qrCode == null) {
        throw Exception("Failed to generate QR code");
      }

      return qrCode;
    } catch (e) {
      throw Exception("Error generating QR code: $e");
    }
  }
}
