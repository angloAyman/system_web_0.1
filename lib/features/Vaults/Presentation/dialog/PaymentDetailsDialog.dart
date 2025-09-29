import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:system/Adminfeatures/Vaults/data/repositories/supabase_vault_repository.dart';
import 'package:system/Adminfeatures/Vaults/pdf/generatePaymentDetailsPdf.dart';

class PaymentDetailsDialog extends StatelessWidget {
  final String vaultName;

  PaymentDetailsDialog({Key? key, required this.vaultName}) : super(key: key);

  final SupabaseVaultRepository _vaultRepository = SupabaseVaultRepository();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('تفاصيل المدفعات بالخزنة (${vaultName})'),

    // title: const Text('تفاصيل المدفعات'),
      content: FutureBuilder<List<Map<String, dynamic>>>(
        future: _vaultRepository.getPaymentsByVaultId(vaultName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('حدث خطأ: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('لا توجد دفعات لهذه الخزنة.');
          }

          final payments = snapshot.data!;

          return SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('المسلسل', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('التاريخ', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('اسم المستخدم', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('المبلغ', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('الوصف', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: payments.map((payment) {
                  String formattedDate = '';
                  if (payment['timestamp'] != null) {
                    try {
                      final DateTime date = DateTime.parse(payment['timestamp']);
                      formattedDate = DateFormat('dd/MM/yyyy').format(date); // Format the date
                    } catch (e) {
                      formattedDate = 'غير معروف'; // Handle invalid date format
                    }
                  }
                  return DataRow(cells: [
                    DataCell(Text('${payment['id']}')),
                    DataCell(Text(formattedDate)), // Display formatted date
                    DataCell(Text('${payment['userName']}')),
                    DataCell(Text('${payment['amount']}')),
                    DataCell(Text(payment['description'] ?? 'لا يوجد وصف')),
                  ]);
                }).toList(),
              ),
            ),
          );
        },
      ),
      actions: [
        // TextButton(
        //   onPressed: () => Navigator.of(context).pop(),
        //   child: const Text('إغلاق'),
        // ),
        ElevatedButton(
          onPressed: () async {
            final payments = await _vaultRepository.getPaymentsByVaultId(vaultName);
            await generatePaymentDetailsPdf(payments, vaultName);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('تم إنشاء ملف PDF بنجاح!')),
            );
          },
          child: const Text('تصدير PDF'),
        ),

        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إغلاق'),
        ),
      ],
    );
  }
}
