// // import 'package:flutter/material.dart';
// // import 'package:qr_code_scanner/qr_code_scanner.dart';
// //
// // class QRViewExample extends StatefulWidget {
// //   @override
// //   State<StatefulWidget> createState() => _QRViewExampleState();
// // }
// //
// // class _QRViewExampleState extends State<QRViewExample> {
// //   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
// //   QRViewController? controller;
// //
// //   @override
// //   void dispose() {
// //     controller?.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text('مسح رمز QR')),
// //       body: Column(
// //         children: <Widget>[
// //           Expanded(
// //             flex: 5,
// //             child: QRView(
// //               key: qrKey,
// //               onQRViewCreated: _onQRViewCreated,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   void _onQRViewCreated(QRViewController controller) {
// //     this.controller = controller;
// //     controller.scannedDataStream.listen((scanData) {
// //       controller.pauseCamera();
// //       Navigator.pop(context, scanData.code);
// //
// //     });
// //   }
// //
// // }
//
// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
//
// class QRViewExample extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _QRViewExampleState();
// }
//
// class _QRViewExampleState extends State<QRViewExample> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   QRViewController? controller;
//   bool _isCameraInitialized = false;
//   bool _hasScanned = false;
//
//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
//
//   @override
//   void reassemble() {
//     super.reassemble();
//     if (controller != null) {
//       // Hot reload will pause the camera
//       controller!.pauseCamera();
//       // Hot restart will resume the camera
//       controller!.resumeCamera();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('مسح رمز QR'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             flex: 5,
//             child: Stack(
//               children: [
//                 QRView(
//                   key: qrKey,
//                   onQRViewCreated: _onQRViewCreated,
//                   overlay: QrScannerOverlayShape(
//                     borderColor: Colors.blue,
//                     borderRadius: 10,
//                     borderLength: 30,
//                     borderWidth: 10,
//                     cutOutSize: MediaQuery.of(context).size.width * 0.8,
//                   ),
//                 ),
//                 if (!_isCameraInitialized)
//                   Center(
//                     child: CircularProgressIndicator(),
//                   ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               'ضع رمز QR داخل الإطار للمسح',
//               style: TextStyle(fontSize: 16),
//             ),
//           ),
//           if (_hasScanned)
//             Padding(
//                 padding: const EdgeInsets.only(bottom: 16.0),
//                 child: Text(
//                   'تم مسح الرمز بنجاح!',
//                   style: TextStyle(color: Colors.green, fontSize: 16),
//                 )),
//         ],
//       ),
//     );
//   }
//
//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//
//     // Listen for camera initialization
//     controller.resumeCamera().then((_) {
//       if (mounted) {
//         setState(() {
//           _isCameraInitialized = true;
//         });
//       }
//     });
//
//     // Listen for scan results
//     controller.scannedDataStream.listen((scanData) {
//       if (_hasScanned) return; // Prevent multiple scans
//
//       setState(() {
//         _hasScanned = true;
//       });
//
//       // Pause camera and return the result after a small delay
//       controller.pauseCamera().then((_) {
//         Future.delayed(Duration(milliseconds: 500), () {
//           if (mounted) {
//             Navigator.pop(context, scanData.code);
//           }
//         });
//       });
//     }, onError: (error) {
//       // Handle scan errors
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('خطأ في المسح: $error')),
//         );
//       }
//     });
//   }
// }