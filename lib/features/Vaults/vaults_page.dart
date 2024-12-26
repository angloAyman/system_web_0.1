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
