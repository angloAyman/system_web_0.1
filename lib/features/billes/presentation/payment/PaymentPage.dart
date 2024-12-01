import 'package:flutter/material.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/billes/data/repositories/bill_repository.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final BillRepository _billRepository = BillRepository();
  late Future<List<Bill>> _deferredBillsFuture;

  int _totalBills = 0;
  int _paidBills = 0;
  int _deferredBillsCount = 0;

  @override
  void initState() {
    super.initState();
    _deferredBillsFuture = _loadDeferredBills();
    _loadBillCounts(); // Fetch dynamic counts
  }

  Future<List<Bill>> _loadDeferredBills() async {
    try {
      return await _billRepository.getDeferredBills();
    } catch (error) {
      print("Error loading deferred bills: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load deferred bills: $error')),
      );
      return [];
    }
  }

  Future<void> _loadBillCounts() async {
    try {
      // Example API calls to fetch counts
      final totalBills = await _billRepository.getTotalBillsCount();
      final paidBills = await _billRepository.getPaidBillsCount();
      final deferredBills = await _billRepository.getDeferredBillsCount();

      setState(() {
        _totalBills = totalBills;
        _paidBills = paidBills;
        _deferredBillsCount = deferredBills;
      });
    } catch (error) {
      print("Error loading bill counts: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load bill counts: $error')),
      );
    }
  }

  void _navigateToAddPaymentPage(int billId, String customerName) {
    print('Navigate to payment page for Bill ID: $billId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الخزنة'),
      ),
      body: Column(
        children: [
          // Row with 3 Cards
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCard('Total Bills', '$_totalBills', Icons.description, Colors.blue),
                _buildCard('Paid Bills', '$_paidBills', Icons.check_circle, Colors.green),
                _buildCard('Deferred Bills', '$_deferredBillsCount', Icons.access_time, Colors.orange),
              ],
            ),
          ),
          // Deferred Bills List
          Expanded(
            child: FutureBuilder<List<Bill>>(
              future: _deferredBillsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No deferred bills available at the moment.'),
                  );
                }

                final deferredBills = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: deferredBills.length,
                    itemBuilder: (context, index) {
                      final bill = deferredBills[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text('Bill ID: ${bill.id}'),
                          subtitle: Text('Customer: ${bill.customerName}'),
                          trailing: ElevatedButton(
                            onPressed: () => _navigateToAddPaymentPage(bill.id as int, bill.customerName),
                            child: const Text('Add Payment'),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String title, String count, IconData icon, Color color) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
    );
  }
}
