import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/attendance/Presentation/pdf/generatePDF.dart';
import 'package:system/main_screens/mobile_screens/Drawer/widget/AttendancePage2Mobile/generatePdfAttendance.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class AttendancePage2Mobile extends StatefulWidget {
  @override
  _AttendancePage2MobileState createState() => _AttendancePage2MobileState();
}

class _AttendancePage2MobileState extends State<AttendancePage2Mobile> {
  final SupabaseClient _client = Supabase.instance.client;
  final _scrollController = ScrollController();

  List<Map<String, dynamic>> users = [];
  Map<String, dynamic>? selectedUser;
  String? selectedemployeeName;
  DateTime focusedDay = DateTime.now().toLocal();
  Set<DateTime> attendanceDays = {};
  int totalWorkHours = 0;
  int totalWorkMinutes = 0;
  bool isCalendarView = true;
  bool isLoading = false;

  // Search variables
  DateTime? startDate;
  DateTime? endDate;
  List<Map<String, dynamic>> attendanceLogs = [];

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
      if (mounted) _showErrorSnackbar('خطأ في جلب المستخدمين: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

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

          final loginTime = DateTime.parse(loginStr).toLocal();
          final logoutTime = DateTime.parse(logoutStr).toLocal();

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
          .gte('login_time', startDate!.toUtc().toIso8601String())
          .lte('login_time', endDate!.toUtc().toIso8601String())
          .order('login_time', ascending: true);

      if (response != null) {
        final Map<String, Map<String, dynamic>> groupedLogs = {};

        for (var entry in response) {
          final loginTime = DateTime.parse(entry['login_time']).toLocal();
          final dateKey = DateFormat('yyyy-MM-dd').format(loginTime);

          if (!groupedLogs.containsKey(dateKey)) {
            groupedLogs[dateKey] = {
              'date': dateKey,
              'first_login': loginTime,
              'last_logout': entry['logout_time'] != null
                  ? DateTime.parse(entry['logout_time']).toLocal()
                  : null,
              'sessions': [],
            };
          }

          groupedLogs[dateKey]!['sessions'].add({
            'login': loginTime,
            'logout': entry['logout_time'] != null
                ? DateTime.parse(entry['logout_time']).toLocal()
                : null,
          });
        }

        // Calculate total time per day
        for (var entry in groupedLogs.values) {
          DateTime? firstLogin;
          DateTime? lastLogout;
          Duration totalDuration = Duration.zero;

          for (var session in entry['sessions']) {
            final login = session['login'];
            final logout = session['logout'];

            if (login != null) {
              if (firstLogin == null || login.isBefore(firstLogin)) {
                firstLogin = login;
              }
            }

            if (logout != null) {
              if (lastLogout == null || logout.isAfter(lastLogout)) {
                lastLogout = logout;
              }
            }

            if (login != null && logout != null) {
              totalDuration += logout.difference(login);
            }
          }

          entry['first_login'] = firstLogin;
          entry['last_logout'] = lastLogout;

          final hours = totalDuration.inHours;
          final minutes = totalDuration.inMinutes.remainder(60);
          entry['time_difference'] = "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}";
        }

        setState(() => attendanceLogs = groupedLogs.values.toList());
      }
    } catch (e) {
      _showErrorSnackbar('خطأ في جلب السجلات: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        )
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
        title: const Text('نظام الحضور والانصراف'),
        actions: [
          if (!isCalendarView && attendanceLogs.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              onPressed: () => generatePDFMobile(attendanceLogs,startDate,endDate,selectedemployeeName!),
              tooltip: 'تصدير إلى PDF',
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // User Selector
              _buildUserSelector(),

              // View Toggle
              _buildViewToggle(),

              // Main Content
              isCalendarView
                  ? _buildCalendarView()
                  : SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: _buildSearchView(),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildUserSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(12),
      child: Row(
        children: [
          const Icon(Icons.person, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButton<Map<String, dynamic>>(
              value: selectedUser,
              isExpanded: true,
              underline: Container(),
              hint: const Text('اختر موظف'),
              items: users.map((user) {
                return DropdownMenuItem(
                  value: user,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue[100],
                        radius: 16,
                        child: Text(
                          user['name'][0].toUpperCase(),
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(user['name']),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (user) {
                if (user != null) {
                  setState(() {
                    selectedUser = user;
                    selectedemployeeName = user['name'];
                  });
                  _fetchAttendanceData(user['id']);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: TextButton(
              onPressed: () => setState(() => isCalendarView = true),
              style: TextButton.styleFrom(
                backgroundColor: isCalendarView
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                'التقويم',
                style: TextStyle(
                  color: isCalendarView ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: TextButton(
              onPressed: () => setState(() => isCalendarView = false),
              style: TextButton.styleFrom(
                backgroundColor: !isCalendarView
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                'البحث',
                style: TextStyle(
                  color: !isCalendarView ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarView() {
    return Column(
      children: [
        // Calendar
        Card(
          margin: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TableCalendar(
              locale: 'ar',
              focusedDay: focusedDay,
              firstDay: DateTime(2020),
              lastDay: DateTime(2030),
              calendarFormat: CalendarFormat.month,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: const TextStyle(fontSize: 16),
                leftChevronIcon: const Icon(Icons.chevron_left),
                rightChevronIcon: const Icon(Icons.chevron_right),
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.blue[200],
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: const TextStyle(fontSize: 14),
                weekendTextStyle: const TextStyle(color: Colors.red),
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
                    margin: const EdgeInsets.all(4),
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

        // Stats Cards
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _buildStatCard(
                title: 'أيام الحضور',
                value: '${_getAttendanceCountForMonth()} يوم',
                icon: Icons.calendar_today,
                color: Colors.blue,
              ),
              const SizedBox(height: 8),
              _buildStatCard(
                title: 'إجمالي ساعات العمل',
                value: '$totalWorkHours ساعة $totalWorkMinutes دقيقة',
                icon: Icons.access_time,
                color: Colors.green,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({required String title, required String value, required IconData icon, required Color color}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchView() {
    return Column(
      children: [
        // Date Selectors
        Card(
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDateSelector(
                  title: 'تاريخ البداية',
                  date: startDate,
                  onTap: () => _selectDate(context, true),
                ),
                const SizedBox(height: 16),
                _buildDateSelector(
                  title: 'تاريخ النهاية',
                  date: endDate,
                  onTap: () => _selectDate(context, false),
                ),
              ],
            ),
          ),
        ),

        // Results
        Expanded(
          child: attendanceLogs.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 16),
                const Text('لا توجد سجلات للعرض', style: TextStyle(fontSize: 16)),
              ],
            ),
          )
              : _buildAttendanceList(),
        ),
      ],
    );
  }

  Widget _buildDateSelector({required String title, DateTime? date, required VoidCallback onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 12),
                Text(
                  date != null
                      ? DateFormat('yyyy-MM-dd').format(date)
                      : 'انقر لاختيار التاريخ',
                  style: TextStyle(
                    color: date != null ? Colors.black : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: attendanceLogs.length,
      itemBuilder: (context, index) {
        final log = attendanceLogs[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ExpansionTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.history, size: 20),
            ),
            title: Text(log['date']),
            subtitle: Text('المدة: ${log['time_difference']}'),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (log['first_login'] != null)
                      _buildTimeRow(
                        icon: Icons.login,
                        label: 'أول تسجيل دخول',
                        time: DateFormat('hh:mm a').format(log['first_login']),
                      ),

                    if (log['last_logout'] != null)
                      _buildTimeRow(
                        icon: Icons.logout,
                        label: 'آخر تسجيل خروج',
                        time: DateFormat('hh:mm a').format(log['last_logout']),
                      ),

                    const SizedBox(height: 12),
                    if (log['sessions'] != null && log['sessions'].isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'جلسات العمل:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ...log['sessions'].map<Widget>((session) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'دخول: ${DateFormat('hh:mm a').format(session['login'])}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      session['logout'] != null
                                          ? 'خروج: ${DateFormat('hh:mm a').format(session['logout'])}'
                                          : 'لم يتم تسجيل الخروج',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: session['logout'] != null
                                            ? null
                                            : Colors.orange,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimeRow({required IconData icon, required String label, required String time}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(time),
        ],
      ),
    );
  }
}