// // // import 'package:flutter/material.dart';
// // // import 'package:supabase_flutter/supabase_flutter.dart';
// // // import '../../data/repositories/auth_repository.dart';
// // // import '../widgets/custom_text_field.dart';
// // //
// // // class LoginScreen extends StatefulWidget {
// // //   @override
// // //   _LoginScreenState createState() => _LoginScreenState();
// // // }
// // //
// // // class _LoginScreenState extends State<LoginScreen> {
// // //   final TextEditingController _emailController = TextEditingController();
// // //   final TextEditingController _passwordController = TextEditingController();
// // //   final AuthRepository _authRepository = AuthRepository();
// // //
// // //   Future<void> _signIn() async {
// // //     final email = _emailController.text;
// // //     final password = _passwordController.text;
// // //
// // //     final res = await _authRepository.signInWithEmail(email, password);
// // //     final session = res.session;
// // //     final user = res.user;
// // //
// // //     if (session != null && user != null) {
// // //       // Handle successful login
// // //       Navigator.pushReplacementNamed(context, '/users');
// // //       print('Successfully signed in! User ID: ${user.id}');
// // //     } else {
// // //       // Handle login failure
// // //       print('Failed to sign in.');
// // //     }
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(title: Text('Login')),
// // //       body: Padding(
// // //         padding: const EdgeInsets.all(16.0),
// // //         child: Column(
// // //           mainAxisAlignment: MainAxisAlignment.center,
// // //           children: [
// // //             CustomTextField(
// // //               controller: _emailController,
// // //               label: 'Email',
// // //             ),
// // //             CustomTextField(
// // //               controller: _passwordController,
// // //               label: 'Password',
// // //               obscureText: true,
// // //             ),
// // //             SizedBox(height: 20),
// // //             ElevatedButton(
// // //               onPressed: _signIn,
// // //               child: Text('Sign In'),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// import 'package:flutter/material.dart';
// import 'package:system/features/auth/data/auth_service.dart';
// import 'package:system/shared/app_routes.dart';
//
// class LoginScreen extends StatefulWidget {
//   final AuthService authService;
//
//   const LoginScreen({Key? key, required this.authService}) : super(key: key);
//
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _isLoading = false;
//
//   void _login() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       final authModel = await widget.authService.signInWithEmailPassword(
//         _emailController.text,
//         _passwordController.text,
//       );
//
//       if (authModel.role == 'admin') {
//         Navigator.pushReplacementNamed(context, AppRoutes.adminHome);
//       } else if (authModel.role == 'user') {
//         Navigator.pushReplacementNamed(context, AppRoutes.userHome);
//       } else {
//         throw Exception('Unknown role: ${authModel.role}');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${e.toString()}')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Login')),
//       body: Row(
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   TextField(
//                     controller: _emailController,
//                     decoration: const InputDecoration(labelText: 'Email'),
//                   ),
//                   TextField(
//                     controller: _passwordController,
//                     obscureText: true,
//                     decoration: const InputDecoration(labelText: 'Password'),
//                   ),
//                   const SizedBox(height: 20),
//                   _isLoading
//                       ? const CircularProgressIndicator()
//                       : ElevatedButton(
//                     onPressed: _login,
//                     child: const Text('Login'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:system/features/auth/data/auth_service.dart';
// import 'package:system/features/auth/presentation/widget/custom_text_field.dart';
// import 'package:system/shared/app_routes.dart';
//
// class LoginScreen extends StatefulWidget {
//
//   final AuthService authService;
// //
//   const LoginScreen({Key? key, required this.authService}) : super(key: key);
//
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   // final AuthService _authRepository = AuthService();
//
//   Future<void> _signIn() async {
//     final username = _usernameController.text;
//     final password = _passwordController.text;
//     bool _isLoading = false;
//
//   void _login() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//     final authModel = await widget.authService..signInWithUsername(username, password);
//     if (authModel.role == 'admin') {
//         Navigator.pushReplacementNamed(context, AppRoutes.adminHome);
//       } else if (authModel.role == 'user') {
//         Navigator.pushReplacementNamed(context, AppRoutes.userHome);
//       } else {
//         throw Exception('Unknown role: ${authModel.role}');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${e.toString()}')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//     // final userRole = response.from['role'];
//     //
//     // if (res != null ) {
//     //   Navigator.pushReplacementNamed(context, AppRoutes.adminHome);
//     // } else {
//     //   print('Failed to sign in.');
//     // }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CustomTextField(
//               controller: _usernameController,
//               label: 'Username',
//             ),
//             CustomTextField(
//               controller: _passwordController,
//               label: 'Password',
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _signIn,
//               child: Text('Sign In'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:system/features/auth/data/auth_service.dart';
import 'package:system/core/shared/app_routes.dart';

class LoginScreen extends StatefulWidget {
  final AuthService authService;

  const LoginScreen({Key? key, required this.authService}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
      appBar: AppBar(title: const Text('Login')

      ),
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: _login,
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

