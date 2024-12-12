import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:system/core/constants/app_constants.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/billes/data/repositories/bill_repository.dart';
import 'package:system/features/billes/presentation/Dialog/adding/bill/showAddBillDialog.dart';
import 'package:system/features/billes/presentation/Dialog/details-editing-pdf/bill/showBillDetailsDialog.dart';

class BillingPage extends StatefulWidget {
  @override
  _BillingPageState createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  final BillRepository _billRepository = BillRepository();
  late Future<List<Bill>> _billsFuture;
  List<Bill> _bills = [];
  List<Bill> _filteredBills = [];
  final TextEditingController _searchController = TextEditingController();
  String? _selectedStatus;
  String _searchCriteria = 'id'; // Default search by ID

  @override
  void initState() {
    super.initState();
    _billsFuture = _billRepository.getBills();
    _billsFuture.then((bills) {
      setState(() {
        _bills = bills;
        _filteredBills = bills;
      });
    });
    _searchController.addListener(_filterBills);
  }

  void addBill(Bill bill, payment, report) async {
    try {
      // await _billRepository.addBill(bill);
      await _billRepository.addBill(bill, payment, report);
      refreshBills();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding bill: $e')),
      );
    }
  }

  void refreshBills() {
    setState(() {
      _billsFuture = _billRepository.getBills();
      _billsFuture.then((bills) {
        setState(() {
          _bills = bills;
          _filteredBills = bills;
        });
      });
    });
  }

  void _filterBills() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredBills = _bills.where((bill) {
        final matchesQuery = _searchCriteria == 'id'
            ? bill.id.toString().contains(query)
            : bill.customerName.toLowerCase().contains(query);

        final matchesStatus = _selectedStatus == null || bill.status == _selectedStatus;

        return matchesQuery && matchesStatus;
      }).toList();
    });
  }

  // تغيير حالة الفاتورة بناءً على الفئة المحددة
  void _onNavBarItemTapped(int index) {
    setState(() {
      switch (index) {
        case 0:
          _selectedStatus =  AppStrings.pending; // آجل
          break;
        case 1:
          _selectedStatus = AppStrings.paid; // تم الدفع
          break;
        case 2:
          _selectedStatus = AppStrings.openInvoice; // فاتورة مفتوحة
          break;
        case 3:
          _selectedStatus = null; // الكل
          break;
        default:
          _selectedStatus = null;
      }
      _filterBills(); // تحديث الفواتير بناءً على الفئة المحددة
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الفواتير'),
        actions: [
          TextButton.icon(onPressed: (){
            Navigator.pushReplacementNamed(context, '/adminHome'); // توجيه المستخدم إلى صفحة تسجيل الدخول
          }, label: Icon(Icons.home)),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: BottomNavigationBar(
              selectedFontSize: 15,
              currentIndex: _selectedStatus ==  AppStrings.pending
                  ? 0
                  : _selectedStatus == AppStrings.paid
                  ? 1
                  : _selectedStatus == AppStrings.openInvoice
                  ? 2
                  : 3,
              // ? 3

              onTap: _onNavBarItemTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.pending_actions,
                    size: 30,
                  ),
                  label: AppStrings.pending,
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle,
                    size: 30,
                  ),
                  label: AppStrings.paid,
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.hourglass_empty,
                    size: 30,
                  ),
                  label: AppStrings.openInvoice,
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.all_inclusive,
                    size: 30,
                  ),
                  label: AppStrings.all,
                ),
              ],
            ),
          ),
                   Row(
            children: [
              // Search TextField
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: _searchCriteria == 'id'
                        ? 'بحث برقم الفاتورة'
                        : 'بحث باسم العميل', // Update placeholder dynamically
                    prefixIcon: const Icon(Icons.search, color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(width: 8.0), // Space between ToggleButtons and TextField
              // ToggleButtons for search criteria
              ToggleButtons(
                isSelected: [
                  _searchCriteria == 'id',
                  _searchCriteria == 'customerName',
                ],
                onPressed: (index) {
                  setState(() {
                    _searchCriteria = index == 0 ? 'id' : 'customerName';
                  });
                },
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('رقم الفاتورة'), // Bill ID
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('اسم العميل'), // Customer Name
                  ),
                ],
                borderRadius: BorderRadius.circular(8.0),
                borderColor: Colors.grey,
                selectedBorderColor: Colors.blue,
                fillColor: Colors.blue.withOpacity(0.1),
                selectedColor: Colors.blue,
                color: Colors.black,
              ),
              // Action Button for Starting Search
              ElevatedButton(
                onPressed: () {
                  _filterBills(); // Trigger the search functionality
                },
                child: const Icon(Icons.search), // Search icon on the button
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ), backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Button background color
                ),
              ),
              const SizedBox(width: 8.0), // Space between ToggleButtons and Search Button
            ],
          ),


          Expanded(
            child: FutureBuilder<List<Bill>>(
              future: _billsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('خطأ: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('لا توجد فواتير حالياً.'));
                }

                return ListView.builder(
                  itemCount: _filteredBills.length,
                  itemBuilder: (context, index) {
                    final bill = _filteredBills[index];
                    return ListTile(
                      title: Text(
                          '${bill.id} - ${bill.customerName} - ${bill.date}'),
                      subtitle: Text(
                        'الحالة: ${bill.status}',
                        style: TextStyle(
                          color: bill.status == 'تم الدفع'
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                      onTap: () {
                        showBillDetailsDialog(context, bill ,);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddBillDialog(
            context: context,
            onAddBill: addBill,
          );
        },
        child: Icon(Icons.add),
        tooltip: 'إضافة فاتورة جديدة',

      ),
    );
  }
}
