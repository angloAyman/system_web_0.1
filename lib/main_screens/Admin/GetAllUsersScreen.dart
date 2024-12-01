// // import 'package:flutter/material.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart';
// //
// // class GetAllUsersScreen extends StatefulWidget {
// //   @override
// //   State<GetAllUsersScreen> createState() => _GetAllUsersScreenState();
// // }
// //
// // class _GetAllUsersScreenState extends State<GetAllUsersScreen> {
// //   List<Map<String, dynamic>> users = [];
// //   bool isLoading = true;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchUsers();
// //   }
// //
// //   Future<void> fetchUsers() async {
// //     try {
// //       final SupabaseClient supabase = Supabase.instance.client;
// //       final response = await supabase.from('users').select('email,role');
// //
// //       if (response != null) {
// //         setState(() {
// //           users = List<Map<String, dynamic>>.from(response);
// //           isLoading = false;
// //         });
// //       }
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Error fetching users: $e')),
// //       );
// //       setState(() {
// //         isLoading = false;
// //       });
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('All Users'),
// //         centerTitle: true,
// //       ),
// //       body: isLoading
// //           ? const Center(child: CircularProgressIndicator())
// //           : users.isEmpty
// //           ? const Center(
// //         child: Text('No users found.'),
// //       )
// //           : SingleChildScrollView(
// //         scrollDirection: Axis.horizontal,
// //         child: DataTable(
// //           columns: users.isNotEmpty
// //               ? users.first.keys.map((key) {
// //             return DataColumn(
// //               label: Text(key.toUpperCase()),
// //             );
// //           }).toList()
// //               : [],
// //           rows: users
// //               .map(
// //                 (user) => DataRow(
// //               cells: user.values.map((value) {
// //                 return DataCell(
// //                   Text(value.toString()),
// //                 );
// //               }).toList(),
// //             ),
// //           )
// //               .toList(),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:system/main_screens/Admin/AddUserScreen.dart';
//
// class GetAllUsersScreen extends StatefulWidget {
//   @override
//   State<GetAllUsersScreen> createState() => _GetAllUsersScreenState();
// }
//
// class _GetAllUsersScreenState extends State<GetAllUsersScreen> {
//   List<Map<String, dynamic>> users = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchUsers();
//   }
//
//   Future<void> fetchUsers() async {
//     try {
//       final SupabaseClient supabase = Supabase.instance.client;
//       final response = await supabase.from('users').select('name,email,role,created_at');
//
//       if (response != null) {
//         setState(() {
//           users = List<Map<String, dynamic>>.from(response);
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error fetching users: $e')),
//       );
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   Future<void> navigateToAddUser() async {
//     final result = await Navigator.of(context).push(
//       MaterialPageRoute(builder: (context) => AddUserScreen()),
//     );
//
//     if (result == true) {
//       fetchUsers(); // Refresh the user list after adding a user
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('All Users'),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 ElevatedButton(
//                   onPressed: navigateToAddUser,
//                   child: const Text('Add User'),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : users.isEmpty
//                 ? const Center(child: Text('No users found.'))
//                 : SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: DataTable(
//                 columns: users.isNotEmpty
//                     ? users.first.keys.map((key) {
//                   return DataColumn(
//                     label: Text(key.toUpperCase()),
//                   );
//                 }).toList()
//                     : [],
//                 rows: users
//                     .map(
//                       (user) => DataRow(
//                     cells: user.values.map((value) {
//                       return DataCell(Text(value.toString()));
//                     }).toList(),
//                   ),
//                 )
//                     .toList(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/core/shared/app_routes.dart';

class GetAllUsersScreen extends StatefulWidget {
  @override
  State<GetAllUsersScreen> createState() => _GetAllUsersScreenState();
}

class _GetAllUsersScreenState extends State<GetAllUsersScreen> {
  List<Map<String, dynamic>> users = [];
  bool isLoading = true;
  // final supabase = SupabaseClient(
  //     'https://mianifmvhtxtqxxhhwpr.supabase.co',
  //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1pYW5pZm12aHR4dHF4eGhod3ByIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTczMjE4NjYxMCwiZXhwIjoyMDQ3NzYyNjEwfQ.eoHNowtHQOXw_hu3lI8glXPTOoMZ1NDUtMphGq3j3nY'
  // );

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await Supabase.instance.client
          .from('users')
          .select('*')
          ;

      if (response != null) {
        setState(() {
          users = List<Map<String, dynamic>>.from(response);
        });
      } else {
        throw Exception(response!);
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


    // Future<void> deleteUser(String userId) async {
    //   setState(() {
    //     isLoading = true;
    //   });
    //
    //   try {
    //     // Delete user from `users` table
    //     final response = await Supabase.instance.client
    //         .from('users')
    //         .delete()
    //         .eq('id', userId)
    //         ;
    //          fetchUsers();
    //     print("response:$response");
    //
    //     // Check if there was an error in the response
    //     if (response.error != null) {
    //       print("response.error:$response.error");
    //       throw Exception('Error deleting user from users table: ${response.error!.message}');
    //     }
    //
    //     // Optionally delete user from Auth
    //     final authResponse = await Supabase.instance.client.auth.admin.deleteUser(userId);
    //
    //
    //     // Show success message
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('User deleted successfully')),
    //     );
    //
    //     // Refresh the user list
    //     fetchUsers();
    //   } catch (e) {
    //     print("Error: $e");
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('Error deleting user: $e')),
    //     );
    //   } finally {
    //     setState(() {
    //       isLoading = false;
    //     });
    //   }
    // }



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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted successfully')),
      );


      // Refresh the user list
      fetchUsers();

      print("1: $response");

      if (response == null) {
        print("2 response == null: $response");

      } else {
        print("2: $response");

        throw Exception(response.error!.message);
      }
    } catch (e) {
      print("e:$e");

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
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // const Text(
                //   'قائمة المستخدمين',
                //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                // ),
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.of(context).pushNamed("/adduser").then((_) {
                      fetchUsers();
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
                  // DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Role')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: users
                    .map(
                      (user) => DataRow(cells: [
                    // DataCell(Text(user['id'] ?? '')),
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
                                  title: const Text('Confirm Delete'),
                                  content: Text(
                                    'Are you sure you want to delete user "${user['name']}"?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        await deleteUser(user['id']);
                                        fetchUsers();
                                      },
                                      child: const Text('Delete'),
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
                  ]),
                )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
