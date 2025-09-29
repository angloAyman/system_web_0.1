// import 'package:flutter/material.dart';
// import 'package:system/features/Vaults/data/repositories/supabase_vault_repository.dart';
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

// اضافة مصروفات
import 'package:flutter/material.dart';
import 'package:system/features/Vaults/data/repositories/supabase_vault_repository.dart';

class PaymentDialog extends StatefulWidget {
  @override
  _PaymentDialogState createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  final SupabaseVaultRepository _vaultRepository = SupabaseVaultRepository();

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<Map<String, dynamic>> _vaults = [];
  String? _selectedVaultid;

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
      showCustomDialog("تنبيه", "حدث خطأ أثناء تحميل الخزائن: $e");

    }
  }


  Future<void> _submitPayment() async {
    final amount = int.tryParse(_amountController.text) ?? 0;
    final description = _descriptionController.text.trim();

    if (_selectedVaultid == null) {
      showCustomDialog("تنبيه", "يرجى اختيار الخزنة.");
      _showMessage("يرجى اختيار الخزنة.");
      return;
    }

    if (amount <= 0) {
      showCustomDialog("تنبيه", "يرجى إدخال مبلغ صالح.");
      _showMessage( "يرجى إدخال مبلغ صالح.");
      return;
    }

    if (description.isEmpty) {
      showCustomDialog("تنبيه", "يرجى إدخال وصف للدفعة.");
      _showMessage( "يرجى إدخال وصف للدفعة.");
      return;
    }

    try {
      // 1️⃣ جلب بيانات المستخدم
      final user = await _vaultRepository.getAuthenticatedUser();
      final userName = user?['name'] ?? 'غير معروف';
      print("✅ المستخدم المسجل: $userName");

      // 2️⃣ جلب رصيد الخزنة
      final currentBalance = await _vaultRepository.getVaultBalance(_selectedVaultid!) ?? 0;
      print("💰 الرصيد الحالي للخزنة: $currentBalance");

      if (currentBalance < amount) {
        showCustomDialog("تنبيه", "الرصيد المتوفر في الخزنة غير كافٍ لإتمام الدفعة.");
        _showMessage( "الرصيد المتوفر في الخزنة غير كافٍ لإتمام الدفعة.");
        return;
      }

      // 3️⃣ تحديث الرصيد
      await _vaultRepository.updateVaultBalanceAndLogPayment(
        vault_id: _selectedVaultid!,
        newBalance: currentBalance - amount,
      );

      // 4️⃣ جلب اسم الخزنة
      final vaultName = await _vaultRepository.getVaultbyid(_selectedVaultid!) ?? "غير معروف";
      print("🏦 اسم الخزنة: $vaultName");

      // 5️⃣ حفظ بيانات الدفع
      await _vaultRepository.subtractFromVaultBalance(
        vault_id: _selectedVaultid!,
        vault_name: vaultName,
        amount: amount,
        description: description,
        timestamp: DateTime.now().toIso8601String(),
        userName: userName,
      );

      showCustomDialog("نجاح", "تمت إضافة الدفعة بنجاح.");
      _showMessage( "تمت إضافة الدفعة بنجاح.");

    } catch (e) {
      print("❌ خطأ أثناء إضافة الدفعة: ${e.toString()}");
      showCustomDialog("خطأ", "حدث خطأ أثناء إضافة الدفعة.");
      _showMessage( "حدث خطأ أثناء إضافة الدفعة.");
    }
  }

  /// دالة مساعدة لعرض التنبيهات

  void showCustomDialog(String title, String message) {
    if (!mounted) return; // Ensure the widget is still in the tree

    WidgetsBinding.instance.addPostFrameCallback((_) { // Ensure it runs on the UI thread
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Use dialogContext instead of context
                },                child: const Text("موافق"),
              ),
            ],
          );
        },
      );
    });
  }


  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }



@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('إضافة دفعة جديدة'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: _selectedVaultid,
            decoration: const InputDecoration(
              labelText: 'اختر الخزنة',
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
                  // 'خزنة: ${vault['name']} (الرصيد: ${vault['balance']} جنيه)',
                  'خزنة: ${vault['name']} ',
                  textDirection: TextDirection.rtl, // Ensures RTL display
                  textAlign: TextAlign.right, // Aligns text right within the dropdown item
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedVaultid = value;
              });
            },
            isExpanded: true, // Better UX on mobile screens
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
