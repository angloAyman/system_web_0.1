// // import 'package:easy_sidemenu/easy_sidemenu.dart';
// // import 'package:flutter/material.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart';
// // import 'package:system/features/auth/presentation/screens/GetAllUsersScreen.dart';
// //
// // class AdminHomeScreen extends StatefulWidget {
// //
// //   final String title="admin page";
// //
// //   @override
// //   State<AdminHomeScreen> createState() => _AdminHomeScreenState();
// // }
// //
// // class _AdminHomeScreenState extends State<AdminHomeScreen> {
// //   PageController pageController = PageController();
// //   SideMenuController sideMenu = SideMenuController();
// //
// //
// //
// //   @override
// //   void initState() {
// //     sideMenu.addListener((index) {
// //       pageController.jumpToPage(index);
// //     });
// //     super.initState();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(widget.title),
// //         centerTitle: true,
// //       ),
// //       body: Row(
// //         mainAxisAlignment: MainAxisAlignment.start,
// //         children: [
// //           SideMenu(
// //             controller: sideMenu,
// //             style: SideMenuStyle(
// //               // showTooltip: false,
// //               displayMode: SideMenuDisplayMode.auto,
// //               showHamburger: true,
// //               hoverColor: Colors.blue[100],
// //               selectedHoverColor: Colors.blue[100],
// //               selectedColor: Colors.lightBlue,
// //               selectedTitleTextStyle: const TextStyle(color: Colors.white),
// //               selectedIconColor: Colors.white,
// //               // decoration: BoxDecoration(
// //               //   borderRadius: BorderRadius.all(Radius.circular(10)),
// //               // ),
// //               // backgroundColor: Colors.grey[200]
// //             ),
// //             title: Column(
// //               children: [
// //                 ConstrainedBox(
// //                   constraints: const BoxConstraints(
// //                     maxHeight: 150,
// //                     maxWidth: 150,
// //                   ),
// //                   child: Image.asset(
// //                     'assets/images/easy_sidemenu.png',
// //                   ),
// //                 ),
// //                 const Divider(
// //                   indent: 8.0,
// //                   endIndent: 8.0,
// //                 ),
// //               ],
// //             ),
// //             footer: Padding(
// //               padding: const EdgeInsets.all(8.0),
// //               child: Container(
// //                 decoration: BoxDecoration(
// //                     color: Colors.lightBlue[50],
// //                     borderRadius: BorderRadius.circular(12)),
// //                 child: Padding(
// //                   padding:
// //                   const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
// //                   child: Text(
// //                     'mohada',
// //                     style: TextStyle(fontSize: 15, color: Colors.grey[800]),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //             items: [
// //               SideMenuItem(
// //                 title: 'Dashboard',
// //                 onTap: (index, _) {
// //                   sideMenu.changePage(index);
// //                 },
// //                 icon: const Icon(Icons.home),
// //                 badgeContent: const Text(
// //                   '3',
// //                   style: TextStyle(color: Colors.white),
// //                 ),
// //                 tooltipContent: "This is a tooltip for Dashboard item",
// //               ),
// //               SideMenuItem(
// //                 title: 'Users',
// //                 onTap: (index, _) {
// //                   sideMenu.changePage(index);
// //                 },
// //                 icon: const Icon(Icons.supervisor_account),
// //               ),
// //               SideMenuExpansionItem(
// //                 title: "Expansion Item",
// //                 icon: const Icon(Icons.kitchen),
// //                 children: [
// //                   SideMenuItem(
// //                     title: 'Expansion Item 1',
// //                     onTap: (index, _) {
// //                       sideMenu.changePage(index);
// //                     },
// //                     icon: const Icon(Icons.home),
// //                     badgeContent: const Text(
// //                       '3',
// //                       style: TextStyle(color: Colors.white),
// //                     ),
// //                     tooltipContent: "Expansion Item 1",
// //                   ),
// //                   SideMenuItem(
// //                     title: 'Expansion Item 2',
// //                     onTap: (index, _) {
// //                       sideMenu.changePage(index);
// //                     },
// //                     icon: const Icon(Icons.supervisor_account),
// //                   )
// //                 ],
// //               ),
// //               SideMenuItem(
// //                 title: 'Files',
// //                 onTap: (index, _) {
// //                   sideMenu.changePage(index);
// //                 },
// //                 icon: const Icon(Icons.file_copy_rounded),
// //                 trailing: Container(
// //                     decoration: const BoxDecoration(
// //                         color: Colors.amber,
// //                         borderRadius: BorderRadius.all(Radius.circular(6))),
// //                     child: Padding(
// //                       padding: const EdgeInsets.symmetric(
// //                           horizontal: 6.0, vertical: 3),
// //                       child: Text(
// //                         'New',
// //                         style: TextStyle(fontSize: 11, color: Colors.grey[800]),
// //                       ),
// //                     )),
// //               ),
// //               SideMenuItem(
// //                 title: 'Download',
// //                 onTap: (index, _) {
// //                   sideMenu.changePage(index);
// //                 },
// //                 icon: const Icon(Icons.download),
// //               ),
// //               SideMenuItem(
// //                 builder: (context, displayMode) {
// //                   return const Divider(
// //                     endIndent: 8,
// //                     indent: 8,
// //                   );
// //                 },
// //               ),
// //               SideMenuItem(
// //                 title: 'Settings',
// //                 onTap: (index, _) {
// //                   sideMenu.changePage(index);
// //                 },
// //                 icon: const Icon(Icons.settings),
// //               ),
// //               // SideMenuItem(
// //               //   onTap:(index, _){
// //               //     sideMenu.changePage(index);
// //               //   },
// //               //   icon: const Icon(Icons.image_rounded),
// //               // ),
// //               // SideMenuItem(
// //               //   title: 'Only Title',
// //               //   onTap:(index, _){
// //               //     sideMenu.changePage(index);
// //               //   },
// //               // ),
// //               const SideMenuItem(
// //                 title: 'Exit',
// //                 icon: Icon(Icons.exit_to_app),
// //               ),
// //             ],
// //           ),
// //           const VerticalDivider(width: 0,),
// //           Expanded(
// //             child: PageView(
// //               controller: pageController,
// //               children: [
// //                 Container(
// //                   color: Colors.white,
// //                   child: const Center(
// //                     child: Text(
// //                       'Dashboard',
// //                       style: TextStyle(fontSize: 35),
// //                     ),
// //                   ),
// //                 ),
// //                 Container(
// //                   color: Colors.white,
// //                   child: const Center(
// //                     child: Text(
// //                       'Users',
// //                       style: TextStyle(fontSize: 35),
// //                     ),
// //                   ),
// //                 ),
// //                 Container(
// //                   color: Colors.white,
// //                   child: const Center(
// //                     child: Text(
// //                       'Expansion Item 1',
// //                       style: TextStyle(fontSize: 35),
// //                     ),
// //                   ),
// //                 ),
// //                 Container(
// //                   color: Colors.white,
// //                   child: const Center(
// //                     child: Text(
// //                       'Expansion Item 2',
// //                       style: TextStyle(fontSize: 35),
// //                     ),
// //                   ),
// //                 ),
// //                 Container(
// //                   color: Colors.white,
// //                   child: const Center(
// //                     child: Text(
// //                       'Files',
// //                       style: TextStyle(fontSize: 35),
// //                     ),
// //                   ),
// //                 ),
// //                 Container(
// //                   color: Colors.white,
// //                   child: const Center(
// //                     child: Text(
// //                       'Download',
// //                       style: TextStyle(fontSize: 35),
// //                     ),
// //                   ),
// //                 ),
// //
// //                 // this is for SideMenuItem with builder (divider)
// //                 const SizedBox.shrink(),
// //
// //                 Container(
// //                   color: Colors.white,
// //                   child: const Center(
// //                     child: Text(
// //                       'Settings',
// //                       style: TextStyle(fontSize: 35),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:easy_sidemenu/easy_sidemenu.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// class AdminHomeScreen extends StatefulWidget {
//   final String title = "Admin Page";
//
//   @override
//   State<AdminHomeScreen> createState() => _AdminHomeScreenState();
// }
//
// class _AdminHomeScreenState extends State<AdminHomeScreen> {
//   PageController pageController = PageController();
//   SideMenuController sideMenu = SideMenuController();
//   String userName = ""; // To store the username
//
//   @override
//   void initState() {
//     super.initState();
//     sideMenu.addListener((index) {
//       pageController.jumpToPage(index);
//     });
//     _getUserName(); // Fetch the user name on initialization
//   }
//
//   Future<void> _getUserName() async {
//     final SupabaseClient supabase = Supabase.instance.client;
//
//     // Get the currently signed-in user's ID
//     final User? user = supabase.auth.currentUser;
//     if (user != null) {
//       // Fetch the user's profile from the 'users' table
//       final response = await supabase
//           .from('users')
//           .select('email')
//           .eq('id', user.id)
//           .single();
//
//       setState(() {
//         userName = response?['email'] ?? 'Unknown User';
//       });
//     } else {
//       setState(() {
//         userName = 'No User Signed In';
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         centerTitle: true,
//       ),
//       body: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           SideMenu(
//             controller: sideMenu,
//             style: SideMenuStyle(
//               displayMode: SideMenuDisplayMode.auto,
//               showHamburger: true,
//               hoverColor: Colors.blue[100],
//               selectedHoverColor: Colors.blue[100],
//               selectedColor: Colors.lightBlue,
//               selectedTitleTextStyle: const TextStyle(color: Colors.white),
//               selectedIconColor: Colors.white,
//             ),
//             title: Column(
//               children: [
//                 ConstrainedBox(
//                   constraints: const BoxConstraints(
//                     maxHeight: 150,
//                     maxWidth: 150,
//                   ),
//                   child: Image.asset(
//                     'assets/images/easy_sidemenu.png',
//                   ),
//                 ),
//                 const Divider(indent: 8.0, endIndent: 8.0),
//               ],
//             ),
//             footer: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.lightBlue[50],
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Padding(
//                   padding:
//                   const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
//                   child: Text(
//                     userName, // Display the username
//                     style: TextStyle(fontSize: 15, color: Colors.grey[800]),
//                   ),
//                 ),
//               ),
//             ),
//             items: [
//               SideMenuItem(
//                 title: 'Dashboard',
//                 onTap: (index, _) {
//                   sideMenu.changePage(index);
//                 },
//                 icon: const Icon(Icons.home),
//               ),
//               SideMenuItem(
//                 title: 'Users',
//                 onTap: (index, _) {
//                   sideMenu.changePage(index);
//                 },
//                 icon: const Icon(Icons.supervisor_account),
//               ),
//               SideMenuExpansionItem(
//                 title: "Expansion Item",
//                 icon: const Icon(Icons.kitchen),
//                 children: [
//                   SideMenuItem(
//                     title: 'Expansion Item 1',
//                     onTap: (index, _) {
//                       sideMenu.changePage(index);
//                     },
//                     icon: const Icon(Icons.home),
//                   ),
//                   SideMenuItem(
//                     title: 'Expansion Item 2',
//                     onTap: (index, _) {
//                       sideMenu.changePage(index);
//                     },
//                     icon: const Icon(Icons.supervisor_account),
//                   )
//                 ],
//               ),
//               SideMenuItem(
//                 title: 'Files',
//                 onTap: (index, _) {
//                   sideMenu.changePage(index);
//                 },
//                 icon: const Icon(Icons.file_copy_rounded),
//               ),
//               SideMenuItem(
//                 title: 'Download',
//                 onTap: (index, _) {
//                   sideMenu.changePage(index);
//                 },
//                 icon: const Icon(Icons.download),
//               ),
//               const SideMenuItem(
//                 title: 'Exit',
//                 icon: Icon(Icons.exit_to_app),
//               ),
//             ],
//           ),
//           const VerticalDivider(width: 0),
//           Expanded(
//             child: PageView(
//               controller: pageController,
//               children: [
//                 Container(
//                   color: Colors.white,
//                   child: const Center(
//                     child: Text(
//                       'Dashboard',
//                       style: TextStyle(fontSize: 35),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   color: Colors.white,
//                   child: const Center(
//                     child: Text(
//                       'Users',
//                       style: TextStyle(fontSize: 35),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/core/constants/colors.dart';
import 'package:system/core/themes/AppColors/them_constants.dart';
import 'package:system/features/Vaults/vaults_page.dart';
import 'package:system/features/auth/data/auth_service.dart';
import 'package:system/features/billes/presentation/payment/PaymentPage.dart';
import 'package:system/features/billes/presentation/payment/PaymentPage.dart';
import 'package:system/features/billes/presentation/BillingPage.dart';
import 'package:system/features/billes/presentation/safe/report_page.dart';
import 'package:system/features/category/presentation/screens/category_page.dart';
import 'package:system/features/customer/presentation/customerPage.dart';
import 'package:system/features/report/UI/ItemsReportDashboard.dart';
import 'package:system/features/report/UI/ReportCategoryOperationsPage.dart';
import 'package:system/features/report/UI/billsReportPage.dart';
import 'package:system/features/report/UI/ReportsPage.dart';
import 'package:system/main.dart';
import 'package:system/features/auth/presentation/screens/GetAllUsersScreen.dart';
import 'package:system/main_screens/Admin/mainScreen.dart';

class AdminHomeScreen extends StatefulWidget {
  final String title = "Admin ROTOSH Page";

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();
  final AuthService _authService = AuthService(Supabase.instance.client);

  String userName = "";
  String userRole = "";
  Map<String, dynamic> userInfo = {}; // To store user info

  @override
  void initState() {
    super.initState();
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
    _getUserInfo(); // Fetch the user info on initialization
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
        userName = response?['name'] ?? 'Unknown User';
        userRole = response?['role'] ?? 'Unknown User';
        userInfo = response ?? {}; // Store all user information
      });
    } else {
      setState(() {
        userName = 'No User Signed In';
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
              selectedIconColor: Colors.white,
              selectedTitleTextStyleExpandable:  const TextStyle(color: Colors.lightBlue),
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
                      'assets/logo/logo-5.png',
                    ),
                  ),
                ),
                const Divider(indent: 8.0, endIndent: 8.0),
              ],
            ),
            footer: Padding(
              padding: const EdgeInsets.all(10.0),
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
                      style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                    ),
                  ),
                ),
              ),
            ),
            items: [
              //الفواتير
              SideMenuItem(
                title: 'الصفحة الرئيسية                ',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.home),
              ),
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
              //الاصناف
              SideMenuItem(
                // trailing: Text("الاصناف" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
                title: 'الاصناف               ',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.book),
              ),
              SideMenuItem(
                // trailing: Text("العملاء" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
                title: 'العملاء                ',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.supervised_user_circle_sharp),
              ),


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
                icon: const Icon(Icons.gif_box),
              ),
              SideMenuItem(
                // trailing: Text("التقارير" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
                title: ' تقارير عمليات الصنف                ',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.gif_box),
              ),

                ]),
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
                // trailing: Text("خروج" , style: TextStyle(fontWeight: FontWeight.w400),textDirection: TextDirection.rtl,),
                title: 'خروج                  ',
                onTap: (index, _) async {
                  sideMenu.changePage(index);
                  await _authService.signOut();
                  Navigator.pushReplacementNamed(context, '/'); // توجيه المستخدم إلى صفحة تسجيل الدخول

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
                // Container(
                //   color: Colors.white,
                //   child: const Center(
                //     child: Text(
                //       'الفواتير',
                //       style: TextStyle(fontSize: 35),
                //     ),
                //   ),
                // ),
               // الاصناف
                CategoryPage(),
               //  Container(
               //    color: Colors.white,
               //    child: const Center(
               //      child: Text(
               //        'الاصناف',
               //        style: TextStyle(fontSize: 35),
               //      ),
               //    ),
               //  ),
                //العملاء
                CustomerPage(),
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
                ReportsPage(),
                billsReportPage(),
                ItemsReportDashboard(),
                ReportCategoryOperationsPage(),
                // الماليات
                PaymentPage(),

                VaultsPage(userRole: userRole,),
                GetAllUsersScreen(),


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
