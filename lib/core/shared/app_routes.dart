import 'package:flutter/material.dart';
import 'package:system/features/auth/data/auth_service.dart';
import 'package:system/features/auth/presentation/screens/login_screen.dart';
import 'package:system/features/billes/presentation/payment/PaymentPage.dart';
import 'package:system/features/billes/presentation/BillingPage.dart';
import 'package:system/features/billes/presentation/report_page.dart';
import 'package:system/features/billes/presentation/safe/report_page.dart';
import 'package:system/features/customer/presentation/customerPage.dart';
import 'package:system/main_screens/Admin/AddUserScreen.dart';
import 'package:system/main_screens/Admin/AdminHomeScreen.dart';
import 'package:system/main_screens/Layouts/desktop_layout.dart';
import 'package:system/main_screens/MyHomeScreen.dart';
import 'package:system/main_screens/User/UserHomeScreen.dart';


// class AppRoutes {
//   // static const String login = '/';
//   static const String login = '/login';
//   static const String adminHome = '/adminHome';
//   static const String userHome = '/userHome';
//   static const String addUser = '/adduser';
//   static const String billing = '/billing';
//   static const String report = '/report';
//
// }

late final AuthService authService;

final Map<String, WidgetBuilder> routes = {
  '/': (context) => MyHomeScreen(),
  '/login': (context) => LoginScreen(authService: authService),
  '/DesktopLayout': (context) => DesktopLayout(authService: authService),
  '/adminHome': (context) => AdminHomeScreen(),
  '/userHome': (context) => UserHomeScreen(),
  '/adduser': (context) => AddUserScreen(),
  '/billing': (context) => BillingPage(),
  // '/report': (context) => ReportPage(),
  '/safe': (context) => PaymentPage(),
  '/customer': (context) => CustomerPage(),
};
