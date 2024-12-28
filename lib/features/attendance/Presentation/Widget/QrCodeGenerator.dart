import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeGenerator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final randomCode = 'attendance_${now.year}-${now.month}-${now.day}';
    return Column(
      children: [
        Text(
          'رمز QR الخاص بك:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        QrImageView(
          data: randomCode,
          size: 200,
          backgroundColor: Colors.white,
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';
//
// class QRGeneratorPage extends StatelessWidget {
//   final String baseUrl = 'https://mianifmvhtxtqxxhhwpr.supabase.co/confirm-attendance';
//
//   @override
//   Widget build(BuildContext context) {
//     final String attendanceId = 'unique-attendance-id'; // Replace with your logic
//     final String qrData = '$baseUrl?id=$attendanceId';
//
//     return Scaffold(
//       appBar: AppBar(title: Text('Generate QR Code')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Scan this QR Code:', style: TextStyle(fontSize: 18)),
//             SizedBox(height: 20),
//             QrImageView(
//               data: qrData,
//               size: 100,
//               backgroundColor: Colors.white,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
