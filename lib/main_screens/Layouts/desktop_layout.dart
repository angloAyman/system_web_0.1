import 'package:flutter/material.dart';
import 'package:system/core/constants/app_constants.dart';
import 'package:system/core/constants/colors.dart';
import 'package:system/core/themes/AppColors/them_constants.dart';
import 'package:system/features/auth/data/auth_service.dart';
import 'package:system/features/auth/presentation/screens/login_screen.dart';
import 'package:system/main.dart';
import 'package:system/core/shared/app_routes.dart';

class DesktopLayout extends StatefulWidget {
  final AuthService authService;

  const DesktopLayout({Key? key, required this.authService}) : super(key: key);

  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authModel = await widget.authService.signInWithUsernamePassword(
        _usernameController.text,
        _passwordController.text,
      );

      if (authModel.role == 'admin') {
        Navigator.pushReplacementNamed(context, "/adminHome");
      } else if (authModel.role == 'user') {
        Navigator.pushReplacementNamed(context, "/userHome");
      } else {
        throw Exception('Unknown role: ${authModel.role}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مرحبا بك في ROTOSH DESKTOP'),
        centerTitle: true,
        actions: [
          Switch(
              value: themeManagermain.themeMode == ThemeMode.dark,
              onChanged: (newValue) {
                themeManagermain.toggleTheme(newValue);
              })
        ],
      ),
      body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
            backgroundColor: AppColors.background2,
              radius: (500),
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 80,
                      ),
                      Center(
                        child: Image.asset(
                          "assets/logo/logo-3.png",
                          width: 200,
                          height: 200,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "ROTOSH",
                        style:
                        AppBarTheme.of(context).titleTextStyle,
                        // style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold,
                        // ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "تسجيل الدخول",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          // height: 40,
                          width: 300,
                          child: TextField(
                            controller: _usernameController,
                            decoration:
                            // const InputDecoration(labelText: 'Username'),
                            const InputDecoration(
                                labelText: 'اسم المستخدم',
                                counterStyle:
                                TextStyle(fontWeight: FontWeight.bold)),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          // height: 40,
                          width: 300,
                          child: TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                                labelText: 'كلمة المرور',
                                counterStyle:
                                TextStyle(fontWeight: FontWeight.bold)),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                        onPressed: _login,
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}