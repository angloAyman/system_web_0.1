import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

class BackupPage2 extends StatefulWidget {
  @override
  _BackupPage2State createState() => _BackupPage2State();
}

class _BackupPage2State extends State<BackupPage2> {
  final SupabaseClient supabase = Supabase.instance.client;
  bool isLoading = false;
  String backupMessage = '';
  List<Map<String, dynamic>>? backupData;
  List<Map<String, String>> backupHistory = [];

  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();
  final ValueNotifier<double> _progressNotifier = ValueNotifier<double>(0.0);

  // Table configuration
  static const List<String> _tableNames = [
    'categories',
    'sub_categories',
    'business_customers',
    'normal_customers',
    'vaults',
    'bills',
    'bill_items',
    'payment',
    'paymentsOut',
    'logins',
    'reports',
  ];

  // Define primary key types for each table
  final Map<String, String> _tableKeyTypes = {
    'categories': 'uuid',
    'sub_categories': 'uuid',
    'business_customers': 'uuid',
    'normal_customers': 'uuid',
    'vaults': 'uuid',
    'bills': 'integer',
    'bill_items': 'integer',
    'payment': 'uuid',
    'paymentsOut': 'integer',
    'logins': 'integer',
    'reports': 'uuid',
  };

  // Table selection state
  Map<String, bool> _tableSelection = {
    'categories': true,
    'sub_categories': true,
    'business_customers': true,
    'normal_customers': true,
    'vaults': true,
    'bills': true,
    'bill_items': true,
    'payment': true,
    'paymentsOut': true,
    'logins': true,
    'reports': true,
  };

  // Track which tables are available in a backup file
  Map<String, bool> _availableTablesInBackup = {};

  @override
  void initState() {
    super.initState();
    loadBackupHistory();
  }

  @override
  void dispose() {
    _progressNotifier.dispose();
    super.dispose();
  }

  /// Gets the backup directory (cross-platform)
  Future<Directory> getBackupDirectory() async {
    if (Platform.isWindows) {
      return Directory("${Platform.environment['USERPROFILE']}\\Desktop");
    } else if (Platform.isMacOS || Platform.isLinux) {
      return Directory("${Platform.environment['HOME']}/Desktop");
    } else {
      // For mobile, use documents directory
      return await getApplicationDocumentsDirectory();
    }
  }

  /// Loads the list of backups from the backup directory
  Future<void> loadBackupHistory() async {
    try {
      final directory = await getBackupDirectory();
      List<Map<String, String>> backups = [];

      if (await directory.exists()) {
        final files = directory.listSync();
        for (var file in files) {
          if (file is File && file.path.endsWith(".json")) {
            final stat = await file.stat();
            backups.add({
              "id": file.path.split(Platform.pathSeparator).last,
              "date": stat.modified.toString(),
              "file": file.path,
              "size": "${(stat.size / 1024).toStringAsFixed(2)} KB",
            });
          }
        }

        // Sort by date, newest first
        backups.sort((a, b) => b['date']!.compareTo(a['date']!));
      }

      setState(() {
        backupHistory = backups;
      });
    } catch (e) {
      setState(() {
        backupMessage = "خطأ في تحميل سجل النسخ الاحتياطية: ${e.toString()}";
      });
    }
  }

