import 'package:flutter/material.dart';
import 'package:system/features/Vaults/data/models/vault_model.dart';
import 'package:system/features/Vaults/data/repositories/supabase_vault_repository.dart';

Future<void> showAddVaultDialog(BuildContext context, void Function() refreshVaults) async {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController balanceController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('إضافة خزنة جديدة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'اسم الخزنة',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: balanceController,
              decoration: const InputDecoration(
                labelText: 'الرصيد الابتدائي',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              try {
                final name = nameController.text;
                final balance = balanceController.text;

                if (name.isEmpty || balance.isEmpty || int.tryParse(balance) == null) {
                  throw Exception('يرجى إدخال الحقول بشكل صحيح');
                }

                await SupabaseVaultRepository().addVault(
                  Vault(id: '', name: name, balance: int.parse(balance),isActive: true),
                );
                refreshVaults();
                Navigator.pop(context);
              } catch (e) {
                print("$e");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('.خطا في اضافة الخزينة: $e')),
                );
              }
            },
            child: const Text('إضافة الخزينة'),
          ),
        ],
      );
    },
  );
}
