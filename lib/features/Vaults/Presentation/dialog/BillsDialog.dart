import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:system/Adminfeatures/Vaults/data/repositories/supabase_vault_repository.dart';

class BillsDialog extends StatefulWidget {
  final String vaultId;
  final String vaultName;

  const BillsDialog({Key? key, required this.vaultId,required this.vaultName}) : super(key: key);

  @override
  _BillsDialogState createState() => _BillsDialogState();
}

class _BillsDialogState extends State<BillsDialog> {
  final SupabaseVaultRepository _vaultRepository = SupabaseVaultRepository();
  final TextEditingController _searchController = TextEditingController();

  String _selectedFilter = 'id'; // Default filter option
  List<Map<String, dynamic>> _allBills = []; // All bills fetched from the repository
  List<Map<String, dynamic>> _filteredBills = [];



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
    // Update the vault balance after loading the bills
    await _updateVaultBalance();
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

  // Calculate the total payment
  double _calculateTotalPayment() {
    return _filteredBills.fold(0.0, (sum, bill) => sum + (bill['payment'] ?? 0.0));
  }

  // Update the vault balance based on total payments from the bills
  Future<void> _updateVaultBalance() async {
    final totalPayment = _calculateTotalPayment();

    try {
      // Call the method in the repository to update the vault balance
      await _vaultRepository.updateVaultBalance(widget.vaultId);

      // Optionally, you can display a success message or update other UI elements.
      print('Vault balance updated successfully.');
    } catch (e) {
      print('Error updating vault balance: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('الفواتير المرتبطة بالخزنة (${widget.vaultName})'),
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
              child: Column(
                children: [
                  DataTable(
                    columns: const [
                      DataColumn(label: Text('رقم الفاتورة')),
                      DataColumn(label: Text('اسم العميل')),
                      DataColumn(label: Text('تاريخ الفاتورة')),
                      DataColumn(label: Text('حالة الفاتورة')),
                      DataColumn(label: Text('اجمالي الفاتورة')),
                      DataColumn(label: Text('التفاصيل')),
                    ],
                    rows: _filteredBills.map((bill) {
                      String formattedDate = '';
                      if (bill['date'] != null) {
                        try {
                          final DateTime date = DateTime.parse(bill['date']);
                          formattedDate = DateFormat('dd/MM/yyyy').format(date); // Format the date
                        } catch (e) {
                          formattedDate = 'غير معروف'; // Handle invalid date format
                        }
                      }
                      return DataRow(cells: [
                        DataCell(Text(bill['id']?.toString() ?? 'غير متوفر')),
                        DataCell(Text(bill['customer_name'] ?? '')),
                        // DataCell(Text(bill['date'] ?? '')),
                        DataCell(Text(formattedDate)), // Display formatted date
                        DataCell(Text(bill['status'] ?? '')),
                        DataCell(Text('جنيه مصري: ${bill['total_price']?.toString() ?? '0.00'}')),
                        DataCell(Text('تم دفع: ${bill['payment']?.toString() ?? '0.00'}')),
                      ]);
                    }).toList(),
                  ),

              const SizedBox(height: 10),

              // Display the total payment
                  Text(
                    'إجمالي المدفوعات: جنيه مصري ${_calculateTotalPayment().toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
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
