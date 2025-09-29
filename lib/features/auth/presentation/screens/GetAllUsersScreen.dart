import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GetAllUsersScreen extends StatefulWidget {
  @override
  State<GetAllUsersScreen> createState() => _GetAllUsersScreenState();
}

class _GetAllUsersScreenState extends State<GetAllUsersScreen> {
  List<Map<String, dynamic>> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  // Function to fetch users from Supabase
  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await Supabase.instance.client.from('users').select('*');

      if (response == null) {
        throw Exception(response);
      }

      if (response != null) {
        setState(() {
          users = List<Map<String, dynamic>>.from(response);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No users found')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching users: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to delete user from Supabase
  Future<void> deleteUser(String userId) async {
    setState(() {
      isLoading = true;
    });

    try {
      // Delete user from `users` table
      final response = await Supabase.instance.client
          .from('users')
          .delete()
          .eq('id', userId)
          ;

      // Optionally delete user from Auth
      await Supabase.instance.client.auth.admin.deleteUser(userId);

      if (response.error != null) {
        throw Exception(response.error!.message);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('UserLayouts deleted successfully')),
      );

      // Refresh the user list
      fetchUsers();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting user: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة المستخدمين'),
        centerTitle: true,
        actions: [
          TextButton.icon(onPressed: (){
            Navigator.pushReplacementNamed(context, '/adminHome'); // توجيه المستخدم إلى صفحة تسجيل الدخول
          }, label: Icon(Icons.home)),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.of(context).pushNamed("/adduser").then((_) {
                      fetchUsers(); // Refresh after adding a user
                    });
                  },
                  child: const Text('اضافة مستخدم جديد'),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('الاسم')),
                  DataColumn(label: Text('الايميل')),
                  DataColumn(label: Text('الدور')),
                  DataColumn(label: Text('مهام')),
                ],
                rows: users.map((user) {
                  return DataRow(cells: [
                    DataCell(Text(user['name'] ?? '')),
                    DataCell(Text(user['email'] ?? '')),
                    DataCell(Text(user['role'] ?? '')),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('تاكيد الحذف'),
                                    content: Text(
                                      'هل انت متاكد من حذف  "${user['name']}"?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('الغاء'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          await deleteUser(user['id']);
                                          fetchUsers();
                                        },
                                        child: const Text('حذف'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
