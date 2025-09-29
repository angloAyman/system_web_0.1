// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:system/features/billes/data/models/bill_model.dart';
// import 'package:system/features/billes/data/repositories/bill_repository.dart';
// import 'package:system/features/billes/presentation/Dialog/adding/bill/AddbillPaymentPage.dart';
// import 'package:system/features/payment/pdf.dart';
//
// class PaymentPageMoblie extends StatefulWidget {
//   const PaymentPageMoblie({Key? key}) : super(key: key);
//
//   @override
//   _PaymentPageMoblieState createState() => _PaymentPageMoblieState();
// }
//
// class _PaymentPageMoblieState extends State<PaymentPageMoblie> {
//   final BillRepository _billRepository = BillRepository();
//   late Future<List<Bill>> _allBillsFuture;
//   final TextEditingController _searchController = TextEditingController();
//
//   List<Bill> _allBills = [];
//   List<Bill> _filteredBills = [];
//   String _selectedStatus = "اجمالي الفواتير";
//
//   int _totalBills = 0;
//   int _paidBills = 0;
//   int _deferredBillsCount = 0;
//   int _openBillsCount = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _allBillsFuture = _loadAllBills();
//     _loadBillCounts();
//     _searchController.addListener(_filterBillsBySearch);
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//
//     super.dispose();
//   }
//
//   Future<List<Bill>> _loadAllBills() async {
//     try {
//       final bills = await _billRepository.getBills();
//       setState(() {
//         _allBills = bills;
//         _filteredBills = bills; // Default view shows all bills
//       });
//       return bills;
//     } catch (error) {
//       print("Error loading bills: $error");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load bills: $error')),
//       );
//       return [];
//     }
//   }
//
//   Future<void> _loadBillCounts() async {
//     try {
//       final totalBills = await _billRepository.getTotalBillsCount();
//       final paidBills = await _billRepository.getPaidBillsCount();
//       final deferredBills = await _billRepository.getDeferredBillsCount();
//       final openBills = await _billRepository.getOpenBillsCount();
//
//       setState(() {
//         _totalBills = totalBills;
//         _paidBills = paidBills;
//         _deferredBillsCount = deferredBills;
//         _openBillsCount = openBills;
//       });
//     } catch (error) {
//       print("Error loading bill counts: $error");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load bill counts: $error')),
//       );
//     }
//   }
//
//   void _filterBills(String status) {
//     setState(() {
//       _selectedStatus = status;
//     });
//     _applyFilters();
//   }
//
//   void _filterBillsBySearch() {
//     _applyFilters();
//   }
//
//   void _applyFilters() {
//     final searchQuery = _searchController.text.toLowerCase();
//     setState(() {
//       _filteredBills = _allBills.where((bill) {
//         // Apply search filter
//         final matchesSearch = searchQuery.isEmpty ||
//             bill.id.toString().contains(searchQuery) ||
//             bill.customerName.toLowerCase().contains(searchQuery);
//
//         // Apply status filter
//         final matchesStatus = _selectedStatus == "اجمالي الفواتير" ||
//             (_selectedStatus == "آجل" && bill.status == "آجل") ||
//             (_selectedStatus == "تم الدفع" && bill.status == "تم الدفع") ||
//             (_selectedStatus == "فاتورة مفتوحة" &&
//                 bill.status == "فاتورة مفتوحة");
//
//         return matchesSearch && matchesStatus;
//       }).toList();
//     });
//   }
//
//   Future<bool> _showAddPaymentDialog(
//       int billId,
//       int payment,
//       String customerName,
//       DateTime billDate,
//       int total_price,
//       ) async {
//     return await showDialog<bool>(
//       context: context,
//       builder: (BuildContext context) {
//         return AddPaymentDialog(
//           billId: billId,
//           payment: payment,
//           customerName: customerName,
//           billDate: billDate,
//           total_price: total_price,
//         );
//       },
//     )??
//         false;
//   }
//
//   Future<List<Map<String, dynamic>>> _fetchPayments(int billId) async {
//     final response = await Supabase.instance.client
//         .from('payment')
//         .select('*, users(name)')
//         .eq('bill_id', billId)
//         .order('date', ascending: false);
//
//     if (response == null) {
//       throw Exception('Failed to fetch payments.');
//     }
//
//     return List<Map<String, dynamic>>.from(response);
//   }
//
//
//   Future<Bill> _fetchBill(int billId) async {
//     try {
//       final response = await Supabase.instance.client
//           .from('bills')
//           .select('*, bill_items(*)')
//           .eq('id', billId)
//           .single(); // ✅ جلب عنصر واحد فقط
//
//       if (response == null) {
//         throw Exception('لم يتم العثور على الفاتورة.');
//       }
//
//       print("بيانات الفاتورة: $response"); // ✅ طباعة البيانات للتحقق
//
//       return Bill.fromJson(response); // ✅ تأكد من أن `Bill` يحتوي على `fromJson`
//     } catch (e) {
//       print("خطأ أثناء جلب الفاتورة: $e"); // ✅ طباعة أي خطأ يحدث
//       throw Exception("حدث خطأ أثناء جلب الفاتورة.");
//     }
//   }
//
//
//   void _showPaymentDetailsDialog(int billId, String customerName,
//       DateTime billDate, int total_price) async {
//     try {
//       final bill = await _fetchBill(billId);
//
//       final payments = await _fetchPayments(billId);
//       final totalPayments = payments.fold(
//           0.0, (sum, payment) => sum + (payment['payment'] ?? 0.0));
//       // حساب المبلغ المتبقي
//       final remainingAmount = total_price - totalPayments;
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('تفاصيل المدفوعات للفاتورة $billId'),
//             content: payments.isEmpty
//                 ? const Text('لا توجد مدفوعات لهذه الفاتورة.')
//                 : SizedBox(
//               width: double.maxFinite,
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: payments.length,
//                 itemBuilder: (context, index) {
//                   final payment = payments[index];
//                   final userName =
//                       payment['users']['name'] ?? 'غير معروف';
//                   return ListTile(
//                     title: Text('المبلغ: ${payment['payment']}'),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                             'التاريخ: ${DateTime.parse(payment['date']).toLocal().toString().split(' ')[0]}'),
//                         Text('المستخدم: $userName'),
//                       ],
//                     ),
//                     trailing: ElevatedButton.icon(
//                       icon: Icon(Icons.picture_as_pdf),
//                       label: Text('استخراج PDF'),
//                       onPressed: () async {
//
//                         await createPDF( context,bill,payment, customerName, billDate,
//                             total_price, totalPayments, remainingAmount);
//                       },
//                     ),
//                   );
//                 },
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: const Text('إغلاق'),
//               ),
//             ],
//           );
//         },
//       );
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('خطأ أثناء تحميل المدفوعات: $error')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('القسم المالي'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.pushReplacementNamed(context, '/adminHome');
//             },
//             icon: const Icon(Icons.home),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Search Bar
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 labelText: 'البحث عن طريق رقم الفاتورة أو اسم العميل',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.search),
//               ),
//             ),
//           ),
//           // Row with Cards
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _buildCard(
//                     'اجمالي الفواتير',
//                     '$_totalBills',
//                     Icons.description,
//                     Colors.blue,
//                     _selectedStatus == "اجمالي الفواتير",
//                         () => _filterBills("اجمالي الفواتير")),
//                 _buildCard(
//                     'تم الدفع',
//                     '$_paidBills',
//                     Icons.check_circle,
//                     Colors.green,
//                     _selectedStatus == "تم الدفع",
//                         () => _filterBills("تم الدفع")),
//                 _buildCard(
//                     'آجل',
//                     '$_deferredBillsCount',
//                     Icons.access_time,
//                     Colors.orange,
//                     _selectedStatus == "آجل",
//                         () => _filterBills("آجل")),
//                 _buildCard(
//                     'فاتورة مفتوحة',
//                     '$_openBillsCount',
//                     Icons.folder_open,
//                     Colors.red,
//                     _selectedStatus == "فاتورة مفتوحة",
//                         () => _filterBills("فاتورة مفتوحة")),
//               ],
//             ),
//           ),
//           // Filtered Bills List
//           Expanded(
//             child: _filteredBills.isEmpty
//                 ? const Center(
//               child: Text(
//                 'لا توجد فواتير متاحة للفلتر المحدد.',
//                 style: TextStyle(fontSize: 18),
//               ),
//             )
//                 : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ListView.builder(
//                 itemCount: _filteredBills.length,
//                 itemBuilder: (context, index) {
//                   final bill = _filteredBills[index];
//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8.0),
//                     child: ListTile(
//                       title: Text('رقم الفاتورة: ${bill.id}'),
//                       subtitle: Text('العميل: ${bill.customerName}'),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           ElevatedButton(
//                             onPressed: () async {
//                               bool result = await _showAddPaymentDialog(
//                                   bill.id,
//                                   bill.payment,
//                                   bill.customerName,
//                                   bill.date,
//                                   bill.total_price);
//
//                               if (result) {
//                                 setState(
//                                         () async {
//
//                                       _loadBillCounts();
//                                     }); // Refresh UI only after async work is completed
//                               }
//                             },
//                             child: const Text('اضافة الدفع'),
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           ElevatedButton(
//                             onPressed: () => _showPaymentDetailsDialog(
//                                 bill.id,
//                                 bill.customerName,
//                                 bill.date as DateTime,
//                                 bill.total_price),
//                             child: const Text(
//                                 ' تفاصيل المدفوعات و الايصالات'),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCard(String title, String count, IconData icon, Color color,
//       bool isSelected, VoidCallback onTap) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: Card(
//           color: isSelected ? color.withOpacity(0.3) : color.withOpacity(0.1),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(icon, size: 40, color: color),
//                 const SizedBox(height: 8),
//                 Text(
//                   title,
//                   style: TextStyle(
//                       fontSize: 16, fontWeight: FontWeight.bold, color: color),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   count,
//                   style: TextStyle(
//                       fontSize: 24, fontWeight: FontWeight.bold, color: color),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/billes/data/repositories/bill_repository.dart';
import 'package:system/features/billes/presentation/Dialog/adding/bill/AddbillPaymentPage.dart';
import 'package:system/features/payment/pdf.dart';
import 'package:system/main_screens/mobile_screens/Drawer/widget/PaymentPageMobile/AddPaymentDialogMobile.dart';

class PaymentPageMobile extends StatefulWidget {
  const PaymentPageMobile({Key? key}) : super(key: key);

  @override
  _PaymentPageMobileState createState() => _PaymentPageMobileState();
}

class _PaymentPageMobileState extends State<PaymentPageMobile> {
  final BillRepository _billRepository = BillRepository();
  late Future<List<Bill>> _allBillsFuture;
  final TextEditingController _searchController = TextEditingController();

  List<Bill> _allBills = [];
  List<Bill> _filteredBills = [];
  String _selectedStatus = "اجمالي الفواتير";

  int _totalBills = 0;
  int _paidBills = 0;
  int _deferredBillsCount = 0;
  int _openBillsCount = 0;

  @override
  void initState() {
    super.initState();
    _allBillsFuture = _loadAllBills();
    _loadBillCounts();
    _searchController.addListener(_filterBillsBySearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Bill>> _loadAllBills() async {
    try {
      final bills = await _billRepository.getBills();
      setState(() {
        _allBills = bills;
        _filteredBills = bills;
      });
      return bills;
    } catch (error) {
      _showErrorSnackBar('فشل في تحميل الفواتير: $error');
      return [];
    }
  }

  Future<void> _loadBillCounts() async {
    try {
      final totalBills = await _billRepository.getTotalBillsCount();
      final paidBills = await _billRepository.getPaidBillsCount();
      final deferredBills = await _billRepository.getDeferredBillsCount();
      final openBills = await _billRepository.getOpenBillsCount();

      setState(() {
        _totalBills = totalBills;
        _paidBills = paidBills;
        _deferredBillsCount = deferredBills;
        _openBillsCount = openBills;
      });
    } catch (error) {
      _showErrorSnackBar('فشل في تحميل الاحصائيات: $error');
    }
  }

  void _filterBills(String status) {
    setState(() {
      _selectedStatus = status;
    });
    _applyFilters();
  }

  void _filterBillsBySearch() {
    _applyFilters();
  }

  void _applyFilters() {
    final searchQuery = _searchController.text.toLowerCase();
    setState(() {
      _filteredBills = _allBills.where((bill) {
        final matchesSearch = searchQuery.isEmpty ||
            bill.id.toString().contains(searchQuery) ||
            bill.customerName.toLowerCase().contains(searchQuery);
        final matchesStatus = _selectedStatus == "اجمالي الفواتير" ||
            (_selectedStatus == "آجل" && bill.status == "آجل") ||
            (_selectedStatus == "تم الدفع" && bill.status == "تم الدفع") ||
            (_selectedStatus == "فاتورة مفتوحة" && bill.status == "فاتورة مفتوحة");

        return matchesSearch && matchesStatus;
      }).toList();
    });
  }

  Future<List<Map<String, dynamic>>> _fetchPayments(int billId) async {
    final response = await Supabase.instance.client
        .from('payment')
        .select('*, users(name)')
        .eq('bill_id', billId)
        .order('date', ascending: false);

    if (response == null) {
      throw Exception('Failed to fetch payments.');
    }

    return List<Map<String, dynamic>>.from(response);
  }


  Future<Bill> _fetchBill(int billId) async {
    try {
      final response = await Supabase.instance.client
          .from('bills')
          .select('*, bill_items(*)')
          .eq('id', billId)
          .single(); // ✅ جلب عنصر واحد فقط

      if (response == null) {
        throw Exception('لم يتم العثور على الفاتورة.');
      }

      print("بيانات الفاتورة: $response"); // ✅ طباعة البيانات للتحقق

      return Bill.fromJson(response); // ✅ تأكد من أن `Bill` يحتوي على `fromJson`
    } catch (e) {
      print("خطأ أثناء جلب الفاتورة: $e"); // ✅ طباعة أي خطأ يحدث
      throw Exception("حدث خطأ أثناء جلب الفاتورة.");
    }
  }


  Future<void> _showPaymentDetailsDialog(
      int billId, String customerName, DateTime billDate, double total_price) async {
    try {
      final bill = await _fetchBill(billId);
      final payments = await _fetchPayments(billId);

      final totalPayments = payments.fold(
          0.0, (sum, payment) => sum + (payment['payment'] ?? 0.0));
      final remainingAmount = total_price - totalPayments;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('تفاصيل المدفوعات للفاتورة $billId'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bill summary
                  Text(
                    'العميل: $customerName',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text('تاريخ الفاتورة: ${billDate.toLocal().toString().split(' ')[0]}'),
                  SizedBox(height: 4),
                  Text('اجمالي الفاتورة: $total_price جنيه'),
                  SizedBox(height: 4),
                  Text('اجمالي المدفوعات: $totalPayments جنيه'),
                  SizedBox(height: 4),
                  Text('المتبقي: $remainingAmount جنيه'),
                  Divider(),

                  // Payments list
                  payments.isEmpty
                      ? Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Text('لا توجد مدفوعات لهذه الفاتورة.'),
                    ),
                  )
                      : ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: payments.length,
                    separatorBuilder: (context, index) =>
                        Divider(thickness: 1),
                    itemBuilder: (context, index) {
                      final payment = payments[index];
                      final userName =
                          payment['users']['name'] ?? 'غير معروف';
                      final paymentDate = DateTime.parse(payment['date'])
                          .toLocal()
                          .toString()
                          .split(' ')[0];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('المبلغ: ${payment['payment']} جنيه',
                              style:
                              TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('التاريخ: $paymentDate'),
                          Text('المستخدم: $userName'),
                          SizedBox(height: 8),
                          ElevatedButton.icon(
                            icon: Icon(Icons.picture_as_pdf),
                            label: Text('استخراج PDF'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 36),
                              textStyle: TextStyle(fontSize: 14),
                            ),
                            onPressed: () async {
                              await createPDF(
                                context,
                                bill,
                                payment,
                                customerName,
                                billDate,
                                total_price,
                                totalPayments,
                                remainingAmount,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                children: [
                  TextButton(
                    onPressed: () => _showAddPaymentDialog(
                        bill.id,
                        bill.payment,
                        bill.customerName,
                        bill.date,
                        bill.total_price),
                    child: const Text('اضافة دفع'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('إغلاق'),
                  ),
                ],
              ),
            ],
          );
        },
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ أثناء تحميل المدفوعات: $error')),
      );
    }
  }


  Future<bool> _showAddPaymentDialog(
      int billId,
      double payment,
      String customerName,
      DateTime billDate,
      double total_price) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AddPaymentDialogMobile(
        billId: billId,
        payment: payment,
        customerName: customerName,
        billDate: billDate,
        total_price: total_price,
      ),
    ) ??
        false;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildCard(String title, String count, IconData icon, Color color,
      bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: isSelected ? color.withOpacity(0.3) : color.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 32, color: color),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold, color: color),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  count,
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('القسم المالي'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/adminHome'),
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'بحث برقم الفاتورة أو اسم العميل',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            // Cards Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  _buildCardRow(
                      ['اجمالي الفواتير', 'تم الدفع'],
                      [_totalBills.toString(), _paidBills.toString()],
                      [Icons.description, Icons.check_circle],
                      [Colors.blue, Colors.green]),
                  _buildCardRow(
                      ['آجل', 'فاتورة مفتوحة'],
                      [_deferredBillsCount.toString(), _openBillsCount.toString()],
                      [Icons.access_time, Icons.folder_open],
                      [Colors.orange, Colors.red]),
                ],
              ),
            ),
            // Filtered Bills List
            _filteredBills.isEmpty
                ? const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('لا توجد فواتير متاحة.',
                    style: TextStyle(fontSize: 16)),
              ),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _filteredBills.length,
              itemBuilder: (context, index) {
                final bill = _filteredBills[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text('رقم الفاتورة: ${bill.id}'),
                    subtitle: Text('العميل: ${bill.customerName}'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () => _showPaymentDetailsDialog(
                        bill.id,
                        bill.customerName,
                        bill.date as DateTime,
                        bill.total_price),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardRow(List<String> titles, List<String> counts,
      List<IconData> icons, List<Color> colors) {
    return Row(
      children: List.generate(
        titles.length,
            (index) => _buildCard(
            titles[index],
            counts[index],
            icons[index],
            colors[index],
            _selectedStatus == titles[index],
                () => _filterBills(titles[index])),
      ),
    );
  }


}
