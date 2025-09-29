
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:share_plus/share_plus.dart';

class BackupPage extends StatefulWidget {
  @override
  _BackupPageState createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  bool isLoading = false;
  String backupMessage = '';
  List<Map<String, dynamic>>? backupData;
  List<Map<String, String>> backupHistory = [];

  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadBackupHistory();
  }

  /// Loads the list of backups from local storage
  Future<void> loadBackupHistory() async {
    final directory =
        Directory("${Platform.environment['USERPROFILE']}\\Desktop");
    List<Map<String, String>> backups = [];

    if (directory.existsSync()) {
      List<FileSystemEntity> files = directory.listSync();
      for (var file in files) {
        if (file is File && file.path.endsWith(".json")) {
          backups.add({
            "id": file.path.split("\\").last,
            "date": File(file.path).lastModifiedSync().toString(),
            "file": file.path,
          });
        }
      }
    }

    setState(() {
      backupHistory = backups;
    });
  }

  /// 🟢 **Backup Database**
  Future<void> backupDatabase() async {
    setState(() {
      isLoading = true;
      backupMessage = "إنشاء نسخة احتياطية...";
    });

    try {
      // Fetch all tables
      // final attendance = await supabase.from('attendance').select();
      final bill_items = await supabase.from('bill_items').select();
      final bills = await supabase.from('bills').select();
      final business_customers = await supabase.from('business_customers').select();
      final categories = await supabase.from('categories').select();
      final logins = await supabase.from('logins').select();
      final normal_customers = await supabase.from('normal_customers').select();
      final payment = await supabase.from('payment').select();
      final paymentsOut = await supabase.from('paymentsOut').select();
      final reports = await supabase.from('reports').select();
      final sub_categories = await supabase.from('sub_categories').select();
      // final users = await supabase.from('users').select();
      final vaults = await supabase.from('vaults').select();

      // Convert to JSON
      Map<String, dynamic> backupData = {
        // "attendance": attendance,
        "bill_items": bill_items,
        "bills": bills,
        "business_customers": business_customers,
        "categories": categories,
        "logins": logins,
        "normal_customers": normal_customers,
        "payment": payment,
        "paymentsOut": paymentsOut,
        "reports": reports,
        "sub_categories": sub_categories,
        // "users": users,
        "vaults": vaults,
      };

      final directory =
          Directory("${Platform.environment['USERPROFILE']}\\Desktop");

      // Format the date for a valid filename
      String formattedDate = DateTime.now()
          .toIso8601String()
          .replaceAll(":", "-")
          .replaceAll(".", "-"); // Replace invalid characters

      final filePath = "${directory.path}\\database_backup_$formattedDate.json";

      File backupFile = File(filePath);
      await backupFile.writeAsString(jsonEncode(backupData));
      print(backupFile);
      setState(() {
        isLoading = false;
        backupMessage = "تم حفظ  نسخة احتياطية: $filePath";
      });

      // Refresh backup history
      loadBackupHistory();

      // Share the file
      Share.shareXFiles([XFile(filePath)], text: " نسخة احتياطية من البيانات");
    } catch (e) {
      setState(() {
        isLoading = false;
        backupMessage = "خطأ: ${e.toString()}";
        print(backupMessage);
      });
    }
  }

  /// 🟡 **Restore Database from Backup**
  // Future<void> restoreBackupFromFile(String filePath) async {
  //   try {
  //     File backupFile = File(filePath);
  //     if (!backupFile.existsSync()) {
  //       setState(() {
  //         backupMessage = "خطأ: لا يوم ملفات";
  //       });
  //       return;
  //     }
  //
  //     String content = await backupFile.readAsString();
  //     Map<String, dynamic> data = jsonDecode(content);
  //
  //     // Insert data into tables
  //     // await supabase.from('attendance').insert(data['attendance']);
  //     await supabase.from('bill_items').insert(data['bill_items']);
  //     await supabase.from('bills').insert(data['bills']);
  //     await supabase
  //         .from('business_customers')
  //         .insert(data['business_customers']);
  //     await supabase.from('categories').insert(data['categories']);
  //     await supabase.from('logins').insert(data['logins']);
  //     await supabase.from('normal_customers').insert(data['normal_customers']);
  //     await supabase.from('payment').insert(data['payment']);
  //     await supabase.from('paymentsOut').insert(data['paymentsOut']);
  //     await supabase.from('reports').insert(data['reports']);
  //     await supabase.from('sub_categories').insert(data['sub_categories']);
  //     // await supabase.from('users').insert(data['users']);
  //     await supabase.from('vaults').insert(data['vaults']);
  //
  //     setState(() {
  //       backupMessage = "Database restored successfully from backup!";
  //     });
  //   } catch (e) {
  //     setState(() {
  //       backupMessage = "خطا في الاسترجاع: ${e.toString()}";
  //       print(e);
  //     });
  //   }
  // }
  Future<void> restoreBackupFromFile(String filePath) async {
    try {
      File backupFile = File(filePath);
      if (!backupFile.existsSync()) {
        setState(() {
          backupMessage = "خطأ: لا يوجد ملفات";
        });
        return;
      }

      String content = await backupFile.readAsString();
      Map<String, dynamic> data = jsonDecode(content);

      // ⚠️ Insert tables in correct order to satisfy foreign key constraints
      // Example order based on your schema dependencies

      await supabase.from('categories').insert(data['categories']);
      await supabase.from('sub_categories').insert(data['sub_categories']);
      await supabase.from('business_customers').insert(data['business_customers']);
      await supabase.from('normal_customers').insert(data['normal_customers']);
      await supabase.from('vaults').insert(data['vaults']);
      await supabase.from('bills').insert(data['bills']); // parent table
      await supabase.from('bill_items').insert(data['bill_items']); // child table
      await supabase.from('payment').insert(data['payment']);
      await supabase.from('paymentsOut').insert(data['paymentsOut']);
      await supabase.from('logins').insert(data['logins']);
      await supabase.from('reports').insert(data['reports']);
      // await supabase.from('users').insert(data['users']); // if needed

      setState(() {
        backupMessage = "✅ تم استرجاع قاعدة البيانات بنجاح من النسخة الاحتياطية!";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تم الاسترجاع بنجاح"),
          backgroundColor: Colors.green,
        ),
      );

    } catch (e) {
      setState(() {
        backupMessage = "❌ خطأ في الاسترجاع: ${e.toString()}";
        print(e);
      });
    }
  }

  /// 🔴 **Reset Database** (Deletes all data)
  // Future<void> resetDatabase() async {
  //   setState(() {
  //     isLoading = true;
  //     backupMessage = "جاري تهيئة البيانات..";
  //   });
  //
  //   try {
  //     // await supabase.from('attendance').delete();
  //     await supabase.from('bill_items').delete();
  //     await supabase.from('bills').delete();
  //     await supabase.from('business_customers').delete();
  //     await supabase.from('categories').delete();
  //     await supabase.from('logins').delete();
  //
  //         await supabase.from('logins').delete().neq('id', 0);
  //
  //     // await supabase.from('logins').delete().neq('login_time', '1970-01-01T00:00:00Z'); // Use timestamp if needed
  //
  //     await supabase.from('normal_customers').delete();
  //     await supabase.from('payment').delete();
  //     await supabase.from('paymentsOut').delete();
  //     await supabase.from('reports').delete();
  //     await supabase.from('sub_categories').delete();
  //     // await supabase.from('users').delete();
  //     await supabase.from('vaults').delete();
  //
  //     setState(() {
  //       isLoading = false;
  //       backupMessage = "✅ تم حذف البيانات بنجاح!";
  //     });
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //       backupMessage = "❌ خطا : ${e.toString()}";
  //       print(e);
  //     });
  //   }
  // }

  Future<void> resetDatabase() async {
    // Add confirmation dialog
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("تأكيد الضبط المصنعي"),
        content: const Text("سيتم حذف جميع البيانات بشكل دائم. هل أنت متأكد؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("متابعة", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (!confirm) return;

    setState(() {
      isLoading = true;
      backupMessage = "جاري تهيئة البيانات..";
    });

    try {
      const dummyUuid = '00000000-0000-0000-0000-000000000000';
      const dummyDate = '1970-01-01T00:00:00Z';
      const dummyInt = -1;

      // Delete using appropriate filters per table
      // await supabase.from('attendance').delete().neq('id', dummyUuid);
      await supabase.from('bill_items').delete().neq('id', dummyInt);
      await supabase.from('bills').delete().neq('id', dummyInt);
      await supabase.from('business_customers').delete().neq('id', dummyUuid);
      await supabase.from('categories').delete().neq('id', dummyUuid);
      await supabase.from('logins').delete().neq('login_time', dummyDate); // Use timestamp if needed
      await supabase.from('normal_customers').delete().neq('id', dummyUuid);
      await supabase.from('payment').delete().neq('id', dummyUuid);
      await supabase.from('paymentsOut').delete().neq('id', dummyInt);
      await supabase.from('reports').delete().neq('id', dummyUuid);
      await supabase.from('sub_categories').delete().neq('id', dummyUuid);
      await supabase.from('vaults').delete().neq('id', dummyUuid);

      setState(() {
        isLoading = false;
        backupMessage = "✅ تم حذف البيانات بنجاح!";
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("تمت إعادة الضبط المصنعي بنجاح"),
            backgroundColor: Colors.green,
          )
      );
    } catch (e) {
      final errorMsg = e is PostgrestException ? e.message : e.toString();
      setState(() {
        isLoading = false;
        backupMessage = "❌ خطا: $errorMsg";
        print(e);
      });
    }
  }
  /// 🔴 **delete BackupFile ** (Deletes from pc)
  Future<void> deleteBackupFile(String filePath) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("تاكيد الحذف"),
        content: Text("هل أنت متأكد أنك تريد حذف هذا الملف النسخة الاحتياطية ؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("الغاء"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("حذف", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmDelete) {
      try {
        File backupFile = File(filePath);
        if (backupFile.existsSync()) {
          await backupFile.delete();
          setState(() {
            backupMessage = "تم الحذف بنجاح!";
          });
          loadBackupHistory();
        }
      } catch (e) {
        setState(() {
          backupMessage = "خطا بالحذف: ${e.toString()}";
        });
      }
    }
  }



  Widget buildBackupTable() {
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
                  dataRowHeight: 50, // تحديد ارتفاع الصفوف
                  columns: const [
                    DataColumn(label: Text('م', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('تاريخ', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('مسار الملف', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('المهام', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: List<DataRow>.generate(
                    backupHistory.length,
                        (index) {
                      final backup = backupHistory[index];
                      String formattedDate = DateFormat('dd/MM/yy').format(DateTime.parse(backup['date']!));

                      return DataRow(cells: [
                        DataCell(Text((index + 1).toString(), style: TextStyle(fontWeight: FontWeight.w600))),
                        DataCell(Text(formattedDate)),
                        DataCell(Text(backup['file']!, overflow: TextOverflow.ellipsis)),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.restore, color: Colors.green),
                                onPressed: () => restoreBackupFromFile(backup['file']!),
                              ),
                              SizedBox(width: 5),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
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
      appBar: AppBar(title: Text("النسخ الاحتياطي لقاعدة البيانات واستعادتها")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) CircularProgressIndicator(),
            SizedBox(height: 20),
            Row(
              children: [
                // 🟢 Backup Button
                ElevatedButton(
                  onPressed: isLoading ? null : backupDatabase,
                  child: Text("إنشاء نسخة احتياطية"),
                ),
                SizedBox(width: 10),
                // 🔴 Reset Button
                ElevatedButton(
                  onPressed: isLoading ? null : resetDatabase,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text("اساعدة الضبط لوضع المصنع",
                      style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 10),


              ],
            ),
            SizedBox(height: 20),

            // Backup Message
            Text(backupMessage,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),

            // 🟣 Display Backup Table
            Expanded(child: buildBackupTable()),
          ],
        ),
      ),
    );
  }
}


// 🟡 Restore Backup Button
// ElevatedButton(
//   onPressed: isLoading ? null : restoreBackup,
//   style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//   child: Text("Restore Backup", style: TextStyle(color: Colors.white)),
// ),