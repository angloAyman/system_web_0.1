// // // import 'package:flutter/material.dart';
// // // import 'package:system/features/Vaults/Presentation/dialog/add_vault_dialog.dart';
// // // import 'package:system/features/Vaults/data/models/vault_model.dart';
// // // import 'package:system/features/Vaults/data/repositories/supabase_vault_repository.dart';
// // //
// // // class VaultsPage extends StatefulWidget {
// // //   final String userRole; // إضافة الدور لتحديد الصلاحيات
// // //   const VaultsPage({Key? key, required this.userRole}) : super(key: key);
// // //
// // //   @override
// // //   _VaultsPageState createState() => _VaultsPageState();
// // // }
// // //
// // // class _VaultsPageState extends State<VaultsPage> {
// // //   final SupabaseVaultRepository _vaultRepository = SupabaseVaultRepository();
// // //   late Future<List<Vault>> _vaultsFuture;
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _vaultsFuture = _vaultRepository.getVaults();
// // //   }
// // //
// // //   void _refreshVaults() {
// // //     setState(() {
// // //       _vaultsFuture = _vaultRepository.getVaults();
// // //     });
// // //   }
// // //
// // //   // عرض Dialog يحتوي على جدول الفواتير المرتبطة بالخزنة
// // //   void _showBillsForVaultDialog(String vaultId) async {
// // //     final bills = await _vaultRepository.getBillsForVault(vaultId);
// // //     showDialog(
// // //       context: context,
// // //       builder: (BuildContext context) {
// // //         return AlertDialog(
// // //           title: const Text('الفواتير المرتبطة بالخزنة'),
// // //           content: SizedBox(
// // //             width: double.maxFinite,
// // //             child: SingleChildScrollView(
// // //               child: DataTable(
// // //                 columns: const [
// // //                   DataColumn(label: Text('رقم الفاتورة')),
// // //                   DataColumn(label: Text('اسم العميل')),
// // //                   DataColumn(label: Text('تاريخ الفاتورة')),
// // //                   DataColumn(label: Text('حالة الفاتورة')),
// // //                   DataColumn(label: Text('التفاصيل')),
// // //                 ],
// // //                 rows: bills.map((bill) {
// // //                   return DataRow(cells: [
// // //                     DataCell(Text(bill['id']?.toString() ?? 'غير متوفر')),
// // //                     DataCell(Text(bill['customer_name'] ?? '')),
// // //                     DataCell(Text(bill['date'] ?? '')),
// // //                     DataCell(Text(bill['status'] ?? '')),
// // //                     DataCell(Text('تم دفع: ${bill['payment']?.toString() ?? '0.00'}')), // تأكد من تحويل payment إلى String
// // //                   ]);
// // //                 }).toList(),
// // //               ),
// // //             ),
// // //           ),
// // //           actions: [
// // //             TextButton(
// // //               onPressed: () {
// // //                 Navigator.of(context).pop();
// // //               },
// // //               child: const Text('إغلاق'),
// // //             ),
// // //           ],
// // //         );
// // //       },
// // //     );
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text('الخزائن'),
// // //       ),
// // //       body: FutureBuilder<List<Vault>>(
// // //         future: _vaultsFuture,
// // //         builder: (context, snapshot) {
// // //           if (snapshot.connectionState == ConnectionState.waiting) {
// // //             return const Center(child: CircularProgressIndicator());
// // //           } else if (snapshot.hasError) {
// // //             return Center(child: Text('خطأ: ${snapshot.error}'));
// // //           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
// // //             return const Center(child: Text('لا توجد خزائن حالياً.'));
// // //           }
// // //
// // //           final vaults = snapshot.data!;
// // //           return ListView.builder(
// // //             itemCount: vaults.length,
// // //             itemBuilder: (context, index) {
// // //               final vault = vaults[index];
// // //               return Card(
// // //                 elevation: 4,
// // //                 margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
// // //                 child: Padding(
// // //                   padding: const EdgeInsets.all(12.0),
// // //                   child: Column(
// // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                     children: [
// // //                       Text(
// // //                         vault.name,
// // //                         style: const TextStyle(
// // //                           fontSize: 18,
// // //                           fontWeight: FontWeight.bold,
// // //                         ),
// // //                       ),
// // //                       const SizedBox(height: 8),
// // //                       Text('الرصيد: ${vault.balance}'),
// // //                       const SizedBox(height: 8),
// // //                       Row(
// // //                         mainAxisAlignment: MainAxisAlignment.end,
// // //                         children: [
// // //                           if (widget.userRole == 'admin') // السماح بالحذف فقط للمدير
// // //                             IconButton(
// // //                               icon: const Icon(Icons.delete, color: Colors.red),
// // //                               onPressed: () async {
// // //                                 try {
// // //                                   await _vaultRepository.deleteVault(vault.id);
// // //                                   _refreshVaults();
// // //                                 } catch (e) {
// // //                                   ScaffoldMessenger.of(context).showSnackBar(
// // //                                     SnackBar(content: Text('خطأ عند حذف الخزنة: $e')),
// // //                                   );
// // //                                 }
// // //                               },
// // //                             ),
// // //                           IconButton(
// // //                             icon: const Icon(Icons.history, color: Colors.blue),
// // //                             onPressed: () {
// // //                               _showBillsForVaultDialog(vault.id);
// // //                             },
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //               );
// // //             },
// // //           );
// // //         },
// // //       ),
// // //       floatingActionButton: FloatingActionButton(
// // //         onPressed: () {
// // //           showAddVaultDialog(context, _refreshVaults);
// // //         },
// // //         child: const Icon(Icons.add),
// // //       ),
// // //     );
// // //   }
// // // }
// //
// // import 'package:flutter/material.dart';
// // import 'package:system/features/Vaults/Presentation/dialog/add_vault_dialog.dart';
// // import 'package:system/features/Vaults/data/models/vault_model.dart';
// // import 'package:system/features/Vaults/data/repositories/supabase_vault_repository.dart';
// //
// // class VaultsPage extends StatefulWidget {
// //   final String userRole; // إضافة الدور لتحديد الصلاحيات
// //   const VaultsPage({Key? key, required this.userRole}) : super(key: key);
// //
// //   @override
// //   _VaultsPageState createState() => _VaultsPageState();
// // }
// //
// // class _VaultsPageState extends State<VaultsPage> {
// //   final SupabaseVaultRepository _vaultRepository = SupabaseVaultRepository();
// //   late Future<List<Vault>> _vaultsFuture;
// //   final TextEditingController _searchController = TextEditingController();
// //   String _selectedFilter = 'id'; // Default filter option
// //   List<Map<String, dynamic>> _filteredBills = []; // Filtered bills list
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _vaultsFuture = _vaultRepository.getVaults();
// //   }
// //
// //   void _refreshVaults() {
// //     setState(() {
// //       _vaultsFuture = _vaultRepository.getVaults();
// //     });
// //   }
// //
// //   // Update the search filter based on the selected filter and the input
// //   void _filterBills(String query) {
// //     setState(() {
// //       _filteredBills = _filteredBills.where((bill) {
// //         switch (_selectedFilter) {
// //           case 'id':
// //             return bill['id']?.toString().contains(query) ?? false;
// //           case 'customer_name':
// //             return bill['customer_name']?.contains(query) ?? false;
// //           case 'date':
// //             return bill['date']?.contains(query) ?? false;
// //           case 'state':
// //             return bill['state']?.contains(query) ?? false;
// //           default:
// //             return false;
// //         }
// //       }).toList();
// //     });
// //   }
// //
// //   // عرض Dialog يحتوي على جدول الفواتير المرتبطة بالخزنة
// //   void _showBillsForVaultDialog(String vaultId) async {
// //     final bills = await _vaultRepository.getBillsForVault(vaultId);
// //     setState(() {
// //       _filteredBills = bills;
// //     });
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: const Text('الفواتير المرتبطة بالخزنة'),
// //           content: Column(
// //             children: [
// //               // Search Bar
// //               TextField(
// //                 controller: _searchController,
// //                 decoration: const InputDecoration(
// //                   labelText: 'ابحث...',
// //                   border: OutlineInputBorder(),
// //                 ),
// //                 onChanged: _filterBills,
// //               ),
// //               const SizedBox(height: 10),
// //               // ToggleButtons for selecting the filter criteria
// //               ToggleButtons(
// //                 isSelected: [
// //                   _selectedFilter == 'id',
// //                   _selectedFilter == 'customer_name',
// //                   _selectedFilter == 'date',
// //                   _selectedFilter == 'state',
// //                 ],
// //                 onPressed: (index) {
// //                   setState(() {
// //                     switch (index) {
// //                       case 0:
// //                         _selectedFilter = 'id';
// //                         break;
// //                       case 1:
// //                         _selectedFilter = 'customer_name';
// //                         break;
// //                       case 2:
// //                         _selectedFilter = 'date';
// //                         break;
// //                       case 3:
// //                         _selectedFilter = 'state';
// //                         break;
// //                     }
// //                   });
// //                   _filterBills(_searchController.text); // Re-filter after changing selection
// //                 },
// //                 children: const [
// //                   Padding(
// //                     padding: EdgeInsets.symmetric(horizontal: 8.0),
// //                     child: Text('رقم الفاتورة'),
// //                   ),
// //                   Padding(
// //                     padding: EdgeInsets.symmetric(horizontal: 8.0),
// //                     child: Text('اسم العميل'),
// //                   ),
// //                   Padding(
// //                     padding: EdgeInsets.symmetric(horizontal: 8.0),
// //                     child: Text('تاريخ الفاتورة'),
// //                   ),
// //                   Padding(
// //                     padding: EdgeInsets.symmetric(horizontal: 8.0),
// //                     child: Text('حالة الفاتورة'),
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 10),
// //               // DataTable for showing the filtered bills
// //               Expanded(
// //                 child: SingleChildScrollView(
// //                   child: DataTable(
// //                     columns: const [
// //                       DataColumn(label: Text('رقم الفاتورة')),
// //                       DataColumn(label: Text('اسم العميل')),
// //                       DataColumn(label: Text('تاريخ الفاتورة')),
// //                       DataColumn(label: Text('حالة الفاتورة')),
// //                       DataColumn(label: Text('التفاصيل')),
// //                     ],
// //                     rows: _filteredBills.map((bill) {
// //                       return DataRow(cells: [
// //                         DataCell(Text(bill['id']?.toString() ?? 'غير متوفر')),
// //                         DataCell(Text(bill['customer_name'] ?? '')),
// //                         DataCell(Text(bill['date'] ?? '')),
// //                         DataCell(Text(bill['status'] ?? '')),
// //                         DataCell(Text('تم دفع: ${bill['payment']?.toString() ?? '0.00'}')), // تأكد من تحويل payment إلى String
// //                       ]);
// //                     }).toList(),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () {
// //                 Navigator.of(context).pop();
// //               },
// //               child: const Text('إغلاق'),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('الخزائن'),
// //       ),
// //       body: FutureBuilder<List<Vault>>(
// //         future: _vaultsFuture,
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return const Center(child: CircularProgressIndicator());
// //           } else if (snapshot.hasError) {
// //             return Center(child: Text('خطأ: ${snapshot.error}'));
// //           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
// //             return const Center(child: Text('لا توجد خزائن حالياً.'));
// //           }
// //
// //           final vaults = snapshot.data!;
// //           return ListView.builder(
// //             itemCount: vaults.length,
// //             itemBuilder: (context, index) {
// //               final vault = vaults[index];
// //               return Card(
// //                 elevation: 4,
// //                 margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(12.0),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         vault.name,
// //                         style: const TextStyle(
// //                           fontSize: 18,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                       const SizedBox(height: 8),
// //                       Text('الرصيد: ${vault.balance}'),
// //                       const SizedBox(height: 8),
// //                       Row(
// //                         mainAxisAlignment: MainAxisAlignment.end,
// //                         children: [
// //                           if (widget.userRole == 'admin') // السماح بالحذف فقط للمدير
// //                             IconButton(
// //                               icon: const Icon(Icons.delete, color: Colors.red),
// //                               onPressed: () async {
// //                                 try {
// //                                   await _vaultRepository.deleteVault(vault.id);
// //                                   _refreshVaults();
// //                                 } catch (e) {
// //                                   ScaffoldMessenger.of(context).showSnackBar(
// //                                     SnackBar(content: Text('خطأ عند حذف الخزنة: $e')),
// //                                   );
// //                                 }
// //                               },
// //                             ),
// //                           IconButton(
// //                             icon: const Icon(Icons.history, color: Colors.blue),
// //                             onPressed: () {
// //                               _showBillsForVaultDialog(vault.id);
// //                             },
// //                           ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               );
// //             },
// //           );
// //         },
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () {
// //           showAddVaultDialog(context, _refreshVaults);
// //         },
// //         child: const Icon(Icons.add),
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:system/features/Vaults/Presentation/dialog/add_vault_dialog.dart';
// import 'package:system/features/Vaults/data/models/vault_model.dart';
// import 'package:system/features/Vaults/data/repositories/supabase_vault_repository.dart';
//
// class VaultsPage extends StatefulWidget {
//   final String userRole; // إضافة الدور لتحديد الصلاحيات
//   const VaultsPage({Key? key, required this.userRole}) : super(key: key);
//
//   @override
//   _VaultsPageState createState() => _VaultsPageState();
// }
//
// class _VaultsPageState extends State<VaultsPage> {
//   final SupabaseVaultRepository _vaultRepository = SupabaseVaultRepository();
//   late Future<List<Vault>> _vaultsFuture;
//   final TextEditingController _searchController = TextEditingController();
//   String _selectedFilter = 'id'; // Default filter option
//   List<Map<String, dynamic>> _filteredBills = []; // Filtered bills list
//
//   @override
//   void initState() {
//     super.initState();
//     _vaultsFuture = _vaultRepository.getVaults();
//   }
//
//   void _refreshVaults() {
//     setState(() {
//       _vaultsFuture = _vaultRepository.getVaults();
//     });
//   }
//
//   // Update the search filter based on the selected filter and the input
//   void _filterBills(String query) {
//     setState(() {
//       // إعادة الفلترة عند تغيير النص في مربع البحث
//       _filteredBills = _filteredBills.where((bill) {
//         switch (_selectedFilter) {
//           case 'id':
//             return bill['id']?.toString().contains(query) ?? false;
//           case 'customer_name':
//             return bill['customer_name']?.contains(query) ?? false;
//           case 'date':
//             return bill['date']?.contains(query) ?? false;
//           case 'state':
//             return bill['state']?.contains(query) ?? false;
//           default:
//             return false;
//         }
//       }).toList();
//     });
//   }
//
//   // عرض Dialog يحتوي على جدول الفواتير المرتبطة بالخزنة
//   void _showBillsForVaultDialog(String vaultId) async {
//     final bills = await _vaultRepository.getBillsForVault(vaultId);
//     setState(() {
//       _filteredBills = bills; // عند جلب الفواتير، حفظها في القائمة المفلترة
//     });
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('الفواتير المرتبطة بالخزنة'),
//           content: Column(
//             children: [
//               // Search Bar
//               TextField(
//                 controller: _searchController,
//                 decoration: const InputDecoration(
//                   labelText: 'ابحث...',
//                   border: OutlineInputBorder(),
//                 ),
//                 onChanged: _filterBills, // تطبيق الفلترة عند تغيير النص
//               ),
//               const SizedBox(height: 10),
//               // ToggleButtons for selecting the filter criteria
//               ToggleButtons(
//                 isSelected: [
//                   _selectedFilter == 'id',
//                   _selectedFilter == 'customer_name',
//                   _selectedFilter == 'date',
//                   _selectedFilter == 'state',
//                 ],
//                 onPressed: (index) {
//                   setState(() {
//                     switch (index) {
//                       case 0:
//                         _selectedFilter = 'id';
//                         break;
//                       case 1:
//                         _selectedFilter = 'customer_name';
//                         break;
//                       case 2:
//                         _selectedFilter = 'date';
//                         break;
//                       case 3:
//                         _selectedFilter = 'state';
//                         break;
//                     }
//                   });
//                   _filterBills(_searchController.text); // Re-filter after changing selection
//                 },
//                 children: const [
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 8.0),
//                     child: Text('رقم الفاتورة'),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 8.0),
//                     child: Text('اسم العميل'),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 8.0),
//                     child: Text('تاريخ الفاتورة'),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 8.0),
//                     child: Text('حالة الفاتورة'),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               // DataTable for showing the filtered bills
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: DataTable(
//                     columns: const [
//                       DataColumn(label: Text('رقم الفاتورة')),
//                       DataColumn(label: Text('اسم العميل')),
//                       DataColumn(label: Text('تاريخ الفاتورة')),
//                       DataColumn(label: Text('حالة الفاتورة')),
//                       DataColumn(label: Text('التفاصيل')),
//                     ],
//
//                     rows: _filteredBills.map((bill) {
//                       return DataRow(cells: [
//                         DataCell(Text(bill['id']?.toString() ?? 'غير متوفر')),
//                         DataCell(Text(bill['customer_name'] ?? '')),
//                         DataCell(Text(bill['date'] ?? '')),
//                         DataCell(Text(bill['status'] ?? '')),
//                         DataCell(Text('تم دفع: ${bill['payment']?.toString() ?? '0.00'}')), // تأكد من تحويل payment إلى String
//                       ]);
//                     }).toList(),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('إغلاق'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('الخزائن'),
//       ),
//       body: FutureBuilder<List<Vault>>(
//         future: _vaultsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('خطأ: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('لا توجد خزائن حالياً.'));
//           }
//
//           final vaults = snapshot.data!;
//           return ListView.builder(
//             itemCount: vaults.length,
//             itemBuilder: (context, index) {
//               final vault = vaults[index];
//               return Card(
//                 elevation: 4,
//                 margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         vault.name,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text('الرصيد: ${vault.balance}'),
//                       const SizedBox(height: 8),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           if (widget.userRole == 'admin') // السماح بالحذف فقط للمدير
//                             IconButton(
//                               icon: const Icon(Icons.delete, color: Colors.red),
//                               onPressed: () async {
//                                 try {
//                                   await _vaultRepository.deleteVault(vault.id);
//                                   _refreshVaults();
//                                 } catch (e) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(content: Text('خطأ عند حذف الخزنة: $e')),
//                                   );
//                                 }
//                               },
//                             ),
//                           IconButton(
//                             icon: const Icon(Icons.history, color: Colors.blue),
//                             onPressed: () {
//                               _showBillsForVaultDialog(vault.id);
//                             },
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           showAddVaultDialog(context, _refreshVaults);
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:system/features/Vaults/Presentation/dialog/add_vault_dialog.dart';
import 'package:system/features/Vaults/data/models/vault_model.dart';
import 'package:system/features/Vaults/data/repositories/supabase_vault_repository.dart';

import 'Presentation/dialog/BillsDialog.dart';

class VaultsPage extends StatefulWidget {
  final String userRole; // إضافة الدور لتحديد الصلاحيات
  const VaultsPage({Key? key, required this.userRole}) : super(key: key);

  @override
  _VaultsPageState createState() => _VaultsPageState();
}

class _VaultsPageState extends State<VaultsPage> {
  final SupabaseVaultRepository _vaultRepository = SupabaseVaultRepository();
  late Future<List<Vault>> _vaultsFuture;

  @override
  void initState() {
    super.initState();
    _vaultsFuture = _vaultRepository.getVaults();
  }

  void _refreshVaults() {
    setState(() {
      _vaultsFuture = _vaultRepository.getVaults();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الخزائن'),
        actions: [
          TextButton.icon(onPressed: (){
            Navigator.pushReplacementNamed(context, '/adminHome'); // توجيه المستخدم إلى صفحة تسجيل الدخول
          }, label: Icon(Icons.home)),
        ],
      ),
      body: FutureBuilder<List<Vault>>(
        future: _vaultsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('خطأ: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('لا توجد خزائن حالياً.'));
          }

          final vaults = snapshot.data!;
          return ListView.builder(
            itemCount: vaults.length,
            itemBuilder: (context, index) {
              final vault = vaults[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vault.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('الرصيد: ${vault.balance}'),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (widget.userRole == 'admin') // السماح بالحذف فقط للمدير
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                try {
                                  await _vaultRepository.deleteVault(vault.id);
                                  _refreshVaults();
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('خطأ عند حذف الخزنة: $e')),
                                  );
                                }
                              },
                            ),
                          IconButton(
                            icon: const Icon(Icons.history, color: Colors.blue),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => BillsDialog(vaultId: vault.id),

                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddVaultDialog(context, _refreshVaults);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
