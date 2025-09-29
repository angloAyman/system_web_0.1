
import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:system/core/constants/colors.dart';
import 'package:system/core/themes/AppColors/them_constants.dart';
import 'package:system/features/auth/data/auth_service.dart';
import 'package:system/main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase package

class LoginDesktopLayout extends StatefulWidget {
  final AuthService authService;

  const LoginDesktopLayout({Key? key, required this.authService}) : super(key: key);

  @override
  State<LoginDesktopLayout> createState() => _LoginDesktopLayoutState();
}

class _LoginDesktopLayoutState extends State<LoginDesktopLayout> with WidgetsBindingObserver {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isOffline = false;
  String? userId;
  final SupabaseClient supabase = Supabase.instance.client;

  StreamSubscription? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _monitorConnection();
    getUserId();
    listenToAuthChanges(); // ← إضافة هذا إن أردت مراقبة تغيّر الجلسة
  }


  Future<void> getUserId() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      setState(() {
        userId = user.id;
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if ( state == AppLifecycleState.detached) {
      if (userId != null) {
        await logoutUser(userId!); // Ensure Supabase update completes
      }
    }
  }

  Future<void> logoutUser(String userId) async {
    try {
      final session = supabase.auth.currentSession;
      final sessionId = session?.accessToken ?? "";

      final record = await supabase
          .from('logins')
          .select()
          .eq('user_id', userId)
          .eq('session_id', sessionId)
          .eq('logout_time', "")
          .maybeSingle();

      if (record != null) {
        await supabase
            .from('logins')
            .update({'logout_time': DateTime.now().toUtc().toIso8601String()})
            .eq('id', record['id']);
        debugPrint("✅ تم تسجيل الخروج من الجلسة الحالية.");
      } else {
        debugPrint("⚠️ لا يوجد جلسة نشطة حالياً لهذا المستخدم.");
      }
    } catch (e) {
      debugPrint("❌ خطأ أثناء تسجيل الخروج: $e");
    }
  }

  void listenToAuthChanges() {
    supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (!mounted) return;
      setState(() {
        userId = session?.user?.id;
      });
    });
  }

  // Monitor the connection status
  void _monitorConnection() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (!mounted) return;
      setState(() {
        _isOffline = results.every((r) => r == ConnectivityResult.none);
      });
    });
  }






  // Function to record login time in the Supabase 'logins' table
  Future<void> recordLoginTime(String userId) async {
    try {
      final session = supabase.auth.currentSession;
      final sessionId = session?.accessToken ?? ""; // استخدم التوكن كمعرّف فريد للجلسة

      // ✅ تحقق من وجود جلسة نشطة مسبقاً
      final existing = await supabase
          .from('logins')
          .select()
          .eq('user_id', userId)
          .isFilter('logout_time', null) // ✅ يعادل IS NULL
          .maybeSingle();


      if (existing != null) {
        // لو فيه جلسة قديمة مفتوحة
        throw Exception("هذا المستخدم مسجل دخول بالفعل من جهاز آخر");
      }

      // ✅ إدخال جلسة جديدة
      final loginTime = DateFormat('yyyy-MM-dd HH:mm:ss',"en").format(DateTime.now().toLocal());

      await supabase.from('logins').insert([
        {
          'user_id': userId,
          'session_id': sessionId,
          'login_time': loginTime,
          'device': "pc",
          'logout_time': null,
        }
      ]);
      debugPrint("✅ تم تسجيل الدخول للجلسة الجديدة");

    } catch (e) {
      debugPrint("خطأ أثناء تسجيل وقت الدخول: $e");
      rethrow; // مهم علشان نقدر نعرض رسالة للمستخدم

    }
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) {
      return; // Exit if the form is invalid
    }

    if (_isOffline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يوجد اتصال بالإنترنت')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authModel = await widget.authService.signInWithUsernamePassword(
        _usernameController.text,
        _passwordController.text,
      );


      if (authModel != null) {
        await recordLoginTime(authModel.id);
        // startAutoLogoutTimer(context);
      }

      if (authModel.role == 'admin') {
        Navigator.pushReplacementNamed(context, "/adminHome");
      } else if (authModel.role == 'user') {
        Navigator.pushReplacementNamed(context, "/userHome");
      }else if (authModel.role == 'user2') {
        Navigator.pushReplacementNamed(context, "/userHome2");
      }else if (authModel.role == 'dev') {
        Navigator.pushReplacementNamed(context, "/adminHome");
      } else {
        throw Exception('Unknown role: ${authModel.role}');
      }
    } catch (e) {
      print(e);
      _showErrorDialog('خطأ', e.toString()); // ✅ نعرض الخطأ (لو فيه جلسة مفتوحة مثلاً)

      // _showErrorDialog('خطأ', 'اسم المستخدم أو كلمة المرور غير صحيحة');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('حسنًا'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel(); // ← هذا مهم
    WidgetsBinding.instance.removeObserver(this);
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مرحبا بك في ROTOSH DESKTOP'),
        centerTitle: true,
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: CircleAvatar(
            backgroundColor: AppColors.primary,
            radius: 300,
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 50),
                    Image.asset(
                      "assets/logo/logo-6.png",
                      width: 300,
                      height: 300,
                    ),
                    const Text(
                      "تسجيل الدخول",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            width: 300,
                            child: TextFormField(
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                labelText: 'اسم المستخدم',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'يرجى إدخال اسم المستخدم';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: 300,
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'كلمة المرور',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'يرجى إدخال كلمة المرور';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      child: const Text('دخول'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
