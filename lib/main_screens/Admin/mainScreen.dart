// import 'package:flutter/material.dart';
// import 'package:system/features/billes/data/models/bill_model.dart';
// import 'package:system/features/billes/data/repositories/bill_repository.dart';
// import 'package:system/features/billes/presentation/BillingPage.dart';
// import 'package:system/features/billes/presentation/Dialog/adding/bill/showAddBillDialog.dart';
//
// class Mainscreen extends StatefulWidget {
//   const Mainscreen({super.key});
//
//   @override
//   State<Mainscreen> createState() => _MainscreenState();
// }
//
//
//
//
// class _MainscreenState extends State<Mainscreen> {
//   final BillRepository _billRepository = BillRepository();
//
//   void addBill(Bill bill, payment, report) async {
//     try {
//       // await _billRepository.addBill(bill);
//       await _billRepository.addBill(bill, payment, report);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error adding bill: $e')),
//       );
//     }
//   }
//
//   // Function to show the report selection dialog
//   void _showReportSelectionDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("اختار نوع التقرير "),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // انشاء تقرير
//               // '//ItemsReport': (context) => billsReportPage(),
//               ListTile(
//                 title: Text(" انشاء تقرير"),
//                 onTap: () {
//                   Navigator.pushReplacementNamed(context, '/ItemsReport'); // Example route for Category Report
//                   Navigator.of(context).pop();  // Close the dialog
//                 },
//               ),
//
//               // المنتجات و الفواتير
//               // '//ItemsCharts': (context) => ItemsReportDashboard(),
//               ListTile(
//                 title: Text("المنتجات و الفواتير"),
//                 onTap: () {
//                   Navigator.pushReplacementNamed(context, '/ItemsCharts'); // Example route for Payment Report
//                   Navigator.of(context).pop();  // Close the dialog
//                 },
//               ),
//
//               //تقارير عمليات الصنف
//               // '/CategoryReport': (context) => ReportCategoryOperationsPage(),
//               ListTile(
//                 title: Text("تقارير عمليات الصنف"),
//                 onTap: () {
//                   Navigator.pushReplacementNamed(context, '/CategoryReport'); // Example route for Payment Report
//                   Navigator.of(context).pop();  // Close the dialog
//                 },
//               ),
//               // Add more report types here as needed
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             SizedBox(height: 50),
//             // Logo section
//             Center(
//               child: Image.asset(
//                 "assets/logo/logo-3.png",
//                 width: 300,
//                 height: 300,
//               ),
//             ),
//             SizedBox(height: 50), // Space between logo and buttons
//
//             // Buttons row section
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Wrap(
//                   alignment: WrapAlignment.center,
//                   spacing: 20,
//                   runSpacing: 20,
//                   children: [
//                     _buildButton(
//                       text: "اضافة فاتورة",
//                       icon: Icons.file_copy_outlined,
//                       onPressed: () {
//                        showAddBillDialog(
//                           context: context,
//                           onAddBill: addBill,
//                         ).then((_) {
//                          Navigator.pushReplacementNamed(context, '/billing'); // توجيه المستخدم إلى صفحة تسجيل الدخول
//                        });
//
//
//                       },
//                     ),
//                     _buildButton(
//                       text: "اضافة صنف",
//                       icon: Icons.book,
//                       onPressed: () {
//                         Navigator.pushReplacementNamed(context, '/Category'); // توجيه المستخدم إلى صفحة تسجيل الدخول
//
//                       },
//                     ),
//                     _buildButton(
//                       text: "اضافة عميل",
//                       icon: Icons.supervised_user_circle_sharp,
//                       onPressed: () {
//                         Navigator.pushReplacementNamed(context, '/customer'); // توجيه المستخدم إلى صفحة تسجيل الدخول
//
//                       },
//                     ),
//                     _buildButton(
//                       text: "ايداع مبلع",
//                       icon: Icons.payment,
//                       onPressed: () {
//                         Navigator.pushReplacementNamed(context, '/Payment'); // توجيه المستخدم إلى صفحة تسجيل الدخول
//
//                       },
//                     ),
//                     _buildButton(
//                       text: "سحب مبلع",
//                       icon: Icons.payment,
//                       onPressed: () {
//                         Navigator.pushReplacementNamed(context, '/Payment'); // توجيه المستخدم إلى صفحة تسجيل الدخول
//
//                       },
//                     ),
//                     _buildButton(
//                       text: "طباعة تقرير",
//                       icon: Icons.add_business_sharp,
//                       onPressed: () {
//                         _showReportSelectionDialog(context); // Show the report selection dialog
//                         // Navigator.pushReplacementNamed(context, '/ItemsReport'); // توجيه المستخدم إلى صفحة تسجيل الدخول
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildButton({
//     required String text,
//     required IconData icon,
//     required VoidCallback onPressed,
//   }) {
//     return TextButton.icon(
//       onPressed: onPressed,
//       icon: Icon(icon),
//       label: Text(
//         text,
//         textDirection: TextDirection.rtl, // Right-to-left text
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/billes/data/repositories/bill_repository.dart';
import 'package:system/features/billes/presentation/Dialog/adding/bill/showAddBillDialog.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  final BillRepository _billRepository = BillRepository();

  // Function to add a bill
  void addBill(Bill bill, payment, report) async {
    try {
      await _billRepository.addBill(bill, payment, report);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إضافة الفاتورة بنجاح')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في إضافة الفاتورة: $e')),
      );
    }
  }

  // Function to show the report selection dialog
  void _showReportSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("اختار نوع التقرير"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("إنشاء تقرير"),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/ItemsReport');
                  // Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text("المنتجات والفواتير"),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/ItemsCharts');
                  // Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text("تقارير عمليات الصنف"),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/CategoryReport');
                  // Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50),
            // Logo section
            Center(
              child: Image.asset(
                "assets/logo/logo-3.png",
                width: 300,
                height: 300,
                errorBuilder: (context, error, stackTrace) {
                  return const Text(
                    'Logo Not Found',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  );
                },
              ),
            ),
            const SizedBox(height: 50), // Space between logo and buttons

            // Buttons section
            Expanded(
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
                          Navigator.pushReplacementNamed(context, '/billing');
                        });
                      },
                    ),
                    _buildButton(
                      text: "إضافة صنف",
                      icon: Icons.book,
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/Category');
                      },
                    ),
                    _buildButton(
                      text: "إضافة عميل",
                      icon: Icons.supervised_user_circle_sharp,
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/customer');
                      },
                    ),
                    _buildButton(
                      text: "إيداع مبلغ",
                      icon: Icons.payment,
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/Payment');
                      },
                    ),
                    _buildButton(
                      text: "سحب مبلغ",
                      icon: Icons.payment,
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/Payment');
                      },
                    ),
                    _buildButton(
                      text: "طباعة تقرير",
                      icon: Icons.add_business_sharp,
                      onPressed: () {
                        _showReportSelectionDialog(context);
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
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(
        text,
        textDirection: TextDirection.rtl, // Right-to-left text
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(fontSize: 16),
      ),
    );
  }
}
