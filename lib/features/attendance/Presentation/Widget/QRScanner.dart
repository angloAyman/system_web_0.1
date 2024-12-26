import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('قم بمسح رمز الاستجابة السريع')),
      body: Center(
        child: SizedBox(
          width: 300,
          height: 300,
          child: QRView(
            key: GlobalKey(debugLabel: 'QR'),
            onQRViewCreated: (controller) {
              controller.scannedDataStream.listen((scanData) {
                controller.pauseCamera();
                Navigator.pop(context, scanData.code);
              });
            },
          ),
        ),
      ),
    );
  }
}
