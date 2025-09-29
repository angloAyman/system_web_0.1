import 'package:flutter/material.dart';
import 'package:system/Adminfeatures/Vaults/Presentation/dialog/PaymentDetailsDialog.dart';
import 'package:system/Adminfeatures/Vaults/Presentation/dialog/PaymentDialog.dart';
import 'package:system/Adminfeatures/Vaults/Presentation/dialog/VaultTransferDialog.dart';
import 'package:system/Adminfeatures/Vaults/Presentation/dialog/add_vault_dialog.dart';
import 'package:system/Adminfeatures/Vaults/data/models/vault_model.dart';
import 'package:system/Adminfeatures/Vaults/data/repositories/supabase_vault_repository.dart';
import 'package:system/Adminfeatures/Vaults/pdf/generateallPaymentDetailsPdf.dart';

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
          TextButton.icon(
              onPressed: () {
                Navigator.pushReplacementNamed(context,
                    '/adminHome'); // توجيه المستخدم إلى صفحة تسجيل الدخول
              },
              label: Icon(Icons.home)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
              child: Row(
            children: [
              SizedBox(width: 20,),

              ElevatedButton(
                onPressed: () {
                  showAddVaultDialog(context, _refreshVaults);
                },
                child: const Text('انشاء خزينة جديدة'),
              ),

              SizedBox(width: 20,),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => VaultTransferDialog(),
                  ).then((_) {
                    // Call _refreshVaults after the dialog is closed
                    _refreshVaults();
                  });
                },

                child: const Text('تحويل مبلغ'),
              ),

              SizedBox(width: 20,),

              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => PaymentDialog(),
                  ).then((_) {
                    // Call _refreshVaults after the dialog is closed
                    _refreshVaults();
                  });
                },
                child: const Text('المصروفات'),
              ),

              SizedBox(width: 20,),
              ElevatedButton(
                onPressed: () async {
                  final payments = await _vaultRepository.getAllVaults();
                  await generateallPaymentDetailsPdf(payments);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم إنشاء ملف PDF بنجاح!')),
                  );
                },

                child: const Text('PDF تصدير المصروفات ',
                  textDirection: TextDirection.ltr,
                ),
              ),


            ],
          )),
          Expanded(
            flex: 10,
            child: FutureBuilder<List<Vault>>(
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
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
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
                                if (widget.userRole ==
                                    'admin') // السماح بالحذف فقط للمدير
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () async {
                                      try {
                                        await _vaultRepository
                                            .deleteVault(vault.id);
                                        _refreshVaults();
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'خطأ عند حذف الخزنة: $e')),
                                        );
                                      }
                                    },
                                  ),
                                // TextButton.icon(
                                //   icon: const Icon(Icons.history,
                                //     color: Colors.blue,semanticLabel: "الفواتير المرتبطة بالخزنة" ,),
                                //   onPressed: () {
                                //     showDialog(
                                //       context: context,
                                //       builder: (context) =>
                                //           BillsDialog(vaultId: vault.id,vaultName: vault.name,),
                                //     );
                                //   },
                                //   label: Text("الفواتير المرتبطة بالخزنة"),
                                // ),
                                IconButton(
                                  icon: const Icon(Icons.history,
                                      color: Colors.blue,semanticLabel: "الفواتير المرتبطة بالخزنة" ,),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          BillsDialog(vaultId: vault.id,vaultName: vault.name,),
                                    );
                                  },
                                    tooltip:"الفواتير المرتبطة بالخزنة"
                                ),
                                IconButton(
                                  icon: const Icon(
                                      Icons.account_balance_wallet_outlined,
                                      color: Colors.blue),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => PaymentDetailsDialog(vaultName: vault.name),
                                    );
                                  },
                                    tooltip:" تفاصيل المدفعات للخزنة "

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
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     showAddVaultDialog(context, _refreshVaults);
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
