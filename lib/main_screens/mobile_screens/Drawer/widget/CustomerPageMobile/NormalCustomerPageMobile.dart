import 'package:flutter/material.dart';
import 'package:system/features/customer/data/model/normal_customer_model.dart';
import 'package:system/features/customer/data/repository/normal_customer_repository.dart';
import 'package:system/features/customer/presentation/normal/AddNormalCustomerDialogs.dart';

class NormalCustomerPageMobile extends StatefulWidget {
  final String searchQuery;

  const NormalCustomerPageMobile({Key? key, required this.searchQuery})
      : super(key: key);

  @override
  _NormalCustomerPageMobileState createState() => _NormalCustomerPageMobileState();
}

class _NormalCustomerPageMobileState extends State<NormalCustomerPageMobile> {
  final NormalCustomerRepository _repository = NormalCustomerRepository();
  late Future<List<normal_customers>> _customersFuture;
  List<normal_customers> _customers = [];
  List<normal_customers> _filteredCustomers = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  @override
  void didUpdateWidget(covariant NormalCustomerPageMobile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != oldWidget.searchQuery) {
      _filterCustomers(widget.searchQuery);
    }
  }

  void _loadCustomers() {
    setState(() => _isLoading = true);
    _customersFuture = _repository.fetchCustomers().then((customers) {
      _customers = customers;
      _filterCustomers(widget.searchQuery);
      setState(() => _isLoading = false);
      return customers;
    }).catchError((error) {
      setState(() => _isLoading = false);
      throw error;
    });
  }

  void _refreshCustomers() {
    _loadCustomers();
    _filterCustomers(widget.searchQuery);
  }

  void _filterCustomers(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      _filteredCustomers = _customers.where((customer) {
        return (customer.name ?? '').toLowerCase().contains(lowerQuery) ||
            (customer.email ?? '').toLowerCase().contains(lowerQuery) ||
            (customer.phone ?? '').toLowerCase().contains(lowerQuery) ||
            (customer.phonecall ?? '').toLowerCase().contains(lowerQuery) ||
            (customer.address ?? '').toLowerCase().contains(lowerQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('العملاء'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshCustomers,
          ),
        ],
      ),
      body: FutureBuilder<List<normal_customers>>(
        future: _customersFuture,
        builder: (context, snapshot) {
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _buildMessageCard(
              icon: Icons.error_outline,
              text: 'حدث خطأ: ${snapshot.error}',
              buttonLabel: 'إعادة المحاولة',
              onPressed: _refreshCustomers,
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildMessageCard(
              icon: Icons.group_off,
              text: 'لا يوجد عملاء حاليًا',
              buttonLabel: 'تحديث',
              onPressed: _refreshCustomers,
            );
          }

          if (_filteredCustomers.isEmpty) {
            return _buildMessageCard(
              icon: Icons.search_off,
              text: 'لا توجد نتائج لـ "${widget.searchQuery}"',
              buttonLabel: 'مسح البحث',
              onPressed: () => _filterCustomers(''),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _refreshCustomers(),
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _filteredCustomers.length,
              itemBuilder: (context, index) {
                final customer = _filteredCustomers[index];
                return _buildCustomerCard(customer);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addCustomer',
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMessageCard({required IconData icon, required String text, required String buttonLabel, required VoidCallback onPressed}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text(text, textAlign: TextAlign.center),
          TextButton(onPressed: onPressed, child: Text(buttonLabel)),
        ],
      ),
    );
  }

  Widget _buildCustomerCard(normal_customers customer) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: InkWell(
        onTap: () => _showCustomerDetails(context, customer),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      customer.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildActionButtons(customer),
                ],
              ),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.phone, customer.phone),
              if (customer.phonecall?.isNotEmpty ?? false)
                _buildInfoRow(Icons.phone_android, customer.phonecall!),
              if (customer.email?.isNotEmpty ?? false)
                _buildInfoRow(Icons.email, customer.email!),
              if (customer.address?.isNotEmpty ?? false)
                _buildInfoRow(Icons.location_on, customer.address!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(normal_customers customer) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, size: 20),
          color: Colors.blue,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () => _showEditDialog(context, customer),
        ),
        IconButton(
          icon: const Icon(Icons.delete, size: 20),
          color: Colors.red,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () => _showDeleteDialog(context, customer.id),
        ),
      ],
    );
  }

  void _showAddDialog(BuildContext context) {
    NormalCustomerDialogs.showAddOrUpdateDialog(
      context: context,
      isBusiness: false,
      onSubmit: (name, email, phone, address, phonecall) =>
          _addCustomer(name, email, phone, address, phonecall),
    );
  }

  void _showEditDialog(BuildContext context, normal_customers customer) {
    NormalCustomerDialogs.showAddOrUpdateDialog(
      context: context,
      normalCustomer: customer,
      isBusiness: false,
      onSubmit: (name, email, phone, address, phonecall) =>
          _updateCustomer(customer.id, name, email, phone, address, phonecall),
    );
  }

  void _showDeleteDialog(BuildContext context, String id) {
    NormalCustomerDialogs.showDeleteConfirmation(
      context: context,
      onConfirm: () => _deleteCustomer(id),
    );
  }

  void _showCustomerDetails(BuildContext context, normal_customers customer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(customer.name, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                _buildDetailItem('الهاتف', customer.phone),
                if (customer.phonecall?.isNotEmpty ?? false)
                  _buildDetailItem('واتساب', customer.phonecall!),
                if (customer.email?.isNotEmpty ?? false)
                  _buildDetailItem('البريد الإلكتروني', customer.email!),
                if (customer.address?.isNotEmpty ?? false)
                  _buildDetailItem('العنوان', customer.address!),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showEditDialog(context, customer);
                      },
                      child: const Text('تعديل'),
                    ),
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('إغلاق'),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Future<void> _addCustomer(String name, String email, String phone, String address, String phonecall) async {
    try {
      final newCustomer = normal_customers(
        id: '',
        name: name,
        email: email,
        phone: phone,
        address: address,
        phonecall: phonecall,
      );
      await _repository.addCustomer(newCustomer);
      _refreshCustomers();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تمت إضافة العميل بنجاح')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في إضافة العميل: $e')),
      );
    }
  }

  Future<void> _updateCustomer(String id, String name, String email, String phone, String address, String phonecall) async {
    try {
      final updatedCustomer = normal_customers(
        id: id,
        name: name,
        email: email,
        phone: phone,
        address: address,
        phonecall: phonecall,
      );
      await _repository.updateCustomer(updatedCustomer);
      _refreshCustomers();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تعديل بيانات العميل')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في تعديل العميل: $e')),
      );
    }
  }

  Future<void> _deleteCustomer(String id) async {
    try {
      await _repository.deleteCustomer(id);
      _refreshCustomers();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حذف العميل بنجاح')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في حذف العميل: $e')),
      );
    }
  }
}