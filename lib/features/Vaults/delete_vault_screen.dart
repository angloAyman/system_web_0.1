// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// class DeleteVaultScreen extends StatefulWidget {
//   final String vaultId;
//
//   DeleteVaultScreen({required this.vaultId});
//
//   @override
//   _DeleteVaultScreenState createState() => _DeleteVaultScreenState();
// }
//
// class _DeleteVaultScreenState extends State<DeleteVaultScreen> {
//   final SupabaseClient _client = Supabase.instance.client;
//   List<Map<String, dynamic>> bills = [];
//   List<Map<String, dynamic>> payments = [];
//   List<Map<String, dynamic>> vaults = [];
//
//   Set<int> selectedBills = {};
//   Set<int> selectedPayments = {};
//   bool selectAllBills = false;
//   bool selectAllPayments = false;
//   String? selectedVaultId;
//
//   int? vaultBalance;
//   String? vaultName;
//
//   int totalBills = 0;
//   // bool isLoading = true;
//   @override
//   void initState() {
//     super.initState();
//
//     _fetchVaultinfo();
//     _fetchData();
//   }
//
//   Future<void> _fetchVaultinfo() async {
//     final billsResponse = await _client
//         .from('bills')
//         .select('id, payment')
//         .eq('vault_id', widget.vaultId)
//     ;
//
//
//     vaultBalance = await getVaultBalance(widget.vaultId);
//     vaultName = await getVaultNane(widget.vaultId);
//     bills = List<Map<String, dynamic>>.from(billsResponse ?? []);
//     totalBills = bills.length;
//
//     setState(() {}); // Refresh UI with the fetched balance
//   }
//
//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("خطأ",
//               style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
//           content: Text(message, style: TextStyle(fontSize: 16)),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text("موافق", style: TextStyle(fontSize: 16)),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void showLoadingDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false, // يمنع إغلاق النافذة أثناء التحميل
//       builder: (context) {
//         return AlertDialog(
//           content: Row(
//             children: [
//               CircularProgressIndicator(),
//               SizedBox(width: 20),
//               Text("جاري تحميل بيانات الفاتورة..."),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> _fetchData() async {
//     // showLoadingDialog();
//     try {
//       final billsResponse = await _client
//           .from('bills')
//           .select('id, payment')
//           .eq('vault_id', widget.vaultId)
//       ;
//
//       final paymentsResponse = await _client
//           .from('paymentsOut')
//           .select('id, amount')
//           .eq('vault_id', widget.vaultId)
//       ;
//
//       final vaultsResponse = await _client.from('vaults').select(
//           'id, name,balance');
//
//       setState(() {
//         bills = List<Map<String, dynamic>>.from(billsResponse ?? []);
//         payments = List<Map<String, dynamic>>.from(paymentsResponse ?? []);
//         vaults = List<Map<String, dynamic>>.from(vaultsResponse ?? []);
//         // totalBills = bills.length;
//
//       });
//     } catch (e) {
//       print("Error fetching data: $e");
//     }
//     // setState(() {
//     //   isLoading = false;
//     // });
//   }
//
//   Future<void> _DeleteVault() async {
//     try {
//       await _client.from('vaults').delete().eq('id', widget.vaultId);
//       Navigator.pop(context, true); // Pass true to indicate success
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('تم حذف الخزنة بنجاح')));
//     } catch (e) {
//       print("Error during transfer or delete: $e");
//     }
//   }
//
//   Future<String?> getVaultNane(String vaultId) async {
//     try {
//       final response = await _client
//           .from('vaults')
//           .select('name')
//           .eq('id', vaultId)
//           .single();
//
//       return response != null ? (response['name'] as String) : null;
//     } catch (e) {
//       print("Error fetching vault balance: $e");
//       return null;
//     }
//   }
//
//
//   // transfer bill
//
//   Future<int?> getVaultBalance(String vaultId) async {
//     try {
//       final response = await _client
//           .from('vaults')
//           .select('balance')
//           .eq('id', vaultId)
//           .single();
//
//       return response != null ? (response['balance'] as int) : null;
//     } catch (e) {
//       print("Error fetching vault balance: $e");
//       return null;
//     }
//   }
//
//
//   Future<void> _transferBill(int billId, String newVaultId,int billpayment) async {
//     try {
//       // Get balance of the selected vault
//       int? newVaultBalance = await getVaultBalance(newVaultId);
//       int? oldVaultBalance = await getVaultBalance(widget.vaultId);
//
//       // Update vault_id in the bill
//       await _client.from('bills').update({'vault_id': newVaultId}).eq(
//           'id', billId);
//
//
//       // Add the bills payment to the new vault
//       await _client.from('vaults').update({
//         'balance': (newVaultBalance ?? 0) + billpayment,
//       }).eq('id', newVaultId);
//
//       // remove the bills payment to the old vault
//       await _client.from('vaults').update({
//         'balance': (oldVaultBalance ?? 0) - billpayment,
//       }).eq('id', widget.vaultId);
//
//       // Refresh data after transfer
//       // await _fetchData();
//       await _fetchVaultinfo();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('تم تحويل الفاتورة بنجاح')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('حدث خطأ أثناء التحويل: $e')),
//       );
//     }
//   }
//
//   void _showTransferDialog(int billId, int billpayment) {
//     String? selectedVaultId;
//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               title: Text("تحويل الفاتورة"),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text("اختر الخزنة الجديدة لهذه الفاتورة:"),
//                   DropdownButton<String>(
//                     isExpanded: true,
//                     value: selectedVaultId,
//                     hint: Text("اختر خزنة"),
//                     items: vaults.where((v) => v['id'] != widget.vaultId).map((
//                         vault) {
//                       return DropdownMenuItem<String>(
//                         value: vault['id'],
//                         child: Text(vault['name']),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         selectedVaultId = value;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: Text("إلغاء"),
//                 ),
//                 ElevatedButton(
//                   onPressed: selectedVaultId == null ? null : () async {
//                     await _transferBill(billId, selectedVaultId!, billpayment);
//                     Navigator.pop(context);
//                   },
//                   child: Text("نقل"),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Future<void> _showTransferSelectionDialog() async {
//     await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("اختر خزنة لتحويل الفواتير"),
//           content: DropdownButton<String>(
//             isExpanded: true,
//             value: selectedVaultId,
//             hint: Text('اختر خزنة لتحويل الفواتير'),
//             items: vaults.where((v) => v['id'] != widget.vaultId).map<DropdownMenuItem<String>>((vault) {
//               return DropdownMenuItem<String>(
//                 value: vault['id'],
//                 child: Text(vault['name']),
//               );
//             }).toList(),
//             onChanged: (value) {
//               setState(() {
//                 selectedVaultId = value;
//               });
//               Navigator.pop(context);
//             },
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> _transferSelectedBills() async {
//     await _showTransferSelectionDialog();
//     if (selectedVaultId == null) {
//       _showErrorDialog("يرجى اختيار خزنة جديدة أولاً.");
//       return;
//     }
//
//     for (int billId in selectedBills) {
//       final bill = bills.firstWhere((b) => b['id'] == billId, orElse: () => {});
//       if (bill.isNotEmpty) {
//         int billPayment = bill['payment'] ?? 0;
//         await _transferBill(billId, selectedVaultId!, billPayment);
//       }
//     }
//     setState(() {
//       selectedBills.clear();
//     });
//   }
//
//   // transfer paymentOut
//   void _showTransferDialogpayment(int paymentId, int paymentpayment) {
//     String? selectedVaultId;
//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               title: Text("تحويل المدفوعات"),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text("اختر الخزنة الجديدة لهذه الفاتورة:"),
//                   DropdownButton<String>(
//                     isExpanded: true,
//                     value: selectedVaultId,
//                     hint: Text("اختر خزنة"),
//                     items: vaults.where((v) => v['id'] != widget.vaultId).map((
//                         vault) {
//                       return DropdownMenuItem<String>(
//                         value: vault['id'],
//                         child: Text(vault['name']),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         selectedVaultId = value;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: Text("إلغاء"),
//                 ),
//                 ElevatedButton(
//                   onPressed: selectedVaultId == null ? null : () async {
//                     await _transferPaymentOut(paymentId, selectedVaultId!, paymentpayment);
//                     Navigator.pop(context);
//                   },
//                   child: Text("نقل"),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Future<void> _transferPaymentOut(int paymentId, String newVaultId,int paymentAmount) async {
//     try {
//       // Get balance of the selected vault
//       int? newVaultBalance = await getVaultBalance(newVaultId);
//       int? oldVaultBalance = await getVaultBalance(widget.vaultId);
//
//       // Update vault_id in the bill
//       await _client.from('paymentsOut').update({'vault_id': newVaultId}).eq(
//           'id', paymentId);
//
//       // Check if the payment amount is greater than the vault balance
//       if (newVaultBalance != null && paymentAmount > newVaultBalance) {
//         _showErrorDialog("المدفوعات أكبر من رصيد الخزينة");
//         return; // Stop execution
//       }
//
//       // Add the payment amount to the new vault
//       await _client.from('vaults').update({
//         'balance': (newVaultBalance ?? 0) - paymentAmount,
//       }).eq('id', newVaultId);
//
//
//       // remove the bills payment to the old vault
//       await _client.from('vaults').update({
//         'balance': (oldVaultBalance ?? 0) - paymentAmount,
//       }).eq('id', widget.vaultId);
//
//       // Refresh data after transfer
//       await _fetchData();
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('تم تحويل الدفعة بنجاح')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('حدث خطأ أثناء التحويل: $e')),
//       );
//     }
//   }
//
//   Future<void> _transferSelectedPaynents() async {
//     await _showTransferSelectionDialog();
//     if (selectedVaultId == null) {
//       _showErrorDialog("يرجى اختيار خزنة جديدة أولاً.");
//       return;
//     }
//
//     for (int paymentId in selectedPayments) {
//       final payment = payments.firstWhere((b) => b['id'] == paymentId, orElse: () => {});
//       if (payment.isNotEmpty) {
//         int paymentPayment = payment['payment'] ?? 0;
//         await _transferPaymentOut(paymentId, selectedVaultId!, paymentPayment);
//       }
//     }
//     setState(() {
//       selectedBills.clear();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('حذف الخزنة'),
//       leading: TextButton.icon(onPressed: (){
//         Navigator.pop(context, true); // Pass true to indicate success
//       }, label: Icon(Icons.arrow_back,size: 20,),),
//       ),
//       body: Column(
//         children: [
//           Column(
//             textDirection: TextDirection.rtl,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//             Text("اسم الخزينة : $vaultName ",style: TextStyle(fontSize: 24),),
//             Text("رصيد الخزينة : $vaultBalance ",style: TextStyle(fontSize: 24),),
//             Text("إجمالي عدد الفواتير المرتبطة: $totalBills", style: TextStyle(fontSize: 24)),
//           ],),
//
//           // if (selectedBills.isNotEmpty)
//
//           Expanded(
//             child: Row(
//               children: [
//                 Expanded(child: _buildBillList(
//                     "الفواتير المرتبطة", bills, selectedBills, selectAllBills, (
//                     value) {
//                   setState(() {
//                     selectAllBills = value;
//                     selectedBills.clear();
//                     if (selectAllBills) {
//                       selectedBills.addAll(bills.map((b) => b['id'] as int));
//                     }
//                   });
//                 })),
//                 Expanded(child: _buildPaymentList(
//                     "المدفوعات المرتبطة", payments, selectedPayments,
//                     selectAllPayments, (value) {
//                   setState(() {
//                     selectAllPayments = value;
//                     selectedPayments.clear();
//                     if (selectAllPayments) {
//                       selectedPayments.addAll(
//                           payments.map((p) => p['id'] as int));
//                     }
//                   });
//                 })),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: ElevatedButton(
//               onPressed: vaultBalance == 0 ? _DeleteVault : null,
//               child: Text('تأكيد الحذف'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//   Widget _buildBillList(String title,
//       List<Map<String, dynamic>> data,
//       Set<int> selectedItems,
//       bool selectAll,
//       Function(bool) onSelectAll) {
//     return Card(
//       margin: EdgeInsets.all(8),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(0,10,0,0),
//             child: ElevatedButton(
//               onPressed: _transferSelectedBills,
//               child: Text('تحويل الفواتير'),
//             ),
//           ),
//
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
//                 Checkbox(value: selectAll,
//                     onChanged: (value) => onSelectAll(value ?? false)),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: data.length,
//               itemBuilder: (context, index) {
//                 final item = data[index];
//                 int itemId = item['id'] as int;
//                 int itempayment = item['payment'] as int;
//                 return ListTile(
//                   leading: Checkbox(
//                     value: selectedItems.contains(itemId),
//                     onChanged: (value) {
//                       setState(() {
//                         if (value == true) {
//                           selectedItems.add(itemId);
//                         } else {
//                           selectedItems.remove(itemId);
//                         }
//                       });
//                     },
//                   ),
//                   title: Text('ID: $itemId'),
//                   subtitle: Text('المبلغ: ${item['payment'] ?? "غير متوفر"}'),
//                   trailing: IconButton(
//                     icon: Icon(Icons.swap_horiz, color: Colors.blue),
//                     onPressed: () => _showTransferDialog(itemId, itempayment),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPaymentList(String title,
//       List<Map<String, dynamic>> data,
//       Set<int> selectedItems,
//       bool selectAll,
//       Function(bool) onSelectAll) {
//     return Card(
//       margin: EdgeInsets.all(8),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(0,10,0,0),
//             child: ElevatedButton(
//               onPressed: _transferSelectedPaynents,
//               child: Text('تحويل المدفوعات'),
//             ),
//           ),
//
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
//                 Checkbox(value: selectAll,
//                     onChanged: (value) => onSelectAll(value ?? false)),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: data.length,
//               itemBuilder: (context, index) {
//                 final item = data[index];
//                 int itemId = item['id'] as int;
//                 int itempayment = item['amount'] as int;
//                 return ListTile(
//                   leading: Checkbox(
//                     value: selectedItems.contains(itemId),
//                     onChanged: (value) {
//                       setState(() {
//                         if (value == true) {
//                           selectedItems.add(itemId);
//                         } else {
//                           selectedItems.remove(itemId);
//                         }
//                       });
//                     },
//                   ),
//                   title: Text('ID: $itemId'),
//                   subtitle: Text('المبلغ: ${item['amount'] ?? "غير متوفر"}'),
//                   trailing: IconButton(
//                     icon: Icon(Icons.swap_horiz, color: Colors.blue),
//                     onPressed: () => _showTransferDialogpayment(itemId, itempayment),
//                   ),
//
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
