import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:system/core/constants/app_constants.dart';
import 'package:system/core/themes/AppColors/them_constants.dart';
import 'package:system/features/billes/FavoriteBillsPage.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/billes/data/repositories/bill_repository.dart';
import 'package:system/features/billes/presentation/Dialog/adding/bill/showAddBillDialog.dart';
import 'package:system/features/billes/presentation/Dialog/details-editing-pdf/bill/showBillDetailsDialog.dart';

class UserBillingPage extends StatefulWidget {
  @override
  _UserBillingPageState createState() => _UserBillingPageState();
}

class _UserBillingPageState extends State<UserBillingPage> {
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

        final matchesStatus =
            _selectedStatus == null || bill.status == _selectedStatus;

        return matchesQuery && matchesStatus;
      }).toList();
    });
  }

  // تغيير حالة الفاتورة بناءً على الفئة المحددة
  void _onNavBarItemTapped(int index) {
    setState(() {
      switch (index) {
        case 0:
          _selectedStatus = AppStrings.pending; // آجل
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

// Dialog to update the bill description
  Future<String?> _showDescriptionDialog(
      BuildContext context, int billId, String currentDescription) {
    TextEditingController _descriptionController =
        TextEditingController(text: currentDescription);

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تحديث تفاصيل الفاتورة'),
          content: TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(hintText: 'أدخل تفاصيل الفاتورة'),
            maxLines: null,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(_descriptionController
                    .text); // Return the updated description
                // Navigator.of(context).pop();
              },
              child: const Text('حفظ'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without saving
              },
              child: const Text('إلغاء'),
            ),
          ],
        );
      },
    );
  }

  void _toggleFavoriteStatusAndUpdateDescription(Bill bill) async {
    final updatedDescription =
        await _showDescriptionDialog(context, bill.id, bill.description);

    if (updatedDescription != null) {
      try {
        await _billRepository.updateFavoriteStatusAndDescription(
          billId: bill.id,
          isFavorite: !bill.isFavorite, // Toggle the favorite status
          description: updatedDescription, // Set the updated description
        );

        // Update the UI
        setState(() {
          bill.isFavorite = !bill.isFavorite;
          bill.description = updatedDescription;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'تمت ${bill.isFavorite ? "إضافة" : "إزالة"} الفاتورة للمفضلة')),
        );
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء تحديث الفاتورة: $e')),
        );
      }
    }
  }

  // Method to format the date to DD/MM/YYYY format
  String _formatDate(dynamic date) {
    if (date is DateTime) {
      return '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year}';
    } else if (date is String) {
      // If the date is already a string in a known format (like 'YYYY-MM-DD'), you can parse it
      final parsedDate = DateTime.tryParse(date);
      if (parsedDate != null) {
        return '${parsedDate.day.toString().padLeft(2, '0')}/'
            '${parsedDate.month.toString().padLeft(2, '0')}/'
            '${parsedDate.year}';
      }
    }
    return 'غير محدد'; // Return a default value if the date is invalid
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الفواتير'),
        actions: [
          TextButton.icon(
              onPressed: () {
                Navigator.pushReplacementNamed(context,
                    '/userMainScreen'); // توجيه المستخدم إلى صفحة تسجيل الدخول
              },
              label: Icon(Icons.home)),
          IconButton(
            icon: Icon(Icons.account_balance),
            onPressed: () async {
              // final favoriteBill = _bills.firstWhere((bill) => bill.isFavorite);
              // await _addToFavorites(favoriteBill);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriteBillsPage(),
                ),
              );
            },
          ),
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
              showUnselectedLabels: true,
              selectedFontSize: 15,
              currentIndex: _selectedStatus == AppStrings.pending
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
              const SizedBox(width: 8.0),
              // Space between ToggleButtons and TextField
              // Search TextField
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: _searchCriteria == 'id'
                        ? 'بحث برقم الفاتورة'
                        : 'بحث باسم العميل',
                    // Update placeholder dynamically
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
              const SizedBox(width: 8.0),
              // Space between ToggleButtons and TextField
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
              const SizedBox(width: 8.0),
              // Space between ToggleButtons and TextField
              ElevatedButton(
                onPressed: () {
                  _filterBills(); // Trigger the search functionality
                },
                child: const Icon(Icons.search), // Search icon on the button
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0), // Button background color
                ),
              ),
              const SizedBox(width: 8.0),
              // Space between ToggleButtons and Search Button
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
                        '${bill.id} -'
                        ' ${bill.customerName} -'
                        ' ${_formatDate(bill.date)}', // Format the date here
                      ),
                      subtitle: Text(
                        'الحالة: ${bill.status}',
                        style: TextStyle(
                          color: bill.status == 'تم الدفع'
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                      // trailing:
                      //  IconButton(
                      //    icon: Icon(
                      //      bill.isFavorite ? Icons.account_balance : Icons.account_balance_outlined,
                      //      color: bill.isFavorite ? AppColors.primary : null,
                      //    ),
                      //    onPressed: () => _toggleFavoriteStatusAndUpdateDescription(bill),
                      //  ),
                      trailing: IconButton(
                        icon: Icon(
                          bill.isFavorite
                              ? Icons.account_balance
                              : Icons.account_balance_outlined,
                          color: bill.isFavorite ? AppColors.primary : null,
                        ),
                        onPressed: () async {
                          try {
                            if (bill.isFavorite) {
                              // Call the method to remove from favorites
                              _billRepository.removeFromFavorites(bill);

                              // Update the UI
                              setState(() {
                                bill.isFavorite = false;
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('تمت إزالة الفاتورة من المفضلة')),
                              );
                            } else {
                              // Call the method to add to favorites and update description
                              _toggleFavoriteStatusAndUpdateDescription(bill);
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('حدث خطأ: ${e.toString()}')),
                            );
                          }
                        },
                      ),

                      onTap: () {
                        showBillDetailsDialog(
                          context,
                          bill,
                        );
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
