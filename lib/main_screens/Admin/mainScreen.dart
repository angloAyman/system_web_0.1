import 'package:flutter/material.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/billes/data/repositories/bill_repository.dart';
import 'package:system/features/billes/presentation/BillingPage.dart';
import 'package:system/features/billes/presentation/Dialog/adding/bill/showAddBillDialog.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}




class _MainscreenState extends State<Mainscreen> {
  final BillRepository _billRepository = BillRepository();

  void addBill(Bill bill, payment, report) async {
    try {
      // await _billRepository.addBill(bill);
      await _billRepository.addBill(bill, payment, report);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding bill: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 50),
            // Logo section
            Center(
              child: Image.asset(
                "assets/logo/logo-3.png",
                width: 300,
                height: 300,
              ),
            ),
            SizedBox(height: 50), // Space between logo and buttons

            // Buttons row section
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    _buildButton(
                      text: "اضافة فاتورة",
                      icon: Icons.file_copy_outlined,
                      onPressed: () {
                       showAddBillDialog(
                          context: context,
                          onAddBill: addBill,
                        ).then((_) {
                         Navigator.pushReplacementNamed(context, '/billing'); // توجيه المستخدم إلى صفحة تسجيل الدخول
                       });


                      },
                    ),
                    _buildButton(
                      text: "اضافة صنف",
                      icon: Icons.book,
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/Category'); // توجيه المستخدم إلى صفحة تسجيل الدخول

                      },
                    ),
                    _buildButton(
                      text: "اضافة عميل",
                      icon: Icons.supervised_user_circle_sharp,
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/customer'); // توجيه المستخدم إلى صفحة تسجيل الدخول

                      },
                    ),
                    _buildButton(
                      text: "ايداع مبلع",
                      icon: Icons.payment,
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/Payment'); // توجيه المستخدم إلى صفحة تسجيل الدخول

                      },
                    ),
                    _buildButton(
                      text: "سحب مبلع",
                      icon: Icons.payment,
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/Payment'); // توجيه المستخدم إلى صفحة تسجيل الدخول

                      },
                    ),
                    _buildButton(
                      text: "طباعة تقرير",
                      icon: Icons.add_business_sharp,
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/ItemsReport'); // توجيه المستخدم إلى صفحة تسجيل الدخول
                      },
                    ),
                  ],
                ),
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
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(
        text,
        textDirection: TextDirection.rtl, // Right-to-left text
      ),
    );
  }
}
