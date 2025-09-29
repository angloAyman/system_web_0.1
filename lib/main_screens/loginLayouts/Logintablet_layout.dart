// import 'package:flutter/material.dart';
// import 'package:system/features/auth/data/auth_service.dart';
// import 'package:system/features/auth/presentation/screens/login_screen.dart';
// import 'package:system/core/shared/app_routes.dart';
//
// import '../../main.dart';
//
// class LoginTabletLayout extends StatelessWidget {
//   final AuthService authService;
//
//   const LoginTabletLayout({Key? key, required this.authService}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('مرحبا بك في ROTOSH Tablet'),
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
//       body: Container(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Expanded(
//                 child: Center(
//                     child: Image.asset(
//               'assets/logo/logo-3.png',
//               scale: 2,
//             ))),
//             Expanded(child: LoginScreen(authService: authService)),
//             // child: ElevatedButton(
//             //   onPressed: () {
//             //     Navigator.pushNamed(context, AppRoutes.login); // استخدام route
//             //   },
//             //   child: Text('Go to Details'),
//             // ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
