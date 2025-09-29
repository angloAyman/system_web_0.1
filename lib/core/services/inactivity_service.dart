import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/data/auth_service.dart';
import '../../main.dart';
import '../../main_screens/Responsive/login_responsive.dart';

class InactivityService {
  static final InactivityService _instance = InactivityService._internal();

  factory InactivityService() => _instance;

  InactivityService._internal();

  Timer? _inactivityTimer;
  final Duration timeoutDuration = Duration(minutes: 10);

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
  void dispose() {
    _inactivityTimer?.cancel();
  }
  Future<void> _handleInactivityTimeout(BuildContext context) async {
    final user = Supabase.instance.client.auth.currentUser;
    final AuthService _authService = AuthService(Supabase.instance.client);

    if (user != null) {
      _authService.logoutUser(user.id);

      if (!context.mounted) return;
      if (user != null) {
        await _authService.logoutUser(user.id);

        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => LoginResponsive()),
              (route) => false,
        );
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) =>
              AlertDialog(
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
}