  /// Shows a confirmation dialog
  Future<bool> _showConfirmationDialog(String title, String content) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("إلغاء"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("متابعة", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;
  }

  /// Shows a dialog for table selection
  Future<void> _showTableSelectionDialog({bool forRestore = false, Map<String, dynamic>? backupData}) async {
    // If for restore, update available tables
    if (forRestore && backupData != null) {
      _availableTablesInBackup.clear();
      for (String table in _tableNames) {
        _availableTablesInBackup[table] = backupData.containsKey(table);
      }
    }

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(forRestore ? "اختر الجداول للاستعادة" : "اختر الجداول للنسخ الاحتياطي"),
            content: Container(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: _tableNames.map((table) {
                  final isAvailable = forRestore ? _availableTablesInBackup[table] ?? false : true;

                  return CheckboxListTile(
                    title: Text(
                      _getTableDisplayName(table),
                      style: TextStyle(
                        color: isAvailable ? null : Colors.grey,
                      ),
                    ),
                    value: forRestore
                        ? (_tableSelection[table] ?? false) && isAvailable
                        : _tableSelection[table] ?? false,
                    onChanged: isAvailable
                        ? (value) {
                      setState(() {
                        _tableSelection[table] = value ?? false;
                      });
                    }
                        : null,
                  );
                }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("إلغاء"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (forRestore) {
                    _restoreBackupWithSelectedTables(backupData!);
                  }
                },
                child: Text(forRestore ? "استعادة" : "احتفظ بالإعدادات"),
              ),
              if (!forRestore)
                TextButton(
                  onPressed: () {
                    // Select all tables
                    for (String table in _tableNames) {
                      _tableSelection[table] = true;
                    }
                    setState(() {});
                  },
                  child: Text("اختر الكل"),
                ),
            ],
          );
        },
      ),
    );
  }

  /// Get display name for table
  String _getTableDisplayName(String tableName) {
    final names = {
      'categories': 'الفئات',
      'sub_categories': 'الفئات الفرعية',
      'business_customers': 'العملاء التجاريين',
      'normal_customers': 'العملاء العاديين',
      'vaults': 'الخزائن',
      'bills': 'الفواتير',
      'bill_items': 'عناصر الفاتورة',
      'payment': 'المدفوعات',
      'paymentsOut': 'المدفوعات الصادرة',
      'logins': 'عمليات تسجيل الدخول',
      'reports': 'التقارير',
    };

    return names[tableName] ?? tableName;
  }

  /// Properly clear a table based on its primary key type
  Future<void> _clearTable(String tableName) async {
    final keyType = _tableKeyTypes[tableName];

    try {
      if (keyType == 'uuid') {
        // For UUID tables, use a valid UUID format
        await supabase.from(tableName).delete().neq('id', '00000000-0000-0000-0000-000000000000');
      } else if (keyType == 'integer') {
        // For integer tables, use a negative number
        await supabase.from(tableName).delete().neq('id', -1);
      } else {
        // Default approach for other types
        await supabase.from(tableName).delete().neq('id', 'invalid_id');
      }
    } catch (e) {
      print("Error clearing table $tableName: $e");
      // Fallback: try to delete all records without condition
      try {
        // This might not work due to PostgREST restrictions
        // but we try as a fallback
        await supabase.from(tableName).delete();
      } catch (e2) {
        print("Fallback deletion also failed for $tableName: $e2");
      }
    }
  }

  /// 🟢 **Backup Database with selected tables**
  Future<void> backupDatabase() async {
    if (!await _showConfirmationDialog(
      "إنشاء نسخة احتياطية",
      "هل تريد إنشاء نسخة احتياطية جديدة؟",
    )) return;

    // Show table selection dialog
    await _showTableSelectionDialog(forRestore: false);

    // Check if any table is selected
    if (!_tableSelection.values.any((isSelected) => isSelected)) {
      setState(() {
        backupMessage = "لم يتم اختيار أي جدول للنسخ الاحتياطي";
      });
      return;
    }

    setState(() {
      isLoading = true;
      backupMessage = "جاري إنشاء نسخة احتياطية...";
      _progressNotifier.value = 0.0;
    });

    try {
      // Fetch only selected tables
      Map<String, dynamic> backupData = {};
      final selectedTables = _tableNames.where((table) => _tableSelection[table] ?? false).toList();

      for (int i = 0; i < selectedTables.length; i++) {
        final tableName = selectedTables[i];
        try {
          final data = await supabase.from(tableName).select();
          backupData[tableName] = data;

          // Update progress
          _progressNotifier.value = (i + 1) / selectedTables.length;
          await Future.delayed(Duration(milliseconds: 100));
        } catch (e) {
          print("Error fetching table $tableName: $e");
        }
      }

      // Add metadata
      final jsonData = jsonEncode({
        "backup_date": DateTime.now().toIso8601String(),
        "version": "1.1", // Version bump to indicate table selection support
        "tables": backupData,
        "included_tables": selectedTables,
      });

      final directory = await getBackupDirectory();

      // Create directory if it doesn't exist
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      // Format the date for a valid filename
      String formattedDate = DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
      final filePath = "${directory.path}${Platform.pathSeparator}database_backup_$formattedDate.json";

      File backupFile = File(filePath);
      await backupFile.writeAsString(jsonData);

      setState(() {
        isLoading = false;
        backupMessage = "تم حفظ النسخة الاحتياطية بنجاح: ${backupFile.path}";
      });

      // Refresh backup history
      await loadBackupHistory();

      // Share the file
      if (await backupFile.exists()) {
        await Share.shareXFiles([XFile(filePath)], text: "نسخة احتياطية من البيانات");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        backupMessage = "خطأ في إنشاء النسخة الاحتياطية: ${e.toString()}";
      });
    } finally {
      _progressNotifier.value = 0.0;
    }
  }

  /// 🟡 **Restore Database from Backup with selected tables**
  Future<void> _restoreBackupWithSelectedTables(Map<String, dynamic> data) async {
    setState(() {
      isLoading = true;
      backupMessage = "جاري استعادة البيانات...";
      _progressNotifier.value = 0.0;
    });

    try {
      final tables = data['tables'] as Map<String, dynamic>;
      final selectedTables = _tableNames.where((table) =>
      (_tableSelection[table] ?? false) && tables.containsKey(table)).toList();

      final totalTables = selectedTables.length;
      int processedTables = 0;

      // Clear selected tables first (in reverse order to respect foreign keys)
      for (String tableName in selectedTables.reversed) {
        try {
          // Use proper clearing method for each table
          await _clearTable(tableName);
          processedTables++;
          _progressNotifier.value = processedTables / (totalTables * 2);
        } catch (e) {
          print("Error clearing table $tableName: $e");
        }
      }

      // Insert backup data (in correct order)
      for (String tableName in selectedTables) {
        if (tables.containsKey(tableName)) {
          try {
            final tableData = tables[tableName] as List<dynamic>;
            if (tableData.isNotEmpty) {
              // Use upsert instead of insert to handle duplicate keys
              await supabase.from(tableName).upsert(tableData);
            }
            processedTables++;
            _progressNotifier.value = processedTables / (totalTables * 2);
          } catch (e) {
            print("Error inserting into $tableName: $e");
          }
        }
      }

      setState(() {
        backupMessage = "✅ تم استرجاع الجداول المحددة بنجاح!";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("تم الاسترجاع بنجاح"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        backupMessage = "❌ خطأ في الاسترجاع: ${e.toString()}";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
      _progressNotifier.value = 0.0;
    }
  }

  /// Restore backup from file with table selection
  Future<void> restoreBackupFromFile(String filePath) async {
    if (!await _showConfirmationDialog(
      "استعادة النسخة الاحتياطية",
      "سيتم استبدال البيانات الحالية بالبيانات من النسخة الاحتياطية. هل أنت متأكد؟",
    )) return;

    try {
      File backupFile = File(filePath);
      if (!await backupFile.exists()) {
        setState(() {
          backupMessage = "خطأ: الملف غير موجود";
        });
        return;
      }

      String content = await backupFile.readAsString();
      Map<String, dynamic> data = jsonDecode(content);

      // Check if backup format is valid
      if (data['tables'] == null) {
        setState(() {
          backupMessage = "خطأ: تنسيق النسخة الاحتياطية غير صالح";
        });
        return;
      }

      // Show table selection dialog for restore
      await _showTableSelectionDialog(forRestore: true, backupData: data['tables']);

      // Check if any table is selected
      if (!_tableSelection.values.any((isSelected) => isSelected)) {
        setState(() {
          backupMessage = "لم يتم اختيار أي جدول للاستعادة";
        });
        return;
      }

      // Proceed with restore
      await _restoreBackupWithSelectedTables(data);
    } catch (e) {
      setState(() {
        backupMessage = "❌ خطأ في قراءة ملف النسخة الاحتياطية: ${e.toString()}";
      });
    }
  }

  /// 🔴 **Reset Database** (Deletes all data)
  Future<void> resetDatabase() async {
    if (!await _showConfirmationDialog(
      "تأكيد الضبط المصنعي",
      "سيتم حذف جميع البيانات بشكل دائم. هل أنت متأكد؟",
    )) return;

    setState(() {
      isLoading = true;
      backupMessage = "جاري تهيئة البيانات..";
      _progressNotifier.value = 0.0;
    });

    try {
      // Delete in reverse order to respect foreign key constraints
      final totalTables = _tableNames.length;

      for (int i = 0; i < _tableNames.length; i++) {
        final tableName = _tableNames.reversed.toList()[i];
        try {
          // Use proper clearing method for each table
          await _clearTable(tableName);
          _progressNotifier.value = (i + 1) / totalTables;
        } catch (e) {
          print("Error resetting table $tableName: $e");
        }
      }

      setState(() {
        isLoading = false;
        backupMessage = "✅ تم حذف البيانات بنجاح!";
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("تمت إعادة الضبط المصنعي بنجاح"),
            backgroundColor: Colors.green,
          )
      );
    } catch (e) {
      final errorMsg = e is PostgrestException ? e.message : e.toString();
      setState(() {
        isLoading = false;
        backupMessage = "❌ خطأ: $errorMsg";
      });
    } finally {
      _progressNotifier.value = 0.0;
    }
  }

  /// 🔴 **delete BackupFile ** (Deletes from storage)
  Future<void> deleteBackupFile(String filePath) async {
    if (!await _showConfirmationDialog(
      "تأكيد الحذف",
      "هل أنت متأكد أنك تريد حذف هذا الملف النسخة الاحتياطية؟",
    )) return;

    try {
      File backupFile = File(filePath);
      if (await backupFile.exists()) {
        await backupFile.delete();
        setState(() {
          backupMessage = "تم الحذف بنجاح!";
        });
        await loadBackupHistory();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("تم حذف النسخة الاحتياطية"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        backupMessage = "خطأ في الحذف: ${e.toString()}";
      });
    }
  }

  /// Import backup from file
  Future<void> importBackup() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        String filePath = result.files.single.path!;
        await restoreBackupFromFile(filePath);
      }
    } catch (e) {
      setState(() {
        backupMessage = "خطأ في استيراد النسخة الاحتياطية: ${e.toString()}";
      });
    }
  }

  Widget buildProgressIndicator() {
    return ValueListenableBuilder<double>(
      valueListenable: _progressNotifier,
      builder: (context, value, child) {
        return LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        );
      },
    );
  }

  Widget buildBackupTable() {
    if (backupHistory.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "لا توجد نسخ احتياطية",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Scrollbar(
          controller: _horizontalController,
          thumbVisibility: true,
          trackVisibility: true,
          child: SingleChildScrollView(
            controller: _horizontalController,
            scrollDirection: Axis.horizontal,
            child: Scrollbar(
              controller: _verticalController,
              thumbVisibility: true,
              trackVisibility: true,
              child: SingleChildScrollView(
                controller: _verticalController,
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columnSpacing: 20,
                  headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[300]!),
                  dataRowHeight: 50,
                  columns: [
                    DataColumn(label: Text('م', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('التاريخ', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('الحجم', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('اسم الملف', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('المهام', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: List<DataRow>.generate(
                    backupHistory.length,
                        (index) {
                      final backup = backupHistory[index];
                      String formattedDate = DateFormat('dd/MM/yy HH:mm').format(DateTime.parse(backup['date']!));

                      return DataRow(cells: [
                        DataCell(Text((index + 1).toString(), style: TextStyle(fontWeight: FontWeight.w600))),
                        DataCell(Text(formattedDate)),
                        DataCell(Text(backup['size'] ?? 'N/A')),
                        DataCell(
                          Tooltip(
                            message: backup['file']!,
                            child: Text(
                              backup['id']!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.restore, color: Colors.green),
                                tooltip: "استعادة",
                                onPressed: () => restoreBackupFromFile(backup['file']!),
                              ),
                              SizedBox(width: 5),
                              IconButton(
                                icon: Icon(Icons.share, color: Colors.blue),
                                tooltip: "مشاركة",
                                onPressed: () async {
                                  try {
                                    await Share.shareXFiles([XFile(backup['file']!)], text: "نسخة احتياطية من البيانات".tr());
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("خطأ في المشاركة: ${e.toString()}")),
                                    );
                                  }
                                },
                              ),
                              SizedBox(width: 5),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                tooltip: "حذف",
                                onPressed: () => deleteBackupFile(backup['file']!),
                              ),
                            ],
                          ),
                        ),
                      ]);
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("النسخ الاحتياطي لقاعدة البيانات واستعادتها"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: "تحديث",
            onPressed: loadBackupHistory,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) buildProgressIndicator(),
            SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                // 🟢 Backup Button
                ElevatedButton.icon(
                  onPressed: isLoading ? null : backupDatabase,
                  icon: Icon(Icons.backup),
                  label: Text("إنشاء نسخة احتياطية"),
                ),
                // 🔵 Import Button
                ElevatedButton.icon(
                  onPressed: isLoading ? null : importBackup,
                  icon: Icon(Icons.upload),
                  label: Text("استيراد نسخة"),
                ),
                // 🔴 Reset Button
                ElevatedButton.icon(
                  onPressed: isLoading ? null : resetDatabase,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  icon: Icon(Icons.restart_alt, color: Colors.white),
                  label: Text("استعادة الضبط المصنعي", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Backup Message
            SelectableText(
              backupMessage,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Info card
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "يتم حفظ النسخ الاحتياطية في مجلد سطح المكتب",
                        style: TextStyle(color: Colors.blue[800]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),

            // 🟣 Display Backup Table
            Expanded(
              child: backupHistory.isEmpty && !isLoading
                  ? Center(child: Text("لا توجد نسخ احتياطية"))
                  : buildBackupTable(),
            ),
          ],
        ),
      ),
    );
  }
}