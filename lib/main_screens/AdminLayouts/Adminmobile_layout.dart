// // // // import 'package:flutter/material.dart';
// // // // import 'package:system/core/constants/colors.dart';
// // // // import 'package:system/core/themes/AppColors/them_constants.dart';
// // // // import 'package:system/features/auth/data/auth_service.dart';
// // // // import 'package:system/main.dart';
// // // // import 'package:connectivity_plus/connectivity_plus.dart';
// // // // import 'package:connectivity_plus/connectivity_plus.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:easy_sidemenu/easy_sidemenu.dart';
// // // // import 'package:supabase_flutter/supabase_flutter.dart';
// // // // import 'package:system/core/constants/colors.dart';
// // // // import 'package:system/core/themes/AppColors/them_constants.dart';
// // // // import 'package:system/features/Vaults/vaults_page.dart';
// // // // import 'package:system/features/attendance/Presentation/AttendancePage.dart';
// // // // import 'package:system/features/auth/data/auth_service.dart';
// // // // import 'package:system/features/billes/presentation/payment/PaymentPage.dart';
// // // // import 'package:system/features/billes/presentation/payment/PaymentPage.dart';
// // // // import 'package:system/features/billes/presentation/BillingPage.dart';
// // // // import 'package:system/features/billes/presentation/safe/report_page.dart';
// // // // import 'package:system/features/category/presentation/screens/category_page.dart';
// // // // import 'package:system/features/customer/presentation/customerPage.dart';
// // // // import 'package:system/features/report/UI/ItemsReportDashboard.dart';
// // // // import 'package:system/features/report/UI/PaymentReportPage.dart';
// // // // import 'package:system/features/report/UI/billsReportPage.dart';
// // // // import 'package:system/features/report/UI/ReportsPage.dart';
// // // // import 'package:system/main.dart';
// // // // import 'package:system/features/auth/presentation/screens/GetAllUsersScreen.dart';
// // // // import 'package:system/main_screens/Admin/devmainScreen.dart';
// // // //
// // // // class AdminMobileLayout extends StatefulWidget {
// // // //   final AuthService authService;
// // // //   final String title = "Admin ROTOSH Page";
// // // //
// // // //   const AdminMobileLayout({Key? key, required this.authService}) : super(key: key);
// // // //
// // // //   @override
// // // //   State<AdminMobileLayout> createState() => _AdminMobileLayoutState();
// // // // }
// // // //
// // // // class _AdminMobileLayoutState extends State<AdminMobileLayout> {
// // // //   PageController pageController = PageController();
// // // //   SideMenuController sideMenu = SideMenuController();
// // // //   final AuthService _authService = AuthService(Supabase.instance.client);
// // // //   bool _isOffline = false;
// // // //
// // // //   String userName = "";
// // // //   String userRole = "";
// // // //   Map<String, dynamic> userInfo = {}; // To store user info
// // // //
// // // //   @override
// // // //   void initState() {
// // // //     _monitorConnection();
// // // //
// // // //     super.initState();
// // // //     sideMenu.addListener((index) {
// // // //       pageController.jumpToPage(index);
// // // //     });
// // // //     _getUserInfo(); // Fetch the user info on initialization
// // // //   }
// // // //
// // // //   // Monitor the connection status
// // // //   void _monitorConnection() {
// // // //     Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
// // // //       setState(() {
// // // //         // Assuming you want to check if there is no connectivity in any of the results.
// // // //         _isOffline = result.every((ConnectivityResult r) => r == ConnectivityResult.none);
// // // //       });
// // // //     });
// // // //   }
// // // //
// // // //   Future<void> _getUserInfo() async {
// // // //     final SupabaseClient supabase = Supabase.instance.client;
// // // //
// // // //     // Get the currently signed-in user's ID
// // // //     final UserLayouts? user = supabase.auth.currentUser;
// // // //     if (user != null) {
// // // //       // Fetch the user's profile from the 'users' table
// // // //       final response = await supabase
// // // //           .from('users')
// // // //           .select('*') // Fetch all columns
// // // //           .eq('id', user.id)
// // // //           .single();
// // // //
// // // //       setState(() {
// // // //         userName = response?['name'] ?? 'Unknown UserLayouts';
// // // //         userRole = response?['role'] ?? 'Unknown UserLayouts';
// // // //         userInfo = response ?? {}; // Store all user information
// // // //       });
// // // //     } else {
// // // //       setState(() {
// // // //         userName = 'No UserLayouts Signed In';
// // // //       });
// // // //     }
// // // //   }
// // // //
// // // //   void _showUserInfoDialog(BuildContext context) {
// // // //     if (userInfo.isEmpty) {
// // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // //         const SnackBar(content: Text('No user information available!')),
// // // //       );
// // // //       return;
// // // //     }
// // // //
// // // //     showDialog(
// // // //       context: context,
// // // //       builder: (BuildContext context) {
// // // //         return AlertDialog(
// // // //           title: const Text('معلومات المستخدم'),
// // // //           content: SingleChildScrollView(
// // // //             child: ListBody(
// // // //               children: userInfo.entries.map((entry) {
// // // //                 return Text("${entry.key}: ${entry.value}");
// // // //               }).toList(),
// // // //             ),
// // // //           ),
// // // //           actions: [
// // // //             TextButton(
// // // //               onPressed: () {
// // // //                 Navigator.of(context).pop();
// // // //               },
// // // //               child: const Text('اغلاق'),
// // // //             ),
// // // //           ],
// // // //         );
// // // //       },
// // // //     );
// // // //   }
// // // //
// // // //   @override
// // // //   void dispose() {
// // // //     // Cancel any active listeners or operations
// // // //     super.dispose();
// // // //   }
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(
// // // //         title: Text(widget.title),
// // // //         actions: [
// // // //           Switch(
// // // //               value: themeManagermain.themeMode == ThemeMode.dark,
// // // //               onChanged: (newValue) {
// // // //                 themeManagermain.toggleTheme(newValue);
// // // //               })
// // // //         ],
// // // //         bottom: _isOffline
// // // //             ? PreferredSize(
// // // //           preferredSize: const Size.fromHeight(30.0),
// // // //           child: Container(
// // // //             color: Colors.red,
// // // //             height: 30,
// // // //             child: const Center(
// // // //               child: Text(
// // // //                 'لا يوجد اتصال بالإنترنت',
// // // //                 style: TextStyle(color: Colors.white),
// // // //               ),
// // // //             ),
// // // //           ),
// // // //         )
// // // //             : null,
// // // //       ),
// // // //
// // // //       body: Row(
// // // //         mainAxisAlignment: MainAxisAlignment.center,
// // // //         children: [
// // // //           SideMenu(
// // // //             controller: sideMenu,
// // // //             style: SideMenuStyle(
// // // //               openSideMenuWidth: 250,
// // // //               itemBorderRadius: const BorderRadius.all(
// // // //                 Radius.circular(50.0),),
// // // //               // backgroundColor: AppColors.background,
// // // //               backgroundColor: AppBarTheme.of(context).backgroundColor,
// // // //               displayMode: SideMenuDisplayMode.auto,
// // // //               showHamburger: true,
// // // //               hoverColor: Colors.blue[100],
// // // //               selectedHoverColor: Colors.blue[100],
// // // //               selectedColor: Colors.lightBlue,
// // // //               selectedTitleTextStyle: const TextStyle(color: Colors.white),
// // // //               // unselectedTitleTextStyle: const TextStyle(color: Colors.white) ,
// // // //               unselectedTitleTextStyle:  TextStyle(color: AppBarTheme.of(context).titleTextStyle?.color ) ,
// // // //               selectedIconColor:AppBarTheme.of(context).titleTextStyle?.color,
// // // //               unselectedIconColor: AppBarTheme.of(context).titleTextStyle?.color,
// // // //               unselectedIconColorExpandable: AppBarTheme.of(context).titleTextStyle?.color ,
// // // //               selectedTitleTextStyleExpandable:  const TextStyle(color: Colors.lightBlue),
// // // //               selectedIconColorExpandable: AppBarTheme.of(context).titleTextStyle?.color ,
// // // //               arrowOpen: AppBarTheme.of(context).titleTextStyle?.color,
// // // //               arrowCollapse: AppBarTheme.of(context).titleTextStyle?.color,
// // // //             ),
// // // //             title: Column(
// // // //               children: [
// // // //                 ConstrainedBox(
// // // //                   constraints: const BoxConstraints(
// // // //                     maxHeight: 200,
// // // //                     maxWidth: 220,
// // // //
// // // //                   ),
// // // //
// // // //                   child: Container(
// // // //                     height: 84,
// // // //                     child: Image.asset(
// // // //                       'assets/logo/logo-4.png',
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //                 const Divider(indent: 8.0, endIndent: 8.0),
// // // //               ],
// // // //             ),
// // // //             footer: Padding(
// // // //               padding: const EdgeInsets.all(10.0),
// // // //               child: GestureDetector(
// // // //                 onTap: () {
// // // //                   _showUserInfoDialog(context); // Show user info dialog
// // // //                 },
// // // //                 child: Container(
// // // //                   decoration: BoxDecoration(
// // // //                     color: AppColors.secondary,
// // // //                     borderRadius: BorderRadius.circular(12),
// // // //                   ),
// // // //                   child: Padding(
// // // //                     padding:
// // // //                     const EdgeInsets.symmetric(vertical: 4, horizontal: 50),
// // // //                     child: Text(
// // // //                       userName,
// // // //                       style: TextStyle(fontSize: 15, color: Colors.grey[800]),
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //             items: [
// // // //               SideMenuItem(
// // // //                 title: 'حضور و اصراف                ',
// // // //                 onTap: (index, _) {
// // // //                   sideMenu.changePage(index);
// // // //                 },
// // // //                 icon: const Icon(Icons.home),
// // // //               ),
// // // //               //الصفحة الرئيسية
// // // //               SideMenuItem(
// // // //                 title: 'الصفحة الرئيسية                ',
// // // //                 onTap: (index, _) {
// // // //                   sideMenu.changePage(index);
// // // //                 },
// // // //                 icon: const Icon(Icons.home),
// // // //               ),
// // // //               // المبيعات
// // // //               SideMenuExpansionItem(
// // // //                   title: "المبيعات",
// // // //                   icon: const Icon(Icons.add_business_sharp),
// // // //                   children: [
// // // //                     //الفواتير
// // // //                     SideMenuItem(
// // // //                       // trailing: Text("الفواتير" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
// // // //                       title: 'الفواتير                ',
// // // //                       onTap: (index, _) {
// // // //                         sideMenu.changePage(index);
// // // //                       },
// // // //                       icon: const Icon(Icons.file_copy_outlined),
// // // //                     ),
// // // //                   ]),
// // // //
// // // //               // تقارير
// // // //               SideMenuExpansionItem(
// // // //                   title: "التقارير",
// // // //                   icon: const Icon(Icons.add_business_sharp),
// // // //                   children: [
// // // //                     //التقارير
// // // //                     SideMenuItem(
// // // //                       // trailing: Text("التقارير" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
// // // //                       title: ' التقارير البرنامج                ',
// // // //                       onTap: (index, _) {
// // // //                         sideMenu.changePage(index);
// // // //                       },
// // // //                       icon: const Icon(Icons.file_copy_outlined),
// // // //                     ),
// // // //                     SideMenuItem(
// // // //                       // trailing: Text("التقارير" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
// // // //                       title: ' انشاء تقرير                ',
// // // //                       onTap: (index, _) {
// // // //                         sideMenu.changePage(index);
// // // //                       },
// // // //                       icon: const Icon(Icons.file_copy_outlined),
// // // //                     ),
// // // //                     SideMenuItem(
// // // //                       // trailing: Text("التقارير" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
// // // //                       title: '  المنتجات و الفواتير                ',
// // // //                       onTap: (index, _) {
// // // //                         sideMenu.changePage(index);
// // // //                       },
// // // //                       icon: const Icon(Icons.gif_box),
// // // //                     ),
// // // //                     SideMenuItem(
// // // //                       // trailing: Text("التقارير" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
// // // //                       title: ' تقارير عمليات الصنف                ',
// // // //                       onTap: (index, _) {
// // // //                         sideMenu.changePage(index);
// // // //                       },
// // // //                       icon: const Icon(Icons.gif_box),
// // // //                     ),
// // // //
// // // //                   ]),
// // // //               // الماليات
// // // //               SideMenuExpansionItem(
// // // //                   title: "المالية",
// // // //                   icon: const Icon(Icons.kitchen),
// // // //                   children: [
// // // //                     SideMenuItem(
// // // //                       title: 'القسم المالي                  ',
// // // //                       onTap: (index, _) {
// // // //                         sideMenu.changePage(index);
// // // //                       },
// // // //                       icon: const Icon(Icons.payment),
// // // //                     ),
// // // //
// // // //                     SideMenuItem(
// // // //                       title: 'الخزنة                  ',
// // // //                       onTap: (index, _) {
// // // //                         sideMenu.changePage(index);
// // // //                       },
// // // //                       icon: const Icon(Icons.paypal),
// // // //                     ),
// // // //
// // // //                   ]),
// // // //
// // // //               //الاصناف
// // // //               SideMenuItem(
// // // //                 // trailing: Text("الاصناف" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
// // // //                 title: 'الاصناف               ',
// // // //                 onTap: (index, _) {
// // // //                   sideMenu.changePage(index);
// // // //                 },
// // // //                 icon: const Icon(Icons.book),
// // // //               ),
// // // //               // العملاء
// // // //               SideMenuItem(
// // // //                 // trailing: Text("العملاء" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
// // // //                 title: 'العملاء                ',
// // // //                 onTap: (index, _) {
// // // //                   sideMenu.changePage(index);
// // // //                 },
// // // //                 icon: const Icon(Icons.supervised_user_circle_sharp),
// // // //               ),
// // // //
// // // //               // المستخدمين
// // // //               SideMenuItem(
// // // //                 // trailing: Text("المستخدمين" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
// // // //                 title: '  المستخدمين           ',
// // // //                 onTap: (index, _) {
// // // //                   sideMenu.changePage(index);
// // // //                 },
// // // //                 icon: const Icon(Icons.supervisor_account),
// // // //               ),
// // // //               SideMenuItem(
// // // //                 // trailing: Text("خروج" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
// // // //                 title: 'خروج                  ',
// // // //                 onTap: (index, _) async {
// // // //                   // sideMenu.changePage(index);
// // // //                   await _authService.signOut();
// // // //                   Navigator.pushReplacementNamed(context, '/'); // توجيه المستخدم إلى صفحة تسجيل الدخول
// // // //
// // // //                 },
// // // //                 icon: const Icon(Icons.output_rounded),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //           // const VerticalDivider(width: 0),
// // // //           Expanded(
// // // //             child: PageView(
// // // //               controller: pageController,
// // // //               children: [
// // // //                 AttendancePage(),
// // // //                 // الرئيسية
// // // //                 Mainscreen(),
// // // //                 // الفواتير
// // // //                 BillingPage(),
// // // //                 // Container(
// // // //                 //   color: Colors.white,
// // // //                 //   child: const Center(
// // // //                 //     child: Text(
// // // //                 //       'الفواتير',
// // // //                 //       style: TextStyle(fontSize: 35),
// // // //                 //     ),
// // // //                 //   ),
// // // //                 // ),
// // // //
// // // //
// // // //                 //  Container(
// // // //                 //    color: Colors.white,
// // // //                 //    child: const Center(
// // // //                 //      child: Text(
// // // //                 //        'الاصناف',
// // // //                 //        style: TextStyle(fontSize: 35),
// // // //                 //      ),
// // // //                 //    ),
// // // //                 //  ),
// // // //
// // // //
// // // //                 //تقاير
// // // //                 // ReportPage(),
// // // //                 // Container(
// // // //                 //   color: Colors.white,
// // // //                 //   child: const Center(
// // // //                 //     child: Text(
// // // //                 //       'ReportPage',
// // // //                 //       style: TextStyle(fontSize: 35),
// // // //                 //     ),
// // // //                 //   ),
// // // //                 // ),
// // // //                 // app log
// // // //                 // التقارير
// // // //                 ReportsPage(),
// // // //                 billsReportPage(),
// // // //                 ItemsReportDashboard(),
// // // //                 ReportCategoryOperationsPage(),
// // // //                 // الماليات
// // // //                 PaymentPage(),
// // // //                 VaultsPage(userRole: userRole,),
// // // //
// // // //                 // الاصناف
// // // //                 CategoryPage(),
// // // //                 //العملاء
// // // //                 CustomerPage(),
// // // //
// // // //                 GetAllUsersScreen(),
// // // //
// // // //
// // // //                 // Container(
// // // //                 //   color: Colors.white,
// // // //                 //   child: const Center(
// // // //                 //     child: Text(
// // // //                 //       'خروج',
// // // //                 //       style: TextStyle(fontSize: 35),
// // // //                 //     ),
// // // //                 //   ),
// // // //                 // ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // // import 'package:flutter/material.dart';
// // // import 'package:system/core/constants/colors.dart';
// // // import 'package:system/core/themes/AppColors/them_constants.dart';
// // // import 'package:system/features/auth/data/auth_service.dart';
// // // import 'package:system/main.dart';
// // // import 'package:connectivity_plus/connectivity_plus.dart';
// // // import 'package:supabase_flutter/supabase_flutter.dart';
// // // import 'package:system/features/Vaults/vaults_page.dart';
// // // import 'package:system/features/attendance/Presentation/AttendancePage.dart';
// // // import 'package:system/features/auth/data/auth_service.dart';
// // // import 'package:system/features/billes/presentation/payment/PaymentPage.dart';
// // // import 'package:system/features/billes/presentation/BillingPage.dart';
// // // import 'package:system/features/billes/presentation/safe/report_page.dart';
// // // import 'package:system/features/category/presentation/screens/category_page.dart';
// // // import 'package:system/features/customer/presentation/customerPage.dart';
// // // import 'package:system/features/report/UI/ItemsReportDashboard.dart';
// // // import 'package:system/features/report/UI/PaymentReportPage.dart';
// // // import 'package:system/features/report/UI/billsReportPage.dart';
// // // import 'package:system/features/report/UI/ReportsPage.dart';
// // // import 'package:system/main.dart';
// // // import 'package:system/features/auth/presentation/screens/GetAllUsersScreen.dart';
// // // import 'package:system/main_screens/Admin/devmainScreen.dart';
// // //
// // // class AdminMobileLayout extends StatefulWidget {
// // //   final AuthService authService;
// // //   final String title = "Admin ROTOSH Page";
// // //
// // //   const AdminMobileLayout({Key? key, required this.authService}) : super(key: key);
// // //
// // //   @override
// // //   State<AdminMobileLayout> createState() => _AdminMobileLayoutState();
// // // }
// // //
// // // class _AdminMobileLayoutState extends State<AdminMobileLayout> {
// // //   PageController pageController = PageController();
// // //   final AuthService _authService = AuthService(Supabase.instance.client);
// // //   bool _isOffline = false;
// // //
// // //   String userName = "";
// // //   String userRole = "";
// // //   Map<String, dynamic> userInfo = {}; // To store user info
// // //
// // //   @override
// // //   void initState() {
// // //     _monitorConnection();
// // //
// // //     super.initState();
// // //     _getUserInfo(); // Fetch the user info on initialization
// // //   }
// // //
// // //   // Monitor the connection status
// // //   void _monitorConnection() {
// // //     Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
// // //       setState(() {
// // //         // Assuming you want to check if there is no connectivity in any of the results.
// // //         _isOffline = result.every((ConnectivityResult r) => r == ConnectivityResult.none);
// // //       });
// // //     });
// // //   }
// // //
// // //   Future<void> _getUserInfo() async {
// // //     final SupabaseClient supabase = Supabase.instance.client;
// // //
// // //     // Get the currently signed-in user's ID
// // //     final UserLayouts? user = supabase.auth.currentUser;
// // //     if (user != null) {
// // //       // Fetch the user's profile from the 'users' table
// // //       final response = await supabase
// // //           .from('users')
// // //           .select('*') // Fetch all columns
// // //           .eq('id', user.id)
// // //           .single();
// // //
// // //       setState(() {
// // //         userName = response?['name'] ?? 'Unknown UserLayouts';
// // //         userRole = response?['role'] ?? 'Unknown UserLayouts';
// // //         userInfo = response ?? {}; // Store all user information
// // //       });
// // //     } else {
// // //       setState(() {
// // //         userName = 'No UserLayouts Signed In';
// // //       });
// // //     }
// // //   }
// // //
// // //   void _showUserInfoDialog(BuildContext context) {
// // //     if (userInfo.isEmpty) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         const SnackBar(content: Text('No user information available!')),
// // //       );
// // //       return;
// // //     }
// // //
// // //     showDialog(
// // //       context: context,
// // //       builder: (BuildContext context) {
// // //         return AlertDialog(
// // //           title: const Text('معلومات المستخدم'),
// // //           content: SingleChildScrollView(
// // //             child: ListBody(
// // //               children: userInfo.entries.map((entry) {
// // //                 return Text("${entry.key}: ${entry.value}");
// // //               }).toList(),
// // //             ),
// // //           ),
// // //           actions: [
// // //             TextButton(
// // //               onPressed: () {
// // //                 Navigator.of(context).pop();
// // //               },
// // //               child: const Text('اغلاق'),
// // //             ),
// // //           ],
// // //         );
// // //       },
// // //     );
// // //   }
// // //
// // //   @override
// // //   void dispose() {
// // //     // Cancel any active listeners or operations
// // //     super.dispose();
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text(widget.title),
// // //         actions: [
// // //           Switch(
// // //               value: themeManagermain.themeMode == ThemeMode.dark,
// // //               onChanged: (newValue) {
// // //                 themeManagermain.toggleTheme(newValue);
// // //               })
// // //         ],
// // //         bottom: _isOffline
// // //             ? PreferredSize(
// // //           preferredSize: const Size.fromHeight(30.0),
// // //           child: Container(
// // //             color: Colors.red,
// // //             height: 30,
// // //             child: const Center(
// // //               child: Text(
// // //                 'لا يوجد اتصال بالإنترنت',
// // //                 style: TextStyle(color: Colors.white),
// // //               ),
// // //             ),
// // //           ),
// // //         )
// // //             : null,
// // //       ),
// // //       drawer: Drawer(
// // //         child: ListView(
// // //           padding: EdgeInsets.zero,
// // //           children: [
// // //             UserAccountsDrawerHeader(
// // //               accountName: Text(userName),
// // //               accountEmail: Text(userRole),
// // //               currentAccountPicture: CircleAvatar(
// // //                 backgroundColor: Colors.white,
// // //                 child: Text(userName[0], style: TextStyle(color: Colors.black)),
// // //               ),
// // //             ),
// // //             ListTile(
// // //               title: const Text('حضور و اصراف'),
// // //               onTap: () {
// // //                 Navigator.pushReplacement(
// // //                   context,
// // //                   MaterialPageRoute(builder: (context) => AttendancePage()),
// // //                 );
// // //               },
// // //             ),
// // //             ListTile(
// // //               title: const Text('الصفحة الرئيسية'),
// // //               onTap: () {
// // //                 Navigator.pushReplacement(
// // //                   context,
// // //                   MaterialPageRoute(builder: (context) => Mainscreen()),
// // //                 );
// // //               },
// // //             ),
// // //             ListTile(
// // //               title: const Text('الفواتير'),
// // //               onTap: () {
// // //                 Navigator.pushReplacement(
// // //                   context,
// // //                   MaterialPageRoute(builder: (context) => BillingPage()),
// // //                 );
// // //               },
// // //             ),
// // //             ListTile(
// // //               title: const Text('التقارير'),
// // //               onTap: () {
// // //                 Navigator.pushReplacement(
// // //                   context,
// // //                   MaterialPageRoute(builder: (context) => ReportsPage()),
// // //                 );
// // //               },
// // //             ),
// // //             ListTile(
// // //               title: const Text('انشاء تقرير'),
// // //               onTap: () {
// // //                 Navigator.pushReplacement(
// // //                   context,
// // //                   MaterialPageRoute(builder: (context) => ReportCategoryOperationsPage()),
// // //                 );
// // //               },
// // //             ),
// // //             ListTile(
// // //               title: const Text('المالية'),
// // //               onTap: () {
// // //                 Navigator.pushReplacement(
// // //                   context,
// // //                   MaterialPageRoute(builder: (context) => PaymentPage()),
// // //                 );
// // //               },
// // //             ),
// // //             ListTile(
// // //               title: const Text('الخزنة'),
// // //               onTap: () {
// // //                 Navigator.pushReplacement(
// // //                   context,
// // //                   MaterialPageRoute(builder: (context) => VaultsPage(userRole: userRole)),
// // //                 );
// // //               },
// // //             ),
// // //             ListTile(
// // //               title: const Text('الاصناف'),
// // //               onTap: () {
// // //                 Navigator.pushReplacement(
// // //                   context,
// // //                   MaterialPageRoute(builder: (context) => CategoryPage()),
// // //                 );
// // //               },
// // //             ),
// // //             ListTile(
// // //               title: const Text('العملاء'),
// // //               onTap: () {
// // //                 Navigator.pushReplacement(
// // //                   context,
// // //                   MaterialPageRoute(builder: (context) => CustomerPage()),
// // //                 );
// // //               },
// // //             ),
// // //             ListTile(
// // //               title: const Text('المستخدمين'),
// // //               onTap: () {
// // //                 Navigator.pushReplacement(
// // //                   context,
// // //                   MaterialPageRoute(builder: (context) => GetAllUsersScreen()),
// // //                 );
// // //               },
// // //             ),
// // //             ListTile(
// // //               title: const Text('خروج'),
// // //               onTap: () async {
// // //                 await _authService.signOut();
// // //                 Navigator.pushReplacementNamed(context, '/');
// // //               },
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //       body: PageView(
// // //         controller: pageController,
// // //         children: [
// // //           AttendancePage(),
// // //           Mainscreen(),
// // //           BillingPage(),
// // //           ReportsPage(),
// // //           ReportCategoryOperationsPage(),
// // //           PaymentPage(),
// // //           VaultsPage(userRole: userRole),
// // //           CategoryPage(),
// // //           CustomerPage(),
// // //           GetAllUsersScreen(),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'package:flutter/material.dart';
// // import 'package:system/core/constants/colors.dart';
// // import 'package:system/core/themes/AppColors/them_constants.dart';
// // import 'package:system/features/auth/data/auth_service.dart';
// // import 'package:system/main.dart';
// // import 'package:connectivity_plus/connectivity_plus.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart';
// // import 'package:system/features/Vaults/vaults_page.dart';
// // import 'package:system/1not%20use/AttendancePage.dart';
// // import 'package:system/features/auth/data/auth_service.dart';
// // import 'package:system/features/payment/PaymentPage.dart';
// // import 'package:system/features/billes/presentation/BillingPage.dart';
// // import 'package:system/features/billes/presentation/safe/report_page.dart';
// // import 'package:system/features/category/presentation/screens/category_page.dart';
// // import 'package:system/features/customer/presentation/customerPage.dart';
// // import 'package:system/features/report/UI/ItemsReportDashboard.dart';
// // import 'package:system/features/report/UI/reportcategory/PaymentReportPage.dart';
// // import 'package:system/features/report/UI/billsReportPage.dart';
// // import 'package:system/features/report/UI/ReportsPage.dart';
// // import 'package:system/main.dart';
// // import 'package:system/features/auth/presentation/screens/GetAllUsersScreen.dart';
// // import 'package:system/main_screens/AdminLayouts/devmainScreen.dart';
// //
// // class AdminMobileLayout extends StatefulWidget {
// //   final AuthService authService;
// //   final String title = "Admin ROTOSH Page";
// //
// //   const AdminMobileLayout({Key? key, required this.authService}) : super(key: key);
// //
// //   @override
// //   State<AdminMobileLayout> createState() => _AdminMobileLayoutState();
// // }
// //
// // class _AdminMobileLayoutState extends State<AdminMobileLayout> {
// //   PageController pageController = PageController();
// //   final AuthService _authService = AuthService(Supabase.instance.client);
// //   bool _isOffline = false;
// //
// //   String userName = "";
// //   String userRole = "";
// //   Map<String, dynamic> userInfo = {}; // To store user info
// //
// //   @override
// //   void initState() {
// //     _monitorConnection();
// //
// //     super.initState();
// //     _getUserInfo(); // Fetch the user info on initialization
// //   }
// //
// //   // Monitor the connection status
// //   void _monitorConnection() {
// //     Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
// //       setState(() {
// //         // Assuming you want to check if there is no connectivity in any of the results.
// //         _isOffline = result.every((ConnectivityResult r) => r == ConnectivityResult.none);
// //       });
// //     });
// //   }
// //
// //   Future<void> _getUserInfo() async {
// //     final SupabaseClient supabase = Supabase.instance.client;
// //
// //     // Get the currently signed-in user's ID
// //     final User? user = supabase.auth.currentUser;
// //     if (user != null) {
// //       // Fetch the user's profile from the 'users' table
// //       final response = await supabase
// //           .from('users')
// //           .select('*') // Fetch all columns
// //           .eq('id', user.id)
// //           .single();
// //
// //       setState(() {
// //         userName = response?['name'] ?? 'Unknown UserLayouts';
// //         userRole = response?['role'] ?? 'Unknown UserLayouts';
// //         userInfo = response ?? {}; // Store all user information
// //       });
// //     } else {
// //       setState(() {
// //         userName = 'No UserLayouts Signed In';
// //       });
// //     }
// //   }
// //
// //   void _showUserInfoDialog(BuildContext context) {
// //     if (userInfo.isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('No user information available!')),
// //       );
// //       return;
// //     }
// //
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: const Text('معلومات المستخدم'),
// //           content: SingleChildScrollView(
// //             child: ListBody(
// //               children: userInfo.entries.map((entry) {
// //                 return Text("${entry.key}: ${entry.value}");
// //               }).toList(),
// //             ),
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () {
// //                 Navigator.of(context).pop();
// //               },
// //               child: const Text('اغلاق'),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// //
// //   @override
// //   void dispose() {
// //     // Cancel any active listeners or operations
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         // title: Text(widget.title),
// //         title: Text("Admin ROTOSH "),
// //         actions: [
// //           Switch(
// //               value: themeManagermain.themeMode == ThemeMode.dark,
// //               onChanged: (newValue) {
// //                 themeManagermain.toggleTheme(newValue);
// //               })
// //         ],
// //         leading: Navigator.canPop(context)
// //             ? IconButton(
// //           icon: const Icon(Icons.arrow_back),
// //           onPressed: () {
// //             Navigator.pop(context); // Goes back to the previous screen
// //           },
// //         )
// //             : null,
// //         bottom: _isOffline
// //             ? PreferredSize(
// //           preferredSize: const Size.fromHeight(30.0),
// //           child: Container(
// //             color: Colors.red,
// //             height: 30,
// //             child: const Center(
// //               child: Text(
// //                 'لا يوجد اتصال بالإنترنت',
// //                 style: TextStyle(color: Colors.white),
// //               ),
// //             ),
// //           ),
// //         )
// //             : null,
// //       ),
// //       drawer: Drawer(
// //         child: ListView(
// //           padding: EdgeInsets.zero,
// //           children: [
// //             UserAccountsDrawerHeader(
// //               accountName: Text(userName),
// //               accountEmail: Text(userRole),
// //               currentAccountPicture: CircleAvatar(
// //                 backgroundColor: Colors.white,
// //                 child: Text(userName[0], style: TextStyle(color: Colors.black)),
// //               ),
// //             ),
// //             ListTile(
// //               title: const Text('الصفحة الرئيسية'),
// //               onTap: () {
// //                 // Navigator.pushReplacement(
// //                 //   context,
// //                 //   // MaterialPageRoute(builder: (context) => Mainscreen()),
// //                 // );
// //               },
// //             ),
// //
// //             ListTile(
// //               title: const Text('الفواتير'),
// //               onTap: () {
// //                 // Navigator.pushReplacement(
// //                 //   context,
// //                 //   MaterialPageRoute(builder: (context) => BillingPage()),
// //                 // );
// //               },
// //             ),
// //
// //             ListTile(
// //               title: const Text('تقارير البرنامج'),
// //               onTap: () {
// //                 Navigator.pushReplacement(
// //                   context,
// //                   MaterialPageRoute(builder: (context) => ReportsPage()),
// //                 );
// //               },
// //             ),
// //             ListTile(
// //               title: const Text('انشاء تقرير'),
// //               onTap: () {
// //                 Navigator.pushReplacement(
// //                   context,
// //                   MaterialPageRoute(builder: (context) => ReportCategoryOperationsPage()),
// //                 );
// //               },
// //             ),
// //
// //             ListTile(
// //               title: const Text('المنتجات و الفواتير'),
// //               onTap: () {
// //                 // Navigator.pushReplacement(
// //                 //   context,
// //                 //   // MaterialPageRoute(builder: (context) => AttendancePage()),
// //                 // );
// //               },
// //             ),
// //             ListTile(
// //               title: const Text('اتقارير عمليات الصنف '),
// //               onTap: () {
// //                 // Navigator.pushReplacement(
// //                 //   context,
// //                 //   // MaterialPageRoute(builder: (context) => AttendancePage()),
// //                 // );
// //               },
// //             ),
// //
// //
// //
// //
// //              ListTile(
// //               title: const Text('حضور و اصراف'),
// //               onTap: () {
// //                 // Navigator.pushReplacement(
// //                 //   context,
// //                 //   // MaterialPageRoute(builder: (context) => AttendancePage()),
// //                 // );
// //               },
// //             ),
// //
// //             ListTile(
// //               title: const Text('نظام حضور و اصراف'),
// //               onTap: () {
// //                 // Navigator.pushReplacement(
// //                 //   context,
// //                 //   // MaterialPageRoute(builder: (context) => AttendancePage()),
// //                 // );
// //               },
// //             ),
// //             ListTile(
// //               title: const Text('المالية'),
// //               onTap: () {
// //                 Navigator.pushReplacement(
// //                   context,
// //                   MaterialPageRoute(builder: (context) => PaymentPage()),
// //                 );
// //               },
// //             ),
// //             ListTile(
// //               title: const Text('الخزنة'),
// //               onTap: () {
// //                 Navigator.pushReplacement(
// //                   context,
// //                   MaterialPageRoute(builder: (context) => VaultsPage(userRole: userRole)),
// //                 );
// //               },
// //             ),
// //
// //             ListTile(
// //               title: const Text('العملاء'),
// //               onTap: () {
// //                 Navigator.pushReplacement(
// //                   context,
// //                   MaterialPageRoute(builder: (context) => CustomerPage()),
// //                 );
// //               },
// //             ),
// //             ListTile(
// //               title: const Text('كشف حساب العملاء'),
// //               onTap: () {
// //                 Navigator.pushReplacement(
// //                   context,
// //                   MaterialPageRoute(builder: (context) => CustomerPage()),
// //                 );
// //               },
// //             ),
// //             ListTile(
// //               title: const Text('الاصناف'),
// //               onTap: () {
// //                 Navigator.pushReplacement(
// //                   context,
// //                   MaterialPageRoute(builder: (context) => CategoryPage()),
// //                 );
// //               },
// //             ),
// //
// //             ListTile(
// //               title: const Text('المستخدمين'),
// //               onTap: () {
// //                 Navigator.pushReplacement(
// //                   context,
// //                   MaterialPageRoute(builder: (context) => GetAllUsersScreen()),
// //                 );
// //               },
// //             ),
// //             ListTile(
// //               title: const Text('النسخ الاحتياطي'),
// //               onTap: () {
// //                 Navigator.pushReplacement(
// //                   context,
// //                   MaterialPageRoute(builder: (context) => GetAllUsersScreen()),
// //                 );
// //               },
// //             ),
// //
// //             ListTile(
// //               title: const Text('خروج'),
// //               onTap: () async {
// //                 await _authService.signOut();
// //                 Navigator.pushReplacementNamed(context, '/');
// //               },
// //             ),
// //           ],
// //         ),
// //       ),
// //       body: PageView(
// //         controller: pageController,
// //         children: [
// //
// //
// //           // AttendancePage(),
// //           Mainscreen(),
// //           BillingPage(),
// //           ReportsPage(),
// //           ReportCategoryOperationsPage(),
// //           PaymentPage(),
// //           VaultsPage(userRole: userRole),
// //           CategoryPage(),
// //           CustomerPage(),
// //           GetAllUsersScreen(),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:system/core/constants/colors.dart';
// import 'package:system/core/themes/AppColors/them_constants.dart';
// import 'package:system/features/attendance/Presentation/LoginTablePage.dart';
// import 'package:system/features/attendance/Presentation/newattendancepage.dart';
// import 'package:system/features/auth/data/auth_service.dart';
// import 'package:system/features/backup/BackupPage.dart';
// import 'package:system/features/customer/presentation/widgets/customer_account_statement.dart';
// import 'package:system/main.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
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
// import 'package:system/features/report/UI/reportcategory/PaymentReportPage.dart';
// import 'package:system/features/report/UI/billsReportPage.dart';
// import 'package:system/features/report/UI/ReportsPage.dart';
// import 'package:system/main.dart';
// import 'package:system/features/auth/presentation/screens/GetAllUsersScreen.dart';
// import 'package:system/main_screens/AdminLayouts/devmainScreen.dart';
//
// class AdminMobileLayout extends StatefulWidget {
//   final AuthService authService;
//   final String title = "Admin ROTOSH Pageas";
//
//   const AdminMobileLayout({Key? key, required this.authService})
//       : super(key: key);
//
//   @override
//   State<AdminMobileLayout> createState() => _AdminMobileLayoutState();
// }
//
// class _AdminMobileLayoutState extends State<AdminMobileLayout> {
//   PageController pageController = PageController();
//   SideMenuController sideMenu = SideMenuController();
//   final AuthService _authService = AuthService(Supabase.instance.client);
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
//
//     super.initState();
//     sideMenu.addListener((index) {
//       pageController.jumpToPage(index);
//     });
//     _getUserInfo(); // Fetch the user info on initialization
//   }
//
//   // Monitor the connection status
//   void _monitorConnection() {
//     Connectivity()
//         .onConnectivityChanged
//         .listen((List<ConnectivityResult> result) {
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
//   @override
//   void dispose() {
//     // Cancel any active listeners or operations
//     super.dispose();
//   }
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
//           preferredSize: const Size.fromHeight(30.0),
//           child: Container(
//             color: Colors.red,
//             height: 30,
//             child: const Center(
//               child: Text(
//                 'لا يوجد اتصال بالإنترنت',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//         )
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
//               displayMode: SideMenuDisplayMode.open,
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
//               AppBarTheme.of(context).titleTextStyle?.color,
//               unselectedIconColorExpandable:
//               AppBarTheme.of(context).titleTextStyle?.color,
//               selectedTitleTextStyleExpandable:
//               const TextStyle(color: Colors.lightBlue),
//               selectedIconColorExpandable:
//               AppBarTheme.of(context).titleTextStyle?.color,
//               arrowOpen: AppBarTheme.of(context).titleTextStyle?.color,
//               arrowCollapse: AppBarTheme.of(context).titleTextStyle?.color,
//             ),
//             title: Column(
//               children: [
//                 ConstrainedBox(
//                   constraints: const BoxConstraints(
//                     maxHeight: 200,
//                     maxWidth: 220,
//                   ),
//                   child: Container(
//                     height: 70,
//                     child: Image.asset(
//                       'assets/logo/logo-4.png',
//                     ),
//                   ),
//                 ),
//                 const Divider(indent: 8.0, endIndent: 8.0),
//               ],
//             ),
//             footer: Container(
//               color: Colors.black,
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
//                 child: GestureDetector(
//                   onTap: () {
//                     _showUserInfoDialog(context); // Show user info dialog
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       // color: AppColors.secondary,
//                       color: AppColors.secondary,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 4, horizontal: 50),
//                       child: Text(
//                         userName,
//                         style: TextStyle(fontSize: 15, color: Colors.black),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
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
//               // العملاء
//               SideMenuExpansionItem(
//                   title: "العملاء",
//                   icon: const Icon(Icons.add_business_sharp),
//                   children: [
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
//                     SideMenuItem(
//                       // trailing: Text("العملاء" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
//                       title: '     كشف حساب عميل         ',
//                       onTap: (index, _) {
//                         sideMenu.changePage(index);
//                       },
//                       icon: const Icon(Icons.supervised_user_circle_sharp),
//                     ),
//                   ]),
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
//                   await _authService.signOut();
//                   _authService.recordLogoutTime(userid);
//
//                   Navigator.pushReplacementNamed(
//                       context, '/'); // توجيه المستخدم إلى صفحة تسجيل الدخول
//                 },
//                 icon: const Icon(Icons.output_rounded),
//               ),
//               SideMenuItem(
//                 title: 'خروج                  ',
//                 onTap: (index, _) {},
//                 icon: const Icon(Icons.output_rounded),
//               ),
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
//                 CustomerSelectionPage(),
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

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/core/constants/colors.dart';
import 'package:system/core/themes/AppColors/them_constants.dart';
import 'package:system/features/Vaults/vaults_page.dart';
import 'package:system/features/attendance/Presentation/LoginTablePage.dart';
import 'package:system/features/attendance/Presentation/newattendancepage.dart';
import 'package:system/features/auth/data/auth_service.dart';
import 'package:system/features/auth/presentation/screens/GetAllUsersScreen.dart';
import 'package:system/features/backup/BackupPage.dart';
import 'package:system/features/billes/presentation/BillingPage.dart';
import 'package:system/features/category/presentation/screens/category_page.dart';
import 'package:system/features/customer/presentation/customerPage.dart';
import 'package:system/features/payment/PaymentPage.dart';
import 'package:system/features/report/UI/ItemsReportDashboard.dart';
import 'package:system/features/report/UI/ReportsPage.dart';
import 'package:system/features/report/UI/billsReportPage.dart';
import 'package:system/features/report/UI/reportcategory/ReportCategoryOperationsPage.dart';
import 'package:system/main.dart';
import 'package:system/main_screens/mobile_screens/Drawer/AttendancePage2Mobile.dart';
import 'package:system/main_screens/mobile_screens/Drawer/CustomerPageMobile.dart';
import 'package:system/main_screens/mobile_screens/Drawer/CustomerSelectionPageMobile.dart';
import 'package:system/main_screens/mobile_screens/Drawer/GetAllUsersScreenMoble.dart';
import 'package:system/main_screens/mobile_screens/Drawer/LoginTablePageMobile.dart';
import 'package:system/main_screens/mobile_screens/Drawer/PaymentPageMobile.dart';
import 'package:system/main_screens/mobile_screens/Drawer/ReportCategoryOperationsPageMobile.dart';
import 'package:system/main_screens/mobile_screens/Drawer/VaultsPageMobile.dart';
import 'package:system/main_screens/mobile_screens/bills/BillingPage_mobileLayout.dart';
import 'package:system/main_screens/mobile_screens/mainScreen_mobileLayout.dart';

import '../../features/report/UI/customer/customer_account_statement.dart';
import '../loginLayouts/Loginmobile_layout.dart';
import '../mobile_screens/Drawer/ItemsReportDashboardMobile.dart';

class AdminMobileLayout extends StatefulWidget {
  final AuthService authService;
  final String title = "Admin ROTOSH";

  const AdminMobileLayout({Key? key, required this.authService})
      : super(key: key);

  @override
  State<AdminMobileLayout> createState() => _AdminMobileLayoutState();
}

class _AdminMobileLayoutState extends State<AdminMobileLayout> with WidgetsBindingObserver {
  PageController pageController = PageController();
  final AuthService _authService = AuthService(Supabase.instance.client);
  bool _isOffline = false;

  String userName = "";
  String userid = "";
  String userRole = "";
  Map<String, dynamic> userInfo = {};
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    MainscreenMobile(),//0
    BillingPagemobile(),//1
    // ReportsPage() ,//2
    // billsReportPage(),//3
    ItemsReportDashboardMobile(),//2   // ItemsReportDashboard(),//2
    // ReportCategoryOperationsPage(),//3

    ReportCategoryOperationsPageMobile(),//3


    // LoginTablePage(),//4
    LoginTablePageMobile(),//4


    // AttendancePage2(),//5
    AttendancePage2Mobile(),//5

    // PaymentPage(),//6
    PaymentPageMobile(),//6

    // VaultsPage(userRole: "admin",),//7
    VaultsPageMobile(userRole: "admin",),//7


    // CustomerPage(),//8
    CustomerPageMobile(),//8

    // CustomerSelectionPage(),//9
    CustomerSelectionPageMobile(),//9

    CategoryPage(),//10
    // GetAllUsersScreen(),//11
    GetAllUsersScreenMobile(),//11
    // BackupPage(),//12
  ];


  @override
  void initState() {
    _monitorConnection();
    super.initState();
    WidgetsBinding.instance.addObserver(this); // 👈 نضيف مراقبة lifecycle
    fetchUserLogins();
    _getUserInfo(); // Fetch the user info on initialization
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // 👈 نشيل المراقبة لما الودجت يتقفل
    super.dispose();
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

// 👇 هنا نراقب حالات التطبيق
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
    if ( state == AppLifecycleState.detached || state == AppLifecycleState.inactive) {
      // التطبيق دخل الخلفية أو تم إغلاقه
      await _logoutInSupabase();


    }
    if ( state == AppLifecycleState.resumed) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => LoginMobileLayout(authService: AuthService(supabase),)
        ),
      );

    }

  }

  Future<void> _logoutInSupabase() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      await Supabase.instance.client
          .from('logins')
          .update({'logout_time': DateTime.now().toIso8601String()})
          .eq('user_id', user.id)
          .isFilter('logout_time' , null)
          ; // يحدث بس لو لسه الجلسة مفتوحة
    }
  }



  void _onDrawerItemTap(int index) {
    setState(() {
      _selectedIndex = index;
      pageController.jumpToPage(index);
    });
    Navigator.pop(context); // Close the drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Switch(
            value: themeManagermain.themeMode == ThemeMode.dark,
            onChanged: (newValue) {
              themeManagermain.toggleTheme(newValue);
            },
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primary),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('مرحبا!', style: TextStyle(color: Colors.white, fontSize: 20)),
                  SizedBox(height: 10),
                  Text('Admin Panel', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('الصفحة الرئيسية'),
              onTap: () => _onDrawerItemTap(0),
            ),

            ExpansionTile(
              leading: Icon(Icons.add_business_sharp),
              title: Text("المبيعات"),
              children: [
                ListTile(
                  leading: Icon(Icons.file_copy_outlined),
                  title: Text('الفواتير'),
                  onTap: () => _onDrawerItemTap(1),
                ),
              ],
            ),
            ExpansionTile(
              leading: Icon(Icons.bar_chart),
              title: Text("التقارير "),
              children: [
                  ListTile(
                  leading: Icon(Icons.pie_chart),
                  title: Text('المنتجات و الفواتير'),
                  onTap: () => _onDrawerItemTap(2),
                ),
                ListTile(
                  leading: Icon(Icons.pie_chart),
                  title: Text('تقارير عمليات الصنف'),
                  onTap: () => _onDrawerItemTap(3),
                ),

                ListTile(
                  leading: Icon(Icons.pie_chart),
                  title: Text('حضور و انصراف'),
                  onTap: () => _onDrawerItemTap(4),
                ),

                ListTile(
                  leading: Icon(Icons.pie_chart),
                  title: Text('نظام الحضور والانصراف'),
                  onTap: () => _onDrawerItemTap(5),
                ),
              ],
            ),

            ExpansionTile(
              leading: Icon(Icons.bar_chart),
              title: Text("المالية"),
              children: [
                ListTile(
                  leading: Icon(Icons.pie_chart),
                  title: Text('القسم المالي'),
                  onTap: () => _onDrawerItemTap(6),
                ),
                ListTile(
                  leading: Icon(Icons.pie_chart),
                  title: Text('الخزنة '),
                  onTap: () => _onDrawerItemTap(7),
                ),
              ],
            ),

            ExpansionTile(
              leading: Icon(Icons.bar_chart),
              title: Text("العملاء"),
              children: [
                ListTile(
                  leading: Icon(Icons.pie_chart),
                  title: Text('العملاء '),
                  onTap: () => _onDrawerItemTap(8),
                ),
                ListTile(
                  leading: Icon(Icons.pie_chart),
                  title: Text('كشف حساب عميل '),
                  onTap: () => _onDrawerItemTap(9),
                ),
              ],
            ),

            ListTile(
              leading: Icon(Icons.supervisor_account),
              title: Text('الاصناف'),
              onTap: () => _onDrawerItemTap(10),
            ),
            ListTile(
              leading: Icon(Icons.supervisor_account),
              title: Text('المستخدمين'),
              onTap: () => _onDrawerItemTap(11),
            ),


            ListTile(
              leading: Icon(Icons.logout),
              title: Text('خروج'),
              onTap: () async {
                _authService.logoutUser(userid);
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: PageView(
        controller: pageController,
        children: _pages,
      ),
    );
  }
}

// ListTile(
//   leading: Icon(Icons.supervisor_account),
//   title: Text('نسخة احتياطية'),
//   onTap: () => _onDrawerItemTap(12),
// ),