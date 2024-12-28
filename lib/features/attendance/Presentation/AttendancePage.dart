// // import 'package:flutter/material.dart';
// // import 'package:qr_code_scanner/qr_code_scanner.dart';
// // import 'package:qr_flutter/qr_flutter.dart';
// // import 'package:system/features/attendance/Data/AttendanceRepository.dart';
// //
// // class AttendancePage extends StatefulWidget {
// //   @override
// //   _AttendancePageState createState() => _AttendancePageState();
// // }
// //
// // class _AttendancePageState extends State<AttendancePage> {
// //   final AttendanceRepository _attendanceRepository = AttendanceRepository();
// //
// //   bool _isScanning = false;
// //   String? _qrCodeResult;
// //   String _statusMessage = '';
// //   bool _isSubmitting = false;
// //
// //   late String _generatedQRCode;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _generateQRCode(); // Generate the QR code on page load
// //   }
// //
// //   void _generateQRCode() {
// //     final now = DateTime.now();
// //     final randomCode = 'attendance_${now.millisecondsSinceEpoch}';
// //     setState(() {
// //       _generatedQRCode = randomCode;
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('تسجيل الحضور والانصراف'),
// //       ),
// //
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           children: [
// //             Expanded(
// //               child: _isScanning
// //                   ? Center(
// //                 child: Column(
// //                   mainAxisSize: MainAxisSize.min,
// //                   children: [
// //                     Text('قم بمسح رمز الاستجابة السريع'),
// //                     SizedBox(height: 20),
// //                     SizedBox(
// //                       width: 300,
// //                       height: 300,
// //                       child: QRView(
// //                         key: GlobalKey(debugLabel: 'QR'),
// //                         onQRViewCreated: _onQRViewCreated,
// //                       ),
// //                     ),
// //                     ElevatedButton(
// //                       onPressed: () {
// //                         setState(() {
// //                           _isScanning = false;
// //                         });
// //                       },
// //                       child: Text('إلغاء المسح'),
// //                     ),
// //                   ],
// //                 ),
// //               )
// //                   : Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   ElevatedButton(
// //                     onPressed: () {
// //                       setState(() {
// //                         _isScanning = true;
// //                         _qrCodeResult = null;
// //                         _statusMessage = '';
// //                       });
// //                     },
// //                     child: Text('بدء مسح QR'),
// //                   ),
// //                   if (_qrCodeResult != null)
// //                     Padding(
// //                       padding: const EdgeInsets.symmetric(vertical: 16.0),
// //                       child: Text(
// //                         'تم مسح QR: $_qrCodeResult',
// //                         style: TextStyle(
// //                             fontSize: 16, fontWeight: FontWeight.bold),
// //                         textAlign: TextAlign.center,
// //                       ),
// //                     ),
// //                   if (_statusMessage.isNotEmpty)
// //                     Padding(
// //                       padding: const EdgeInsets.symmetric(vertical: 16.0),
// //                       child: Text(
// //                         _statusMessage,
// //                         style: TextStyle(
// //                           fontSize: 16,
// //                           fontWeight: FontWeight.bold,
// //                           color: _statusMessage.contains('نجاح')
// //                               ? Colors.green
// //                               : Colors.red,
// //                         ),
// //                         textAlign: TextAlign.center,
// //                       ),
// //                     ),
// //                   ElevatedButton(
// //                     onPressed: _qrCodeResult == null || _isSubmitting
// //                         ? null
// //                         : () => _submitAttendance(_qrCodeResult!),
// //                     child: _isSubmitting
// //                         ? CircularProgressIndicator(
// //                       valueColor:
// //                       AlwaysStoppedAnimation<Color>(Colors.white),
// //                     )
// //                         : Text('تسجيل الحضور'),
// //                   ),
// //                   SizedBox(height: 20),
// //                   Divider(),
// //                   SizedBox(height: 20),
// //                   Text(
// //                     'رمز QR الخاص بك:',
// //                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //                   ),
// //                   SizedBox(height: 10),
// //                   QrImageView(
// //                     data: _generatedQRCode,
// //                     size: 200,
// //                     backgroundColor: Colors.white,
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   void _onQRViewCreated(QRViewController controller) {
// //     controller.scannedDataStream.listen((scanData) {
// //       controller.pauseCamera();
// //       setState(() {
// //         _qrCodeResult = scanData.code;
// //         _isScanning = false;
// //       });
// //     });
// //   }
// //
// //   Future<void> _submitAttendance(String qrCode) async {
// //     setState(() {
// //       _isSubmitting = true;
// //     });
// //
// //     try {
// //       await _attendanceRepository.markAttendance(qrCode);
// //       setState(() {
// //         _statusMessage = 'تم تسجيل الحضور بنجاح!';
// //       });
// //     } catch (e) {
// //       setState(() {
// //         _statusMessage = 'فشل تسجيل الحضور: $e';
// //       });
// //     } finally {
// //       setState(() {
// //         _isSubmitting = false;
// //       });
// //     }
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:system/features/attendance/Data/AttendanceRepository.dart';
//
// class AttendancePage extends StatefulWidget {
//   @override
//   _AttendancePageState createState() => _AttendancePageState();
// }
//
// class _AttendancePageState extends State<AttendancePage> {
//   final AttendanceRepository _attendanceRepository = AttendanceRepository();
//
//   bool _isScanning = false;
//   String? _qrCodeResult;
//   String _statusMessage = '';
//   bool _isSubmitting = false;
//
//   late String _generatedQRCode;
//
//   @override
//   void initState() {
//     super.initState();
//     _generateQRCode(); // Generate the QR code on page load
//   }
//
//   void _generateQRCode() {
//     final now = DateTime.now();
//     final randomCode = 'attendance_${now.millisecondsSinceEpoch}';
//     setState(() {
//       _generatedQRCode = randomCode;
//     });
//   }
//
//   void _addShiftDialog() {
//     final _startController = TextEditingController();
//     final _endController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('إضافة وردية'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: _startController,
//                 decoration: InputDecoration(
//                   labelText: 'بداية الوردية',
//                   hintText: 'HH:MM',
//                 ),
//                 keyboardType: TextInputType.datetime,
//               ),
//               TextField(
//                 controller: _endController,
//                 decoration: InputDecoration(
//                   labelText: 'نهاية الوردية',
//                   hintText: 'HH:MM',
//                 ),
//                 keyboardType: TextInputType.datetime,
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('إلغاء'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 final start = _startController.text.trim();
//                 final end = _endController.text.trim();
//                 if (start.isEmpty || end.isEmpty) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('يرجى ملء جميع الحقول'),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                   return;
//                 }
//
//                 try {
//                   await _attendanceRepository.addShift(start, end);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('تمت إضافة الوردية بنجاح!'),
//                       backgroundColor: Colors.green,
//                     ),
//                   );
//                   Navigator.pop(context);
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('فشل إضافة الوردية: $e'),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 }
//               },
//               child: Text('إضافة'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('تسجيل الحضور والانصراف'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: _isScanning
//                   ? Center(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text('قم بمسح رمز الاستجابة السريع'),
//                     SizedBox(height: 20),
//                     SizedBox(
//                       width: 300,
//                       height: 300,
//                       child: QRView(
//                         key: GlobalKey(debugLabel: 'QR'),
//                         onQRViewCreated: _onQRViewCreated,
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           _isScanning = false;
//                         });
//                       },
//                       child: Text('إلغاء المسح'),
//                     ),
//                   ],
//                 ),
//               )
//                   : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         _isScanning = true;
//                         _qrCodeResult = null;
//                         _statusMessage = '';
//                       });
//                     },
//                     child: Text('بدء مسح QR'),
//                   ),
//                   if (_qrCodeResult != null)
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 16.0),
//                       child: Text(
//                         'تم مسح QR: $_qrCodeResult',
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.bold),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   if (_statusMessage.isNotEmpty)
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 16.0),
//                       child: Text(
//                         _statusMessage,
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: _statusMessage.contains('نجاح')
//                               ? Colors.green
//                               : Colors.red,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ElevatedButton(
//                     onPressed: _qrCodeResult == null || _isSubmitting
//                         ? null
//                         : () => _submitAttendance(_qrCodeResult!),
//                     child: _isSubmitting
//                         ? CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(
//                           Colors.white),
//                     )
//                         : Text('تسجيل الحضور'),
//                   ),
//                   SizedBox(height: 20),
//                   Divider(),
//                   SizedBox(height: 20),
//                   Text(
//                     'رمز QR الخاص بك:',
//                     style: TextStyle(
//                         fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 10),
//                   QrImageView(
//                     data: _generatedQRCode,
//                     size: 200,
//                     backgroundColor: Colors.white,
//                   ),
//                 ],
//               ),
//             ),
//             ElevatedButton(
//               onPressed: _addShiftDialog,
//               child: Text('إضافة وردية'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _onQRViewCreated(QRViewController controller) {
//     controller.scannedDataStream.listen((scanData) {
//       controller.pauseCamera();
//       setState(() {
//         _qrCodeResult = scanData.code;
//         _isScanning = false;
//       });
//     });
//   }
//
//   Future<void> _submitAttendance(String qrCode) async {
//     setState(() {
//       _isSubmitting = true;
//     });
//
//     try {
//       await _attendanceRepository.markAttendance(qrCode);
//       setState(() {
//         _statusMessage = 'تم تسجيل الحضور بنجاح!';
//       });
//     } catch (e) {
//       setState(() {
//         _statusMessage = 'فشل تسجيل الحضور: $e';
//       });
//     } finally {
//       setState(() {
//         _isSubmitting = false;
//       });
//     }
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:system/features/attendance/Data/AttendanceRepository.dart';
//
// class AttendancePage extends StatefulWidget {
//   @override
//   _AttendancePageState createState() => _AttendancePageState();
// }
//
// class _AttendancePageState extends State<AttendancePage> {
//   final AttendanceRepository _attendanceRepository = AttendanceRepository();
//
//   late String _dailyQRCode; // To store the generated QR code
//   bool _isSubmitting = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _generateDailyQRCode(); // Generate the daily QR code on page load
//   }
//
//   void _generateDailyQRCode() {
//     final now = DateTime.now();
//     final formattedDate = '${now.year}-${now.month}-${now.day}';
//     setState(() {
//       _dailyQRCode = 'daily_shift_$formattedDate';
//     });
//   }
//
//   void _addShiftDialog() {
//     final _startController = TextEditingController();
//     final _endController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('إضافة وردية'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: _startController,
//                 decoration: InputDecoration(
//                   labelText: 'بداية الوردية',
//                   hintText: 'HH:MM',
//                 ),
//                 keyboardType: TextInputType.datetime,
//               ),
//               TextField(
//                 controller: _endController,
//                 decoration: InputDecoration(
//                   labelText: 'نهاية الوردية',
//                   hintText: 'HH:MM',
//                 ),
//                 keyboardType: TextInputType.datetime,
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('إلغاء'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 final start = _startController.text.trim();
//                 final end = _endController.text.trim();
//                 if (start.isEmpty || end.isEmpty) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('يرجى ملء جميع الحقول'),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                   return;
//                 }
//
//                 try {
//                   await _attendanceRepository.addShift(
//                     start: start,
//                     end: end,
//                     qrCode: _dailyQRCode,
//                   );
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('تمت إضافة الوردية بنجاح!'),
//                       backgroundColor: Colors.green,
//                     ),
//                   );
//                   Navigator.pop(context);
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('فشل إضافة الوردية: $e'),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 }
//               },
//               child: Text('إضافة'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('تسجيل الحضور والانصراف'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'رمز QR اليومي:',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 10),
//                   QrImageView(
//                     data: _dailyQRCode,
//                     size: 200,
//                     backgroundColor: Colors.white,
//                   ),
//                   SizedBox(height: 20),
//                   Row(
//                     children: [
//                       ElevatedButton(
//                         onPressed: _addShiftDialog,
//                         child: Text('إضافة وردية جديدة'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/attendance/Presentation/Widget/QRScanner.dart';
import 'package:system/features/attendance/Presentation/Widget/QrCodeGenerator.dart';
import 'package:system/features/attendance/Presentation/Widget/ShiftDialog.dart';
import 'package:system/features/attendance/Data/AttendanceRepository.dart';
import 'package:system/features/attendance/Presentation/local_web_page.dart';

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final AttendanceRepository _attendanceRepository = AttendanceRepository();
  String? _qrCodeResult;
  String _statusMessage = '';
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تسجيل الحضور والانصراف'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(children: [
                    ElevatedButton(
                      onPressed: () => _addShiftDialog(context),
                      child: Text('إضافة وردية'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () => _startQRScanner(context),
                      child: Text('بدء مسح QR'),
                    ),

                  ],),
                  if (_qrCodeResult != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        // 'تم مسح QR: $_qrCodeResult',
                        'تم مسح QR: ',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (_statusMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        _statusMessage,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _statusMessage.contains('نجاح')
                              ? Colors.green
                              : Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ElevatedButton(
                    onPressed: _qrCodeResult == null || _isSubmitting
                        ? null
                        : () => _submitAttendance(_qrCodeResult!),
                    child: _isSubmitting
                        ? CircularProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                        : Text('تسجيل الحضور'),
                  ),
                  SizedBox(height: 20),
                  Divider(),
                  // SizedBox(height: 20),
                  QrCodeGenerator(),
                  // QRGeneratorPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitAttendance(String qrCode) async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      // Fetch the current logged-in user ID from Supabase
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('لم يتم تسجيل الدخول. يرجى تسجيل الدخول أولاً.');
      }
      final userId = user.id; // Get the user ID
      final status = 'present';
      final shiftId = await _attendanceRepository.getShiftIdByQrCode(qrCode);
      final timestamp = DateTime.now();

      // Mark attendance
      await _attendanceRepository.markAttendance(
        userId: userId,
        status: status,
        shiftId: shiftId,
        timestamp: timestamp,
      );
      await Future.delayed(Duration(seconds: 5));
      setState(() {
        _statusMessage = 'تم تسجيل الحضور بنجاح!';
      });
    } catch (e) {
      setState(() async {
        await Future.delayed(Duration(seconds: 5));

        print(e); // For debugging
        _statusMessage = 'فشل تسجيل الحضور: $e';
      });
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  // void _startQRScanner(BuildContext context) async {
  //   final result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => QRScanner()),
  //   );
  //   if (result != null) {
  //     setState(() {
  //       _qrCodeResult = result;
  //       _statusMessage = '';
  //     });
  //   }
  // }

  void _startQRScanner(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
          // QRScanner()
      QRScanner()
      ),
    );

    if (result != null) {
      setState(() {
        _qrCodeResult = result;
        _statusMessage = '';
      });

      // Open the local HTML page in a WebView
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => LocalWebViewPage(),
      //   ),
      // );
    }
  }

  void _addShiftDialog(BuildContext context) async {
    List<Map<String, dynamic>> shifts = [];

    // Fetch shifts from the database
    try {
      shifts = await _attendanceRepository.getShifts();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل في جلب الورديات: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final _startController = TextEditingController();
            final _endController = TextEditingController();
            final now = DateTime.now();
            final randomCode = 'attendance_${now.year}-${now.month}-${now.day}';

            return AlertDialog(
              title: Text('إدارة الورديات'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Table to display shifts
                  if (shifts.isNotEmpty)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('بداية الوردية')),
                          DataColumn(label: Text('نهاية الوردية')),
                          // DataColumn(label: Text('رمز QR')),
                        ],
                        rows: shifts
                            .map(
                              (shift) => DataRow(cells: [
                            DataCell(Text(shift['start_time'])),
                            DataCell(Text(shift['end_time'])),
                            // DataCell(Text(shift['qr_code'])),
                          ]),
                        )
                            .toList(),
                      ),
                    ),
                  if (shifts.isEmpty)
                    Text(
                      'لا توجد ورديات حالياً.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  SizedBox(height: 20),
                  // Input fields for new shifts
                  TextField(
                    controller: _startController,
                    decoration: InputDecoration(
                      labelText: 'بداية الوردية',
                      hintText: 'HH:MM',
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                  TextField(
                    controller: _endController,
                    decoration: InputDecoration(
                      labelText: 'نهاية الوردية',
                      hintText: 'HH:MM',
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('إلغاء'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final start = _startController.text.trim();
                    final end = _endController.text.trim();
                    if (start.isEmpty || end.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('يرجى ملء جميع الحقول'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    try {
                      await _attendanceRepository.addShift(
                        start: start,
                        end: end,
                        qrCode: randomCode,
                      );

                      // Update the shifts list
                      final updatedShifts =
                      await _attendanceRepository.getShifts();
                      setState(() {
                        shifts = updatedShifts;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('تمت إضافة الوردية بنجاح!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('فشل إضافة الوردية: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text('إضافة'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
