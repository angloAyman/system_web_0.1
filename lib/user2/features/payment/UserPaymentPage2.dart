import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/billes/data/repositories/bill_repository.dart';
import 'package:system/features/payment/AddPaymentPage.dart';
import 'package:system/features/payment/pdf.dart';

class UserPaymentPage2 extends StatefulWidget {
  const UserPaymentPage2({Key? key}) : super(key: key);

  @override
  _UserPaymentPage2State createState() => _UserPaymentPage2State();
}

class _UserPaymentPage2State extends State<UserPaymentPage2> {
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
      final bills = await _billRepository.getNormalCustomerBills();
      setState(() {
        _allBills = bills;
        _filteredBills = bills; // Default view shows all bills
      });
      return bills;
    } catch (error) {
      print("Error loading bills: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load bills: $error')),
      );
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
      print("Error loading bill counts: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load bill counts: $error')),
      );
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
        // Apply search filter
        final matchesSearch = searchQuery.isEmpty ||
            bill.id.toString().contains(searchQuery) ||
            bill.customerName.toLowerCase().contains(searchQuery);

        // Apply status filter
        final matchesStatus = _selectedStatus == "اجمالي الفواتير" ||
            (_selectedStatus == "آجل" && bill.status == "آجل") ||
            (_selectedStatus == "تم الدفع" && bill.status == "تم الدفع") ||
            (_selectedStatus == "فاتورة مفتوحة" && bill.status == "فاتورة مفتوحة");

        return matchesSearch && matchesStatus;
      }).toList();
    });
  }

  void _showAddPaymentDialog(int billId, String customerName,DateTime billDate,double total_price,) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddPaymentDialog(billId: billId, customerName: customerName,billDate:billDate,total_price:total_price,);
      },
    );
  }

  Future<Bill> _fetchBill(int billId) async {
    final response = await Supabase.instance.client
        .from('bills')
        .select()
        .eq('id', billId)
        .limit(1)
        .single(); // ✅ استخدم .single() لجلب عنصر واحد فقط

    if (response == null) {
      throw Exception('لم يتم العثور على الفاتورة.');
    }

    return Bill.fromJson(response); // تأكد من أن لديك `fromJson` في `Bill`
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

  void _showPaymentDetailsDialog(int billId, String customerName,DateTime billDate,double total_price) async {
    try {
      final payments = await _fetchPayments(billId);
      final totalPayments = payments.fold(0.0, (sum, payment) => sum + (payment['payment'] ?? 0.0));
      // حساب المبلغ المتبقي
      final remainingAmount = total_price - totalPayments;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('تفاصيل المدفوعات للفاتورة $billId'),
            content: payments.isEmpty
                ? const Text('لا توجد مدفوعات لهذه الفاتورة.')
                : SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: payments.length,
                itemBuilder: (context, index) {
                  final payment = payments[index];
                  final userName = payment['users']['name'] ?? 'غير معروف';
                  return ListTile(
                    title: Text('المبلغ: ${payment['payment']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('التاريخ: ${DateTime.parse(payment['date']).toLocal().toString().split(' ')[0]}'),
                        Text('المستخدم: $userName'),
                      ],
                    ),
                    trailing: ElevatedButton.icon(
                      icon: Icon(Icons.picture_as_pdf),
                      label: Text('استخراج PDF'),
                      onPressed: () async {
                        final bill = await _fetchBill(billId);

                        await createPDF(context,bill,payment, customerName, billDate, total_price,totalPayments,remainingAmount);
                      },
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('إغلاق'),
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('القسم المالي'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/userMainScreen2');
            },
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'البحث عن طريق رقم الفاتورة أو اسم العميل',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          // Row with Cards
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCard('اجمالي الفواتير', '$_totalBills', Icons.description, Colors.blue,
                    _selectedStatus == "اجمالي الفواتير", () => _filterBills("اجمالي الفواتير")),
                _buildCard('تم الدفع', '$_paidBills', Icons.check_circle, Colors.green,
                    _selectedStatus == "تم الدفع", () => _filterBills("تم الدفع")),
                _buildCard('آجل', '$_deferredBillsCount', Icons.access_time, Colors.orange,
                    _selectedStatus == "آجل", () => _filterBills("آجل")),
                _buildCard('فاتورة مفتوحة', '$_openBillsCount', Icons.folder_open, Colors.red,
                    _selectedStatus == "فاتورة مفتوحة", () => _filterBills("فاتورة مفتوحة")),
              ],
            ),
          ),
          // Filtered Bills List
          Expanded(
            child: _filteredBills.isEmpty
                ? const Center(
              child: Text(
                'لا توجد فواتير متاحة للفلتر المحدد.',
                style: TextStyle(fontSize: 18),
              ),
            )
                : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: _filteredBills.length,
                itemBuilder: (context, index) {
                  final bill = _filteredBills[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text('رقم الفاتورة: ${bill.id}'),
                      subtitle: Text('العميل: ${bill.customerName}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () =>
                                _showAddPaymentDialog(bill.id , bill.customerName,bill.date as DateTime,bill.total_price ),
                            child: const Text('اضافة الدفع'),
                          ),
                          SizedBox(width: 10,),
                          ElevatedButton(
                            onPressed: () => _showPaymentDetailsDialog(bill.id ,bill.customerName,bill.date as DateTime,bill.total_price ),
                            child: const Text('تفاصيل المدفوعات'), ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String title, String count, IconData icon, Color color, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: isSelected ? color.withOpacity(0.3) : color.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 40, color: color),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
                ),
                const SizedBox(height: 4),
                Text(
                  count,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
