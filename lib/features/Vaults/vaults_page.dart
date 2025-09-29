import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/Vaults/Presentation/dialog/PaymentDetailsDialog.dart';
import 'package:system/features/Vaults/Presentation/dialog/PaymentDialog.dart';
import 'package:system/features/Vaults/Presentation/dialog/VaultTransferDialog.dart';
import 'package:system/features/Vaults/Presentation/dialog/add_vault_dialog.dart';
import 'package:system/features/Vaults/Presentation/dialog/all_paymentDetailsDialog.dart';
import 'package:system/features/Vaults/data/models/vault_model.dart';
import 'package:system/features/Vaults/data/repositories/supabase_vault_repository.dart';
import 'package:system/features/Vaults/pdf/generateallPaymentDetailsPdf.dart';

import 'Presentation/dialog/BillsDialog.dart';
import 'Presentation/dialog/paymentsDialog.dart';
import 'delete_vault_screen.dart';

class VaultsPage extends StatefulWidget {
  final String userRole; // إضافة الدور لتحديد الصلاحيات
  const VaultsPage({Key? key, required this.userRole}) : super(key: key);

  @override
  _VaultsPageState createState() => _VaultsPageState();
}

class _VaultsPageState extends State<VaultsPage> {
  final SupabaseVaultRepository _vaultRepository = SupabaseVaultRepository();
  late Future<List<Vault>> _vaultsFuture;

  int _totalVault = 0;
  int _totalBalance = 0;
  int _totalpaymentsOut = 0;

  @override
  void initState() {
    super.initState();
    _refreshVaults();
    _vaultsFuture = _vaultRepository.getVaults();

  }


  Future<void> _refreshVaults() async {
    final totalVault = await _vaultRepository.getTotalVaultCount();
    final totalBalance = await _vaultRepository.getTotalVaultBalance();
    final totalpaymentsOut = await _vaultRepository.getTotalpaymentsOut();

    setState(() {
      _totalVault = totalVault ;
      _totalBalance = totalBalance ;
      _totalpaymentsOut = totalpaymentsOut ;
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
          Expanded(flex: 3,
              child: Row(children: [
                _buildCard('اجمالي عدد الخزن ', '$_totalVault', Icons.paypal, Colors.black26,Colors.blue  ),
                _buildCard('اجمالي رصيد الخزن ', '$_totalBalance', Icons.paypal_sharp, Colors.black12,Colors.amber  ),
                _buildCard('اجمالي رصيد المصروفات ', '$_totalpaymentsOut', Icons.paypal_sharp, Colors.black12,Colors.purpleAccent  ),
              ],)),
          Expanded(
              flex: 1,
              child: Row(
                children: [

                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showAddVaultDialog(context, _refreshVaults);
                    },
                    child: const Text('انشاء خزينة جديدة'),
                  ),
                  SizedBox(
                    width: 20,
                  ),
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
                  SizedBox(
                    width: 20,
                  ),
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
                    child: const Text('اضافة المصروفات'),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AllPaymentDetailsDialog(),
                      ).then((_) {
                        // Call _refreshVaults after the dialog is closed
                        _refreshVaults();
                      });
                    },
                    child: const Text('جميع المصروفات '),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final payments = await _vaultRepository.getAlpaymentsOut();
                      await generateallPaymentDetailsPdf(payments);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('تم إنشاء ملف PDF بنجاح!')),
                      );
                    },
                    child: const Text(
                      'PDF تصدير المصروفات ',
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
                            Row(
                              children: [
                                Text(
                                  vault.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                Switch(
                                  value: vault.isActive ?? false,
                                  onChanged: (newValue) async {
                                    try {
                                      await _vaultRepository.updateVaultStatus(vault.id, newValue);

                                      setState(() {
                                        vault.isActive = newValue; // تعديل قيمة الكائن نفسه
                                      });

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('تم تحديث حالة الخزنة')),
                                      );
                                    } catch (e) {
                                      print(e);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('فشل التحديث: $e')),
                                      );
                                    }
                                  },
                                ),


                              ],
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
                                    icon: const Icon(
                                      Icons.filter_frames_rounded,
                                      color: Colors.blue,
                                      semanticLabel:
                                          "الفواتير المرتبطة بالخزنة",
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => BillsDialog(
                                          vaultId: vault.id,
                                          vaultName: vault.name,
                                        ),
                                      );
                                    },
                                    tooltip: "الفواتير المرتبطة بالخزنة"),
                                IconButton(
                                    icon: const Icon(
                                      Icons.payment,
                                      color: Colors.deepOrangeAccent,
                                      semanticLabel:
                                          "المدفوعات المرتبطة بالخزنة",
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>paymentsDialog(
                                          vaultId: vault.id,
                                          vaultName: vault.name,
                                        ),
                                      );
                                    },
                                    tooltip: "المدفوعات المرتبطة بالخزنة"),
                                IconButton(
                                    icon: const Icon(
                                        Icons.account_balance_wallet_outlined,
                                        color: Colors.blue),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            PaymentDetailsDialog(
                                                vaultName: vault.name,
                                                vaultid: vault.id
                                            ),
                                      );
                                    },
                                    tooltip: " تفاصيل المصروفات للخزنة "),
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

    );
  }

  Widget _buildCard(String title, String count, IconData icon, Color bcolor, Color tcolor,
      // VoidCallback onTap
      ) {
    return Expanded(
      child: GestureDetector(
        // onTap: onTap,
        child: Card(
          color:  bcolor.withOpacity(0.3) ,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 30, color: tcolor),
                // const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: tcolor),
                ),
                const SizedBox(height: 4),
                Text(
                  count,
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold, color: tcolor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// IconButton(
//   icon: const Icon(Icons.delete, color: Colors.red),
//   onPressed: () async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => DeleteVaultScreen(vaultId: vault.id),
//       ),
//     );
//
//     // If the deletion was successful, refresh the UI
//     if (result == true) {
//       await _refreshVaults();
//     }
//   },
// ),