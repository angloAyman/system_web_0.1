// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:system/features/Vaults/data/repositories/supabase_vault_repository.dart';
// import 'package:system/features/Vaults/pdf/generatePaymentDetailsPdf.dart';
// import 'package:system/features/Vaults/pdf/generateallPaymentDetailsPdf.dart';
//
// class AllPaymentDetailsDialogMobile extends StatelessWidget {
//
//   AllPaymentDetailsDialogMobile({Key? key, }) : super(key: key);
//
//   final SupabaseVaultRepository _vaultRepository = SupabaseVaultRepository();
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('تفاصيل جميع المدفعات '),
//
//       // title: const Text('تفاصيل المدفعات'),
//       content: FutureBuilder<List<Map<String, dynamic>>>(
//         future: _vaultRepository.getAlpaymentsOut(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const CircularProgressIndicator();
//           } else if (snapshot.hasError) {
//             return Text('حدث خطأ: ${snapshot.error}');
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Text('لا توجد دفعات لهذه الخزنة.');
//           }
//
//           final payments = snapshot.data!;
//
//           return SizedBox(
//             width: double.maxFinite,
//             child: SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: DataTable(
//                 columns: const [
//                   DataColumn(label: Text('المسلسل', style: TextStyle(fontWeight: FontWeight.bold))),
//                   DataColumn(label: Text('التاريخ', style: TextStyle(fontWeight: FontWeight.bold))),
//                   DataColumn(label: Text('اسم المستخدم', style: TextStyle(fontWeight: FontWeight.bold))),
//                   DataColumn(label: Text('المبلغ', style: TextStyle(fontWeight: FontWeight.bold))),
//                   DataColumn(label: Text('الوصف', style: TextStyle(fontWeight: FontWeight.bold))),
//                   DataColumn(label: Text('الخزينة', style: TextStyle(fontWeight: FontWeight.bold))),
//                 ],
//                 rows: payments.map((payment) {
//                   String formattedDate = '';
//                   if (payment['timestamp'] != null) {
//                     try {
//                       final DateTime date = DateTime.parse(payment['timestamp']);
//                       formattedDate = DateFormat('dd/MM/yyyy').format(date); // Format the date
//                     } catch (e) {
//                       formattedDate = 'غير معروف'; // Handle invalid date format
//                     }
//                   }
//                   return DataRow(cells: [
//                     DataCell(Text('${payment['id']}')),
//                     DataCell(Text(formattedDate)), // Display formatted date
//                     DataCell(Text('${payment['userName']}')),
//                     DataCell(Text('${payment['amount']}')),
//                     DataCell(Text(payment['description'] ?? 'لا يوجد وصف')),
//                     DataCell(Text(payment['vault_name'] ?? 'لا يوجد وصف')),
//                   ]);
//                 }).toList(),
//               ),
//             ),
//           );
//         },
//       ),
//       actions: [
//         //
//         ElevatedButton(
//           onPressed: () async {
//             final payments = await _vaultRepository.getAlpaymentsOut();
//             await generateallPaymentDetailsPdf(payments);
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('تم إنشاء ملف PDF بنجاح!')),
//             );
//           },
//           child: const Text('تصدير PDF'),
//         ),
//
//         ElevatedButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: const Text('إغلاق'),
//         ),
//       ],
//     );
//   }
// }

// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:system/features/Vaults/data/repositories/supabase_vault_repository.dart';
// import 'package:system/features/Vaults/pdf/generateallPaymentDetailsPdf.dart';
// import 'package:system/main_screens/mobile_screens/Drawer/widget/PaymentPageMobile/generateallPaymentDetailsPdfMobile.dart';
//
// class AllPaymentDetailsDialogMobile extends StatelessWidget {
//   AllPaymentDetailsDialogMobile({Key? key}) : super(key: key);
//
//   final SupabaseVaultRepository _vaultRepository = SupabaseVaultRepository();
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       insetPadding: const EdgeInsets.all(8.0), // Reduce padding for full mobile width
//       child: SafeArea(
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text('تفاصيل جميع المدفعات'),
//             automaticallyImplyLeading: false,
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.close),
//                 onPressed: () => Navigator.of(context).pop(),
//               ),
//             ],
//           ),
//           body: FutureBuilder<List<Map<String, dynamic>>>(
//             future: _vaultRepository.getAlpaymentsOut(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (snapshot.hasError) {
//                 return Center(child: Text('حدث خطأ: ${snapshot.error}'));
//               } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                 return const Center(child: Text('لا توجد دفعات لهذه الخزنة.'));
//               }
//
//               final payments = snapshot.data!;
//
//               return SingleChildScrollView(
//                 scrollDirection: Axis.horizontal, // Enable horizontal scroll for DataTable
//                 child: ConstrainedBox(
//                   constraints: const BoxConstraints(minWidth: 600), // Minimum width for readability
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.vertical,
//                     child: DataTable(
//                       columnSpacing: 12,
//                       headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
//                       columns: const [
//                         DataColumn(label: Text('م', style: TextStyle(fontWeight: FontWeight.bold))),
//                         DataColumn(label: Text('التاريخ', style: TextStyle(fontWeight: FontWeight.bold))),
//                         DataColumn(label: Text('المستخدم', style: TextStyle(fontWeight: FontWeight.bold))),
//                         DataColumn(label: Text('المبلغ', style: TextStyle(fontWeight: FontWeight.bold))),
//                         DataColumn(label: Text('الوصف', style: TextStyle(fontWeight: FontWeight.bold))),
//                         DataColumn(label: Text('الخزينة', style: TextStyle(fontWeight: FontWeight.bold))),
//                       ],
//                       rows: payments.map((payment) {
//                         String formattedDate = '';
//                         if (payment['timestamp'] != null) {
//                           try {
//                             final DateTime date = DateTime.parse(payment['timestamp']);
//                             formattedDate = DateFormat('dd/MM/yyyy').format(date);
//                           } catch (e) {
//                             formattedDate = 'غير معروف';
//                           }
//                         }
//                         return DataRow(cells: [
//                           DataCell(Text('${payment['id']}')),
//                           DataCell(Text(formattedDate)),
//                           DataCell(Text('${payment['userName']}')),
//                           DataCell(Text('${payment['amount']}')),
//                           DataCell(Text(payment['description'] ?? 'لا يوجد وصف')),
//                           DataCell(Text(payment['vault_name'] ?? 'لا يوجد')),
//                         ]);
//                       }).toList(),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//           bottomNavigationBar: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Wrap(
//               alignment: WrapAlignment.center,
//               spacing: 8,
//               runSpacing: 8,
//               children: [
//                 ElevatedButton.icon(
//                   icon: const Icon(Icons.picture_as_pdf),
//                   label: const Text('تصدير PDF'),
//                   onPressed: () async {
//                     final payments = await _vaultRepository.getAlpaymentsOut();
//                     await generateallPaymentDetailsPdfMobile(payments);
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('تم إنشاء ملف PDF بنجاح!')),
//                     );
//                   },
//                 ),
//                 ElevatedButton.icon(
//                   icon: const Icon(Icons.close),
//                   label: const Text('إغلاق'),
//                   onPressed: () => Navigator.of(context).pop(),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:system/features/Vaults/data/repositories/supabase_vault_repository.dart';
// import 'package:system/main_screens/mobile_screens/Drawer/widget/PaymentPageMobile/generateallPaymentDetailsPdfMobile.dart';
//
// class AllPaymentDetailsDialogMobile extends StatelessWidget {
//   AllPaymentDetailsDialogMobile({Key? key}) : super(key: key);
//
//   final SupabaseVaultRepository _vaultRepository = SupabaseVaultRepository();
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       insetPadding: const EdgeInsets.all(8.0),
//       child: SafeArea(
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text('تفاصيل جميع المدفعات'),
//             automaticallyImplyLeading: false,
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.close),
//                 onPressed: () => Navigator.of(context).pop(),
//               ),
//             ],
//           ),
//           body: FutureBuilder<List<Map<String, dynamic>>>(
//             future: _vaultRepository.getAlpaymentsOut(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (snapshot.hasError) {
//                 return Center(child: Text('حدث خطأ: ${snapshot.error}'));
//               } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                 return const Center(child: Text('لا توجد دفعات لهذه الخزنة.'));
//               }
//
//               final payments = snapshot.data!;
//
//               return Column(
//                 children: [
//                   Expanded(
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: ConstrainedBox(
//                         constraints: const BoxConstraints(minWidth: 600),
//                         child: SingleChildScrollView(
//                           scrollDirection: Axis.vertical,
//                           child: DataTable(
//                             columnSpacing: 12,
//                             headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
//                             columns: const [
//                               DataColumn(label: Text('م', style: TextStyle(fontWeight: FontWeight.bold))),
//                               DataColumn(label: Text('التاريخ', style: TextStyle(fontWeight: FontWeight.bold))),
//                               DataColumn(label: Text('المستخدم', style: TextStyle(fontWeight: FontWeight.bold))),
//                               DataColumn(label: Text('المبلغ', style: TextStyle(fontWeight: FontWeight.bold))),
//                               DataColumn(label: Text('الوصف', style: TextStyle(fontWeight: FontWeight.bold))),
//                               DataColumn(label: Text('الخزينة', style: TextStyle(fontWeight: FontWeight.bold))),
//                             ],
//                             rows: payments.map((payment) {
//                               String formattedDate = 'غير معروف';
//                               if (payment['timestamp'] != null) {
//                                 try {
//                                   final DateTime date = DateTime.parse(payment['timestamp']);
//                                   formattedDate = DateFormat('dd/MM/yyyy').format(date);
//                                 } catch (e) {}
//                               }
//                               return DataRow(cells: [
//                                 DataCell(Text('${payment['id']}')),
//                                 DataCell(Text(formattedDate)),
//                                 DataCell(Text('${payment['userName']}')),
//                                 DataCell(Text('${payment['amount']}')),
//                                 DataCell(Text(payment['description'] ?? 'لا يوجد وصف')),
//                                 DataCell(Text(payment['vault_name'] ?? 'لا يوجد')),
//                               ]);
//                             }).toList(),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Wrap(
//                       alignment: WrapAlignment.center,
//                       spacing: 8,
//                       runSpacing: 8,
//                       children: [
//                         ElevatedButton.icon(
//                           icon: const Icon(Icons.picture_as_pdf),
//                           label: const Text('تصدير PDF'),
//                           onPressed: () async {
//                             try {
//                               await generateallPaymentDetailsPdfMobile(payments);
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(content: Text('تم إنشاء ملف PDF بنجاح!')),
//                               );
//                             } catch (e) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(content: Text('حدث خطأ أثناء إنشاء PDF: $e')),
//                               );
//                             }
//                           },
//                         ),
//                         ElevatedButton.icon(
//                           icon: const Icon(Icons.close),
//                           label: const Text('إغلاق'),
//                           onPressed: () => Navigator.of(context).pop(),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:system/features/Vaults/data/repositories/supabase_vault_repository.dart';
import 'package:system/main_screens/mobile_screens/Drawer/widget/PaymentPageMobile/generateallPaymentDetailsPdfMobile.dart';

class AllPaymentDetailsDialogMobile extends StatefulWidget {
  const AllPaymentDetailsDialogMobile({Key? key}) : super(key: key);

  @override
  State<AllPaymentDetailsDialogMobile> createState() => _AllPaymentDetailsDialogMobileState();
}

class _AllPaymentDetailsDialogMobileState extends State<AllPaymentDetailsDialogMobile> {
  final SupabaseVaultRepository _vaultRepository = SupabaseVaultRepository();
  List<Map<String, dynamic>> _allPayments = [];
  List<Map<String, dynamic>> _filteredPayments = [];
  bool _isLoading = true;
  String _searchQuery = '';
  bool _sortAscending = false;
  int? _sortColumnIndex;

  @override
  void initState() {
    super.initState();
    _fetchPayments();
  }

  Future<void> _fetchPayments() async {
    try {
      final payments = await _vaultRepository.getAlpaymentsOut();
      setState(() {
        _allPayments = payments;
        _filteredPayments = payments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ: $e'.tr())),
      );
    }
  }

  void _filterPayments(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredPayments = _allPayments;
      } else {
        _filteredPayments = _allPayments.where((payment) {
          return (payment['userName']?.toString().toLowerCase().contains(query.toLowerCase()) == true ||
              (payment['description']?.toString().toLowerCase().contains(query.toLowerCase()) == true ||
                  (payment['vault_name']?.toString().toLowerCase().contains(query.toLowerCase()) == true ||
                      (payment['amount']?.toString().contains(query) == true))));
                  }).toList();
      }
    });
  }

  void _sortPayments(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      _filteredPayments.sort((a, b) {
        final dynamic aValue = _getSortValue(a, columnIndex);
        final dynamic bValue = _getSortValue(b, columnIndex);

        if (aValue == null) return ascending ? 1 : -1;
        if (bValue == null) return ascending ? -1 : 1;

        if (aValue is num && bValue is num) {
          return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
        } else if (aValue is DateTime && bValue is DateTime) {
          return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
        } else {
          return ascending
              ? aValue.toString().compareTo(bValue.toString())
              : bValue.toString().compareTo(aValue.toString());
        }
      });
    });
  }

  dynamic _getSortValue(Map<String, dynamic> payment, int columnIndex) {
    switch (columnIndex) {
      case 0: // ID
        return payment['id'];
      case 1: // Date
        try {
          return payment['timestamp'] != null ? DateTime.parse(payment['timestamp']) : null;
        } catch (_) {
          return null;
        }
      case 2: // User
        return payment['userName'];
      case 3: // Amount
        return payment['amount'] is num ? payment['amount'] : double.tryParse(payment['amount'].toString());
      case 4: // Description
        return payment['description'];
      case 5: // Vault
        return payment['vault_name'];
      default:
        return null;
    }
  }

  String _formatDate(String? timestamp) {
    if (timestamp == null) return 'غير معروف';
    try {
      final date = DateTime.parse(timestamp);
      return DateFormat('dd/MM/yyyy - hh:mm a').format(date);
    } catch (e) {
      return 'غير معروف';
    }
  }

  String _formatAmount(dynamic amount) {
    if (amount == null) return '0.00';
    final numValue = amount is num ? amount : int.tryParse(amount.toString());
    return numValue?.toStringAsFixed(2) ?? '0.00';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('تفاصيل جميع المدفعات').tr(),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'بحث'.tr(),
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => _filterPayments(''),
                    )
                        : null,
                  ),
                  onChanged: _filterPayments,
                ),
              ),
              if (_isLoading)
                const Expanded(child: Center(child: CircularProgressIndicator()))
              else if (_filteredPayments.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.payment, size: 48, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? 'لا توجد مدفوعات'.tr()
                              : 'لم يتم العثور على نتائج'.tr(),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _fetchPayments,
                    child: ListView(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 12,
                            headingRowHeight: 48,
                            dataRowMinHeight: 40,
                            dataRowMaxHeight: 60,
                            sortColumnIndex: _sortColumnIndex,
                            sortAscending: _sortAscending,
                            // headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                            //         (Set<MaterialState> states) => Theme.of(context).colorScheme.primaryContainer),
                            columns: [
                              DataColumn(
                                label: const Text('م').tr(),
                                onSort: (columnIndex, ascending) => _sortPayments(columnIndex, ascending),
                              ),
                              DataColumn(
                                label: const Text('التاريخ').tr(),
                                onSort: (columnIndex, ascending) => _sortPayments(columnIndex, ascending),
                              ),
                              DataColumn(
                                label: const Text('المستخدم').tr(),
                                onSort: (columnIndex, ascending) => _sortPayments(columnIndex, ascending),
                              ),
                              DataColumn(
                                label: const Text('المبلغ').tr(),
                                numeric: true,
                                onSort: (columnIndex, ascending) => _sortPayments(columnIndex, ascending),
                              ),
                              DataColumn(
                                label: const Text('الوصف').tr(),
                                onSort: (columnIndex, ascending) => _sortPayments(columnIndex, ascending),
                              ),
                              DataColumn(
                                label: const Text('الخزينة').tr(),
                                onSort: (columnIndex, ascending) => _sortPayments(columnIndex, ascending),
                              ),
                            ],
                            rows: _filteredPayments.map((payment) {
                              return DataRow(
                                color: MaterialStateProperty.resolveWith<Color?>(
                                      (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.selected)) {
                                      return Theme.of(context).colorScheme.primary.withOpacity(0.08);
                                    }
                                    return payment['id'] % 2 == 0
                                        ? Colors.grey[50]
                                        : null;
                                  },
                                ),
                                cells: [
                                  DataCell(Text('${payment['id']}')),
                                  DataCell(Text(_formatDate(payment['timestamp']))),
                                  DataCell(Text('${payment['userName']}')),
                                  DataCell(
                                    Text(
                                      _formatAmount(payment['amount']),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(maxWidth: 200),
                                      child: Text(
                                        payment['description'] ?? 'لا يوجد وصف',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  DataCell(Text(payment['vault_name'] ?? 'لا يوجد')),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'عدد المدفوعات: ${_filteredPayments.length}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'الإجمالي: ${_formatAmount(_filteredPayments.fold(0.0, (sum, item) => sum + (item['amount'] is num ? item['amount'] : double.tryParse(item['amount'].toString()) ?? 0)))}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text('تصدير PDF').tr(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onPressed: () async {
                        try {
                          await generateallPaymentDetailsPdfMobile(_filteredPayments);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('تم إنشاء ملف PDF بنجاح!').tr(),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('حدث خطأ أثناء إنشاء PDF: $e'.tr()),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('تحديث').tr(),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onPressed: _fetchPayments,
                    ),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.close),
                      label: const Text('إغلاق').tr(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}