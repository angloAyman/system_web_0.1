// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// class LoginTablePage extends StatefulWidget {
//   @override
//   _LoginTablePageState createState() => _LoginTablePageState();
// }
//
// class _LoginTablePageState extends State<LoginTablePage> {
//   final SupabaseClient supabase = Supabase.instance.client;
//   List<Map<String, dynamic>> loginRecords = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchLoginRecords();
//   }
//
//   // Fetch the login records and user information
//   Future<void> _fetchLoginRecords() async {
//     final response = await supabase.from('logins').select();
//
//     if (response == null) {
//       print("Error fetching login records: ${response}");
//       return;
//     }
//
//     List<Map<String, dynamic>> records = List<Map<String, dynamic>>.from(response);
//
//     // For each login record, fetch the username using the user_id
//     for (var record in records) {
//       final userResponse = await supabase
//           .from('users') // Assuming 'users' is the table that stores user data
//           .select('name')
//           .eq('id', record['user_id'])
//           .single();
//
//       if (userResponse != null) {
//         record['name'] = userResponse['name']; // Add the username to the record
//       } else {
//         record['name'] = 'Unknown'; // In case the username is not found
//       }
//     }
//
//     setState(() {
//       loginRecords = records;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login Records'),
//       ),
//       body: loginRecords.isEmpty
//           ? Center(child: CircularProgressIndicator()) // Show a loading spinner if no data
//           : SingleChildScrollView(
//         child: Center(
//           child: DataTable(
//             columns: const [
//               // DataColumn(label: Text('User ID')),
//               DataColumn(label: Text('اسم المستخدم')),
//               DataColumn(label: Text('تسجيبل الدخول')),
//               DataColumn(label: Text('تسجيل الخروج')),
//             ],
//             rows: loginRecords.map((record) {
//               final loginTime = DateTime.parse(record['login_time']);
//               final logoutTime = record['logout_time'] != null
//                   ? DateTime.parse(record['logout_time'])
//                   : null;
//
//               return DataRow(cells: [
//                 // DataCell(Text(record['user_id'].toString())),
//                 DataCell(Text(record['name'] ?? 'N/A')),
//                 DataCell(Text(loginTime.toLocal().toString())),
//                 DataCell(Text(logoutTime?.toLocal().toString() ?? 'Not Logged Out')),
//               ]);
//             }).toList(),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:system/Adminfeatures/auth/data/auth_service.dart'; // Import intl package

class LoginTablePage extends StatefulWidget {
  @override
  _LoginTablePageState createState() => _LoginTablePageState();
}

class _LoginTablePageState extends State<LoginTablePage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> loginRecords = [];
  // final _authService = AuthService(authService: AuthService(Supabase.instance.client),); // Assuming you have an _authService to record logout time
  final _authService = AuthService(Supabase.instance.client);
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this); // Add observer to listen to lifecycle changes
    _fetchLoginRecords();
  }

  // Fetch the login records and user information
  Future<void> _fetchLoginRecords() async {
    final response = await supabase.from('logins').select();

    if (response == null) {
      print("Error fetching login records: ${response}");
      return;
    }

    List<Map<String, dynamic>> records = List<Map<String, dynamic>>.from(response);

    // For each login record, fetch the username using the user_id
    for (var record in records) {
      final userResponse = await supabase
          .from('users') // Assuming 'users' is the table that stores user data
          .select('name')
          .eq('id', record['user_id'])
          .single();

      if (userResponse != null) {
        record['name'] = userResponse['name']; // Add the username to the record
      } else {
        record['name'] = 'Unknown'; // In case the username is not found
      }
    }

    setState(() {
      loginRecords = records;
    });
  }



  // Called when the app's lifecycle state changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      // Record logout time when the app is paused or about to be closed
      _recordLogoutTime();
    }
  }

  // Record the logout time for the user
  Future<void> _recordLogoutTime() async {
    // Assuming you have access to user ID
    final userId = "id"; // Replace this with the actual user ID
    await _authService.recordLogoutTime(userId); // Record the logout time
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('حضور و اصراف'),
      ),
      body: loginRecords.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show a loading spinner if no data
          : SingleChildScrollView(
        child: Center(
          child: DataTable(
            columns: const [
              // DataColumn(label: Text('User ID')),
              DataColumn(label: Text('اسم المستخدم')),
              DataColumn(label: Text('تسجيبل الدخول')),
              DataColumn(label: Text('تسجيل الخروج')),
            ],
            rows: loginRecords.map((record) {
              final loginTime = DateTime.parse(record['login_time']);
              final logoutTime = record['logout_time'] != null
                  ? DateTime.parse(record['logout_time'])
                  : null;

              // Format the date and time
              String formattedLoginDate = DateFormat('dd:MM:yy').format(loginTime);
              String formattedLoginTime = DateFormat('HH:mm:ss').format(loginTime);

              String formattedLogoutDate = logoutTime != null
                  ? DateFormat('dd:MM:yy').format(logoutTime)
                  : 'Not Logged Out';
              String formattedLogoutTime = logoutTime != null
                  ? DateFormat('HH:mm:ss').format(logoutTime)
                  : 'Not Logged Out';

              return DataRow(cells: [
                // DataCell(Text(record['user_id'].toString())),
                DataCell(Text(record['name'] ?? 'N/A')),
                DataCell(Text('$formattedLoginDate\n$formattedLoginTime')), // Display Date and Time for login
                DataCell(Text('$formattedLogoutDate\n$formattedLogoutTime')), // Display Date and Time for logout
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
