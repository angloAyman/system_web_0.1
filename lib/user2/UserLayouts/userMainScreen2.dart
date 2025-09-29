import 'package:flutter/material.dart';
import 'package:system/core/themes/AppColors/them_constants.dart';
import 'package:system/features/billes/FavoriteBillsPage.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/billes/data/repositories/bill_repository.dart';
import 'package:system/features/billes/presentation/Dialog/adding/bill/showAddBillDialog.dart';
import 'package:system/features/billes/presentation/Dialog/details-editing-pdf/bill/showBillDetailsDialog.dart';

import '../../features/Vaults/Presentation/dialog/PaymentDialog.dart';

class userMainScreen2 extends StatefulWidget {
  const userMainScreen2({super.key});

  @override
  State<userMainScreen2> createState() => _userMainScreen2State();
}

class _userMainScreen2State extends State<userMainScreen2> {
  final BillRepository _billRepository = BillRepository();
  late Future<List<Bill>> _favoriteBillsFuture;
  late Future<List<Bill>> _NotfavoriteBillsFuture;

  @override
  void initState() {
    super.initState();
    _favoriteBillsFuture =
        _billRepository.getFavoriteBills(); // Fetch favorite bills
    _NotfavoriteBillsFuture =
        _billRepository.getNotFavoriteBills(); // Fetch not favorite bills
  }

  // Function to add a bill
  void addBill(Bill bill, payment, report, preport) async {
    try {
      await _billRepository.addBill(bill, payment, report, preport);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إضافة الفاتورة بنجاح')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في إضافة الفاتورة: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      _buildButton(
                        text: "إضافة فاتورة",
                        icon: Icons.file_copy_outlined,
                        onPressed: () {
                          showAddBillDialog(
                            context: context,
                            onAddBill: addBill,
                          ).then((_) {
                            Navigator.pushReplacementNamed(
                                context, '/userbilling2');
                          });
                        },
                      ),
                      _buildButton(
                        text: "إضافة صنف",
                        icon: Icons.book,
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/UserCategory');
                        },
                      ),
                      _buildButton(
                        text: "إضافة عميل",
                        icon: Icons.supervised_user_circle_sharp,
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/Usercustomer2');
                        },
                      ),
                      _buildButton(
                        text: "إيداع مبلغ",
                        icon: Icons.payment,
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/UserPayment2');
                        },
                      ),
                      _buildButton(
                        text: "اضافة مصروفات",
                        icon: Icons.payment,
                        // onPressed: () {
                        //   Navigator.pushReplacementNamed(context, '/UserPayment2');
                        // },
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => PaymentDialog(),
                          ).then((_) {
                            // Call _refreshVaults after the dialog is closed
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("تم اضافة المصروفات")),
                            );
                          });
                        },
                      ),
                      _buildButton(
                        text: "كشف حساب",
                        icon: Icons.inventory_rounded,
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/CustomerSelectionPage2');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Text(
              "الجدول التنفيذي",
              style: TextStyle(fontSize: 20),
            ),
            Expanded(
              child: FutureBuilder<List<Bill>>(
                future: _favoriteBillsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('خطأ: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('لا توجد فواتير مفضلة.'),
                    );
                  }

                  final favoriteBills = snapshot.data!;

                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('رقم الفاتورة')),
                        DataColumn(label: Text('اسم العميل')),
                        DataColumn(label: Text('الحالة')),
                        DataColumn(label: Text('تفاصيل')),
                        DataColumn(label: Text('الإجراءات')), // Action column
                      ],
                      rows: favoriteBills.map((bill) {
                        return DataRow(cells: [
                          DataCell(Text('${bill.id}')),
                          DataCell(Text(bill.customerName)),
                          DataCell(Text(bill.status)),
                          DataCell(Text(bill.description)),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.visibility),
                                  color: Colors.blue,
                                  onPressed: () {
                                    // Action for "View"
                                    showBillDetailsDialog(
                                      context,
                                      bill,
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    bill.isFavorite
                                        ? Icons.account_balance
                                        : Icons.account_balance_outlined,
                                    color: bill.isFavorite
                                        ? AppColors.primary
                                        : null,
                                  ),
                                  onPressed: () async {
                                    try {
                                      // Call the method to remove from favorites
                                      _billRepository.removeFromFavorites(bill);
                                      _favoriteBillsFuture;
                                      _NotfavoriteBillsFuture;
                                      // Update the UI
                                      setState(() {
                                        bill.isFavorite = false;
                                        _favoriteBillsFuture = _billRepository
                                            .getFavoriteBills(); // Fetch favorite bills
                                        _NotfavoriteBillsFuture =
                                            _billRepository
                                                .getNotFavoriteBills();
                                      });

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'تمت إزالة الفاتورة من المفضلة')),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'حدث خطأ: ${e.toString()}')),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
            Text(
              "الجدول الفواتير التامة",
              style: TextStyle(fontSize: 20),
            ),
            Expanded(
              child: FutureBuilder<List<Bill>>(
                future: _NotfavoriteBillsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('خطأ: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('لا توجد فواتير مفضلة.'),
                    );
                  }

                  final favoriteBills = snapshot.data!;

                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('رقم الفاتورة')),
                        DataColumn(label: Text('اسم العميل')),
                        DataColumn(label: Text('الحالة')),
                        DataColumn(label: Text('تفاصيل')),
                        DataColumn(label: Text('الإجراءات')), // Action column
                      ],
                      rows: favoriteBills.map((bill) {
                        return DataRow(cells: [
                          DataCell(Text('${bill.id}')),
                          DataCell(Text(bill.customerName)),
                          DataCell(Text(bill.status)),
                          DataCell(Text(bill.description)),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.visibility),
                                  color: Colors.blue,
                                  onPressed: () {
                                    // Action for "View"
                                    showBillDetailsDialog(
                                      context,
                                      bill,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      highlightColor: AppColors.back,
      // Add highlight effect on tap
      splashColor: AppColors.baby,
      // Splash effect color
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 45,
                color: AppColors.background2,
              ),
              const SizedBox(height: 8),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
