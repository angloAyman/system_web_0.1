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

// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class QRScannerPage extends StatefulWidget {
//   @override
//   _QRScannerPageState createState() => _QRScannerPageState();
// }
//
// class _QRScannerPageState extends State<QRScannerPage> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   QRViewController? controller;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Scan QR Code')),
//       body: Column(
//         children: [
//           Expanded(
//             flex: 5,
//             child: QRView(
//               key: qrKey,
//               onQRViewCreated: _onQRViewCreated,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _onQRViewCreated(QRViewController qrController) {
//     controller = qrController;
//
//     controller!.scannedDataStream.listen((scanData) async {
//       controller!.pauseCamera();
//
//       final String? scannedUrl = scanData.code;
//       if (scannedUrl != null && Uri.parse(scannedUrl).isAbsolute) {
//         // Open the URL in the browser
//         if (await canLaunch(scannedUrl)) {
//           await launch(scannedUrl);
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Could not launch URL')),
//           );
//         }
//       }
//
//       controller!.resumeCamera();
//     });
//   }
//
//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
// }
