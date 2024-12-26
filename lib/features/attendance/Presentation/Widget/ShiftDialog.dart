import 'package:flutter/material.dart';

class ShiftDialog extends StatelessWidget {
  final Function(String start, String end, String qrCode) onShiftAdded;

  ShiftDialog({required this.onShiftAdded});

  @override
  Widget build(BuildContext context) {
    final _startController = TextEditingController();
    final _endController = TextEditingController();
    final now = DateTime.now();
    final randomCode = 'attendance_${now.year}-${now.month}-${now.day}';

    return AlertDialog(
      title: Text('إضافة وردية'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
          onPressed: () {
            final start = _startController.text.trim();
            final end = _endController.text.trim();
            if (start.isNotEmpty && end.isNotEmpty) {
              onShiftAdded(start, end, randomCode);
              Navigator.pop(context);
            }
          },
          child: Text('إضافة'),
        ),
      ],
    );
  }
}
