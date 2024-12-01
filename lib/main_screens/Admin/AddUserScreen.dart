// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// class AddUserScreen extends StatefulWidget {
//   @override
//   State<AddUserScreen> createState() => _AddUserScreenState();
// }
//
// class _AddUserScreenState extends State<AddUserScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   String selectedRole = 'user';
//   bool isLoading = false;
//
//   Future<void> addUser() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         isLoading = true;
//       });
//
//       try {
//         final SupabaseClient supabase = Supabase.instance.client;
//
//         final response = await supabase.from('users').insert({
//           'email': emailController.text.trim(),
//           'name': nameController.text.trim(),
//           'role': selectedRole,
//         });
//
//         if (response != null) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('User added successfully!')),
//           );
//           Navigator.pop(context, true); // Return to previous screen
//         }
//       } catch (e) {
//         print("$e");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error adding user: $e')),
//         );
//       } finally {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add User'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 controller: nameController,
//                 decoration: const InputDecoration(labelText: 'Name'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the user name';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: emailController,
//                 decoration: const InputDecoration(labelText: 'Email'),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter an email';
//                   }
//                   if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                     return 'Please enter a valid email address';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               DropdownButtonFormField<String>(
//                 value: selectedRole,
//                 items: ['user', 'admin']
//                     .map((role) => DropdownMenuItem(
//                   value: role,
//                   child: Text(role.toUpperCase()),
//                 ))
//                     .toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     selectedRole = value!;
//                   });
//                 },
//                 decoration: const InputDecoration(labelText: 'Role'),
//               ),
//               const SizedBox(height: 24),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: isLoading ? null : addUser,
//                   child: isLoading
//                       ? const CircularProgressIndicator(
//                     color: Colors.white,
//                   )
//                       : const Text('Add User'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddUserScreen extends StatefulWidget {
  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  String selectedRole = 'user'; // Default role is 'user'
  bool isLoading = false;

  final roles = ['user', 'admin'];

  Future<void> addUser() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Create user authentication in Supabase
      final AuthResponse authResponse = await Supabase.instance.client.auth
          .signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (authResponse.user != null) {
        // Insert user profile into the `users` table
        await Supabase.instance.client.from('users').insert({
          'id': authResponse.user!.id,
          'email': emailController.text.trim(),
          'name': nameController.text.trim(),
          'role': selectedRole,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User added successfully!')),
        );
        Navigator.pop(context);
      } else {
        throw Exception('Failed to create user.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add User')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedRole,
              decoration: const InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(),
              ),
              items: roles
                  .map((role) => DropdownMenuItem(
                value: role,
                child: Text(role.toUpperCase()),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedRole = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : addUser,
                child: isLoading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text('Add User'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
