// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// class GetAllUsersScreenMobile extends StatefulWidget {
//   @override
//   State<GetAllUsersScreenMobile> createState() => _GetAllUsersScreenMobileState();
// }
//
// class _GetAllUsersScreenMobileState extends State<GetAllUsersScreenMobile> {
//   List<Map<String, dynamic>> users = [];
//   bool isLoading = true;
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     fetchUsers();
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   Future<void> fetchUsers() async {
//     setState(() => isLoading = true);
//
//     try {
//       final response = await Supabase.instance.client
//           .from('users')
//           .select('*')
//           .order('created_at', ascending: false);
//
//       if (response.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('لا يوجد مستخدمين')),
//         );
//       }
//
//       setState(() => users = List<Map<String, dynamic>>.from(response));
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('خطأ في جلب البيانات: ${e.toString()}')),
//       );
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }
//
//   Future<void> deleteUser(String userId, String userName) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('تأكيد الحذف'),
//         content: Text('هل أنت متأكد من حذف المستخدم "$userName"؟'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('إلغاء'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text('حذف', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     ) ?? false;
//
//     if (!confirmed) return;
//
//     setState(() => isLoading = true);
//
//     try {
//       await Supabase.instance.client
//           .from('users')
//           .delete()
//           .eq('id', userId);
//
//       // Optional: Uncomment if you want to delete auth user too
//       await Supabase.instance.client.auth.admin.deleteUser(userId);
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('تم حذف المستخدم بنجاح')),
//       );
//
//       fetchUsers();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('خطأ في الحذف: ${e.toString()}')),
//       );
//     } finally {
//       if (mounted) setState(() => isLoading = false);
//     }
//   }
//
//   Widget _buildUserCard(Map<String, dynamic> user) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     user['name'] ?? 'بدون اسم',
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.delete, color: Colors.red),
//                   onPressed: () => deleteUser(user['id'], user['name']),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(user['email'] ?? 'بدون بريد إلكتروني'),
//             const SizedBox(height: 4),
//             Chip(
//               label: Text(user['role'] ?? 'بدون دور'),
//               backgroundColor: Colors.blue[50],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('إدارة المستخدمين'),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.home),
//             onPressed: () => Navigator.pushReplacementNamed(context, '/adminHome'),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.add),
//         onPressed: () async {
//           await Navigator.pushNamed(context, "/adduser");
//           fetchUsers();
//         },
//         tooltip: 'إضافة مستخدم جديد',
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : users.isEmpty
//           ? Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Icons.people_outline, size: 64),
//             const SizedBox(height: 16),
//             const Text('لا يوجد مستخدمين مسجلين'),
//             TextButton(
//               onPressed: fetchUsers,
//               child: const Text('إعادة تحميل'),
//             ),
//           ],
//         ),
//       )
//           : RefreshIndicator(
//         onRefresh: fetchUsers,
//         child: ListView.builder(
//           controller: _scrollController,
//           padding: const EdgeInsets.only(bottom: 80),
//           itemCount: users.length,
//           itemBuilder: (context, index) => _buildUserCard(users[index]),
//         ),
//       ),
//     );
//   }
// }


import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GetAllUsersScreenMobile extends StatefulWidget {
  @override
  State<GetAllUsersScreenMobile> createState() => _GetAllUsersScreenMobileState();
}

