
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
      appBar: AppBar(title: const Text('اضافة مستخدم')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'الاسم',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'الايميل',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'كلمة السر',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedRole,
              decoration: const InputDecoration(
                labelText: 'نوع المستخدم',
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
                    : const Text('اضافة مستخدم'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
