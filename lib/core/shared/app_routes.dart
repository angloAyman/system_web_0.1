import 'package:flutter/material.dart';
import 'package:system/features/attendance/Presentation/newattendancepage.dart';
import 'package:system/features/auth/data/auth_service.dart';
import 'package:system/features/auth/presentation/screens/login_screen.dart';
import 'package:system/main_screens/Responsive/AdmindevHomeResponsive.dart';
import 'package:system/main_screens/mobile_screens/Drawer/LoginTablePageMobile.dart';
import 'package:system/main_screens/mobile_screens/bills/BillingPage_mobileLayout.dart';
import 'package:system/user/UserLayouts/UserHomeScreen.dart';
import 'package:system/user/UserLayouts/admin.dart';
import 'package:system/user/features/Customer/presentation/customer_account_statement.dart';
import 'package:system/user/features/bills/presentation/UserBillingPage.dart';
import 'package:system/features/payment/PaymentPage.dart';
import 'package:system/features/billes/presentation/BillingPage.dart';
import 'package:system/user/features/payment/UserPaymentPage.dart';
import 'package:system/features/category/presentation/screens/Usercategory_page.dart';
import 'package:system/features/category/presentation/screens/category_page.dart';
import 'package:system/user/features/Customer/presentation/UsercustomerPage.dart';
import 'package:system/features/customer/presentation/customerPage.dart';
import 'package:system/features/auth/presentation/screens/AddUserScreen.dart';
import 'package:system/features/report/UI/ItemsReportDashboard.dart';
import 'package:system/features/report/UI/reportcategory/ReportCategoryOperationsPage.dart';
import 'package:system/main_screens/AdminLayouts/mainScreen.dart';
import 'package:system/main_screens/Responsive/AdminHomeResponsive.dart';
// import 'package:system/main_screens/UserLayouts/UserHomeScreen.dart';
// import 'package:system/main_screens/UserLayouts/admin.dart';

import 'package:system/user2/features/Customer/presentation/UsercustomerPage2.dart';
import 'package:system/user2/features/Customer/presentation/customer_account_statement2.dart';
import 'package:system/user2/features/bills/presentation/UserBillingPage2.dart';
import 'package:system/user2/features/payment/UserPaymentPage2.dart';
import 'package:system/user2/UserLayouts/UserHomeScreen2.dart';
import 'package:system/user2/UserLayouts/admin2.dart';

import '../../features/report/UI/billsReportPage.dart';

// fistPage route to login Responsive
import 'package:system/main_screens/Responsive/login_responsive.dart';

// loginLayouts
import 'package:system/main_screens/loginLayouts/Logindesktop_layout.dart';

import '../../main_screens/loginLayouts/Loginmobile_layout.dart';
import '../../main_screens/mobile_screens/Attendance/TimeScreen.dart';




late final AuthService authService;

final Map<String, WidgetBuilder> routes = {
  '/': (context) => LoginResponsive(),

  '/DesktopLoginLayout': (context) => LoginDesktopLayout(authService: authService),
  '/MobileLoginLayout': (context) => LoginMobileLayout(authService: authService),


  '/home': (context) => Mainscreen(),
  '/login': (context) => LoginScreen(authService: authService),
  '/adminHome': (context) => adminHomeResponsive(),
  '/billing': (context) => BillingPage(),
  '/Category': (context) => CategoryPage(),
  '/customer': (context) => CustomerPage(),
  '/Payment': (context) => PaymentPage(),

  '/UserCategory': (context) => UserCategoryPage(),




//   user
  '/userMainScreen': (context) => UserDashboard(),
  '/userHome': (context) => UserHomeScreen(),
  '/userbilling': (context) => UserBillingPage(),
  '/Usercustomer': (context) => UserCustomerPage(),
  '/UserPayment': (context) => UserPaymentPage(),
  '/CustomerSelectionPage': (context) => CustomerSelectionPage(),


// user2
  '/userMainScreen2': (context) => User2Dashboard(),
  '/userHome2': (context) => UserHomeScreen2(),
  '/userbilling2': (context) => UserBillingPage2(),
  '/Usercustomer2': (context) => UserCustomerPage2(),
  '/UserPayment2': (context) => UserPaymentPage2(),
  '/CustomerSelectionPage2': (context) => CustomerAccountStatement(),



  // mobile screens
  '/billingmobile': (context) => BillingPagemobile(),


  // '/TimeScreen': (context) => TimeScreen(),
  '/TimeScreen': (context) => LoginTablePageMobile(),



  // '/ItemsReport': (context) => billsReportPage(),
  // '/ItemsCharts': (context) => ReportCategoryOperationsPage(),
  // '/CategoryReport': (context) => ReportCategoryOperationsPage(),

  // انشاء تقرير
  '/ItemsReport': (context) => billsReportPage(),

  // المنتجات و الفواتير
  '/ItemsCharts': (context) => ItemsReportDashboard(),

  //تقارير عمليات الصنف
  '/CategoryReport': (context) => ReportCategoryOperationsPage(),

  '/adduser': (context) => AddUserScreen(),
  // '/report': (context) => ReportPage(),
  '/safe': (context) => PaymentPage(),
};
