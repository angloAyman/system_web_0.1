import 'package:flutter/material.dart';
import 'package:system/features/report/data/model/report_model.dart';
import 'package:system/features/report/data/repository/report_repository.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final ReportRepository _reportRepository = ReportRepository();
  late Future<List<Report>> _reportFuture;
  List<Report> _allReports = []; // جميع التقارير بدون تصفية
  List<Report> _filteredReports = []; // التقارير بعد التصفية
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  int _selectedSearchOption = 0; // 0 for title, 1 for user_name

  @override
  void initState() {
    super.initState();
    _loadReports();
    _searchController.addListener(_filterReports);
  }

  // Future<void> _loadReports() async {
  //   try {
  //     final reports = await _reportRepository.getReports();
  //     setState(() {
  //       _allReports = reports;
  //       _filteredReports = reports;
  //     });
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('خطأ في تحميل التقارير: $e')),
  //     );
  //   }
  // }
  Future<void> _loadReports() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final reports = await _reportRepository.getReports();
      setState(() {
        _allReports = reports;
        _filteredReports = reports;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في تحميل التقارير: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  Future<String?> _getUserIdByName(String name) async {
    try {
      final response = await _reportRepository.getUserIdByName(name);
      return response;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user id for $name: $e')),
      );
      return null;
    }
  }
  // void _filterReports() {
  //   final query = _searchController.text.toLowerCase();
  //   setState(() {
  //     _filteredReports = _allReports.where((report) {
  //       return report.title.toLowerCase().contains(query) ||
  //           report.user_name.toLowerCase().contains(query);
  //     }).toList();
  //   });
  // }

  // void _filterReports() {
  //   final query = _searchController.text.toLowerCase();
  //   setState(() {
  //     if (_selectedSearchOption == 0) {
  //       // Search by title
  //       _filteredReports = _allReports.where((report) {
  //         return report.title.toLowerCase().contains(query);
  //       }).toList();
  //     } else {
  //       // Search by user_name
  //       _filteredReports = _allReports.where((report) {
  //         // Get user_id from user_name
  //         final username =  _reportRepository.getUserIdByName(query) as String;
  //         return username != null && report.user_name.toLowerCase() == username.toLowerCase();
  //         // return report.user_name.toLowerCase().contains(query);
  //       }).toList();
  //     }
  //   });
  // }
  void _filterReports() async {
    final query = _searchController.text.toLowerCase();
    String? userId = await _getUserIdByName(query); // Get the user id by name

    setState(() {
      if (userId != null && userId.isNotEmpty) {
        _filteredReports = _allReports.where((report) {
          return report.user_name == userId; // Match user_id in the report
        }).toList();
      } else {
        // If no user id found, show all reports
        _filteredReports = _allReports;
      }
    });
  }

  Future<void> _deleteReport(String reportId) async {
    try {
      await _reportRepository.deleteReport(reportId); // فرضية وجود دالة الحذف
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حذف التقرير بنجاح')),
      );
      _loadReports();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في حذف التقرير: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' التقارير البرنامج'),
        actions: [
          TextButton.icon(onPressed: (){
            Navigator.pushReplacementNamed(context, '/adminHome'); // توجيه المستخدم إلى صفحة تسجيل الدخول
          }, label: Icon(Icons.home)),
        ],
      ),
      body: Column(
        children: [
          // ToggleButtons for search options (title, user_name)
          ToggleButtons(
            isSelected: [0 == _selectedSearchOption, 1 == _selectedSearchOption],
            onPressed: (int index) {
              setState(() {
                _selectedSearchOption = index;
              });
              _filterReports(); // Reapply filter when search mode changes
            },
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('العملية'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('اسم المستخدم'),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Search TextField
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'بحث',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0)),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical, // السماح بالتمرير العمودي
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // السماح بالتمرير الأفقي
                child: DataTable(
                  columnSpacing: 15,
                  showBottomBorder: true,
                  border: TableBorder.all(width:1 ),
                  columns: const [
                    DataColumn(label: Text('رقم العملية',textAlign: TextAlign.center,), headingRowAlignment: MainAxisAlignment.center,),
                    DataColumn(label: Text('العملية'),headingRowAlignment: MainAxisAlignment.center),
                    DataColumn(label: Text('اسم المستخدم'),headingRowAlignment: MainAxisAlignment.center),
                    DataColumn(label: Text('التاريخ'),headingRowAlignment: MainAxisAlignment.center),
                    DataColumn(label: Text('الوصف'),headingRowAlignment: MainAxisAlignment.center),
                    DataColumn(label: Text('الإجراءات'),headingRowAlignment: MainAxisAlignment.center), // عمود للإجراءات
                  ],
                  rows: _filteredReports.map((report) {
                    return DataRow(cells: [
                      DataCell(Text('${report.operationNumber}')),
                      // عرض رقم العملية
                      DataCell(Text(report.title)),
                      DataCell(
                        FutureBuilder<String?>(
                          future: _reportRepository.getUserNameById(
                              report.user_name), // Fetch username by userId
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text('جارِ التحميل...');
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData) {
                              return const Text('لا يوجد اسم مستخدم');
                            } else {
                              return Text(snapshot.data ?? 'اسم غير متاح');
                            }
                          },
                        ),
                      ),
                      DataCell(Text(
                        '${report.date.day}/${report.date.month}/${report.date.year} ${report.date.hour}:${report.date.minute}',
                      )),
                      DataCell(Text(report.description)),
                      DataCell(
                        Row(
                          children: [
                            // زر تعديل
                            // IconButton(
                            //   icon: const Icon(Icons.edit, color: Colors.blue),
                            //   onPressed: () {
                            //     // تنفيذ عملية التعديل (فتح نافذة تعديل مثلاً)
                            //   },
                            // ),
                            // زر حذف
                            // IconButton(
                            //   icon: const Icon(Icons.delete, color: Colors.red),
                            //   onPressed: () {
                            //     showDialog(
                            //       context: context,
                            //       builder: (context) {
                            //         return AlertDialog(
                            //           title: const Text('تأكيد الحذف'),
                            //           content: Text(
                            //               'هل تريد حذف التقرير "${report.title}"؟'),
                            //           actions: [
                            //             TextButton(
                            //               onPressed: () {
                            //                 Navigator.of(context).pop();
                            //               },
                            //               child: const Text('إلغاء'),
                            //             ),
                            //             ElevatedButton(
                            //               onPressed: () async {
                            //                 Navigator.of(context).pop();
                            //                 await _deleteReport(
                            //                     report.id as String);
                            //               },
                            //               child: const Text('حذف'),
                            //             ),
                            //           ],
                            //         );
                            //       },
                            //     );
                            //   },
                            // ),
                          ],
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