class _GetAllUsersScreenMobileState extends State<GetAllUsersScreenMobile> {
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];
  bool isLoading = true;
  bool isSearching = false;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final _debouncer = _Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    fetchUsers();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchUsers() async {
    setState(() => isLoading = true);

    try {
      final response = await Supabase.instance.client
          .from('users')
          .select('*')
          .order('created_at', ascending: false);

      setState(() {
        users = List<Map<String, dynamic>>.from(response);
        filteredUsers = List.from(users);
      });

      if (response.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لا يوجد مستخدمين')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في جلب البيانات: ${e.toString()}')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _onSearchChanged() {
    _debouncer.run(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        filteredUsers = users.where((user) {
          final name = user['name']?.toString().toLowerCase() ?? '';
          final email = user['email']?.toString().toLowerCase() ?? '';
          final role = user['role']?.toString().toLowerCase() ?? '';
          return name.contains(query) ||
              email.contains(query) ||
              role.contains(query);
        }).toList();
      });
    });
  }

  Future<void> deleteUser(String userId, String userName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف المستخدم "$userName"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;

    if (!confirmed) return;

    setState(() => isLoading = true);

    try {
      await Supabase.instance.client
          .from('users')
          .delete()
          .eq('id', userId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حذف المستخدم بنجاح')),
      );

      await fetchUsers();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في الحذف: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showUserDetails(user),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        user['name'] ?? 'بدون اسم',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        // const PopupMenuItem(
                        //   value: 'edit',
                        //   child: Row(
                        //     children: [
                        //       Icon(Icons.edit, size: 20),
                        //       SizedBox(width: 8),
                        //       Text('تعديل'),
                        //     ],
                        //   ),
                        // ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red, size: 20),
                              SizedBox(width: 8),
                              Text('حذف', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'delete') {
                          deleteUser(user['id'], user['name']);
                        } else if (value == 'edit') {
                          _editUser(user);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.email, size: 16),
                    const SizedBox(width: 8),
                    Expanded(child: Text(user['email'] ?? 'بدون بريد إلكتروني')),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 16),
                    const SizedBox(width: 8),
                    Chip(
                      label: Text(user['role'] ?? 'بدون دور'),
                      backgroundColor: _getRoleColor(user['role']),
                      labelStyle: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
    }

  Color? _getRoleColor(String? role) {
    switch (role?.toLowerCase()) {
      case 'admin':
        return Colors.red[100];
      case 'manager':
        return Colors.blue[100];
      case 'user':
        return Colors.green[100];
      default:
        return Colors.grey[200];
    }
  }

  Future<void> _editUser(Map<String, dynamic> user) async {
    // Implement your edit user navigation
    await Navigator.pushNamed(
      context,
      "/edituser",
      arguments: user,
    );
    await fetchUsers();
  }

  void _showUserDetails(Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blue[100],
                  child: Text(
                    user['name']?.toString().substring(0, 1) ?? '?',
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow('الاسم', user['name'] ?? 'غير معروف'),
              _buildDetailRow('البريد الإلكتروني', user['email'] ?? 'غير معروف'),
              _buildDetailRow('الدور', user['role'] ?? 'غير معروف'),
              _buildDetailRow('تاريخ الإنشاء',
                  user['created_at'] != null
                      ? DateTime.parse(user['created_at']).toString()
                      : 'غير معروف'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _editUser(user);
                    },
                    child: const Text('تعديل'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                    ),
                    child: const Text('إغلاق'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Text(': '),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'ابحث عن مستخدم...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  isSearching = false;
                  _searchController.clear();
                  filteredUsers = List.from(users);
                });
              },
            ),
          ),
        )
            : const Text('إدارة المستخدمين'),
        centerTitle: true,
        actions: [
          if (!isSearching)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => setState(() => isSearching = true),
            ),
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.pushReplacementNamed(context, '/adminHome'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('مستخدم جديد'),
        onPressed: () async {
          await Navigator.pushNamed(context, "/adduser");
          fetchUsers();
        },
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredUsers.isEmpty
          ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.people_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isEmpty
                  ? 'لا يوجد مستخدمين مسجلين'
                  : 'لا توجد نتائج بحث',
            ),
            TextButton(
              onPressed: fetchUsers,
              child: const Text('إعادة تحميل'),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: fetchUsers,
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: filteredUsers.length,
          itemBuilder: (context, index) => _buildUserCard(filteredUsers[index]),
        ),
      ),
    );
  }
}

class _Debouncer {
  final int milliseconds;
  VoidCallback? _callback;
  Timer? _timer;

  _Debouncer({required this.milliseconds});

  void run(VoidCallback callback) {
    _callback = callback;
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), _execute);
  }

  void _execute() {
    if (_callback != null) {
      _callback!();
    }
  }

  void dispose() {
    _timer?.cancel();
  }
}