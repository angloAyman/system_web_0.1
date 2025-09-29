
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:system/features/attendance/Presentation/newattendancepage.dart';
import 'package:system/features/auth/data/auth_service.dart';

class LoginTablePage extends StatefulWidget {
  @override
  _LoginTablePageState createState() => _LoginTablePageState();
}

class _LoginTablePageState extends State<LoginTablePage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final _authService = AuthService(Supabase.instance.client);

  Map<String, List<Map<String, dynamic>>> groupedRecords = {};
  List<String> employeeNames = [];
  bool isLoading = true;
  String? selectedEmployee;
  final TextEditingController searchController = TextEditingController();
  StreamSubscription<List<Map<String, dynamic>>>? _loginsSubscription;

  @override
  void initState() {
    super.initState();
    _fetchLoginRecords();
    _loginsSubscription = supabase
        .from('logins')
        .stream(primaryKey: ['id'])
        .listen((event) {
      _fetchLoginRecords();
    });
  }


  @override
  void dispose() {
    _loginsSubscription?.cancel();
    searchController.dispose();
    super.dispose();
  }


  Future<void> _fetchLoginRecords() async {
    if (!mounted) return; // 👈 تفادي setState بعد التخلص

    setState(() => isLoading = true);

    try {
      final response = await supabase
          .from('logins')
          .select('id, login_time, logout_time, users(name),device')
          .order('login_time', ascending: false);

      if (!mounted) return; // 👈 مرة ثانية بعد await


      List<Map<String, dynamic>> records = List<Map<String, dynamic>>.from(response);
      Map<String, List<Map<String, dynamic>>> grouped = {};

      for (var record in records) {
        final loginDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(record['login_time']));
        grouped.putIfAbsent(loginDate, () => []).add(record);
      }

      // استخراج أسماء الموظفين مرة واحدة فقط
      List<String> names = records
          .map<String>((record) => record['users']?['name']?.toString() ?? 'غير معروف')
          .toSet()
          .toList();

      if (!mounted) return; // 👈 تحقق للمرة الأخيرة قبل setState
      setState(() {
        groupedRecords = grouped;
        employeeNames = names;
        isLoading = false;
      });
    } catch (error) {
      print("Error fetching login records: $error");
    }
  }

  String calculateWorkHours(String loginTime, String? logoutTime) {
    try {
      final login = DateTime.parse(loginTime).toUtc();
      if (logoutTime == null) return "قيد العمل";
      final logout = DateTime.parse(logoutTime).toUtc();
      final duration = logout.difference(login);
      return "${duration.inHours.toString().padLeft(2, '0')}:${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}";
    } catch (e) {
      print("Error in calculateWorkHours: $e");
      return "خطأ";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('حضور و انصراف'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AttendancePage2()),
              );
            },
            icon: Icon(Icons.home),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) return const Iterable<String>.empty();
                return employeeNames.where(
                      (name) => name.toLowerCase().contains(textEditingValue.text.toLowerCase()),
                );
              },
              onSelected: (String selection) {
                setState(() {
                  selectedEmployee = selection;
                });
              },
              fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                searchController.text = controller.text;
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  onEditingComplete: onEditingComplete,
                  decoration: InputDecoration(
                    labelText: "بحث عن موظف",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView(
              children: groupedRecords.entries.map((entry) {
                var filteredRecords = entry.value.where(
                      (record) => selectedEmployee == null || record['users']['name'] == selectedEmployee,
                ).toList();

                if (filteredRecords.isEmpty) return SizedBox.shrink();

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: ExpansionTile(
                    title: Text('التاريخ: ${entry.key}', style: TextStyle(fontWeight: FontWeight.bold)),
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text('اسم المستخدم')),
                            DataColumn(label: Text('تسجيل الدخول')),
                            DataColumn(label: Text('تسجيل الخروج')),
                            DataColumn(label: Text('عدد ساعات العمل')),
                            DataColumn(label: Text('تم التسجيل عبر')),

                          ],
                          rows: filteredRecords.map((record) {
                            final loginTime = record['login_time'];
                            final logoutTime = record['logout_time'];
                            return DataRow(cells: [
                              DataCell(Text(record['users']['name'] ?? 'غير معروف')),
                              DataCell(Text(DateFormat('hh:mm a').format(DateTime.parse(loginTime))

                              )),
                              DataCell(Text(
                                logoutTime != null
                                    ? DateFormat('hh:mm a').format(DateTime.parse(logoutTime))


                                    : 'لم يتم تسجيل الخروج',
                              )),
                              DataCell(Text(calculateWorkHours(loginTime, logoutTime))),
                              DataCell(Text(record['device'] ?? 'غير معروف')),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

