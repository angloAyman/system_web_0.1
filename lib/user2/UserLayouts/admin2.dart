// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:system/features/attendance/Data/AttendanceRepository.dart';
// import 'package:system/features/auth/data/auth_service.dart';
// import 'package:system/features/billes/presentation/BillingPage.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:system/user/features/bills/presentation/UserBillingPage.dart';
// import 'package:system/features/payment/PaymentPage.dart';
// import 'package:system/user/features/payment/UserPaymentPage.dart';
// import 'package:system/features/category/presentation/screens/Usercategory_page.dart';
// import 'package:system/features/category/presentation/screens/category_page.dart';
// import 'package:system/user/features/Customer/presentation/UsercustomerPage.dart';
// import 'package:system/features/customer/presentation/customerPage.dart';
// import 'package:system/main_screens/AdminLayouts/devmainScreen.dart';
// import 'package:system/main_screens/Responsive/login_responsive.dart';
// import 'package:system/user2/UserLayouts/userMainScreen2.dart';
// import 'package:system/user2/features/Customer/presentation/UsercustomerPage2.dart';
// import 'package:system/user2/features/Customer/presentation/customer_account_statement2.dart';
// import 'package:system/user2/features/bills/presentation/UserBillingPage2.dart';
// import 'package:system/user2/features/payment/UserPaymentPage2.dart';
//
// import '../../main.dart';
//
// class admin2 extends StatefulWidget {
//   @override
//   _admin2State createState() => _admin2State();
// }
//
// class _admin2State extends State<admin2> {
//   int _selectedIndex = 0;
//   final AuthService _authService = AuthService(Supabase.instance.client);
//   String userName = "";
//   String userid = "";
//   String userRole = "";
//   Map<String, dynamic> userInfo = {}; // To store user info
//   bool _isOffline = false;
//
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
//
//   // Pages for navigation
//   final List<Widget> _pages = [
//     // الرئيسية
//     userMainScreen2(),
//     // الفواتير
//     UserBillingPage2(),
//     // الماليات
//     UserPaymentPage2(),
//     // الاصناف
//     UserCategoryPage(),
//     //العملاء
//     UserCustomerPage2(),
//     //كشف حساب
//     CustomerSelectionPage2()
//     // خروج
//     // loginResponsive(),
//   ];
//
//   // Drawer menu options
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//       Navigator.pop(context); // Close the drawer after navigation
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('مرحبا بك في User2 '),
//         centerTitle: true,
//         actions: [
//           Switch(
//             value: themeManagermain.themeMode == ThemeMode.dark,
//             onChanged: (newValue) {
//               themeManagermain.toggleTheme(newValue);
//             },
//           )
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
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.admin_panel_settings, size: 50, color: Colors.white),
//                   SizedBox(height: 10),
//                   Text(
//                     'Rotosh',
//                     style: TextStyle(color: Colors.white, fontSize: 20),
//                   ),
//                 ],
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.check_circle),
//               title: Text('الرئيسية'),
//               selected: _selectedIndex == 0,
//               onTap: () => _onItemTapped(0),
//             ),
//             ListTile(
//               leading: Icon(Icons.bar_chart),
//               title: Text('الفواتير'),
//               selected: _selectedIndex == 1,
//               onTap: () => _onItemTapped(1),
//             ),
//             ListTile(
//               leading: Icon(Icons.bar_chart),
//               title: Text('الماليات'),
//               selected: _selectedIndex == 2,
//               onTap: () => _onItemTapped(2),
//             ),
//             ListTile(
//               leading: Icon(Icons.bar_chart),
//               title: Text('الاصناف'),
//               selected: _selectedIndex == 3,
//               onTap: () => _onItemTapped(3),
//             ),
//             ListTile(
//               leading: Icon(Icons.bar_chart),
//               title: Text('العملاء'),
//               selected: _selectedIndex == 4,
//               onTap: () => _onItemTapped(4),
//             ),
//             ListTile(
//               leading: Icon(Icons.output_rounded),
//               title: Text('خروج'),
//               selected: _selectedIndex == 5,
//               onTap: () async {
//                 await _authService.signOut();
//                 _authService.logoutUser(userid);
//                 _onItemTapped(5);
//                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  LoginResponsive(),));
//               },
//             ),
//           ],
//         ),
//       ),
//       body: _pages[_selectedIndex],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/auth/data/auth_service.dart';
import 'package:system/user2/UserLayouts/userMainScreen2.dart';
import 'package:system/user2/features/bills/presentation/UserBillingPage2.dart';
import 'package:system/user2/features/payment/UserPaymentPage2.dart';
import 'package:system/features/category/presentation/screens/Usercategory_page.dart';
import 'package:system/user2/features/Customer/presentation/UsercustomerPage2.dart';
import 'package:system/user2/features/Customer/presentation/customer_account_statement2.dart';
import 'package:system/main_screens/Responsive/login_responsive.dart';
import '../../main.dart';

