import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:system/features/attendance/Presentation/newattendancepage.dart';
import 'package:system/features/auth/data/auth_service.dart';
import 'package:system/main_screens/mobile_screens/mainScreen_mobileLayout.dart';

class LoginTablePageMobile extends StatefulWidget {
  @override
  _LoginTablePageMobileState createState() => _LoginTablePageMobileState();
}

class _LoginTablePageMobileState extends State<LoginTablePageMobile> {
  final SupabaseClient supabase = Supabase.instance.client;
  final _authService = AuthService(Supabase.instance.client);

  List<Map<String, dynamic>> _allRecords = [];
  Map<String, List<Map<String, dynamic>>> _groupedRecords = {};
  List<String> _employeeNames = [];
  bool _isLoading = true;
  String? _selectedEmployee;
  final TextEditingController _searchController = TextEditingController();
  StreamSubscription<List<Map<String, dynamic>>>? _loginsSubscription;
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _fetchLoginRecords();
    _loginsSubscription = supabase
        .from('logins')
        .stream(primaryKey: ['id']).listen((_) => _fetchLoginRecords());
  }

  @override
  void dispose() {
    _loginsSubscription?.cancel();
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchLoginRecords() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      final response = await supabase
          .from('logins')
          .select('id, login_time, logout_time, users(name),device')
          .order('login_time', ascending: false);

      if (!mounted) return;

      _allRecords = List<Map<String, dynamic>>.from(response);
      _groupRecords();
      _extractEmployeeNames();

      if (mounted) setState(() => _isLoading = false);
    } catch (error) {
      print("Error fetching login records: $error");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _groupRecords() {
    _groupedRecords = {};
    for (var record in _allRecords) {
      final loginTime = DateTime.parse(record['login_time']).toLocal();
      final loginDate = DateFormat('yyyy-MM-dd').format(loginTime);
      _groupedRecords.putIfAbsent(loginDate, () => []).add(record);
    }
  }

  void _extractEmployeeNames() {
    _employeeNames = _allRecords
        .map((record) => record['users']?['name']?.toString() ?? 'غير معروف')
        .toSet()
        .toList();
    _employeeNames.sort();
  }

  void _filterRecords(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      setState(() {
        _selectedEmployee = query.isEmpty
            ? null
            : _employeeNames.firstWhere(
                (name) => name.toLowerCase().contains(query.toLowerCase()),
                orElse: () => query);
      });
    });
  }

  String _calculateWorkHours(String loginTime, String? logoutTime) {
    try {
      final login = DateTime.parse(loginTime).toLocal();
      if (logoutTime == null) return "قيد العمل";

      final logout = DateTime.parse(logoutTime).toLocal();
      final duration = logout.difference(login);

      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);

      return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}";
    } catch (e) {
      return "خطأ";
    }
  }

  Widget _buildDateGroup(String date, List<Map<String, dynamic>> records) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Row(
          children: [
            const Icon(Icons.calendar_today, size: 18, color: Colors.blue),
            const SizedBox(width: 8),
            Text('$date', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        children: records.map((record) => _buildRecordCard(record)).toList(),
      ),
    );
  }

  Widget _buildRecordCard(Map<String, dynamic> record) {
    final name = record['users']?['name'] ?? 'غير معروف';
    final loginTime = DateTime.parse(record['login_time']).toLocal();
    final logoutTime = record['logout_time'] != null
        ? DateTime.parse(record['logout_time']).toLocal()
        : null;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        // color: logoutTime == null ? Colors.orange[50] : Colors.grey[50],
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.grey[200]!,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.grey[200]!,
        ),
      ),

      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(name.substring(0, 1),
              style: const TextStyle(color: Colors.blue)),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.login, size: 16, color: Colors.green),
                const SizedBox(width: 4),
                Text('${DateFormat('hh:mm a').format(loginTime)}'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.logout, size: 16, color: Colors.red),
                const SizedBox(width: 4),
                Text(logoutTime != null
                    ? DateFormat('hh:mm a').format(logoutTime)
                    : 'لم يتم تسجيل الخروج'),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.monitor_outlined, size: 16, color: Colors.blue),
                const SizedBox(width: 4),
                Text(record['device']),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('المدة', style: TextStyle(fontSize: 12)),
            Text(
              _calculateWorkHours(record['login_time'], record['logout_time']),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeFilter() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("فلترة الموظفين",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: "ابحث باسم الموظف",
              prefixIcon: const Icon(Icons.search),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _filterRecords('');
                      },
                    )
                  : null,
            ),
            onChanged: _filterRecords,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سجلات الحضور والانصراف'),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainscreenMobile()),
            ),
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildEmployeeFilter(),
          if (_isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_groupedRecords.isEmpty)
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('لا توجد سجلات حضور', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView(
                children: _groupedRecords.entries.map((entry) {
                  final filteredRecords = entry.value.where((record) {
                    final name =
                        record['users']?['name']?.toString() ?? 'غير معروف';
                    return _selectedEmployee == null ||
                        name == _selectedEmployee;
                  }).toList();

                  return filteredRecords.isNotEmpty
                      ? _buildDateGroup(entry.key, filteredRecords)
                      : const SizedBox.shrink();
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
