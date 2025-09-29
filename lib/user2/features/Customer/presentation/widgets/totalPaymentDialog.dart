import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/billes/data/repositories/bill_repository.dart';

class PaymentDialog extends StatefulWidget {
  final String customerName;
  final List<Bill> customerBills;
  final BillRepository billRepository;
  final Function(int, int,int) updateBillStatus;

  PaymentDialog({
    required this.customerName,
    required this.customerBills,
    required this.billRepository,
    required this.updateBillStatus,
  });

  @override
  _PaymentDialogState createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  final TextEditingController _totalPaymentController = TextEditingController();
  List<Map<String, String>> _vaults = [];
  String? _selectedVaultId;
  Map<int, int> _updatedPayments = {};
  bool _isDistributed = false;

  @override
  void initState() {
    super.initState();
    _initializePayments();
    _fetchVaults();
  }

  void _initializePayments() {
    _updatedPayments = {
      for (var bill in widget.customerBills) bill.id: bill.payment ?? 0
    };
  }

  Future<void> _fetchVaults() async {
    try {
      _vaults = await widget.billRepository.fetchVaultList();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء تحميل الخزن')),
      );
    }
  }

  void _applyPayment(int enteredAmount) {
    if (enteredAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى إدخال مبلغ صالح')),
      );
      return;
    }

    int remainingPayment = enteredAmount;

    for (var bill in widget.customerBills) {
      if (remainingPayment <= 0) break;

      int remainingAmountForBill = bill.total_price - _updatedPayments[bill.id]!;

      if (remainingPayment >= remainingAmountForBill) {
        _updatedPayments[bill.id] = bill.total_price;
        remainingPayment -= remainingAmountForBill;
      } else {
        _updatedPayments[bill.id] = _updatedPayments[bill.id]! + remainingPayment;
        remainingPayment = 0;
      }
    }

    if (remainingPayment > 0 && widget.customerBills.isNotEmpty) {
      var lastBill = widget.customerBills.last;
      _updatedPayments[lastBill.id] = _updatedPayments[lastBill.id]! + remainingPayment;
    }

    setState(() => _isDistributed = true);
  }

  int _getTotalAmount() => widget.customerBills.fold(0, (sum, bill) => sum + bill.total_price);
  int _getTotalPaid() => widget.customerBills.fold(0, (sum, bill) => sum + _updatedPayments[bill.id]!);
  int _getRemainingAmount() => _getTotalAmount() - _getTotalPaid();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('إضافة دفعات - ${widget.customerName}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _totalPaymentController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'أدخل المبلغ',
              border: OutlineInputBorder(),
            ),
          ),

          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              int enteredAmount = int.tryParse(_totalPaymentController.text) ?? 0;
              _applyPayment(enteredAmount);
            },
            child: Text('توزيع المبلغ'),
          ),
          SizedBox(height: 10),
          _buildSummaryInfo(_getTotalAmount(), _getTotalPaid(), _getRemainingAmount()),
          _buildBillTable(widget.customerBills, _updatedPayments),
          SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _selectedVaultId,
            hint: Text('اختر الخزنة',style: TextStyle(color: Colors.blue),),
            onChanged: (value) => setState(() => _selectedVaultId = value),
            items: _vaults.map((vault) {
              return DropdownMenuItem<String>(
                value: vault['id'],
                child: Text(vault['name']!),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: _isDistributed ? _savePayments : null,
          child: Text('حفظ الدفعات'),
        ),
      ],
    );
  }

  Future<void> _savePayments() async {
    for (var bill in widget.customerBills) {
      int newPayment = _updatedPayments[bill.id]!;
      if (newPayment > bill.payment!) {
        await widget.billRepository.addPayment(
          billId: bill.id,
          amount: (newPayment - bill.payment!).toInt(),
          userId: Supabase.instance.client.auth.currentUser?.id ?? '',
          paymentStatus: 'إيداع',
          vaultId: _selectedVaultId!,
        );

        await widget.billRepository.updateVaultBalance(_selectedVaultId!, (newPayment - bill.payment!));

        widget.updateBillStatus(bill.id, bill.total_price, newPayment);
      }
    }
    Navigator.pop(context, true);
  }

  Widget _buildSummaryInfo(int total, int paid, int remaining) {
    return Column(
      children: [
        _buildInfoText('إجمالي الفواتير', total,Colors.blue),
        _buildInfoText('إجمالي المدفوعات', paid, Colors.blue),
        _buildInfoText('المبلغ المتبقي', remaining, remaining > 0 ? Colors.red : Colors.green),
      ],
    );
  }

  Widget _buildInfoText(String label, int amount, Color? color) {
    return Text(
      '$label: ${amount.toStringAsFixed(2)} L.E',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
    );
  }

  Widget _buildBillTable(List<Bill> bills, Map<int, int> updatedPayments) {
    return DataTable(
      columnSpacing: 12.0,
      columns: [
        DataColumn(label: Text('رقم الفاتورة')),
        DataColumn(label: Text('إجمالي الفاتورة')),
        DataColumn(label: Text('المدفوع')),
        DataColumn(label: Text('المتبقي')),
      ],
      rows: bills.map((bill) {
        int remainingAmount = bill.total_price - updatedPayments[bill.id]!;
        return DataRow(cells: [
          DataCell(Text(bill.id.toString())),
          DataCell(Text('${bill.total_price.toStringAsFixed(2)} L.E')),
          DataCell(Text('${updatedPayments[bill.id]!.toStringAsFixed(2)} L.E')),
          DataCell(Text('${remainingAmount.toStringAsFixed(2)} L.E',
              style: TextStyle(color: remainingAmount > 0 ? Colors.red : Colors.green))),
        ]);
      }).toList(),
    );
  }
}