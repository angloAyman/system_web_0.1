
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/attendance/Presentation/pdf/generatePDF.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendancePage2 extends StatefulWidget {
  @override
  _AttendancePage2State createState() => _AttendancePage2State();
}

class _AttendancePage2State extends State<AttendancePage2> {
  final SupabaseClient _client = Supabase.instance.client;

  List<Map<String, dynamic>> users = [];
  Map<String, dynamic>? selectedUser;
  DateTime focusedDay = DateTime.now().toLocal();
  Set<DateTime> attendanceDays = {};
  int totalWorkHours = 0;
  int totalWorkMinutes = 0;
  bool isCalendarView = true;

  // Search variables
  DateTime? startDate;
  DateTime? endDate;
  List<Map<String, dynamic>> attendanceLogs = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }


  Future<void> _fetchUsers() async {
    if (!mounted) return;
    setState(() => isLoading = true);
    try {
      final response = await _client.from('users').select('*');
      if (response != null && mounted) {
        setState(() => users = List<Map<String, dynamic>>.from(response));
      }
    } catch (e) {
      if (mounted) _showErrorSnackbar('Error fetching users: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }



  // Future<void> _fetchAttendanceData(String userId) async {
  //   setState(() => isLoading = true);
  //   try {
  //     final response = await _client
  //         .from('logins')
  //         .select('login_time, logout_time')
  //         .eq('user_id', userId);
  //
  //     if (response != null) {
  //       Set<DateTime> days = {};
  //       int hours = 0;
  //       int minutes = 0;
  //       final now = DateTime.now();
  //
  //       for (var entry in response) {
  //         DateTime loginTime = DateTime.parse(entry['login_time']);
  //         DateTime dateKey = DateTime(loginTime.year, loginTime.month, loginTime.day);
  //
  //         if (loginTime.year == now.year && loginTime.month == now.month) {
  //           days.add(dateKey);
  //
  //           if (entry['logout_time'] != null) {
  //             DateTime logoutTime = DateTime.parse(entry['logout_time']);
  //             final duration = logoutTime.difference(loginTime);
  //             hours += duration.inHours;
  //             minutes += duration.inMinutes % 60;
  //           }
  //         }
  //       }
  //
  //       setState(() {
  //         attendanceDays = days;
  //         totalWorkHours = hours + (minutes ~/ 60);
  //         totalWorkMinutes = minutes % 60;
  //       });
  //     }
  //   } catch (e) {
  //     _showErrorSnackbar('Error fetching attendance: $e');
  //   } finally {
  //     setState(() => isLoading = false);
  //   }
  // }
  Future<void> _fetchAttendanceData(String userId) async {
    setState(() => isLoading = true);

    try {
      final response = await _client
          .from('logins')
          .select('login_time, logout_time')
          .eq('user_id', userId);

      if (response != null) {
        final Map<DateTime, List<Map<String, dynamic>>> groupedByDay = {};
        final now = DateTime.now();

        for (final entry in response) {
          final loginStr = entry['login_time'];
          final logoutStr = entry['logout_time'];
          if (loginStr == null || logoutStr == null) continue;

          final loginTime = DateTime.parse(loginStr);
          final logoutTime = DateTime.parse(logoutStr);

          // نأخذ فقط أيام الشهر الحالي
          if (loginTime.year == now.year && loginTime.month == now.month) {
            final dateKey = DateTime(loginTime.year, loginTime.month, loginTime.day);
            groupedByDay.putIfAbsent(dateKey, () => []).add({
              'login': loginTime,
              'logout': logoutTime,
            });
          }
        }

        int totalMinutes = 0;
        final Set<DateTime> uniqueDays = {};

        groupedByDay.forEach((day, sessions) {
          final firstLogin = sessions.map((e) => e['login'] as DateTime).reduce((a, b) => a.isBefore(b) ? a : b);
          final lastLogout = sessions.map((e) => e['logout'] as DateTime).reduce((a, b) => a.isAfter(b) ? a : b);
          final duration = lastLogout.difference(firstLogin);
          totalMinutes += duration.inMinutes;
          uniqueDays.add(day);
        });

        setState(() {
          attendanceDays = uniqueDays;
          totalWorkHours = totalMinutes ~/ 60;
          totalWorkMinutes = totalMinutes % 60;
        });
      }
    } catch (e) {
      _showErrorSnackbar('حدث خطأ أثناء جلب بيانات الحضور: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchAttendanceLogs(String userId) async {
    if (startDate == null || endDate == null) return;

    setState(() => isLoading = true);
    try {
      final response = await _client
          .from('logins')
          .select('login_time, logout_time')
          .eq('user_id', userId)
          .gte('login_time', startDate!.toIso8601String())
          .lte('login_time', endDate!.toIso8601String())
          .order('login_time', ascending: true);

      if (response != null) {
        final Map<String, Map<String, dynamic>> groupedLogs = {};

        for (var entry in response) {
          final loginTime = DateTime.parse(entry['login_time']);
          final dateKey = "${loginTime.year}-${loginTime.month}-${loginTime.day}";

          if (!groupedLogs.containsKey(dateKey)) {
            groupedLogs[dateKey] = {
              'date': dateKey,
              'first_login': entry['login_time'],
              'last_logout': entry['logout_time'],
              'time_difference': '0:00:00',
            };
          } else {
            final currentLogout = entry['logout_time'];
            if (currentLogout != null) {
              groupedLogs[dateKey]!['last_logout'] = currentLogout;
            }
          }
        }

        // Calculate time differences
        for (var entry in groupedLogs.values) {
          if (entry['first_login'] != null && entry['last_logout'] != null) {
            final login = DateTime.parse(entry['first_login']);
            final logout = DateTime.parse(entry['last_logout']);
            final difference = logout.difference(login);

            entry['time_difference'] =
            "${difference.inHours.toString().padLeft(2, '0')}:"
                "${(difference.inMinutes % 60).toString().padLeft(2, '0')}:"
                "${(difference.inSeconds % 60).toString().padLeft(2, '0')}";
          }
        }

        setState(() => attendanceLogs = groupedLogs.values.toList());
      }
    } catch (e) {
      _showErrorSnackbar('Error fetching logs: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message),)
        );
    }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });

      if (selectedUser != null) {
        await _fetchAttendanceLogs(selectedUser!['id']);
      }
    }
  }

  int _getAttendanceCountForMonth() {
    final now = DateTime.now();
    return attendanceDays
        .where((date) => date.year == now.year && date.month == now.month)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('نظام الحضور والانصراف'),
        actions: [
          if (!isCalendarView && attendanceLogs.isNotEmpty)
            IconButton(
              icon: Icon(Icons.picture_as_pdf),
              onPressed: () => generatePDF(attendanceLogs),
              tooltip: 'تصدير إلى PDF',
            ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Row(
        children: [
          // Users List
          _buildUserList(),

          // Main Content
          Expanded(
            flex: 3,
            child: Column(
              children: [
                _buildViewToggle(),
                Expanded(child: isCalendarView ? _buildCalendarView() : _buildSearchView()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    return Expanded(
      child: Card(
        margin: EdgeInsets.all(8),
        elevation: 4,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "المستخدمين",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  final isSelected = selectedUser?['id'] == user['id'];

                  return InkWell(
                      onTap: () {
                    setState(() => selectedUser = user);
                    _fetchAttendanceData(user['id']);
                  },
                  child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                  color: isSelected ? Colors.blue[50] : Colors.black12,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey[300]!,
                  width: isSelected ? 2 : 1,
                  ),
                  ),
                  child: ListTile(
                  leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(user['name'][0].toUpperCase(),),
                  ),
                  title: Text(user['name']),
                  subtitle: Text(user['role']),
                  trailing: isSelected ? Icon(Icons.check_circle, color: Colors.green) : null,
                  ),
                  ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ToggleButtons(
        isSelected: [isCalendarView, !isCalendarView],
        onPressed: (index) {
          setState(() => isCalendarView = index == 0);
        },
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Icon(Icons.calendar_today),
                SizedBox(width: 8),
                Text('التقويم'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Icon(Icons.search),
                SizedBox(width: 8),
                Text('البحث'),
              ],
            ),
          ),
        ],
        borderRadius: BorderRadius.circular(8),
        selectedColor: Colors.white,
        fillColor: Colors.blue,
        color: Colors.blue,
        constraints: BoxConstraints(minHeight: 40, minWidth: 100),
      ),
    );
  }

  Widget _buildCalendarView() {
    return Column(
      children: [
        Expanded(
          child: Card(
            margin: EdgeInsets.all(12),
            child: TableCalendar(
              focusedDay: focusedDay,
              firstDay: DateTime(2020),
              lastDay: DateTime(2030),
              calendarFormat: CalendarFormat.month,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.blue[200],
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              selectedDayPredicate: (day) => attendanceDays.contains(
                DateTime(day.year, day.month, day.day),
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() => this.focusedDay = focusedDay);
              },
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, date, _) {
                  final isPresent = attendanceDays.contains(
                    DateTime(date.year, date.month, date.day),
                  );

                  return Container(
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isPresent ? Colors.green[300] : null,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                          color: isPresent ? Colors.white : null,
                          fontWeight: isPresent ? FontWeight.bold : null,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        _buildStatsRow(),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatCard('أيام الحضور', '${_getAttendanceCountForMonth()} يوم'),
          _buildStatCard(
            'إجمالي ساعات العمل',
            '$totalWorkHours ساعة $totalWorkMinutes دقيقة',
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text(value,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDatePickerButton(true),
              SizedBox(width: 20),
              _buildDatePickerButton(false),
            ],
          ),
        ),
        Expanded(
          child: attendanceLogs.isEmpty
              ? Center(child: Text('لا توجد بيانات للعرض'))
              : _buildAttendanceTable(),
        ),
      ],
    );
  }

  Widget _buildDatePickerButton(bool isStartDate) {
    final date = isStartDate ? startDate : endDate;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(isStartDate ? 'تاريخ البداية' : 'تاريخ النهاية'),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => _selectDate(context, isStartDate),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: Text(
            date != null
                ? "${date.day}/${date.month}/${date.year}"
                : isStartDate ? 'اختر تاريخ البداية' : 'اختر تاريخ النهاية',
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceTable() {
    return Card(
      margin: EdgeInsets.all(8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('التاريخ')),
            DataColumn(label: Text('أول تسجيل دخول')),
            DataColumn(label: Text('آخر تسجيل خروج')),
            DataColumn(label: Text('مدة العمل')),
          ],
          rows: attendanceLogs.map((log) {
            return DataRow(cells: [
              DataCell(Text(log['date'])),
              DataCell(Text(_formatTime(log['first_login']))),
              DataCell(Text(log['last_logout'] != null
                  ? _formatTime(log['last_logout'])
                  : '--')),
              DataCell(Text(log['time_difference'])),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  String _formatTime(String? isoTime) {
    if (isoTime == null) return '--';
    final timePart = isoTime.split('T')[1];
    return timePart.substring(0, 8); // Returns HH:MM:SS
  }
}