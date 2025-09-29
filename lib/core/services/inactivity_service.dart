import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InactivityService {
  static final InactivityService _instance = InactivityService._internal();
  factory InactivityService() => _instance;
  InactivityService._internal();

  Timer? _inactivityTimer;
  final Duration timeoutDuration = Duration(minutes: 1);

  void initialize(BuildContext context) {
    _resetTimer(context);
  }

  void _resetTimer(BuildContext context) {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(timeoutDuration, () {
      _handleInactivityTimeout(context);
    });
  }

  void userActivityDetected(BuildContext context) {
    _resetTimer(context);
  }

  Future<void> _handleInactivityTimeout(BuildContext context) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      await Supabase.instance.client.auth.signOut();
      if (!context.mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: Text('تم تسجيل الخروج'),
          content: Text('لقد انتهت الجلسة بسبب عدم النشاط.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('موافق'),
            ),
          ],
        ),
      );
    }
  }

  void dispose() {
    _inactivityTimer?.cancel();
  }
}
