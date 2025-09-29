// //
// // import 'package:flutter/material.dart';
// // import 'package:system/core/constants/colors.dart';
// // import 'package:system/core/themes/AppColors/them_constants.dart';
// // import 'package:system/features/auth/data/auth_service.dart';
// // import 'package:system/main.dart';
// // import 'package:connectivity_plus/connectivity_plus.dart';
// // import 'package:connectivity_plus/connectivity_plus.dart';
// // import 'package:flutter/material.dart';
// // import 'package:easy_sidemenu/easy_sidemenu.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart';
// // import 'package:system/core/constants/colors.dart';
// // import 'package:system/core/themes/AppColors/them_constants.dart';
// // import 'package:system/features/Vaults/vaults_page.dart';
// // import 'package:system/features/attendance/Presentation/AttendancePage.dart';
// // import 'package:system/features/auth/data/auth_service.dart';
// // import 'package:system/features/billes/presentation/payment/PaymentPage.dart';
// // import 'package:system/features/billes/presentation/payment/PaymentPage.dart';
// // import 'package:system/features/billes/presentation/BillingPage.dart';
// // import 'package:system/features/billes/presentation/safe/report_page.dart';
// // import 'package:system/features/category/presentation/screens/category_page.dart';
// // import 'package:system/features/customer/presentation/customerPage.dart';
// // import 'package:system/features/report/UI/ItemsReportDashboard.dart';
// // import 'package:system/features/report/UI/PaymentReportPage.dart';
// // import 'package:system/features/report/UI/billsReportPage.dart';
// // import 'package:system/features/report/UI/ReportsPage.dart';
// // import 'package:system/main.dart';
// // import 'package:system/features/auth/presentation/screens/GetAllUsersScreen.dart';
// // import 'package:system/main_screens/Admin/devmainScreen.dart';
// //
// // class AdminTabletLayout extends StatefulWidget {
// //   final AuthService authService;
// //   final String title = "Admin Tablet ROTOSH Page";
// //
// //   const AdminTabletLayout({Key? key, required this.authService}) : super(key: key);
// //
// //   @override
// //   State<AdminTabletLayout> createState() => _AdminTabletLayoutState();
// // }
// //
// // class _AdminTabletLayoutState extends State<AdminTabletLayout> {
// //   PageController pageController = PageController();
// //   SideMenuController sideMenu = SideMenuController();
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
// //     sideMenu.addListener((index) {
// //       pageController.jumpToPage(index);
// //     });
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
// //     final UserLayouts? user = supabase.auth.currentUser;
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
// //         title: Text(widget.title),
// //         actions: [
// //           Switch(
// //               value: themeManagermain.themeMode == ThemeMode.dark,
// //               onChanged: (newValue) {
// //                 themeManagermain.toggleTheme(newValue);
// //               })
// //         ],
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
// //
// //       body: Row(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           SideMenu(
// //             controller: sideMenu,
// //             style: SideMenuStyle(
// //               openSideMenuWidth: 250,
// //               itemBorderRadius: const BorderRadius.all(
// //                 Radius.circular(50.0),),
// //               // backgroundColor: AppColors.background,
// //               backgroundColor: AppBarTheme.of(context).backgroundColor,
// //               displayMode: SideMenuDisplayMode.auto,
// //               showHamburger: true,
// //               hoverColor: Colors.blue[100],
// //               selectedHoverColor: Colors.blue[100],
// //               selectedColor: Colors.lightBlue,
// //               selectedTitleTextStyle: const TextStyle(color: Colors.white),
// //               // unselectedTitleTextStyle: const TextStyle(color: Colors.white) ,
// //               unselectedTitleTextStyle:  TextStyle(color: AppBarTheme.of(context).titleTextStyle?.color ) ,
// //               selectedIconColor:AppBarTheme.of(context).titleTextStyle?.color,
// //               unselectedIconColor: AppBarTheme.of(context).titleTextStyle?.color,
// //               unselectedIconColorExpandable: AppBarTheme.of(context).titleTextStyle?.color ,
// //               selectedTitleTextStyleExpandable:  const TextStyle(color: Colors.lightBlue),
// //               selectedIconColorExpandable: AppBarTheme.of(context).titleTextStyle?.color ,
// //               arrowOpen: AppBarTheme.of(context).titleTextStyle?.color,
// //               arrowCollapse: AppBarTheme.of(context).titleTextStyle?.color,
// //             ),
// //             title: Column(
// //               children: [
// //                 ConstrainedBox(
// //                   constraints: const BoxConstraints(
// //                     maxHeight: 200,
// //                     maxWidth: 220,
// //
// //                   ),
// //
// //                   child: Container(
// //                     height: 84,
// //                     child: Image.asset(
// //                       'assets/logo/logo-4.png',
// //                     ),
// //                   ),
// //                 ),
// //                 const Divider(indent: 8.0, endIndent: 8.0),
// //               ],
// //             ),
// //             footer: Padding(
// //               padding: const EdgeInsets.all(10.0),
// //               child: GestureDetector(
// //                 onTap: () {
// //                   _showUserInfoDialog(context); // Show user info dialog
// //                 },
// //                 child: Container(
// //                   decoration: BoxDecoration(
// //                     color: AppColors.secondary,
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                   child: Padding(
// //                     padding:
// //                     const EdgeInsets.symmetric(vertical: 4, horizontal: 50),
// //                     child: Text(
// //                       userName,
// //                       style: TextStyle(fontSize: 15, color: Colors.grey[800]),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //             items: [
// //               SideMenuItem(
// //                 title: 'حضور و اصراف                ',
// //                 onTap: (index, _) {
// //                   sideMenu.changePage(index);
// //                 },
// //                 icon: const Icon(Icons.home),
// //               ),
// //               //الصفحة الرئيسية
// //               SideMenuItem(
// //                 title: 'الصفحة الرئيسية                ',
// //                 onTap: (index, _) {
// //                   sideMenu.changePage(index);
// //                 },
// //                 icon: const Icon(Icons.home),
// //               ),
// //               // المبيعات
// //               SideMenuExpansionItem(
// //                   title: "المبيعات",
// //                   icon: const Icon(Icons.add_business_sharp),
// //                   children: [
// //                     //الفواتير
// //                     SideMenuItem(
// //                       // trailing: Text("الفواتير" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
// //                       title: 'الفواتير                ',
// //                       onTap: (index, _) {
// //                         sideMenu.changePage(index);
// //                       },
// //                       icon: const Icon(Icons.file_copy_outlined),
// //                     ),
// //                   ]),
// //
// //               // تقارير
// //               SideMenuExpansionItem(
// //                   title: "التقارير",
// //                   icon: const Icon(Icons.add_business_sharp),
// //                   children: [
// //                     //التقارير
// //                     SideMenuItem(
// //                       // trailing: Text("التقارير" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
// //                       title: ' التقارير البرنامج                ',
// //                       onTap: (index, _) {
// //                         sideMenu.changePage(index);
// //                       },
// //                       icon: const Icon(Icons.file_copy_outlined),
// //                     ),
// //                     SideMenuItem(
// //                       // trailing: Text("التقارير" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
// //                       title: ' انشاء تقرير                ',
// //                       onTap: (index, _) {
// //                         sideMenu.changePage(index);
// //                       },
// //                       icon: const Icon(Icons.file_copy_outlined),
// //                     ),
// //                     SideMenuItem(
// //                       // trailing: Text("التقارير" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
// //                       title: '  المنتجات و الفواتير                ',
// //                       onTap: (index, _) {
// //                         sideMenu.changePage(index);
// //                       },
// //                       icon: const Icon(Icons.gif_box),
// //                     ),
// //                     SideMenuItem(
// //                       // trailing: Text("التقارير" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
// //                       title: ' تقارير عمليات الصنف                ',
// //                       onTap: (index, _) {
// //                         sideMenu.changePage(index);
// //                       },
// //                       icon: const Icon(Icons.gif_box),
// //                     ),
// //
// //                   ]),
// //               // الماليات
// //               SideMenuExpansionItem(
// //                   title: "المالية",
// //                   icon: const Icon(Icons.kitchen),
// //                   children: [
// //                     SideMenuItem(
// //                       title: 'القسم المالي                  ',
// //                       onTap: (index, _) {
// //                         sideMenu.changePage(index);
// //                       },
// //                       icon: const Icon(Icons.payment),
// //                     ),
// //
// //                     SideMenuItem(
// //                       title: 'الخزنة                  ',
// //                       onTap: (index, _) {
// //                         sideMenu.changePage(index);
// //                       },
// //                       icon: const Icon(Icons.paypal),
// //                     ),
// //
// //                   ]),
// //
// //               //الاصناف
// //               SideMenuItem(
// //                 // trailing: Text("الاصناف" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
// //                 title: 'الاصناف               ',
// //                 onTap: (index, _) {
// //                   sideMenu.changePage(index);
// //                 },
// //                 icon: const Icon(Icons.book),
// //               ),
// //               // العملاء
// //               SideMenuItem(
// //                 // trailing: Text("العملاء" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
// //                 title: 'العملاء                ',
// //                 onTap: (index, _) {
// //                   sideMenu.changePage(index);
// //                 },
// //                 icon: const Icon(Icons.supervised_user_circle_sharp),
// //               ),
// //
// //               // المستخدمين
// //               SideMenuItem(
// //                 // trailing: Text("المستخدمين" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
// //                 title: '  المستخدمين           ',
// //                 onTap: (index, _) {
// //                   sideMenu.changePage(index);
// //                 },
// //                 icon: const Icon(Icons.supervisor_account),
// //               ),
// //               SideMenuItem(
// //                 // trailing: Text("خروج" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
// //                 title: 'خروج                  ',
// //                 onTap: (index, _) async {
// //                   // sideMenu.changePage(index);
// //                   await _authService.signOut();
// //                   Navigator.pushReplacementNamed(context, '/'); // توجيه المستخدم إلى صفحة تسجيل الدخول
// //
// //                 },
// //                 icon: const Icon(Icons.output_rounded),
// //               ),
// //             ],
// //           ),
// //           // const VerticalDivider(width: 0),
// //           Expanded(
// //             child: PageView(
// //               controller: pageController,
// //               children: [
// //                 AttendancePage(),
// //                 // الرئيسية
// //                 Mainscreen(),
// //                 // الفواتير
// //                 BillingPage(),
// //                 // Container(
// //                 //   color: Colors.white,
// //                 //   child: const Center(
// //                 //     child: Text(
// //                 //       'الفواتير',
// //                 //       style: TextStyle(fontSize: 35),
// //                 //     ),
// //                 //   ),
// //                 // ),
// //
// //
// //                 //  Container(
// //                 //    color: Colors.white,
// //                 //    child: const Center(
// //                 //      child: Text(
// //                 //        'الاصناف',
// //                 //        style: TextStyle(fontSize: 35),
// //                 //      ),
// //                 //    ),
// //                 //  ),
// //
// //
// //                 //تقاير
// //                 // ReportPage(),
// //                 // Container(
// //                 //   color: Colors.white,
// //                 //   child: const Center(
// //                 //     child: Text(
// //                 //       'ReportPage',
// //                 //       style: TextStyle(fontSize: 35),
// //                 //     ),
// //                 //   ),
// //                 // ),
// //                 // app log
// //                 // التقارير
// //                 ReportsPage(),
// //                 billsReportPage(),
// //                 ItemsReportDashboard(),
// //                 ReportCategoryOperationsPage(),
// //                 // الماليات
// //                 PaymentPage(),
// //                 VaultsPage(userRole: userRole,),
// //
// //                 // الاصناف
// //                 CategoryPage(),
// //                 //العملاء
// //                 CustomerPage(),
// //
// //                 GetAllUsersScreen(),
// //
// //
// //                 // Container(
// //                 //   color: Colors.white,
// //                 //   child: const Center(
// //                 //     child: Text(
// //                 //       'خروج',
// //                 //       style: TextStyle(fontSize: 35),
// //                 //     ),
// //                 //   ),
// //                 // ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // import 'package:flutter/material.dart';
// // import 'package:system/core/constants/colors.dart';
// // import 'package:system/core/themes/AppColors/them_constants.dart';
// // import 'package:system/features/auth/data/auth_service.dart';
// // import 'package:system/main.dart';
// //
// // class DesktopLayout extends StatefulWidget {
// //   final AuthService authService;
// //
// //   const DesktopLayout({Key? key, required this.authService}) : super(key: key);
// //
// //   @override
// //   State<DesktopLayout> createState() => _DesktopLayoutState();
// // }
// //
// // class _DesktopLayoutState extends State<DesktopLayout> {
// //   final _usernameController = TextEditingController();
// //   final _passwordController = TextEditingController();
// //   final _formKey = GlobalKey<FormState>();
// //   bool _isLoading = false;
// //
// //   void _login() async {
// //     if (!_formKey.currentState!.validate()) {
// //       return; // Exit if the form is invalid
// //     }
// //
// //     setState(() {
// //       _isLoading = true;
// //     });
// //
// //     try {
// //       final authModel = await widget.authService.signInWithUsernamePassword(
// //         _usernameController.text,
// //         _passwordController.text,
// //       );
// //
// //       if (authModel.role == 'admin') {
// //         Navigator.pushReplacementNamed(context, "/adminHome");
// //       } else if (authModel.role == 'user') {
// //         Navigator.pushReplacementNamed(context, "/userHome");
// //       } else {
// //         throw Exception('Unknown role: ${authModel.role}');
// //       }
// //     } catch (e) {
// //       _showErrorDialog('خطأ', 'اسم المستخدم أو كلمة المرور غير صحيحة');
// //     } finally {
// //       setState(() {
// //         _isLoading = false;
// //       });
// //     }
// //   }
// //
// //   void _showErrorDialog(String title, String message) {
// //     showDialog(
// //       context: context,
// //       builder: (context) {
// //         return AlertDialog(
// //           title: Text(title),
// //           content: Text(message),
// //           actions: [
// //             TextButton(
// //               onPressed: () {
// //                 Navigator.of(context).pop(); // Close the dialog
// //               },
// //               child: const Text('حسنًا'),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('مرحبا بك في ROTOSH DESKTOP'),
// //         centerTitle: true,
// //         actions: [
// //           Switch(
// //             value: themeManagermain.themeMode == ThemeMode.dark,
// //             onChanged: (newValue) {
// //               themeManagermain.toggleTheme(newValue);
// //             },
// //           )
// //         ],
// //       ),
// //       body: Center(
// //         child: SingleChildScrollView(
// //           padding: const EdgeInsets.all(16.0),
// //           child: CircleAvatar(
// //             backgroundColor: AppColors.primary,
// //             radius: 300,
// //             child: Stack(
// //               children: [
// //                 Column(
// //                   mainAxisSize: MainAxisSize.min,
// //                   children: [
// //                     const SizedBox(height: 50),
// //                     Image.asset(
// //                       "assets/logo/logo-3.png",
// //                       width: 300,
// //                       height: 300,
// //                     ),
// //                     const Text(
// //                       "تسجيل الدخول",
// //                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// //                     ),
// //                     const SizedBox(height: 20),
// //                     Form(
// //                       key: _formKey,
// //                       child: Column(
// //                         children: [
// //                           Container(
// //                             width: 300,
// //                             child: TextFormField(
// //                               controller: _usernameController,
// //                               decoration: const InputDecoration(
// //                                 labelText: 'اسم المستخدم',
// //                               ),
// //                               validator: (value) {
// //                                 if (value == null || value.isEmpty) {
// //                                   return 'يرجى إدخال اسم المستخدم';
// //                                 }
// //                                 return null;
// //                               },
// //                             ),
// //                           ),
// //                           const SizedBox(height: 10),
// //                           Container(
// //                             width: 300,
// //                             child: TextFormField(
// //                               controller: _passwordController,
// //                               obscureText: true,
// //                               decoration: const InputDecoration(
// //                                 labelText: 'كلمة المرور',
// //                               ),
// //                               validator: (value) {
// //                                 if (value == null || value.isEmpty) {
// //                                   return 'يرجى إدخال كلمة المرور';
// //                                 }
// //                                 return null;
// //                               },
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                     const SizedBox(height: 20),
// //                     _isLoading
// //                         ? const CircularProgressIndicator()
// //                         : ElevatedButton(
// //                       onPressed: _login,
// //                       child: const Text('دخول'),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// //
// // import 'package:flutter/material.dart';
// // import 'package:system/core/constants/colors.dart';
// // import 'package:system/core/themes/AppColors/them_constants.dart';
// // import 'package:system/features/auth/data/auth_service.dart';
// // import 'package:system/main.dart';
// //
// // class DesktopLayout extends StatefulWidget {
// //   final AuthService authService;
// //
// //   const DesktopLayout({Key? key, required this.authService}) : super(key: key);
// //
// //   @override
// //   State<DesktopLayout> createState() => _DesktopLayoutState();
// // }
// //
// // class _DesktopLayoutState extends State<DesktopLayout> {
// //   final _usernameController = TextEditingController();
// //   final _passwordController = TextEditingController();
// //   final _formKey = GlobalKey<FormState>();
// //   bool _isLoading = false;
// //
// //   void _login() async {
// //     if (!_formKey.currentState!.validate()) {
// //       return; // Exit if the form is invalid
// //     }
// //
// //     setState(() {
// //       _isLoading = true;
// //     });
// //
// //     try {
// //       final authModel = await widget.authService.signInWithUsernamePassword(
// //         _usernameController.text,
// //         _passwordController.text,
// //       );
// //
// //       if (authModel.role == 'admin') {
// //         Navigator.pushReplacementNamed(context, "/adminHome");
// //       } else if (authModel.role == 'user') {
// //         Navigator.pushReplacementNamed(context, "/userHome");
// //       } else {
// //         throw Exception('Unknown role: ${authModel.role}');
// //       }
// //     } catch (e) {
// //       _showErrorDialog('خطأ', 'اسم المستخدم أو كلمة المرور غير صحيحة');
// //     } finally {
// //       setState(() {
// //         _isLoading = false;
// //       });
// //     }
// //   }
// //
// //   void _showErrorDialog(String title, String message) {
// //     showDialog(
// //       context: context,
// //       builder: (context) {
// //         return AlertDialog(
// //           title: Text(title),
// //           content: Text(message),
// //           actions: [
// //             TextButton(
// //               onPressed: () {
// //                 Navigator.of(context).pop(); // Close the dialog
// //               },
// //               child: const Text('حسنًا'),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('مرحبا بك في ROTOSH DESKTOP'),
// //         centerTitle: true,
// //         actions: [
// //           Switch(
// //             value: themeManagermain.themeMode == ThemeMode.dark,
// //             onChanged: (newValue) {
// //               themeManagermain.toggleTheme(newValue);
// //             },
// //           )
// //         ],
// //       ),
// //       body: Center(
// //         child: SingleChildScrollView(
// //           padding: const EdgeInsets.all(16.0),
// //           child: CircleAvatar(
// //             backgroundColor: AppColors.primary,
// //             radius: 300,
// //             child: Stack(
// //               children: [
// //                 Column(
// //                   mainAxisSize: MainAxisSize.min,
// //                   children: [
// //                     const SizedBox(height: 50),
// //                     Image.asset(
// //                       "assets/logo/logo-3.png",
// //                       width: 300,
// //                       height: 300,
// //                     ),
// //                     const Text(
// //                       "تسجيل الدخول",
// //                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// //                     ),
// //                     const SizedBox(height: 20),
// //                     Form(
// //                       key: _formKey,
// //                       child: Column(
// //                         children: [
// //                           Container(
// //                             width: 300,
// //                             child: TextFormField(
// //                               controller: _usernameController,
// //                               decoration: const InputDecoration(
// //                                 labelText: 'اسم المستخدم',
// //                               ),
// //                               validator: (value) {
// //                                 if (value == null || value.isEmpty) {
// //                                   return 'يرجى إدخال اسم المستخدم';
// //                                 }
// //                                 return null;
// //                               },
// //                             ),
// //                           ),
// //                           const SizedBox(height: 10),
// //                           Container(
// //                             width: 300,
// //                             child: TextFormField(
// //                               controller: _passwordController,
// //                               obscureText: true,
// //                               decoration: const InputDecoration(
// //                                 labelText: 'كلمة المرور',
// //                               ),
// //                               validator: (value) {
// //                                 if (value == null || value.isEmpty) {
// //                                   return 'يرجى إدخال كلمة المرور';
// //                                 }
// //                                 return null;
// //                               },
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                     const SizedBox(height: 20),
// //                     _isLoading
// //                         ? const CircularProgressIndicator()
// //                         : ElevatedButton(
// //                       onPressed: _login,
// //                       child: const Text('دخول'),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:system/core/constants/colors.dart';
// import 'package:system/core/themes/AppColors/them_constants.dart';
// import 'package:system/features/attendance/Presentation/LoginTablePage.dart';
// import 'package:system/features/auth/data/auth_service.dart';
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
// import 'package:system/features/attendance/Presentation/AttendancePage.dart';
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
// class AdminTabletLayout extends StatefulWidget {
//   final AuthService authService;
//   final String title = "Admin ROTOSH Pageas";
//
//   const AdminTabletLayout({Key? key, required this.authService}) : super(key: key);
//
//   @override
//   State<AdminTabletLayout> createState() => _AdminTabletLayoutState();
// }
//
// class _AdminTabletLayoutState extends State<AdminTabletLayout> {
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
//     Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
//       setState(() {
//         // Assuming you want to check if there is no connectivity in any of the results.
//         _isOffline = result.every((ConnectivityResult r) => r == ConnectivityResult.none);
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
//
//       body: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SideMenu(
//             controller: sideMenu,
//             style: SideMenuStyle(
//               openSideMenuWidth: 250,
//               itemBorderRadius: const BorderRadius.all(
//                 Radius.circular(50.0),),
//               // backgroundColor: AppColors.background,
//               backgroundColor: AppBarTheme.of(context).backgroundColor,
//               displayMode: SideMenuDisplayMode.auto,
//               showHamburger: true,
//               hoverColor: Colors.blue[100],
//               selectedHoverColor: Colors.blue[100],
//               selectedColor: Colors.lightBlue,
//               selectedTitleTextStyle: const TextStyle(color: Colors.white),
//               // unselectedTitleTextStyle: const TextStyle(color: Colors.white) ,
//               unselectedTitleTextStyle:  TextStyle(color: AppBarTheme.of(context).titleTextStyle?.color ) ,
//               selectedIconColor:AppBarTheme.of(context).titleTextStyle?.color,
//               unselectedIconColor: AppBarTheme.of(context).titleTextStyle?.color,
//               unselectedIconColorExpandable: AppBarTheme.of(context).titleTextStyle?.color ,
//               selectedTitleTextStyleExpandable:  const TextStyle(color: Colors.lightBlue),
//               selectedIconColorExpandable: AppBarTheme.of(context).titleTextStyle?.color ,
//               arrowOpen: AppBarTheme.of(context).titleTextStyle?.color,
//               arrowCollapse: AppBarTheme.of(context).titleTextStyle?.color,
//             ),
//             title: Column(
//               children: [
//                 ConstrainedBox(
//                   constraints: const BoxConstraints(
//                     maxHeight: 200,
//                     maxWidth: 220,
//
//                   ),
//
//                   child: Container(
//                     height: 84,
//                     child: Image.asset(
//                       'assets/logo/logo-4.png',
//                     ),
//                   ),
//                 ),
//                 const Divider(indent: 8.0, endIndent: 8.0),
//               ],
//             ),
//             footer: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: GestureDetector(
//                 onTap: () {
//                   _showUserInfoDialog(context); // Show user info dialog
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: AppColors.secondary,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Padding(
//                     padding:
//                     const EdgeInsets.symmetric(vertical: 4, horizontal: 50),
//                     child: Text(
//                       userName,
//                       style: TextStyle(fontSize: 15, color: Colors.grey[800]),
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
//                       title: 'حضور و اصراف                ',
//                       onTap: (index, _) {
//                         sideMenu.changePage(index);
//                       },
//                       icon: const Icon(Icons.accessibility),
//                     ),
//
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
//
//                     SideMenuItem(
//                       title: 'الخزنة                  ',
//                       onTap: (index, _) {
//                         sideMenu.changePage(index);
//                       },
//                       icon: const Icon(Icons.paypal),
//                     ),
//
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
//                       title: '',
//                       onTap: (index, _) {
//                         sideMenu.changePage(index);
//                       },
//                       icon: const Icon(Icons.supervised_user_circle_sharp),
//                     ),
//
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
//                 // trailing: Text("خروج" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
//                 title: 'خروج                  ',
//                 onTap: (index, _) async {
//                   // sideMenu.changePage(index);
//                   await _authService.signOut();
//                   _authService.recordLogoutTime(userid);
//
//                   Navigator.pushReplacementNamed(context, '/'); // توجيه المستخدم إلى صفحة تسجيل الدخول
//
//                 },
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
//
//                 // الماليات
//                 PaymentPage(),
//                 VaultsPage(userRole: userRole,),
//                 //العملاء
//                 CustomerPage(),
//                 CustomerSelectionPage(),
//                 // الاصناف
//                 CategoryPage(),
//
//
//
//                 GetAllUsersScreen(),
//
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
//
// import 'package:flutter/material.dart';
// import 'package:system/core/constants/colors.dart';
// import 'package:system/core/themes/AppColors/them_constants.dart';
// import 'package:system/features/auth/data/auth_service.dart';
// import 'package:system/main.dart';
//
// class DesktopLayout extends StatefulWidget {
//   final AuthService authService;
//
//   const DesktopLayout({Key? key, required this.authService}) : super(key: key);
//
//   @override
//   State<DesktopLayout> createState() => _DesktopLayoutState();
// }
//
// class _DesktopLayoutState extends State<DesktopLayout> {
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;
//
//   void _login() async {
//     if (!_formKey.currentState!.validate()) {
//       return; // Exit if the form is invalid
//     }
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       final authModel = await widget.authService.signInWithUsernamePassword(
//         _usernameController.text,
//         _passwordController.text,
//       );
//
//       if (authModel.role == 'admin') {
//         Navigator.pushReplacementNamed(context, "/adminHome");
//       } else if (authModel.role == 'user') {
//         Navigator.pushReplacementNamed(context, "/userHome");
//       } else {
//         throw Exception('Unknown role: ${authModel.role}');
//       }
//     } catch (e) {
//       _showErrorDialog('خطأ', 'اسم المستخدم أو كلمة المرور غير صحيحة');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   void _showErrorDialog(String title, String message) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(title),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: const Text('حسنًا'),
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
//         title: const Text('مرحبا بك في ROTOSH DESKTOP'),
//         centerTitle: true,
//         actions: [
//           Switch(
//             value: themeManagermain.themeMode == ThemeMode.dark,
//             onChanged: (newValue) {
//               themeManagermain.toggleTheme(newValue);
//             },
//           )
//         ],
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: CircleAvatar(
//             backgroundColor: AppColors.primary,
//             radius: 300,
//             child: Stack(
//               children: [
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const SizedBox(height: 50),
//                     Image.asset(
//                       "assets/logo/logo-3.png",
//                       width: 300,
//                       height: 300,
//                     ),
//                     const Text(
//                       "تسجيل الدخول",
//                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 20),
//                     Form(
//                       key: _formKey,
//                       child: Column(
//                         children: [
//                           Container(
//                             width: 300,
//                             child: TextFormField(
//                               controller: _usernameController,
//                               decoration: const InputDecoration(
//                                 labelText: 'اسم المستخدم',
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'يرجى إدخال اسم المستخدم';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           Container(
//                             width: 300,
//                             child: TextFormField(
//                               controller: _passwordController,
//                               obscureText: true,
//                               decoration: const InputDecoration(
//                                 labelText: 'كلمة المرور',
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'يرجى إدخال كلمة المرور';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     _isLoading
//                         ? const CircularProgressIndicator()
//                         : ElevatedButton(
//                       onPressed: _login,
//                       child: const Text('دخول'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:system/core/constants/colors.dart';
import 'package:system/core/themes/AppColors/them_constants.dart';
import 'package:system/features/attendance/Presentation/LoginTablePage.dart';
import 'package:system/features/attendance/Presentation/newattendancepage.dart';
import 'package:system/features/auth/data/auth_service.dart';
import 'package:system/features/backup/BackupPage.dart';
import 'package:system/features/report/UI/customer/customer_account_statement.dart';
import 'package:system/main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
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

class AdminTabletLayout extends StatefulWidget {
  final AuthService authService;
  final String title = "Admin ROTOSH Pageas";

  const AdminTabletLayout({Key? key, required this.authService}) : super(key: key);

  @override
  State<AdminTabletLayout> createState() => _AdminTabletLayoutState();
}

class _AdminTabletLayoutState extends State<AdminTabletLayout> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();
  final AuthService _authService = AuthService(Supabase.instance.client);
  bool _isOffline = false;

  String userName = "";
  String userid = "";
  String userRole = "";
  Map<String, dynamic> userInfo = {}; // To store user info

  @override
  void initState() {
    _monitorConnection();

    super.initState();
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
    _getUserInfo(); // Fetch the user info on initialization
  }

  // Monitor the connection status
  void _monitorConnection() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      setState(() {
        // Assuming you want to check if there is no connectivity in any of the results.
        _isOffline = result.every((ConnectivityResult r) => r == ConnectivityResult.none);
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

  @override
  void dispose() {
    // Cancel any active listeners or operations
    super.dispose();
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
              })
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
                Radius.circular(50.0),),
              // backgroundColor: AppColors.background,
              backgroundColor: AppBarTheme.of(context).backgroundColor,
              displayMode: SideMenuDisplayMode.auto,
              showHamburger: true,
              hoverColor: Colors.blue[100],
              selectedHoverColor: Colors.blue[100],
              selectedColor: Colors.lightBlue,
              selectedTitleTextStyle: const TextStyle(color: Colors.white),
              // unselectedTitleTextStyle: const TextStyle(color: Colors.white) ,
              unselectedTitleTextStyle:  TextStyle(color: AppBarTheme.of(context).titleTextStyle?.color ) ,
              selectedIconColor:AppBarTheme.of(context).titleTextStyle?.color,
              unselectedIconColor: AppBarTheme.of(context).titleTextStyle?.color,
              unselectedIconColorExpandable: AppBarTheme.of(context).titleTextStyle?.color ,
              selectedTitleTextStyleExpandable:  const TextStyle(color: Colors.lightBlue),
              selectedIconColorExpandable: AppBarTheme.of(context).titleTextStyle?.color ,
              arrowOpen: AppBarTheme.of(context).titleTextStyle?.color,
              arrowCollapse: AppBarTheme.of(context).titleTextStyle?.color,
            ),
            title: Column(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 200,
                    maxWidth: 220,

                  ),

                  child: Container(
                    height: 84,
                    child: Image.asset(
                      'assets/logo/logo-4.png',
                    ),
                  ),
                ),
                const Divider(indent: 8.0, endIndent: 8.0),
              ],
            ),
            footer: Container(
              color: AppBarTheme.of(context).backgroundColor,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(53,10,53,10),
                child: GestureDetector(
                  onTap: () {
                    _showUserInfoDialog(context); // Show user info dialog
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 50),
                      child: Text(
                        userName,
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
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
              // العملاء
              SideMenuExpansionItem(
                  title: "العملاء",
                  icon: const Icon(Icons.add_business_sharp),
                  children: [
                    //العملاء
                    SideMenuItem(
                      // trailing: Text("العملاء" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
                      title: 'العملاء                ',
                      onTap: (index, _) {
                        sideMenu.changePage(index);
                      },
                      icon: const Icon(Icons.supervised_user_circle_sharp),
                    ),
                    //
                    SideMenuItem(
                      // trailing: Text("العملاء" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
                      title: '     كشف حساب عميل         ',
                      onTap: (index, _) {
                        sideMenu.changePage(index);
                      },
                      icon: const Icon(Icons.supervised_user_circle_sharp),
                    ),

                  ]),
              //الاصناف
              SideMenuItem(
                // trailing: Text("الاصناف" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
                title: 'الاصناف               ',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.book),
              ),



              // المستخدمين
              SideMenuItem(
                // trailing: Text("المستخدمين" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
                title: '  المستخدمين           ',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.supervisor_account),
              ),
              SideMenuItem(
                // trailing: Text("المستخدمين" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
                title: '  نسخة احتياطية           ',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.supervisor_account),
              ),
              SideMenuItem(
                // trailing: Text("خروج" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
                title: 'خروج                  ',
                onTap: (index, _) async {
                  // sideMenu.changePage(index);
                  // await _authService.signOut();
                  _authService.logoutUser(userid);

                  Navigator.pushReplacementNamed(context, '/'); // توجيه المستخدم إلى صفحة تسجيل الدخول

                },
                icon: const Icon(Icons.output_rounded),
              ),


              SideMenuItem(
                // trailing: Text("خروج" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
                title: 'خروج                  ',
                onTap: (index, _) async {
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
                // AttendancePage(),
                // الرئيسية
                Mainscreen(),
                // الفواتير
                BillingPage(),
                // Container(
                //   color: Colors.white,
                //   child: const Center(
                //     child: Text(
                //       'الفواتير',
                //       style: TextStyle(fontSize: 35),
                //     ),
                //   ),
                // ),


                //  Container(
                //    color: Colors.white,
                //    child: const Center(
                //      child: Text(
                //        'الاصناف',
                //        style: TextStyle(fontSize: 35),
                //      ),
                //    ),
                //  ),


                //تقاير
                // ReportPage(),
                // Container(
                //   color: Colors.white,
                //   child: const Center(
                //     child: Text(
                //       'ReportPage',
                //       style: TextStyle(fontSize: 35),
                //     ),
                //   ),
                // ),
                // app log
                // التقارير
                ReportsPage(),
                billsReportPage(),
                ItemsReportDashboard(),
                ReportCategoryOperationsPage(),
                LoginTablePage(),
                AttendancePage2(),

                // الماليات
                PaymentPage(),
                VaultsPage(userRole: userRole,),
                //العملاء
                CustomerPage(),
                CustomerSelectionPage(),
                // الاصناف
                CategoryPage(),



                GetAllUsersScreen(),
                BackupPage(),


                // Container(
                //   color: Colors.white,
                //   child: const Center(
                //     child: Text(
                //       'خروج',
                //       style: TextStyle(fontSize: 35),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