class User2Dashboard extends StatefulWidget {
  @override
  _User2DashboardState createState() => _User2DashboardState();
}

class _User2DashboardState extends State<User2Dashboard> {
  int _selectedIndex = 0;
  final AuthService _authService = AuthService(Supabase.instance.client);
  String userName = "Loading...";
  String userid = "";
  String userRole = "";
  bool _isOffline = false;
  bool _isLoading = true;
  bool _isLoggingOut = false;

  final List<Map<String, dynamic>> _menuItems = [
    {'icon': Icons.home, 'title': 'الرئيسية'},
    {'icon': Icons.receipt, 'title': 'الفواتير'},
    {'icon': Icons.payments, 'title': 'الماليات'},
    {'icon': Icons.category, 'title': 'الاصناف'},
    {'icon': Icons.people, 'title': 'العملاء'},
    {'icon': Icons.account_balance, 'title': 'كشف حساب'},
    {'icon': Icons.logout, 'title': 'خروج'},
  ];

  final List<Widget> _pages = [
    userMainScreen2(),
    UserBillingPage2(),
    UserPaymentPage2(),
    UserCategoryPage(),
    UserCustomerPage2(),
    CustomerAccountStatement(),
  ];

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    await _checkConnectivity();
    await _getUserInfo();
  }

  Future<void> _checkConnectivity() async {
    // Implement actual connectivity check (use connectivity_plus package)
    final isConnected = await _checkInternetConnection();
    setState(() => _isOffline = !isConnected);
  }

  Future<bool> _checkInternetConnection() async {
    // Replace with actual connectivity check
    return true;
  }

  Future<void> _getUserInfo() async {
    setState(() => _isLoading = true);
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user == null) {
        _navigateToLogin();
        return;
      }

      final response = await supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .single();

      if (mounted) {
        setState(() {
          userName = response['name'] ?? 'User';
          userid = response['id'] ?? '';
          userRole = response['role'] ?? 'user';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل في تحميل بيانات المستخدم: ${e.toString()}')),
        );
      }
    }
  }

  void _navigateToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginResponsive()),
          (route) => false,
    );
  }

  Future<void> _handleLogout() async {
    setState(() => _isLoggingOut = true);
    try {
      await _authService.signOut();
      await _authService.logoutUser(userid);
      _navigateToLogin();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في تسجيل الخروج: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoggingOut = false);
      }
    }
  }

  void _onItemTapped(int index) {
    if (index == _menuItems.length - 1) { // Logout item
      _handleLogout();
      return;
    }

    setState(() => _selectedIndex = index);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('جاري تحميل البيانات...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('مرحبا بك $userName', style: TextStyle(fontSize: 18)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _initializeUserData,
            tooltip: 'تحديث',
          ),
          Switch(
            value: themeManagermain.themeMode == ThemeMode.dark,
            onChanged: (newValue) => themeManagermain.toggleTheme(newValue),
          ),
        ],
        bottom: _isOffline
            ? PreferredSize(
          preferredSize: Size.fromHeight(30.0),
          child: Container(
            color: Colors.orange,
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off, size: 18, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'وضع عدم الاتصال - البيانات قد لا تكون محدثة',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        )
            : null,
      ),
      drawer: _buildDrawer(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userName),
            accountEmail: Text(userRole),
            currentAccountPicture:
            CircleAvatar(
              child: Image.asset(
                "assets/logo/logo-6.png",

              ),
              // backgroundColor: Colors.white,
              // child: Icon(Icons.person, size: 40),
            ),
            // decoration: BoxDecoration(
            //   color: Colors.blue,
            // ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                return ListTile(
                  leading: Icon(item['icon']),
                  title: Text(item['title']),
                  selected: _selectedIndex == index && index != _menuItems.length - 1,
                  onTap: () => _onItemTapped(index),
                  trailing: _isLoggingOut && index == _menuItems.length - 1
                      ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : null,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'الإصدار 1.0.0',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}