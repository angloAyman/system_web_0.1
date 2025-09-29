// import 'package:flutter/material.dart';
// import 'package:system/Adminfeatures/Vaults/data/repositories/supabase_vault_repository.dart';
//
// class PaymentDialog extends StatefulWidget {
//   final String vaultId;
//
//   const PaymentDialog({Key? key, required this.vaultId}) : super(key: key);
//
//   @override
//   _PaymentDialogState createState() => _PaymentDialogState();
// }
//
// class _PaymentDialogState extends State<PaymentDialog> {
//   final SupabaseVaultRepository _vaultRepository = SupabaseVaultRepository();
//   final TextEditingController _amountController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//
//   // Handle payment submission
//   Future<void> _submitPayment() async {
//     final amount = int.tryParse(_amountController.text) ?? 0;
//     final description = _descriptionController.text.trim();
//
//     if (amount <= 0) {
//       _showMessage('يرجى إدخال مبلغ صالح.');
//       return;
//     }
//     if (description.isEmpty) {
//       _showMessage('يرجى إدخال وصف للدفعة.');
//       return;
//     }
//
//     final timestamp = DateTime.now().toIso8601String();
//
//     try {
//       // Save the payment to the database
//       await _vaultRepository.addPayment(
//         vaultId: widget.vaultId,
//         amount: amount,
//         description: description,
//         timestamp: timestamp,
//       );
//
//       _showMessage('تمت إضافة الدفعة بنجاح.');
//       Navigator.of(context).pop(); // Close the dialog after successful submission
//     } catch (e) {
//       _showMessage('حدث خطأ أثناء إضافة الدفعة: $e');
//     }
//   }
//
//   // Display a message in a snackbar
//   void _showMessage(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('إضافة دفعة جديدة'),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Payment Amount Input
//           TextField(
//             controller: _amountController,
//             keyboardType: TextInputType.number,
//             decoration: const InputDecoration(
//               labelText: 'المبلغ',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           const SizedBox(height: 10),
//           // Description Input
//           TextField(
//             controller: _descriptionController,
//             decoration: const InputDecoration(
//               labelText: 'الوصف',
//               border: OutlineInputBorder(),
//             ),
//           ),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: const Text('إلغاء'),
//         ),
//         ElevatedButton(
//           onPressed: _submitPayment,
//           child: const Text('إضافة'),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:system/Adminfeatures/Vaults/data/repositories/supabase_vault_repository.dart';

class PaymentDialog extends StatefulWidget {
  @override
  _PaymentDialogState createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  final SupabaseVaultRepository _vaultRepository = SupabaseVaultRepository();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<Map<String, dynamic>> _vaults = [];
  String? _selectedVaultName;

  @override
  void initState() {
    super.initState();
    _loadVaults();
  }

  // Fetch all vaults from the database
  Future<void> _loadVaults() async {
    try {
      final vaults = await _vaultRepository.getAllVaults(); // Implement this method in your repository
      setState(() {
        _vaults = vaults;
      });
    } catch (e) {
      _showMessage('حدث خطأ أثناء تحميل الخزائن: $e');
    }
  }



  Future<void> _submitPayment() async {
    final amount = int.tryParse(_amountController.text) ?? 0;
    final description = _descriptionController.text.trim();

    // Validate the vault selection
    if (_selectedVaultName == null) {
      _showMessage('يرجى اختيار الخزنة.');
      return;
    }

    // Validate the entered payment amount
    if (amount <= 0) {
      _showMessage('يرجى إدخال مبلغ صالح.');
      return;
    }

    // Validate the description field
    if (description.isEmpty) {
      _showMessage('يرجى إدخال وصف للدفعة.');
      return;
    }

    try {

      // Fetch the authenticated user's name
      final user = await _vaultRepository.getAuthenticatedUser(); // Implement this in your repository
      final userName = user?['name'] ?? 'غير معروف';

      // Fetch the current balance of the selected vault
      final currentBalance = await _vaultRepository.getVaultBalance(_selectedVaultName!);

      // Ensure there are enough funds in the vault
      if (currentBalance < amount) {
        _showMessage('الرصيد المتوفر في الخزنة غير كافٍ لإتمام الدفعة.');
        return;
      }

      // Record the current timestamp
      final timestamp = DateTime.now().toIso8601String();

      // Update the vault balance and save the payment details
      await _vaultRepository.updateVaultBalanceAndLogPayment(
        vaultname: _selectedVaultName!,
        newBalance: currentBalance - amount,
        amount: amount,
        description: description,
        timestamp: timestamp,

      );

      //  save the payment details
      await _vaultRepository.subtractFromVaultBalance(
        vaultname: _selectedVaultName!,
        amount: amount,
        description: description,
        timestamp: timestamp,
        userName: userName, // Pass the user's name

      );


      // Display success message
      _showMessage('تمت إضافة الدفعة بنجاح.');

      // Close the dialog after successful submission
      // Navigator.of(context).pop();

    } catch (e) {
      // Display error message
      _showMessage('حدث خطأ أثناء إضافة الدفعة: $e');
    }
  }

  // Display a message in a snackbar
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('إضافة دفعة جديدة'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Vault Dropdown Menu
          DropdownButtonFormField<String>(
            value: _selectedVaultName,
            decoration: const InputDecoration(
              labelText: 'اختر الخزنة',
              border: OutlineInputBorder(),
            ),
            items: _vaults.map((vault) {
              return DropdownMenuItem(
                value: vault['name'].toString(),
                child: Text('خزنة: ${vault['name']} (الرصيد: ${vault['balance']} جنيه)'),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedVaultName = value;
              });
            },
          ),
          const SizedBox(height: 10),
          // Payment Amount Input
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'المبلغ',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          // Description Input
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'الوصف',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        // TextButton(
        //   onPressed: () => Navigator.of(context).pop(),
        //   child: const Text('إلغاء'),
        // ),
        ElevatedButton(
          onPressed: () {
            _submitPayment().then((_) {
              Navigator.of(context).pop(); // Close the dialog
            });
          },
          child: const Text('إضافة'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إغلاق'),
        ),
      ],
    );
  }
}
