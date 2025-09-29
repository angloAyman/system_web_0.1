// import 'package:flutter/material.dart';
// import 'package:system/core/themes/AppColors/them_constants.dart';
// import 'package:system/features/Vaults/Presentation/dialog/PaymentDialog.dart';
// import 'package:system/features/billes/FavoriteBillsPage.dart';
// import 'package:system/features/billes/data/models/bill_model.dart';
// import 'package:system/features/billes/data/repositories/bill_repository.dart';
// import 'package:system/features/billes/presentation/Dialog/adding/bill/showAddBillDialog.dart';
// import 'package:system/features/billes/presentation/Dialog/details-editing-pdf/bill/showBillDetailsDialog.dart';
// import 'package:system/main_screens/mobile_screens/bills/dialog/add_Bills/showAddBillDialog_mobileLayout.dart';
// class MainscreenMobile extends StatefulWidget {
//   const MainscreenMobile({super.key});
//
//   @override
//   State<MainscreenMobile> createState() => _MainscreenMobileState();
// }
//
// class _MainscreenMobileState extends State<MainscreenMobile> {
//   final BillRepository _billRepository = BillRepository();
//   late Future<List<Bill>> _favoriteBillsFuture;
//   late Future<List<Bill>> _NotfavoriteBillsFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _favoriteBillsFuture = _billRepository.getFavoriteBills(); // Fetch favorite bills
//     _NotfavoriteBillsFuture = _billRepository.getNotFavoriteBills(); // Fetch not favorite bills
//   }
//
//   // Function to add a bill
//   void addBill(Bill bill, payment, report) async {
//     try {
//       await _billRepository.addBill(bill, payment, report);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('تم إضافة الفاتورة بنجاح')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('خطأ في إضافة الفاتورة: $e')),
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
//           title: const Text("اختار نوع التقرير"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 title: const Text("إنشاء تقرير"),
//
//                 onTap: () {
//                   Navigator.pushReplacementNamed(context, '/ItemsReport');
//                   // Navigator.of(context).pop();
//                 },
//               ),
//               ListTile(
//                 title: const Text("المنتجات والفواتير"),
//                 onTap: () {
//                   Navigator.pushReplacementNamed(context, '/ItemsCharts');
//                   // Navigator.of(context).pop();
//                 },
//               ),
//               ListTile(
//                 title: const Text("تقارير عمليات الصنف"),
//                 onTap: () {
//                   Navigator.pushReplacementNamed(context, '/CategoryReport');
//                   // Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             SizedBox(height: 10,),
//             Expanded(
//               child: Center(
//                  child: SingleChildScrollView(
//                    child: Wrap(
//                      alignment: WrapAlignment.center,
//                      spacing: 20,
//                      runSpacing: 20,
//                      children: [
//                        _buildButton(
//                          text: "الحضور و الانصراف",
//                          icon: Icons.back_hand_outlined,
//                          onPressed: () {
//                              Navigator.pushReplacementNamed(context, '/TimeScreen');
//                            }
//                        ), _buildButton(
//                          text: "إضافة فاتورة",
//                          icon: Icons.file_copy_outlined,
//                          onPressed: () {
//                            showAddBillDialogMobile(
//                              context: context,
//                              onAddBill: addBill,
//                            ).then((_) {
//                              Navigator.pushReplacementNamed(context, '/billingmobile');
//                            });
//                          },
//                        ),
//                        _buildButton(
//                          text: "إضافة صنف",
//                          icon: Icons.book,
//                          onPressed: () {
//                            Navigator.pushReplacementNamed(context, '/Category');
//                          },
//                        ),
//                        _buildButton(
//                          text: "إضافة عميل",
//                          icon: Icons.supervised_user_circle_sharp,
//                          onPressed: () {
//                            Navigator.pushReplacementNamed(context, '/customer');
//                          },
//                        ),
//                        _buildButton(
//                          text: "إيداع مبلغ",
//                          icon: Icons.payment,
//                          onPressed: () {
//                            Navigator.pushReplacementNamed(context, '/Payment');
//                          },
//                        ),
//                        _buildButton(
//                          text: "المصروفات",
//                          icon: Icons.payment,
//                          onPressed: () {
//                            showDialog(context: context,
//                                builder: (context) => PaymentDialog(),
//                            ).then((_) =>Navigator.pushReplacementNamed(context,'/Payment') ,);
//                            // PaymentDialog();
//                          },
//                        ),
//                        _buildButton(
//                          text: "طباعة تقرير",
//                          icon: Icons.add_business_sharp,
//                          onPressed: () {
//                            _showReportSelectionDialog(context);
//                          },
//                        ),
//                      ],
//                    ),
//                  ),
//               ),
//             ),
//
//             Text("الجدول التنفيذي",style: TextStyle(fontSize: 20),),
//             Text("_________",style: TextStyle(fontSize: 20),),
//
//             Expanded(
//           child: FutureBuilder<List<Bill>>(
//             future: _favoriteBillsFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (snapshot.hasError) {
//                 return Center(child: Text('خطأ: ${snapshot.error}'));
//               } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                 return const Center(child: Text('لا توجد فواتير مفضلة.'));
//               }
//
//               final favoriteBills = snapshot.data!;
//
//               return ListView.builder(
//                 itemCount: favoriteBills.length,
//                 itemBuilder: (context, index) {
//                   final bill = favoriteBills[index];
//
//                   return Card(
//                     margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                     child: ListTile(
//                       title: Text('رقم الفاتورة: ${bill.id}'),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('اسم العميل: ${bill.customerName}'),
//                           Text('الحالة: ${bill.status}'),
//                           Text('التفاصيل: ${bill.description}'),
//                         ],
//                       ),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.visibility, color: Colors.blue),
//                             onPressed: () {
//                               showBillDetailsDialog(context, bill);
//                             },
//                           ),
//                           IconButton(
//                             icon: Icon(
//                               bill.isFavorite
//                                   ? Icons.favorite
//                                   : Icons.favorite_border,
//                               color: bill.isFavorite ? AppColors.primary : null,
//                             ),
//                             onPressed: () async {
//                               try {
//                                 _billRepository.removeFromFavorites(bill);
//
//                                 setState(() {
//                                   bill.isFavorite = false;
//                                   _favoriteBillsFuture = _billRepository.getFavoriteBills();
//                                   _NotfavoriteBillsFuture = _billRepository.getNotFavoriteBills();
//                                 });
//
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(content: Text('تمت إزالة الفاتورة من المفضلة')),
//                                 );
//                               } catch (e) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(content: Text('حدث خطأ: ${e.toString()}')),
//                                 );
//                               }
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//
//
//
//             Text("الجدول الفواتير التامة",style: TextStyle(fontSize: 20),),
//             Text("_________",style: TextStyle(fontSize: 20),),
//
//
//         Expanded(
//           child: FutureBuilder<List<Bill>>(
//             future: _NotfavoriteBillsFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (snapshot.hasError) {
//                 return Center(child: Text('خطأ: ${snapshot.error}'));
//               } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                 return const Center(child: Text('لا توجد فواتير غير مفضلة.'));
//               }
//
//               final notFavoriteBills = snapshot.data!;
//
//               return ListView.builder(
//                 itemCount: notFavoriteBills.length,
//                 itemBuilder: (context, index) {
//                   final bill = notFavoriteBills[index];
//
//                   return Card(
//                     margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                     child: ListTile(
//                       title: Text('رقم الفاتورة: ${bill.id}'),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('اسم العميل: ${bill.customerName}'),
//                           Text('الحالة: ${bill.status}'),
//                           Text('التفاصيل: ${bill.description}'),
//                         ],
//                       ),
//                       trailing: IconButton(
//                         icon: const Icon(Icons.visibility, color: Colors.blue),
//                         onPressed: () {
//                           showBillDetailsDialog(context, bill);
//                         },
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//         ],
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
//     return
//       InkWell(
//         onTap: onPressed,
//         highlightColor: AppColors.back,
//         // Add highlight effect on tap
//         splashColor: AppColors.baby,
//         // Splash effect color
//         child: Card(
//           elevation: 4,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   icon,
//                   size: 23,
//                   color: AppColors.background2,
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   text,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//   }
//
//
//   }
import 'package:flutter/material.dart';
import 'package:system/core/themes/AppColors/them_constants.dart';
import 'package:system/features/Vaults/Presentation/dialog/PaymentDialog.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/billes/data/repositories/bill_repository.dart';
import 'package:system/features/billes/presentation/Dialog/adding/bill/showAddBillDialog.dart';
import 'package:system/features/billes/presentation/Dialog/details-editing-pdf/bill/showBillDetailsDialog.dart';
import 'package:system/features/category/presentation/screens/category_page.dart';
import 'package:system/main_screens/mobile_screens/Drawer/ItemsReportDashboardMobile.dart';
import 'package:system/main_screens/mobile_screens/Drawer/LoginTablePageMobile.dart';
import 'package:system/main_screens/mobile_screens/Drawer/PaymentPageMobile.dart';
import 'package:system/main_screens/mobile_screens/Drawer/ReportCategoryOperationsPageMobile.dart';
import 'package:system/main_screens/mobile_screens/Drawer/VaultsPageMobile.dart';
import 'package:system/main_screens/mobile_screens/bills/BillingPage_mobileLayout.dart';
import 'package:system/main_screens/mobile_screens/bills/dialog/add_Bills/showAddBillDialog_mobileLayout.dart';

