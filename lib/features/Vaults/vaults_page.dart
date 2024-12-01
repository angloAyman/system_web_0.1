import 'package:flutter/material.dart';
import 'package:system/features/Vaults/Presentation/dialog/add_vault_dialog.dart';
import 'package:system/features/Vaults/data/models/vault_model.dart';
import 'package:system/features/Vaults/data/repositories/supabase_vault_repository.dart';

class VaultsPage extends StatefulWidget {
  const VaultsPage({Key? key}) : super(key: key);

  @override
  _VaultsPageState createState() => _VaultsPageState();
}

class _VaultsPageState extends State<VaultsPage> {
  final SupabaseVaultRepository _vaultRepository = SupabaseVaultRepository();
  late Future<List<Vault>> _vaultsFuture;
  List<Vault> _filteredVaults = [];
  List<Vault> _vaults = [];

  @override
  void initState() {
    super.initState();
    _vaultsFuture = _vaultRepository.getVaults();
    _vaultsFuture.then((vaults) {
      setState(() {
        _vaults = vaults;
        _filteredVaults = vaults;
      });
    });
  }

  void _refreshVaults() {
    setState(() {
      _vaultsFuture = _vaultRepository.getVaults();
    });
  }

// // دالة تحديث قائمة الخزائن بعد الحذف
//   void _refreshVaults() async {
//     try {
//       final vaults = await _vaultRepository.getVaults();
//       setState(() {
//         _vaults = vaults;
//         _filteredVaults = vaults;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error refreshing vaults: $e')),
//       );
//     }
//   }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الخزائن'),
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
              return ListTile(
                title: Text(vault.name),
                subtitle: Text('الرصيد: ${vault.balance}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: ()  {
                    try {
                       _vaultRepository.deleteVault(vault.id);
                      _refreshVaults();
                    } catch (e) {
                        print('$e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error deleting vault: $e')),
                      );
                    }
                  },
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
