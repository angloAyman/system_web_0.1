import 'package:flutter/material.dart';
import 'package:system/features/Vaults/data/repositories/supabase_vault_repository.dart';

class VaultTransferDialog extends StatefulWidget {
  @override
  _VaultTransferDialogState createState() => _VaultTransferDialogState();
}

class _VaultTransferDialogState extends State<VaultTransferDialog> {
  final SupabaseVaultRepository _vaultRepository = SupabaseVaultRepository();
  final TextEditingController _amountController = TextEditingController();

  List<Map<String, dynamic>> _vaults = [];
  String? _fromVaultId;
  String? _toVaultId;

  @override
  void initState() {
    super.initState();
    _loadVaults();
  }

  Future<void> _loadVaults() async {
    try {
      final vaults = await _vaultRepository.getAllVaults();
      setState(() {
        _vaults = vaults;
      });
    } catch (e) {
      _showMessage('حدث خطأ أثناء تحميل الخزائن: $e');
    }
  }

  Future<void> _transferFunds() async {
    final amount = int.tryParse(_amountController.text) ?? 0;

    if (_fromVaultId == null || _toVaultId == null) {
      _showMessage('يرجى اختيار الخزنة المصدر والخزنة الوجهة.');
      return;
    }

    if (_fromVaultId == _toVaultId) {
      _showMessage('لا يمكن التحويل لنفس الخزنة.');
      return;
    }

    if (amount <= 0) {
      _showMessage('يرجى إدخال مبلغ صالح للتحويل.');
      return;
    }

    try {
      await _vaultRepository.transferBetweenVaults(_fromVaultId!, _toVaultId!, amount);
      _showMessage('تمت عملية التحويل بنجاح.');
      Navigator.of(context).pop();
    } catch (e) {
      _showMessage('حدث خطأ أثناء عملية التحويل: $e');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('تحويل بين الخزائن'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // DropdownButtonFormField<String>(
          //   value: _fromVaultId,
          //   decoration: const InputDecoration(
          //     labelText: 'اختر الخزنة المصدر',
          //     labelStyle: TextStyle(),
          //     border: OutlineInputBorder(),
          //   ),
          //   items: _vaults.map((vault) {
          //     return DropdownMenuItem(
          //       value: vault['id'].toString(),
          //       child: Text('خزنة: ${vault['name']} (الرصيد: ${vault['balance']} جنيه)'),
          //     );
          //   }).toList(),
          //   onChanged: (value) {
          //     setState(() {
          //       _fromVaultId = value;
          //     });
          //   },
          // ),

          DropdownButtonFormField<String>(
            value: _fromVaultId,
            decoration: InputDecoration(
              labelText: 'اختر الخزنة المصدر',
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              border: const OutlineInputBorder(),
            ),
            items: _vaults.map((vault) {
              return DropdownMenuItem(
                value: vault['id'].toString(),
                child: Text(
                  'خزنة: ${vault['name']} (الرصيد: ${vault['balance']} جنيه)',
                  textDirection: TextDirection.rtl, // Ensures RTL direction inside item
                  textAlign: TextAlign.right, // Aligns text to the right for clarity
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _fromVaultId = value;
              });
            },
            isExpanded: true, // Recommended for mobile dropdown width
          ),

          const SizedBox(height: 10),
          // DropdownButtonFormField<String>(
          //   value: _toVaultId,
          //   decoration: const InputDecoration(
          //     labelText: 'اختر الخزنة الوجهة',
          //     border: OutlineInputBorder(),
          //   ),
          //   items: _vaults.map((vault) {
          //     return DropdownMenuItem(
          //       value: vault['id'].toString(),
          //       child: Text('خزنة: ${vault['name']} (الرصيد: ${vault['balance']} جنيه)'),
          //     );
          //   }).toList(),
          //   onChanged: (value) {
          //     setState(() {
          //       _toVaultId = value;
          //     });
          //   },
          // ),
          DropdownButtonFormField<String>(
            value: _toVaultId,
            decoration: const InputDecoration(
              labelText: 'اختر الخزنة الوجهة',
              labelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              border: OutlineInputBorder(),
            ),
            items: _vaults.map((vault) {
              return DropdownMenuItem(
                value: vault['id'].toString(),
                child: Text(
                  'خزنة: ${vault['name']} (الرصيد: ${vault['balance']} جنيه)',
                  textDirection: TextDirection.rtl, // Ensures RTL display
                  textAlign: TextAlign.right, // Aligns text right within the dropdown item
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _toVaultId = value;
              });
            },
            isExpanded: true, // Better UX on mobile screens
          ),


          const SizedBox(height: 10),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'المبلغ',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: _transferFunds,
          child: const Text('تحويل'),
        ),
      ],
    );
  }
}
