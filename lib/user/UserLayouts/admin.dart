import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/attendance/Data/AttendanceRepository.dart';
import 'package:system/features/auth/data/auth_service.dart';
import 'package:system/features/billes/presentation/BillingPage.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:system/user/UserLayouts/userMainScreen.dart';
import 'package:system/user/features/Customer/presentation/customer_account_statement.dart';
import 'package:system/user/features/bills/presentation/UserBillingPage.dart';
import 'package:system/features/payment/PaymentPage.dart';
import 'package:system/user/features/payment/UserPaymentPage.dart';
import 'package:system/features/category/presentation/screens/Usercategory_page.dart';
import 'package:system/features/category/presentation/screens/category_page.dart';
import 'package:system/user/features/Customer/presentation/UsercustomerPage.dart';
import 'package:system/features/customer/presentation/customerPage.dart';
import 'package:system/main_screens/AdminLayouts/mainScreen.dart';
import 'package:system/main_screens/Responsive/login_responsive.dart';
// import 'package:system/main_screens/UserLayouts/userMainScreen.dart';

class admin extends StatefulWidget {
  @override
  _adminState createState() => _adminState();
}

class _adminState extends State<admin> {
  int _selectedIndex = 0;
  final AuthService _authService = AuthService(Supabase.instance.client);
  String userName = "";
  String userid = "";
  String userRole = "";
  Map<String, dynamic> userInfo = {}; // To store user info


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


  // Pages for navigation
  final List<Widget> _pages = [
    // الرئيسية
    userMainScreen(),
    // الفواتير
    UserBillingPage(),
    // الماليات
    UserPaymentPage(),
    // الاصناف
    UserCategoryPage(),
    //العملاء
    UserCustomerPage(),
    //كشف حساب
    CustomerSelectionPage()
    // خروج
    // loginResponsive(),
  ];

  // Drawer menu options
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.pop(context); // Close the drawer after navigation
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(_selectedIndex == 0 ? 'user' : 'user'),
        title: Text("user"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.admin_panel_settings, size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Rotosh',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.check_circle),
              title: Text('الرئيسية'),
              selected: _selectedIndex == 0,
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('الفواتير'),
              selected: _selectedIndex == 1,
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('الماليات'),
              selected: _selectedIndex == 2,
              onTap: () => _onItemTapped(2),
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('الاصناف'),
              selected: _selectedIndex == 3,
              onTap: () => _onItemTapped(3),
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('العملاء'),
              selected: _selectedIndex == 4,
              onTap: () => _onItemTapped(4),
            ),
            ListTile(
              leading: Icon(Icons.output_rounded),
              title: Text('خروج'),
              selected: _selectedIndex == 5,
              onTap: () async {
                await _authService.signOut();
                _authService.logoutUser(userid);

                _onItemTapped(5);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  LoginResponsive(),));

              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}

// Attendance Page
class AttendancePage extends StatefulWidget {
  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final AttendanceRepository _attendanceRepository = AttendanceRepository();

  bool _isScanning = false;

  String? _qrCodeResult;

  String _statusMessage = '';

  bool _isSubmitting = false;

  void _onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      setState(() {
        _qrCodeResult = scanData.code;
        _isScanning = false;
      });
    });
  }

  Future<void> _submitAttendance(String qrCode) async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      // await _attendanceRepository.markAttendance(qrCode);
      setState(() {
        _statusMessage = 'تم تسجيل الحضور بنجاح!';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'فشل تسجيل الحضور: $e';
      });
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    children: [
    Expanded(
    child: _isScanning
    ? Center(
    child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
    Text('قم بمسح رمز الاستجابة السريع'),
    SizedBox(height: 20),
    SizedBox(
    width: 300,
    height: 300,
    child: QRView(
    key: GlobalKey(debugLabel: 'QR'),
    onQRViewCreated: _onQRViewCreated,
    ),
    ),
    ElevatedButton(
    onPressed: () {
    setState(() {
    _isScanning = false;
    });
    },
    child: Text('إلغاء المسح'),
    ),
    ],
    ),
    )
        : Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Center(
      child: ElevatedButton(
      onPressed: () {
      setState(() {
      _isScanning = true;
      _qrCodeResult = null;
      _statusMessage = '';
      });
      },
      child: Text('بدء مسح QR'),
      ),
    ),
    if (_qrCodeResult != null)
    Padding(
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    child: Text(
    'تم مسح QR: $_qrCodeResult',
    style: TextStyle(
    fontSize: 16, fontWeight: FontWeight.bold),
    textAlign: TextAlign.center,
    ),
    ),
    if (_statusMessage.isNotEmpty)
    Padding(
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    child: Text(
    _statusMessage,
    style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: _statusMessage.contains('نجاح')
    ? Colors.green
        : Colors.red,
    ),
    textAlign: TextAlign.center,
    ),
    ),
    ElevatedButton(
    onPressed: _qrCodeResult == null || _isSubmitting
    ? null
        : () => _submitAttendance(_qrCodeResult!),
    child: _isSubmitting
    ? CircularProgressIndicator(
    valueColor:
    AlwaysStoppedAnimation<Color>(Colors.white),
    )
        : Text('تسجيل الحضور'),
    ),
    ]
    )
    //   Center(
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Icon(Icons.check_circle_outline, size: 100, color: Colors.green),
    //       SizedBox(height: 20),
    //       Text(
    //         'Attendance Management',
    //         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    //       ),]
    //       SizedBox(height: 10),
    //       Text('Manage and track attendance records.'),
    //       Container(
    //           child: QRScannerPage(),
    ),
    ]
    )

      ),
    );
  }
}

// Report Page
class ReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bar_chart, size: 100, color: Colors.blue),
          SizedBox(height: 20),
          Text(
            'Reports',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text('View attendance reports and statistics.'),
        ],
      ),
    );
  }
}