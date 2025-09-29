import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ApkDownloadScreen extends StatelessWidget {
  final String apkUrl;

  const ApkDownloadScreen({super.key, required this.apkUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Download APK")),
      body: Center(
        child: QrImageView(
          backgroundColor: Colors.white,
          data: apkUrl, // الرابط اللي من Supabase
          version: QrVersions.auto,
          size: 200.0,
        ),
      ),
    );
  }
}
