// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:system/core/constants/colors.dart';
// import 'package:system/core/themes/AppColors/them_constants.dart';
// import 'package:system/features/attendance/Presentation/LoginTablePage.dart';
// import 'package:system/features/attendance/Presentation/newattendancepage.dart';
// import 'package:system/features/auth/data/auth_service.dart';
// import 'package:system/features/backup/BackupPage.dart';
// import 'package:system/features/report/UI/customer/customer_account_statement.dart';
// import 'package:system/features/report/UI/paymentout/PaymentReportPage.dart';
// import 'package:system/main.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:easy_sidemenu/easy_sidemenu.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:system/core/constants/colors.dart';
// import 'package:system/core/themes/AppColors/them_constants.dart';
// import 'package:system/features/Vaults/vaults_page.dart';
// import 'package:system/1not%20use/AttendancePage.dart';
// import 'package:system/features/auth/data/auth_service.dart';
// import 'package:system/features/payment/PaymentPage.dart';
// import 'package:system/features/payment/PaymentPage.dart';
// import 'package:system/features/billes/presentation/BillingPage.dart';
// import 'package:system/features/billes/presentation/safe/report_page.dart';
// import 'package:system/features/category/presentation/screens/category_page.dart';
// import 'package:system/features/customer/presentation/customerPage.dart';
// import 'package:system/features/report/UI/ItemsReportDashboard.dart';
// import 'package:system/features/report/UI/reportcategory/ReportCategoryOperationsPage.dart';
// import 'package:system/features/report/UI/billsReportPage.dart';
// import 'package:system/features/report/UI/ReportsPage.dart';
// import 'package:system/main.dart';
// import 'package:system/features/auth/presentation/screens/GetAllUsersScreen.dart';
// import 'package:system/main_screens/AdminLayouts/devmainScreen.dart';
//
// import '../Responsive/login_responsive.dart';
//
// class AdminDesktopLayout extends StatefulWidget {
//   final AuthService authService;
//   final String title = "Admin ROTOSH Pageas";
//
//   const AdminDesktopLayout({Key? key, required this.authService})
//       : super(key: key);
//
//   @override
//   State<AdminDesktopLayout> createState() => _AdminDesktopLayoutState();
// }
//
// class _AdminDesktopLayoutState extends State<AdminDesktopLayout> {
//   PageController pageController = PageController();
//   SideMenuController sideMenu = SideMenuController();
//   final AuthService _authService = AuthService(Supabase.instance.client);
//   final SupabaseClient supabase = Supabase.instance.client;
//
//   bool _isOffline = false;
//
//   String userName = "";
//   String userid = "";
//   String userRole = "";
//   Map<String, dynamic> userInfo = {}; // To store user info
//
//   @override
//   void initState() {
//     _monitorConnection();
//     super.initState();
//     fetchUserLogins();
//     sideMenu.addListener((index) {
//       pageController.jumpToPage(index);
//     });
//     _getUserInfo(); // Fetch the user info on initialization
//   }
//
//
//
//
//   // Monitor the connection status
//   void _monitorConnection() {
//     Connectivity()
//         .onConnectivityChanged
//         .listen((List<ConnectivityResult> result) {
//
//       setState(() {
//         // Assuming you want to check if there is no connectivity in any of the results.
//         _isOffline = result
//             .every((ConnectivityResult r) => r == ConnectivityResult.none);
//       });
//     });
//   }
//
//   Future<void> _getUserInfo() async {
//     final SupabaseClient supabase = Supabase.instance.client;
//
//     // Get the currently signed-in user's ID
//     final User? user = supabase.auth.currentUser;
//     if (user != null) {
//       // Fetch the user's profile from the 'users' table
//       final response = await supabase
//           .from('users')
//           .select('*') // Fetch all columns
//           .eq('id', user.id)
//           .single();
//
//       setState(() {
//         userName = response?['name'] ?? 'Unknown UserLayouts';
//         userid = response?['id'] ?? 'Unknown UserLayouts';
//         userRole = response?['role'] ?? 'Unknown UserLayouts';
//         userInfo = response ?? {}; // Store all user information
//       });
//     } else {
//       setState(() {
//         userName = 'No UserLayouts Signed In';
//       });
//     }
//   }
//
//   void _showUserInfoDialog(BuildContext context) {
//     if (userInfo.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('No user information available!')),
//       );
//       return;
//     }
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('معلومات المستخدم'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: userInfo.entries.map((entry) {
//                 return Text("${entry.key}: ${entry.value}");
//               }).toList(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('اغلاق'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> fetchUserLogins() async {
//
//     final response = await supabase
//         .from('logins')
//         .select('id, login_time, logout_time')
//         .eq('user_id', supabase.auth.currentUser!.id);
//
//     for (var log in response) {
//       DateTime loginTime = DateTime.parse(log['login_time']);
//       DateTime? logoutTime = log['logout_time'] != null
//           ? DateTime.parse(log['logout_time'])
//           : null;
//
//       if (logoutTime == null) {
//         DateTime autoLogoutTime = loginTime.add(Duration(minutes: 10));
//         if (autoLogoutTime.isBefore(DateTime.now())) {
//           logoutTime = autoLogoutTime;
//         }
//       }
//
//       print("Login: $loginTime, Logout: $logoutTime");
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         actions: [
//           Switch(
//               value: themeManagermain.themeMode == ThemeMode.dark,
//               onChanged: (newValue) {
//                 themeManagermain.toggleTheme(newValue);
//               })
//         ],
//         bottom: _isOffline
//             ? PreferredSize(
//                 preferredSize: const Size.fromHeight(30.0),
//                 child: Container(
//                   color: Colors.red,
//                   height: 30,
//                   child: const Center(
//                     child: Text(
//                       'لا يوجد اتصال بالإنترنت',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//               )
//             : null,
//       ),
//       body: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SideMenu(
//             controller: sideMenu,
//             style: SideMenuStyle(
//               openSideMenuWidth: 250,
//               itemBorderRadius: const BorderRadius.all(
//                 Radius.circular(50.0),
//               ),
//               // backgroundColor: AppColors.background,
//               backgroundColor: AppBarTheme.of(context).backgroundColor,
//               displayMode: SideMenuDisplayMode.auto,
//               showHamburger: true,
//               hoverColor: Colors.blue[100],
//               selectedHoverColor: Colors.blue[100],
//               selectedColor: Colors.lightBlue,
//               selectedTitleTextStyle: const TextStyle(color: Colors.white),
//               // unselectedTitleTextStyle: const TextStyle(color: Colors.white) ,
//               unselectedTitleTextStyle: TextStyle(
//                   color: AppBarTheme.of(context).titleTextStyle?.color),
//               selectedIconColor: AppBarTheme.of(context).titleTextStyle?.color,
//               unselectedIconColor:
//                   AppBarTheme.of(context).titleTextStyle?.color,
//               unselectedIconColorExpandable:
//                   AppBarTheme.of(context).titleTextStyle?.color,
//               selectedTitleTextStyleExpandable:
//                   const TextStyle(color: Colors.lightBlue),
//               selectedIconColorExpandable:
//                   AppBarTheme.of(context).titleTextStyle?.color,
//               arrowOpen: AppBarTheme.of(context).titleTextStyle?.color,
//               arrowCollapse: AppBarTheme.of(context).titleTextStyle?.color,
//             ),
//             title: Column(
//               children: [
//                  Container(
//                   color: Colors.transparent,
//                   // child: Padding(
//                     // padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
//                     child: GestureDetector(
//                       onTap: () {
//                         _showUserInfoDialog(context); // Show user info dialog
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           // color: AppColors.secondary,
//                           color: AppColors.secondary,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 4, horizontal: 50),
//                           child: Text(
//                             userName,
//                             style: TextStyle(fontSize: 20, color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 // ),
//                 const Divider(indent: 8.0, endIndent: 8.0),
//                 ConstrainedBox(
//                   constraints: const BoxConstraints(
//                     // maxHeight: 200,
//                     // maxWidth: 220,
//                   ),
//                   child: Column(
//                     children: [
//                       Container(
//                         height: 70,
//                         child: Image.asset(
//                           'assets/logo/logo-4.png',
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//               ],
//             ),
//             items: [
//               //الصفحة الرئيسية
//               SideMenuItem(
//                 title: 'الصفحة الرئيسية                ',
//                 onTap: (index, _) {
//                   sideMenu.changePage(index);
//                 },
//                 icon: const Icon(Icons.home),
//               ),
//               // المبيعات
//               SideMenuExpansionItem(
//                   title: "المبيعات",
//                   icon: const Icon(Icons.add_business_sharp),
//                   children: [
//                     //الفواتير
//                     SideMenuItem(
//                       // trailing: Text("الفواتير" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
//                       title: 'الفواتير                ',
//                       onTap: (index, _) {
//                         sideMenu.changePage(index);
//                       },
//                       icon: const Icon(Icons.file_copy_outlined),
//                     ),
//                   ]),
//
//               // تقارير
//               SideMenuExpansionItem(
//                   title: "التقارير",
//                   icon: const Icon(Icons.add_business_sharp),
//                   children: [
//                     //التقارير
//                     SideMenuItem(
//                       // trailing: Text("التقارير" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
//                       title: ' التقارير البرنامج                ',
//                       onTap: (index, _) {
//                         sideMenu.changePage(index);
//                       },
//                       icon: const Icon(Icons.file_copy_outlined),
//                     ),
//                     SideMenuItem(
//                       // trailing: Text("التقارير" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
//                       title: ' انشاء تقرير                ',
//                       onTap: (index, _) {
//                         sideMenu.changePage(index);
//                       },
//                       icon: const Icon(Icons.file_copy_outlined),
//                     ),
//                     SideMenuItem(
//                       // trailing: Text("التقارير" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
//                       title: '  المنتجات و الفواتير                ',
//                       onTap: (index, _) {
//                         sideMenu.changePage(index);
//                       },
//                       icon: const Icon(Icons.file_copy_outlined),
//                     ),
//                     SideMenuItem(
//                       // trailing: Text("التقارير" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
//                       title: ' تقارير عمليات الصنف                ',
//                       onTap: (index, _) {
//                         sideMenu.changePage(index);
//                       },
//                       icon: const Icon(Icons.file_copy_outlined),
//                     ),
//                     SideMenuItem(
//                       title: 'المصروفات                ',
//                       onTap: (index, _) {
//                         sideMenu.changePage(index);
//                       },
//                       icon: const Icon(Icons.file_copy_outlined),
//                     ),
//
//
//                     SideMenuItem(
//                       // trailing: Text("العملاء" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
//                       title: '     كشف حساب عميل         ',
//                       onTap: (index, _) {
//                         sideMenu.changePage(index);
//                       },
//                       icon: const Icon(Icons.supervised_user_circle_sharp),
//                     ),
//
//
//                     SideMenuItem(
//                       title: 'حضور و انصراف                ',
//                       onTap: (index, _) {
//                         sideMenu.changePage(index);
//                       },
//                       icon: const Icon(Icons.accessibility),
//                     ),
//                     SideMenuItem(
//                       title: 'نظام الحضور والانصراف                ',
//                       onTap: (index, _) {
//                         sideMenu.changePage(index);
//                       },
//                       icon: const Icon(Icons.accessibility),
//                     ),
//                   ]),
//               // الماليات
//               SideMenuExpansionItem(
//                   title: "المالية",
//                   icon: const Icon(Icons.kitchen),
//                   children: [
//                     SideMenuItem(
//                       title: 'القسم المالي                  ',
//                       onTap: (index, _) {
//                         sideMenu.changePage(index);
//                       },
//                       icon: const Icon(Icons.payment),
//                     ),
//                     SideMenuItem(
//                       title: 'الخزنة                  ',
//                       onTap: (index, _) {
//                         sideMenu.changePage(index);
//                       },
//                       icon: const Icon(Icons.paypal),
//                     ),
//                   ]),
//
//                     //العملاء
//                     SideMenuItem(
//                       // trailing: Text("العملاء" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
//                       title: 'العملاء                ',
//                       onTap: (index, _) {
//                         sideMenu.changePage(index);
//                       },
//                       icon: const Icon(Icons.supervised_user_circle_sharp),
//                     ),
//                     //
//                   // ]),
//               //الاصناف
//               SideMenuItem(
//                 // trailing: Text("الاصناف" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
//                 title: 'الاصناف               ',
//                 onTap: (index, _) {
//                   sideMenu.changePage(index);
//                 },
//                 icon: const Icon(Icons.book),
//               ),
//
//               // المستخدمين
//               SideMenuItem(
//                 // trailing: Text("المستخدمين" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
//                 title: '  المستخدمين           ',
//                 onTap: (index, _) {
//                   sideMenu.changePage(index);
//                 },
//                 icon: const Icon(Icons.supervisor_account),
//               ),
//               SideMenuItem(
//                 // trailing: Text("المستخدمين" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
//                 title: '  نسخة احتياطية           ',
//                 onTap: (index, _) {
//                   sideMenu.changePage(index);
//                 },
//                 icon: const Icon(Icons.supervisor_account),
//               ),
//               SideMenuItem(
//                 // trailing: Text("خروج" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
//                 title: 'خروج                  ',
//                 onTap: (index, _) async {
//                   // sideMenu.changePage(index);
//                   // await _authService.signOut();
//                   _authService.logoutUser(userid);
//
//                   // توجيه المستخدم لصفحة تسجيل الدخول **بدون زر الرجوع**
//                   Navigator.pushAndRemoveUntil(
//                     context,
//                     MaterialPageRoute(builder: (context) => LoginResponsive()),
//                         (Route<dynamic> route) => false, // إزالة جميع الصفحات السابقة
//                   );
//                   // Navigator. push<void>(
//                   //   context,
//                   //   MaterialPageRoute<void>(
//                   //     builder: (BuildContext context) =>  loginResponsive(),
//                   //   ),
//                   // );
//                   // Navigator.pushReplacementNamed(
//                   //     context, '/'); // توجيه المستخدم إلى صفحة تسجيل الدخول
//                 },
//                 icon: const Icon(Icons.output_rounded),
//               ),
//
//
//
//
//
//
//
//
//
//             ],
//           ),
//           // const VerticalDivider(width: 0),
//           Expanded(
//             child: PageView(
//               controller: pageController,
//               children: [
//                 // AttendancePage(),
//                 // الرئيسية
//                 Mainscreen(),
//                 // الفواتير
//                 BillingPage(),
//                 // Container(
//                 //   color: Colors.white,
//                 //   child: const Center(
//                 //     child: Text(
//                 //       'الفواتير',
//                 //       style: TextStyle(fontSize: 35),
//                 //     ),
//                 //   ),
//                 // ),
//
//                 //  Container(
//                 //    color: Colors.white,
//                 //    child: const Center(
//                 //      child: Text(
//                 //        'الاصناف',
//                 //        style: TextStyle(fontSize: 35),
//                 //      ),
//                 //    ),
//                 //  ),
//
//                 //تقاير
//                 // ReportPage(),
//                 // Container(
//                 //   color: Colors.white,
//                 //   child: const Center(
//                 //     child: Text(
//                 //       'ReportPage',
//                 //       style: TextStyle(fontSize: 35),
//                 //     ),
//                 //   ),
//                 // ),
//                 // app log
//                 // التقارير
//                 ReportsPage(),
//                 billsReportPage(),
//                 ItemsReportDashboard(),
//                 ReportCategoryOperationsPage(),
//                 PaymentReportPage(),
//                 // كشف حساب عميل
//                 CustomerSelectionPage(),
//
//
//                 LoginTablePage(),
//                 AttendancePage2(),
//
//                 // الماليات
//                 PaymentPage(),
//                 VaultsPage(
//                   userRole: userRole,
//                 ),
//                 //العملاء
//                 CustomerPage(),
//                 // الاصناف
//                 CategoryPage(),
//
//                 GetAllUsersScreen(),
//                 BackupPage(),
//
//                 // Container(
//                 //   color: Colors.white,
//                 //   child: const Center(
//                 //     child: Text(
//                 //       'خروج',
//                 //       style: TextStyle(fontSize: 35),
//                 //     ),
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'dart:async';

import 'package:flutter/material.dart';
import 'package:system/core/constants/colors.dart';
import 'package:system/core/themes/AppColors/them_constants.dart';
import 'package:system/features/attendance/Presentation/LoginTablePage.dart';
import 'package:system/features/attendance/Presentation/newattendancepage.dart';
import 'package:system/features/auth/data/auth_service.dart';
import 'package:system/features/downloadAPK/ApkDownloadScreen.dart';
import 'package:system/features/report/UI/customer/customer_account_statement.dart';
import 'package:system/features/report/UI/paymentout/PaymentReportPage.dart';
import 'package:system/main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/core/constants/colors.dart';
import 'package:system/core/themes/AppColors/them_constants.dart';
import 'package:system/features/Vaults/vaults_page.dart';
import 'package:system/1not%20use/AttendancePage.dart';
import 'package:system/features/auth/data/auth_service.dart';
import 'package:system/features/payment/PaymentPage.dart';
import 'package:system/features/payment/PaymentPage.dart';
import 'package:system/features/billes/presentation/BillingPage.dart';
import 'package:system/features/billes/presentation/safe/report_page.dart';
import 'package:system/features/category/presentation/screens/category_page.dart';
import 'package:system/features/customer/presentation/customerPage.dart';
import 'package:system/features/report/UI/ItemsReportDashboard.dart';
import 'package:system/features/report/UI/reportcategory/ReportCategoryOperationsPage.dart';
import 'package:system/features/report/UI/billsReportPage.dart';
import 'package:system/features/report/UI/ReportsPage.dart';
import 'package:system/main.dart';
import 'package:system/features/auth/presentation/screens/GetAllUsersScreen.dart';
import 'package:system/main_screens/AdminLayouts/mainScreen.dart';

import '../../features/backup/BackupPage2.dart';
import '../Responsive/login_responsive.dart';

class AdminDesktopLayout extends StatefulWidget {
  final AuthService authService;
  final String title = "Admin ROTOSH Pageas";

  const AdminDesktopLayout({Key? key, required this.authService})
      : super(key: key);

  @override
  State<AdminDesktopLayout> createState() => _AdminDesktopLayoutState();
}

class _AdminDesktopLayoutState extends State<AdminDesktopLayout> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();
  final AuthService _authService = AuthService(Supabase.instance.client);
  final SupabaseClient supabase = Supabase.instance.client;

  bool _isOffline = false;

  String userName = "";
  String userid = "";
  String userRole = "";
  Map<String, dynamic> userInfo = {}; // To store user info

  String? apkUrl;
  bool loading = true;


  @override
  void initState() {
    _monitorConnection();
    super.initState();
    fetchUserLogins();
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
    _getUserInfo(); // Fetch the user info on initialization
    fetchApkUrl();

  }




  // Monitor the connection status
  void _monitorConnection() {
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {

      setState(() {
        // Assuming you want to check if there is no connectivity in any of the results.
        _isOffline = result
            .every((ConnectivityResult r) => r == ConnectivityResult.none);
      });
    });
  }

  Future<void> _getUserInfo() async {
    final SupabaseClient supabase = Supabase.instance.client;

    // Get the currently signed-in user's ID
    final User? user = supabase.auth.currentUser;
    if (user != null) {
      // Fetch the user's profile from the 'users' table
      final response = await supabase
          .from('users')
          .select('*') // Fetch all columns
          .eq('id', user.id)
          .single();

      setState(() {
        userName = response?['name'] ?? 'Unknown UserLayouts';
        userid = response?['id'] ?? 'Unknown UserLayouts';
        userRole = response?['role'] ?? 'Unknown UserLayouts';
        userInfo = response ?? {}; // Store all user information
      });
    } else {
      setState(() {
        userName = 'No UserLayouts Signed In';
      });
    }
  }

  void _showUserInfoDialog(BuildContext context) {
    if (userInfo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No user information available!')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('معلومات المستخدم'),
          content: SingleChildScrollView(
            child: ListBody(
              children: userInfo.entries.map((entry) {
                return Text("${entry.key}: ${entry.value}");
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('اغلاق'),
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchUserLogins() async {

    final response = await supabase
        .from('logins')
        .select('id, login_time, logout_time')
        .eq('user_id', supabase.auth.currentUser!.id);

    for (var log in response) {
      DateTime loginTime = DateTime.parse(log['login_time']);
      DateTime? logoutTime = log['logout_time'] != null
          ? DateTime.parse(log['logout_time'])
          : null;

      if (logoutTime == null) {
        DateTime autoLogoutTime = loginTime.add(Duration(minutes: 10));
        if (autoLogoutTime.isBefore(DateTime.now())) {
          logoutTime = autoLogoutTime;
        }
      }

      print("Login: $loginTime, Logout: $logoutTime");
    }
  }

  Future<void> fetchApkUrl() async {
    final response = await Supabase.instance.client
        .from('app_links')
        .select('apk_url')
        .limit(1)
        .maybeSingle();

    setState(() {
      apkUrl = response?['apk_url'];
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Row(
            children: [
              Switch(
                  value: themeManagermain.themeMode == ThemeMode.dark,
                  onChanged: (newValue) {
                    themeManagermain.toggleTheme(newValue);
                  }),

              Center(
                child: loading
                    ? const CircularProgressIndicator()
                    : apkUrl == null
                    ? const Text("لا يوجد رابط APK")
                    : ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ApkDownloadScreen(apkUrl: apkUrl!),
                      ),
                    );
                  },
                  child: const Text("تحميل التطبيق"),
                ),
              ),

            ],
          )
        ],
        bottom: _isOffline
            ? PreferredSize(
          preferredSize: const Size.fromHeight(30.0),
          child: Container(
            color: Colors.red,
            height: 30,
            child: const Center(
              child: Text(
                'لا يوجد اتصال بالإنترنت',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        )
            : null,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SideMenu(
            controller: sideMenu,
            style: SideMenuStyle(
              openSideMenuWidth: 250,
              itemBorderRadius: const BorderRadius.all(
                Radius.circular(50.0),
              ),
              backgroundColor: AppBarTheme.of(context).backgroundColor,
              displayMode: SideMenuDisplayMode.auto,
              showHamburger: true,
              hoverColor: Colors.blue[100],
              selectedHoverColor: Colors.blue[100],
              selectedColor: Colors.lightBlue,
              selectedTitleTextStyle: const TextStyle(color: Colors.white),
              unselectedTitleTextStyle: TextStyle(
                  color: AppBarTheme.of(context).titleTextStyle?.color),
              selectedIconColor: AppBarTheme.of(context).titleTextStyle?.color,
              unselectedIconColor:
              AppBarTheme.of(context).titleTextStyle?.color,
              unselectedIconColorExpandable:
              AppBarTheme.of(context).titleTextStyle?.color,
              selectedTitleTextStyleExpandable:
              const TextStyle(color: Colors.lightBlue),
              selectedIconColorExpandable:
              AppBarTheme.of(context).titleTextStyle?.color,
              arrowOpen: AppBarTheme.of(context).titleTextStyle?.color,
              arrowCollapse: AppBarTheme.of(context).titleTextStyle?.color,
            ),
            title: Column(
              children: [
                Container(
                  color: Colors.transparent,
                  child: GestureDetector(
                    onTap: () {
                      _showUserInfoDialog(context); // Show user info dialog
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        // color: AppColors.secondary,
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 50),
                        child: Text(
                          userName,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                // ),
                const Divider(indent: 8.0, endIndent: 8.0),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    // maxHeight: 200,
                    // maxWidth: 220,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 70,
                        child: Image.asset(
                          'assets/logo/logo-4.png',
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
            items: [
              //الصفحة الرئيسية
              SideMenuItem(
                title: 'الصفحة الرئيسية                ',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.home),
              ),
              // المبيعات
              SideMenuExpansionItem(
                  title: "المبيعات",
                  icon: const Icon(Icons.add_business_sharp),
                  children: [
                    //الفواتير
                    SideMenuItem(
                      // trailing: Text("الفواتير" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
                      title: 'الفواتير                ',
                      onTap: (index, _) {
                        sideMenu.changePage(index);
                      },
                      icon: const Icon(Icons.file_copy_outlined),
                    ),
                  ]),

              // تقارير
              SideMenuExpansionItem(
                  title: "التقارير",
                  icon: const Icon(Icons.add_business_sharp),
                  children: [
                    //التقارير
                    SideMenuItem(
                      // trailing: Text("التقارير" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
                      title: ' التقارير البرنامج                ',
                      onTap: (index, _) {
                        sideMenu.changePage(index);
                      },
                      icon: const Icon(Icons.file_copy_outlined),
                    ),
                    SideMenuItem(
                      // trailing: Text("التقارير" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
                      title: ' انشاء تقرير                ',
                      onTap: (index, _) {
                        sideMenu.changePage(index);
                      },
                      icon: const Icon(Icons.file_copy_outlined),
                    ),
                    SideMenuItem(
                      // trailing: Text("التقارير" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
                      title: '  المنتجات و الفواتير                ',
                      onTap: (index, _) {
                        sideMenu.changePage(index);
                      },
                      icon: const Icon(Icons.file_copy_outlined),
                    ),
                    SideMenuItem(
                      // trailing: Text("التقارير" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
                      title: ' تقارير عمليات الصنف                ',
                      onTap: (index, _) {
                        sideMenu.changePage(index);
                      },
                      icon: const Icon(Icons.file_copy_outlined),
                    ),
                    SideMenuItem(
                      title: 'المصروفات                ',
                      onTap: (index, _) {
                        sideMenu.changePage(index);
                      },
                      icon: const Icon(Icons.file_copy_outlined),
                    ),


                    SideMenuItem(
                      // trailing: Text("العملاء" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
                      title: '     كشف حساب عميل         ',
                      onTap: (index, _) {
                        sideMenu.changePage(index);
                      },
                      icon: const Icon(Icons.supervised_user_circle_sharp),
                    ),


                    SideMenuItem(
                      title: 'حضور و انصراف                ',
                      onTap: (index, _) {
                        sideMenu.changePage(index);
                      },
                      icon: const Icon(Icons.accessibility),
                    ),
                    SideMenuItem(
                      title: 'نظام الحضور والانصراف                ',
                      onTap: (index, _) {
                        sideMenu.changePage(index);
                      },
                      icon: const Icon(Icons.accessibility),
                    ),
                  ]),
              // الماليات
              SideMenuExpansionItem(
                  title: "المالية",
                  icon: const Icon(Icons.kitchen),
                  children: [
                    SideMenuItem(
                      title: 'القسم المالي                  ',
                      onTap: (index, _) {
                        sideMenu.changePage(index);
                      },
                      icon: const Icon(Icons.payment),
                    ),
                    SideMenuItem(
                      title: 'الخزنة                  ',
                      onTap: (index, _) {
                        sideMenu.changePage(index);
                      },
                      icon: const Icon(Icons.paypal),
                    ),
                  ]),

              //العملاء
              SideMenuItem(
                // trailing: Text("العملاء" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
                title: 'العملاء                ',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.supervised_user_circle_sharp),
              ),

              //الاصناف
              SideMenuItem(
                title: 'الاصناف               ',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.book),
              ),

              // المستخدمين
              SideMenuItem(
                title: '  المستخدمين           ',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.supervisor_account),
              ),
              SideMenuItem(
                title: '  نسخة احتياطية           ',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.supervisor_account),
              ),
              SideMenuItem(
                title: 'خروج                  ',
                onTap: (index, _) async {

                  _authService.logoutUser(userid);

                  // توجيه المستخدم لصفحة تسجيل الدخول **بدون زر الرجوع**
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginResponsive()),
                        (Route<dynamic> route) => false, // إزالة جميع الصفحات السابقة
                  );

                },
                icon: const Icon(Icons.output_rounded),
              ),









            ],
          ),
          // const VerticalDivider(width: 0),
          Expanded(
            child: PageView(
              controller: pageController,
              children: [
                // الرئيسية
                Mainscreen(),
                // الفواتير
                BillingPage(),


                ReportsPage(),
                billsReportPage(),
                ItemsReportDashboard(),
                ReportCategoryOperationsPage(),
                PaymentReportPage(),
                // كشف حساب عميل
                CustomerSelectionPage(),


                LoginTablePage(),
                AttendancePage2(),

                // الماليات
                PaymentPage(),
                VaultsPage(
                  userRole: userRole,
                ),
                //العملاء
                CustomerPage(),
                // الاصناف
                CategoryPage(),

                GetAllUsersScreen(),
                BackupPage2(),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
