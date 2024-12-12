import 'package:flutter/material.dart';
import 'package:system/features/auth/data/auth_service.dart';
import 'package:system/features/auth/presentation/screens/login_screen.dart';
import 'package:system/features/billes/presentation/payment/PaymentPage.dart';
import 'package:system/features/billes/presentation/BillingPage.dart';
import 'package:system/features/billes/presentation/safe/report_page.dart';
import 'package:system/features/category/presentation/screens/category_page.dart';
import 'package:system/features/customer/presentation/customerPage.dart';
import 'package:system/features/auth/presentation/screens/AddUserScreen.dart';
import 'package:system/features/report/UI/ItemsReportCharts.dart';
import 'package:system/main_screens/Admin/AdminHomeScreen.dart';
import 'package:system/main_screens/Admin/mainScreen.dart';
import 'package:system/main_screens/Layouts/desktop_layout.dart';
import 'package:system/main_screens/MyHomeScreen.dart';
import 'package:system/main_screens/User/UserHomeScreen.dart';

import '../../features/report/UI/billsReportPage.dart';


late final AuthService authService;

final Map<String, WidgetBuilder> routes = {
  '/': (context) => MyHomeScreen(),
  '/home': (context) => Mainscreen(),
  '/login': (context) => LoginScreen(authService: authService),
  '/DesktopLayout': (context) => DesktopLayout(authService: authService),
  '/adminHome': (context) => AdminHomeScreen(),
  '/userHome': (context) => UserHomeScreen(),
  '/billing': (context) => BillingPage(),
  '/Category': (context) => CategoryPage(),
  '/customer': (context) => CustomerPage(),
  '/Payment': (context) => PaymentPage(),
  '/ItemsReport': (context) => billsReportPage(),
  // '/ItemsCharts': (context) => ItemsReportCharts(),


  '/adduser': (context) => AddUserScreen(),
  // '/report': (context) => ReportPage(),
  '/safe': (context) => PaymentPage(),
};
