// import 'package:flutter/material.dart';
// import 'package:system/features/Vaults/data/repositories/supabase_vault_repository.dart';
//
// class BillsDialog extends StatefulWidget {
//   final String vaultId;
//
//   const BillsDialog({Key? key, required this.vaultId}) : super(key: key);
//
//   @override
//   _BillsDialogState createState() => _BillsDialogState();
// }
//
// class _BillsDialogState extends State<BillsDialog> {
//   final SupabaseVaultRepository _vaultRepository = SupabaseVaultRepository();
//   final TextEditingController _searchController = TextEditingController();
//   String _selectedFilter = 'id'; // Default filter option
//   List<Map<String, dynamic>> _filteredBills = []; // Filtered bills list
//
//   @override
//   void initState() {
//     super.initState();
//     _loadBills();
//   }
//
//   // Load bills for the specific vault
//   Future<void> _loadBills() async {
//     final bills = await _vaultRepository.getBillsForVault(widget.vaultId);
//     setState(() {
//       _filteredBills = bills;
//     });
//   }
//
//   // Filter the bills based on the search input
//   void _filterBills(String query) {
//     setState(() {
//       _filteredBills = _filteredBills.where((bill) {
//         switch (_selectedFilter) {
//           case 'id':
//             return bill['id']?.toString().contains(query) ?? false;
//           case 'customer_name':
//             return bill['customer_name']?.contains(query) ?? false;
//           case 'date':
//             return bill['date']?.contains(query) ?? false;
//           case 'state':
//             return bill['status']?.contains(query) ?? false;
//           default:
//             return false;
//         }
//       }).toList();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('الفواتير المرتبطة بالخزنة'),
//       content: Column(
//         children: [
//           // Search Bar
//           TextField(
//             controller: _searchController,
//             decoration: const InputDecoration(
//               labelText: 'ابحث...',
//               border: OutlineInputBorder(),
//             ),
//             onChanged: _filterBills, // Apply filter when text changes
//           ),
//           const SizedBox(height: 10),
//           // ToggleButtons for selecting the filter criteria
//           ToggleButtons(
//             isSelected: [
//               _selectedFilter == 'id',
//               _selectedFilter == 'customer_name',
//               _selectedFilter == 'date',
//               _selectedFilter == 'status',
//             ],
//             onPressed: (index) {
//               setState(() {
//                 switch (index) {
//                   case 0:
//                     _selectedFilter = 'id';
//                     break;
//                   case 1:
//                     _selectedFilter = 'customer_name';
//                     break;
//                   case 2:
//                     _selectedFilter = 'date';
//                     break;
//                   case 3:
//                     _selectedFilter = 'status';
//                     break;
//                 }
//               });
//               _filterBills(_searchController.text);
//               _loadBills();
// // Re-filter after changing selection
//             },
//             children: const [
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 8.0),
//                 child: Text('رقم الفاتورة'),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 8.0),
//                 child: Text('اسم العميل'),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 8.0),
//                 child: Text('تاريخ الفاتورة'),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 8.0),
//                 child: Text('حالة الفاتورة'),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           // DataTable for showing the filtered bills
//           Expanded(
//             child: SingleChildScrollView(
//               child: DataTable(
//                 columns: const [
//                   DataColumn(label: Text('رقم الفاتورة')),
//                   DataColumn(label: Text('اسم العميل')),
//                   DataColumn(label: Text('تاريخ الفاتورة')),
//                   DataColumn(label: Text('حالة الفاتورة')),
//                   DataColumn(label: Text('التفاصيل')),
//                 ],
//                 rows: _filteredBills.map((bill) {
//                   return DataRow(cells: [
//                     DataCell(Text(bill['id']?.toString() ?? 'غير متوفر')),
//                     DataCell(Text(bill['customer_name'] ?? '')),
//                     DataCell(Text(bill['date'] ?? '')),
//                     DataCell(Text(bill['status'] ?? '')),
//                     DataCell(Text('تم دفع: ${bill['payment']?.toString() ?? '0.00'}')),
//                   ]);
//                 }).toList(),
//               ),
//             ),
//           ),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: const Text('إغلاق'),
//         ),
//       ],
//     );
//   }
// }
// //

import 'package:flutter/material.dart';
import 'package:system/features/Vaults/data/repositories/supabase_vault_repository.dart';

class BillsDialog extends StatefulWidget {
  final String vaultId;

  const BillsDialog({Key? key, required this.vaultId}) : super(key: key);

  @override
  _BillsDialogState createState() => _BillsDialogState();
}

class _BillsDialogState extends State<BillsDialog> {
  final SupabaseVaultRepository _vaultRepository = SupabaseVaultRepository();
  final TextEditingController _searchController = TextEditingController();

  String _selectedFilter = 'id'; // Default filter option
  List<Map<String, dynamic>> _allBills = []; // All bills fetched from the repository
  List<Map<String, dynamic>> _filteredBills = []; // Filtered bills list

  @override
  void initState() {
    super.initState();
    _loadBills();
  }

  // Load bills for the specific vault
  Future<void> _loadBills() async {
    final bills = await _vaultRepository.getBillsForVault(widget.vaultId);
    setState(() {
      _allBills = bills;
      _filteredBills = bills; // Initially, show all bills
    });
  }

  // Filter the bills based on the search input and selected filter
  void _filterBills(String query) {
    setState(() {
      _filteredBills = _allBills.where((bill) {
        final value = bill[_selectedFilter]?.toString().toLowerCase() ?? '';
        return value.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('الفواتير المرتبطة بالخزنة'),
      content: Column(
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'ابحث...',
              border: OutlineInputBorder(),
            ),
            onChanged: _filterBills, // Apply filter when text changes
          ),
          const SizedBox(height: 10),
          // ToggleButtons for selecting the filter criteria
          ToggleButtons(
            isSelected: [
              _selectedFilter == 'id',
              _selectedFilter == 'customer_name',
              _selectedFilter == 'date',
              _selectedFilter == 'status',
            ],
            onPressed: (index) {
              setState(() {
                switch (index) {
                  case 0:
                    _selectedFilter = 'id';
                    break;
                  case 1:
                    _selectedFilter = 'customer_name';
                    break;
                  case 2:
                    _selectedFilter = 'date';
                    break;
                  case 3:
                    _selectedFilter = 'status';
                    break;
                }
              });
              _filterBills(_searchController.text); // Re-filter after changing selection
            },
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('رقم الفاتورة'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('اسم العميل'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('تاريخ الفاتورة'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('حالة الفاتورة'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // DataTable for showing the filtered bills
          Flexible(
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('رقم الفاتورة')),
                  DataColumn(label: Text('اسم العميل')),
                  DataColumn(label: Text('تاريخ الفاتورة')),
                  DataColumn(label: Text('حالة الفاتورة')),
                  DataColumn(label: Text('التفاصيل')),
                ],
                rows: _filteredBills.map((bill) {
                  return DataRow(cells: [
                    DataCell(Text(bill['id']?.toString() ?? 'غير متوفر')),
                    DataCell(Text(bill['customer_name'] ?? '')),
                    DataCell(Text(bill['date'] ?? '')),
                    DataCell(Text(bill['status'] ?? '')),
                    DataCell(Text('تم دفع: ${bill['payment']?.toString() ?? '0.00'}')),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('إغلاق'),
        ),
      ],
    );
  }
}
