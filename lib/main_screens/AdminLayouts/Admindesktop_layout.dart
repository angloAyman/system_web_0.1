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
import 'package:system/features/auth/data/auth_service.dart';
import 'package:system/main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class DesktopLayout extends StatefulWidget {
  final AuthService authService;

  const DesktopLayout({Key? key, required this.authService}) : super(key: key);

  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _monitorConnection();
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

      if (authModel.role == 'admin') {
        Navigator.pushReplacementNamed(context, "/adminHome");
      } else if (authModel.role == 'user') {
        Navigator.pushReplacementNamed(context, "/userHome");
      } else {
        throw Exception('Unknown role: ${authModel.role}');
      }
    } catch (e) {
      _showErrorDialog('خطأ', 'اسم المستخدم أو كلمة المرور غير صحيحة');
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
                      "assets/logo/logo-3.png",
                      width: 300,
                      height: 300,
                    ),
                    const Text(
                      "تسجيل الدخول",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                      onPressed: _login,
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
