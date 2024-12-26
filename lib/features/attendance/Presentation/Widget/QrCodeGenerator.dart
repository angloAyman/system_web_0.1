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