import 'Drawer/CustomerPageMobile.dart';

class MainscreenMobile extends StatefulWidget {
  const MainscreenMobile({super.key});

  @override
  State<MainscreenMobile> createState() => _MainscreenMobileState();
}

class _MainscreenMobileState extends State<MainscreenMobile> {
  final BillRepository _billRepository = BillRepository();
  late Future<List<Bill>> _favoriteBillsFuture;
  late Future<List<Bill>> _NotfavoriteBillsFuture;

  @override
  void initState() {
    super.initState();
    _favoriteBillsFuture = _billRepository.getFavoriteBills();
    _NotfavoriteBillsFuture = _billRepository.getNotFavoriteBills();
  }

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

  void _showReportSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("اختار نوع التقرير"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ListTile(
            //   title: const Text("إنشاء تقرير"),
            //   onTap: () => Navigator.pushReplacementNamed(context, '/ItemsReport'),
            // ),
            ListTile(
              title: const Text("المنتجات والفواتير"),
              onTap: () {
                // Navigator.pushReplacementNamed(context, '/ItemsCharts');

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ItemsReportDashboardMobile()),
                );

              },
            ),
            ListTile(
              title: const Text("تقارير عمليات الصنف"),
              onTap: () {
                // Navigator.pushReplacementNamed(context, '/CategoryReport');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportCategoryOperationsPageMobile()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildButton("الحضور و الانصراف", Icons.back_hand_outlined,
                        () {
                          // Navigator.pushReplacementNamed(context, '/TimeScreen');
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => LoginTablePageMobile()),
                          // );
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginTablePageMobile()),
                          );


                        }),
                _buildButton("إضافة فاتورة", Icons.file_copy_outlined, () {
                  showAddBillDialogMobile(
                    context: context,
                    onAddBill: addBill,
                  ).then((_) {
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => BillingPagemobile()),
                    // );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BillingPagemobile()),
                    );


                    // return Navigator.pushReplacementNamed(context, '/billingmobile');
                  });
                }),
                _buildButton("إضافة صنف", Icons.book,
                        () {
                          // Navigator.pushReplacementNamed(context, '/Category');

                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => CategoryPage()),
                          // );

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CategoryPage()),
                          );
                        }),
                _buildButton("إضافة عميل", Icons.supervised_user_circle_sharp,
                        () {
                          // Navigator.pushReplacementNamed(context, '/customer');
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => CustomerPageMobile()),
                          // );
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CustomerPageMobile()),
                          );
                        }),
                _buildButton("القسم المالي", Icons.payment,
                        () {
                          // Navigator.pushReplacementNamed(context, '/Payment');

                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => PaymentPageMobile()),
                          // );
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PaymentPageMobile()),
                          );
                        }),
                _buildButton(" اضافة المصروفات", Icons.payment, () {
                  showDialog(context: context, builder: (_) {
                    return PaymentDialog();
                  })

                      .then((_) {
                        return
                        //   Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => VaultsPageMobile(userRole: "admin",)),
                        // );
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => VaultsPageMobile(userRole: "admin",)),
                          );
                      });
                }),
                _buildButton("طباعة تقرير", Icons.add_business_sharp,
                        () => _showReportSelectionDialog(context)),
              ],
            ),

            const SizedBox(height: 20),
            const Text("الجدول التنفيذي", textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
            const Divider(),

            FutureBuilder<List<Bill>>(
              future: _favoriteBillsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('خطأ: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('لا توجد فواتير مفضلة.'));
                }

                return Column(
                  children: snapshot.data!
                      .map((bill) => _buildBillCard(bill, isFavoriteList: true))
                      .toList(),
                );
              },
            ),

            const SizedBox(height: 20),
            const Text("الجدول الفواتير التامة", textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
            const Divider(),

            FutureBuilder<List<Bill>>(
              future: _NotfavoriteBillsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('خطأ: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('لا توجد فواتير غير مفضلة.'));
                }

                return Column(
                  children: snapshot.data!
                      .map((bill) => _buildBillCard(bill, isFavoriteList: false))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: 100,
      child: InkWell(
        onTap: onPressed,
        highlightColor: AppColors.back,
        splashColor: AppColors.baby,
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Icon(icon, size: 22, color: AppColors.background2),
                const SizedBox(height: 6),
                Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBillCard(Bill bill, {required bool isFavoriteList}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: ListTile(
        title: Text('رقم الفاتورة: ${bill.id}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('اسم العميل: ${bill.customerName}'),
            Text('الحالة: ${bill.status}'),
            Text('التفاصيل: ${bill.description}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.visibility, color: Colors.blue),
              onPressed: () => showBillDetailsDialog(context, bill),
            ),
            if (isFavoriteList)
              IconButton(
                icon: Icon(
                  bill.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: bill.isFavorite ? AppColors.primary : null,
                ),
                onPressed: () async {
                  try {
                    _billRepository.removeFromFavorites(bill);
                    setState(() {
                      bill.isFavorite = false;
                      _favoriteBillsFuture = _billRepository.getFavoriteBills();
                      _NotfavoriteBillsFuture = _billRepository.getNotFavoriteBills();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تمت إزالة الفاتورة من المفضلة')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('حدث خطأ: ${e.toString()}')),
                    );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}



// Expanded(
//   child: FutureBuilder<List<Bill>>(
//     future: _favoriteBillsFuture,
//     builder: (context, snapshot) {
//       if (snapshot.connectionState == ConnectionState.waiting) {
//         return const Center(child: CircularProgressIndicator());
//       } else if (snapshot.hasError) {
//         return Center(
//           child: Text('خطأ: ${snapshot.error}'),
//         );
//       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//         return const Center(
//           child: Text('لا توجد فواتير مفضلة.'),
//         );
//       }
//
//       final favoriteBills = snapshot.data!;
//
//       return SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: DataTable(
//           columns: const [
//             DataColumn(label: Text('رقم الفاتورة')),
//             DataColumn(label: Text('اسم العميل')),
//             DataColumn(label: Text('الحالة')),
//             DataColumn(label: Text('تفاصيل')),
//             DataColumn(label: Text('الإجراءات')), // Action column
//           ],
//           rows: favoriteBills.map((bill) {
//             return DataRow(cells: [
//               DataCell(Text('${bill.id}')),
//               DataCell(Text(bill.customerName)),
//               DataCell(Text(bill.status)),
//               DataCell(Text(bill.description)),
//               DataCell(
//                 Row(
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.visibility),
//                       color: Colors.blue,
//                       onPressed: () {
//                         // Action for "View"
//                         showBillDetailsDialog(context, bill ,);
//                       },
//                     ),
//
//                     IconButton(
//                       icon: Icon(
//                         bill.isFavorite
//                             ? Icons.account_balance
//                             : Icons.account_balance_outlined,
//                         color: bill.isFavorite ? AppColors.primary : null,
//                       ),
//                       onPressed: () async {
//                         try {
//                           // Call the method to remove from favorites
//                           _billRepository.removeFromFavorites(bill);
//                           _favoriteBillsFuture;
//                           _NotfavoriteBillsFuture;
//                           // Update the UI
//                           setState(()  {
//                             bill.isFavorite = false;
//                             _favoriteBillsFuture = _billRepository.getFavoriteBills(); // Fetch favorite bills
//                             _NotfavoriteBillsFuture = _billRepository.getNotFavoriteBills();
//                           });
//
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                                 content:
//                                 Text('تمت إزالة الفاتورة من المفضلة')),
//                           );
//
//                         } catch (e) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                                 content: Text('حدث خطأ: ${e.toString()}')),
//                           );
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ]);
//           }).toList(),
//         ),
//       );
//     },
//   ),
// ),


// Expanded(
//   child: FutureBuilder<List<Bill>>(
//     future: _NotfavoriteBillsFuture,
//     builder: (context, snapshot) {
//       if (snapshot.connectionState == ConnectionState.waiting) {
//         return const Center(child: CircularProgressIndicator());
//       } else if (snapshot.hasError) {
//         return Center(
//           child: Text('خطأ: ${snapshot.error}'),
//         );
//       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//         return const Center(
//           child: Text('لا توجد فواتير مفضلة.'),
//         );
//       }
//
//       final favoriteBills = snapshot.data!;
//
//       return SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: DataTable(
//           columns: const [
//             DataColumn(label: Text('رقم الفاتورة')),
//             DataColumn(label: Text('اسم العميل')),
//             DataColumn(label: Text('الحالة')),
//             DataColumn(label: Text('تفاصيل')),
//             DataColumn(label: Text('الإجراءات')), // Action column
//           ],
//           rows: favoriteBills.map((bill) {
//             return DataRow(cells: [
//               DataCell(Text('${bill.id}')),
//               DataCell(Text(bill.customerName)),
//               DataCell(Text(bill.status)),
//               DataCell(Text(bill.description)),
//               DataCell(
//                 Row(
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.visibility),
//                       color: Colors.blue,
//                       onPressed: () {
//                         // Action for "View"
//                         showBillDetailsDialog(context, bill ,);
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ]);
//           }).toList(),
//         ),
//       );
//     },
//   ),
// ),



//          Widget _buildButton({
//   required String text,
//   required IconData icon,
//   required VoidCallback onPressed,
// }) {
//   return
//     GestureDetector(
//       onTap: onPressed,
//       child: Card(
//          child: Padding(
//         padding: const EdgeInsets.all(16.0),
//        child: Column(
//          mainAxisSize: MainAxisSize.min,
//          children: [
//            Icon(icon, size: 40 , color: AppColors.background2,),
//            const SizedBox(height: 8),
//            Text(
//              text,
//              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
//            ),
//          ],

//   )),
//   ),
// );
// }
