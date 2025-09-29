// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:system/features/auth/data/auth_service.dart';
// import 'package:system/user/UserLayouts/userMainScreen.dart';
// import 'package:system/user/features/Customer/presentation/customer_account_statement.dart';
// import 'package:system/user/features/bills/presentation/UserBillingPage.dart';
// import 'package:system/user/features/payment/UserPaymentPage.dart';
// import 'package:system/features/category/presentation/screens/Usercategory_page.dart';
// import 'package:system/user/features/Customer/presentation/UsercustomerPage.dart';
// import 'package:system/main_screens/Responsive/login_responsive.dart';
//
// import '../../main.dart';
//
// class admin extends StatefulWidget {
//   @override
//   _adminState createState() => _adminState();
// }
//
// class _adminState extends State<admin> {
//   int _selectedIndex = 0;
//   final AuthService _authService = AuthService(Supabase.instance.client);
//   String userName = "";
//   String userid = "";
//   String userRole = "";
//   bool _isOffline = false;
//
//   Map<String, dynamic> userInfo = {}; // To store user info
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
//   // Pages for navigation
//   final List<Widget> _pages = [
//     // الرئيسية
//     userMainScreen(),
//     // الفواتير
//     UserBillingPage(),
//     // الماليات
//     UserPaymentPage(),
//     // الاصناف
//     UserCategoryPage(),
//     //العملاء
//     UserCustomerPage(),
//     //كشف حساب
//     CustomerSelectionPage(),
//     // خروج
//     LoginResponsive(),
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
//         title: const Text('مرحبا بك في USER '),
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
//
//
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
//                   Icon(Icons.admin_panel_settings,
//                       size: 50, color: Colors.white),
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
//                 _authService.logoutUser(userid);
//                 _onItemTapped(5);
//                 Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(builder: (context) => LoginResponsive()),
//                       (Route<dynamic> route) => false, // إزالة جميع الصفحات السابقة
//                 );
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
import 'package:system/user/UserLayouts/userMainScreen.dart';
import 'package:system/user/features/Customer/presentation/customer_account_statement.dart';
import 'package:system/user/features/bills/presentation/UserBillingPage.dart';
import 'package:system/user/features/payment/UserPaymentPage.dart';
import 'package:system/features/category/presentation/screens/Usercategory_page.dart';
import 'package:system/user/features/Customer/presentation/UsercustomerPage.dart';
import 'package:system/main_screens/Responsive/login_responsive.dart';
import '../../main.dart';

class UserDashboard extends StatefulWidget {
  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _selectedIndex = 0;
  final AuthService _authService = AuthService(Supabase.instance.client);
  String userName = "";
  String userid = "";
  String userRole = "";
  bool _isOffline = false;
  bool _isLoading = true;

  Map<String, dynamic> userInfo = {};

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    // Implement actual connectivity check here
    final isConnected = await _checkInternetConnection();
    setState(() {
      _isOffline = !isConnected;
    });
  }

  Future<bool> _checkInternetConnection() async {
    // Placeholder for actual connectivity check
    // You might use connectivity_plus package
    return true;
  }

  Future<void> _getUserInfo() async {
    setState(() => _isLoading = true);
    try {
      final SupabaseClient supabase = Supabase.instance.client;
      final User? user = supabase.auth.currentUser;

      if (user != null) {
        final response = await supabase
            .from('users')
            .select('*')
            .eq('id', user.id)
            .single();

        setState(() {
          userName = response?['name'] ?? 'Unknown User';
          userid = response?['id'] ?? '';
          userRole = response?['role'] ?? 'user';
          userInfo = response ?? {};
          _isLoading = false;
        });
      } else {
        setState(() {
          userName = 'No User Signed In';
          _isLoading = false;
        });
        _navigateToLogin();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user info: ${e.toString()}')),
      );
    }
  }

  void _navigateToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginResponsive()),
          (Route<dynamic> route) => false,
    );
  }

  final List<Widget> _pages = [
    userMainScreen(),
    UserBillingPage(),
    UserPaymentPage(),
    UserCategoryPage(),
    UserCustomerPage(),
    CustomerSelectionPage(),
    LoginResponsive(),
  ];

  final List<Map<String, dynamic>> _menuItems = [
    {'icon': Icons.home, 'title': 'الرئيسية'},
    {'icon': Icons.receipt, 'title': 'الفواتير'},
    {'icon': Icons.payments, 'title': 'الماليات'},
    {'icon': Icons.category, 'title': 'الاصناف'},
    {'icon': Icons.people, 'title': 'العملاء'},
    {'icon': Icons.account_balance, 'title': 'كشف حساب'},
    {'icon': Icons.logout, 'title': 'خروج'},
  ];

  void _onItemTapped(int index) {
    if (index == _menuItems.length - 1) { // Logout item
      _authService.logoutUser(userid);
      _navigateToLogin();
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('مرحبا بك $userName', style: TextStyle(fontSize: 18)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _getUserInfo,
            tooltip: 'تحديث البيانات',
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
            color: Colors.red,
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Center(
              child: Text(
                'لا يوجد اتصال بالإنترنت - الوضع غير متصل',
                style: TextStyle(color: Colors.white),
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
            currentAccountPicture: CircleAvatar(
              child: Image.asset(
                "assets/logo/logo-6.png",
              ),
              backgroundColor: Colors.white,
              // child: Icon(Icons.person, size: 40),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                return ListTile(
                  leading: Icon(item['icon']),
                  title: Text(item['title']),
                  selected: _selectedIndex == index,
                  onTap: () => _onItemTapped(index),
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