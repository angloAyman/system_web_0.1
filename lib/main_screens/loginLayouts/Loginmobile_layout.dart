
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/core/constants/colors.dart';
import 'package:system/core/themes/AppColors/app_colors_dark.dart';
import 'package:system/core/themes/AppColors/them_constants.dart';
import 'package:system/features/auth/data/auth_service.dart';
import 'package:system/main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class LoginMobileLayout extends StatefulWidget {
  final AuthService authService;

  const LoginMobileLayout({Key? key, required this.authService}) : super(key: key);

  @override
  State<LoginMobileLayout> createState() => _LoginMobileLayoutState();
}

class _LoginMobileLayoutState extends State<LoginMobileLayout> with WidgetsBindingObserver {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isOffline = false;
  bool _obscurePassword = true; // أضف هذا داخل State

  String? userId;
  final SupabaseClient supabase = Supabase.instance.client;

  StreamSubscription? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _monitorConnection();
    WidgetsBinding.instance.addObserver(this);
    _monitorConnection();
    getUserId();
    listenToAuthChanges();
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
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      setState(() {
        // Assuming you want to check if there is no connectivity in any of the results.
        _isOffline = result.every((ConnectivityResult r) => r == ConnectivityResult.none);
      });
    });
  }

  // Function to record login time in the Supabase 'logins' table
  // Future<void> recordLoginTime(String userId) async {
  //   try {
  //     final session = supabase.auth.currentSession;
  //     final sessionId = session?.accessToken ?? ""; // استخدم التوكن كمعرّف فريد للجلسة
  //
  //     final loginTime = DateFormat('yyyy-MM-dd HH:mm:ss', 'en').format(DateTime.now().toLocal());
  //
  //     await supabase.from('logins').insert([
  //       {
  //         'user_id': userId,
  //         'session_id': sessionId,
  //         'login_time': loginTime,
  //         'device': "mobile",
  //         'logout_time': null,
  //       }
  //     ]);
  //   } catch (e) {
  //     debugPrint("خطأ أثناء تسجيل وقت الدخول: $e");
  //   }
  // }
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
          'device': "mobile",
          'logout_time': null,
        }
      ]);
      debugPrint("✅ تم تسجيل الدخول للجلسة الجديدة");

    } catch (e) {
      debugPrint("خطأ أثناء تسجيل وقت الدخول: $e");
      rethrow; // مهم علشان نقدر نعرض رسالة للمستخدم

    }
  }


  // void _login() async {
  //   if (!_formKey.currentState!.validate()) {
  //     return; // Exit if the form is invalid
  //   }
  //
  //   if (_isOffline) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('لا يوجد اتصال بالإنترنت')),
  //     );
  //     return;
  //   }
  //
  //
  //
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   try {
  //     final authModel = await widget.authService.signInWithUsernamePassword(
  //       _usernameController.text,
  //       _passwordController.text,
  //     );
  //
  //     if (authModel != null) {
  //       await recordLoginTime(authModel.id);
  //       // startAutoLogoutTimer(context);
  //     }
  //
  //
  //     if (authModel.role.toLowerCase() != 'admin') {
  //       _showErrorDialog("ممنوع", "فقط المستخدم المسؤول (admin) يمكنه تسجيل الدخول.");
  //       return;
  //     }
  //     Navigator.pushReplacementNamed(context, "/adminHome");
  //
  //   } catch (e) {
  //     _showErrorDialog('خطأ', 'اسم المستخدم أو كلمة المرور غير صحيحة');
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: Text('ROTOSH Mobile'),
        // title: Text('مرحبا بك في ROTOSH Mobile'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 50),
                  Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey, // 👈 لون الحد
                        width: 2,           // 👈 عرض الحد
                      ),
                      borderRadius: BorderRadius.circular(50), // 👈 اختياري: زوايا دائرية
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50), // 👈 تأكد من أن الصورة تتبع نفس الانحناء
                      child: Image.asset(
                        "assets/logo/logo-6.png",
                        fit: BoxFit.cover, // 👈 اختياري لتعبئة الحاوية
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "تسجيل الدخول",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: AppColorsDark.AppbarColor ),
                  ),
                  const SizedBox(height: 30),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            border: Border.all(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey[700]!
                                  : Colors.grey[300]!,
                            ),
                          ),
                          child: TextFormField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              labelText: 'اسم المستخدم',
                              border: InputBorder.none, // ✅ إزالة الإطار الداخلي
                            ),
                            style: const TextStyle(fontSize: 16),
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
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[700]!
                : Colors.grey[300]!,
          ),
        ),
        child: TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'كلمة المرور',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          style: const TextStyle(fontSize: 16),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'يرجى إدخال كلمة المرور';
            }
            return null;
          },
          onFieldSubmitted: (_) => _login(), // ✅ تأكد أنك تستدعي الدالة
        ),
      ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: _login,
                    child: const Text('دخول'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
