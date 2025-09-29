import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:system/features/customer/data/model/business_customer_model.dart';
import 'package:system/features/customer/data/repository/business_customer_repository.dart';
import 'package:system/features/customer/presentation/business/AddBusinessCustomerDialogs.dart';

class BusinessCustomerPageMobile extends StatefulWidget {
  final String searchQuery;

  const BusinessCustomerPageMobile({Key? key, required this.searchQuery}) : super(key: key);

  @override
  _BusinessCustomerPageMobileState createState() => _BusinessCustomerPageMobileState();
}

class _BusinessCustomerPageMobileState extends State<BusinessCustomerPageMobile> {
  final BusinessCustomerRepository _repository = BusinessCustomerRepository();
  late Future<List<business_customers>> _customersFuture;
  List<business_customers> _customers = [];
  List<business_customers> _filteredCustomers = [];
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  @override
  void didUpdateWidget(covariant BusinessCustomerPageMobile oldWidget) {
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
            (customer.personName ?? '').toLowerCase().contains(lowerQuery) ||
            (customer.email ?? '').toLowerCase().contains(lowerQuery) ||
            (customer.phone ?? '').toLowerCase().contains(lowerQuery) ||
            (customer.personPhone ?? '').toLowerCase().contains(lowerQuery) ||
            (customer.personphonecall ?? '').toLowerCase().contains(lowerQuery) ||
            (customer.address ?? '').toLowerCase().contains(lowerQuery);
      }).toList();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('العملاء التجاريين'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshCustomers,
          ),
        ],
      ),
      body: FutureBuilder<List<business_customers>>(
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
            // child: ListView.builder(
            //   padding: const EdgeInsets.all(8),
            //   itemCount: _filteredCustomers.length,
            //   itemBuilder: (context, index) {
            //     final customer = _filteredCustomers[index];
            //     return _buildCustomerCard(customer);
            //   },
            // ),
              child:  AdaptiveScrollbar(
          controller: _scrollController,
          child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(8),
          itemCount: _filteredCustomers.length,
          itemBuilder: (context, index) {
          final customer = _filteredCustomers[index];
          return _buildCustomerCard(customer);
          },
          ),
          )

          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addCustomerBusiness',
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

  Widget _buildCustomerCard(business_customers customer) {
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
              _buildInfoRow(Icons.person, customer.personName),
              _buildInfoRow(Icons.phone, customer.phone),
              _buildInfoRow(Icons.phone_android, customer.personphonecall),
              _buildInfoRow(Icons.phone_iphone, customer.personPhone),
              if (customer.email.isNotEmpty) _buildInfoRow(Icons.email, customer.email),
              if (customer.address.isNotEmpty) _buildInfoRow(Icons.location_on, customer.address),
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

  Widget _buildActionButtons(business_customers customer) {
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
    BusinessCustomerDialogs.showAddOrUpdateDialog(
      context: context,
      isBusiness: true,
      onSubmit: (name, personName, email, phone, personPhone, address, personphonecall) =>
          _addCustomer(name, personName, email, phone, personPhone, address, personphonecall),
    );
  }

  void _showEditDialog(BuildContext context, business_customers customer) {
    BusinessCustomerDialogs.showAddOrUpdateDialog(
      context: context,
      businessCustomer: customer,
      isBusiness: true,
      onSubmit: (name, personName, email, phone, personPhone, address, personphonecall) =>
          _updateCustomer(customer.id, name, personName, email, phone, personPhone, address, personphonecall),
    );
  }

  void _showDeleteDialog(BuildContext context, String id) {
    BusinessCustomerDialogs.showDeleteConfirmation(
      context: context,
      onConfirm: () => _deleteCustomer(id),
    );
  }

  void _showCustomerDetails(BuildContext context, business_customers customer) {
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
                _buildDetailItem('اسم المسؤول', customer.personName),
                _buildDetailItem('هاتف الشركة', customer.phone),
                _buildDetailItem('هاتف المسؤول', customer.personPhone),
                _buildDetailItem('واتساب المسؤول', customer.personphonecall),
                if (customer.email.isNotEmpty) _buildDetailItem('البريد الإلكتروني', customer.email),
                if (customer.address.isNotEmpty) _buildDetailItem('العنوان', customer.address),
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

  Future<void> _addCustomer(String name, String personName, String email, String phone, String personPhone, String address, String personphonecall) async {
    try {
      final newCustomer = business_customers(
        id: '',
        name: name,
        personName: personName,
        email: email,
        phone: phone,
        personPhone: personPhone,
        address: address,
        personphonecall: personphonecall,
      );
      await _repository.addCustomer(newCustomer);
      _refreshCustomers();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تمت إضافة العميل التجاري بنجاح')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في إضافة العميل: $e')),
      );
    }
  }

  Future<void> _updateCustomer(String id, String name, String personName, String email, String phone, String personPhone, String address, String personphonecall) async {
    try {
      final updatedCustomer = business_customers(
        id: id,
        name: name,
        personName: personName,
        email: email,
        phone: phone,
        personPhone: personPhone,
        personphonecall: personphonecall,
        address: address,
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


// import 'package:flutter/material.dart';
// import 'package:system/features/customer/data/model/business_customer_model.dart';
// import 'package:system/features/customer/data/repository/business_customer_repository.dart';
// import 'package:system/features/customer/presentation/business/AddBusinessCustomerDialogs.dart';
//
// class BusinessCustomerPageMobile extends StatefulWidget {
//   final String searchQuery;
//
//   const BusinessCustomerPageMobile({Key? key, required this.searchQuery})
//       : super(key: key);
//
//   @override
//   _BusinessCustomerPageMobileState createState() => _BusinessCustomerPageMobileState();
// }
//
// class _BusinessCustomerPageMobileState extends State<BusinessCustomerPageMobile> {
//   final BusinessCustomerRepository _repository = BusinessCustomerRepository();
//   late Future<List<business_customers>> _customersFuture;
//   List<business_customers> _customers = [];
//   List<business_customers> _filteredCustomers = [];
//   bool _isLoading = false;
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     _loadCustomers();
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   void _loadCustomers() {
//     setState(() => _isLoading = true);
//     _customersFuture = _repository.fetchCustomers().then((customers) {
//       _customers = customers;
//       _filterCustomers(widget.searchQuery);
//       setState(() => _isLoading = false);
//       return customers;
//     }).catchError((error) {
//       setState(() => _isLoading = false);
//       throw error;
//     });
//   }
//
//   void _refreshCustomers() => _loadCustomers();
//
//   void _filterCustomers(String query) {
//     final lowerQuery = query.toLowerCase();
//     setState(() {
//       _filteredCustomers = _customers.where((customer) {
//         return customer.name.toLowerCase().contains(lowerQuery) ||
//             customer.personName.toLowerCase().contains(lowerQuery) ||
//             customer.email.toLowerCase().contains(lowerQuery) ||
//             customer.phone.toLowerCase().contains(lowerQuery) ||
//             customer.personPhone.toLowerCase().contains(lowerQuery) ||
//             customer.personphonecall.toLowerCase().contains(lowerQuery) ||
//             customer.address.toLowerCase().contains(lowerQuery);
//       }).toList();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isArabic = Directionality.of(context) == TextDirection.rtl;
//
//     return Scaffold(
//       body: _buildContent(isArabic),
//       floatingActionButton: FloatingActionButton(
//         heroTag: 'addBusinessCustomer',
//         onPressed: () => _showAddDialog(context),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
//
//   Widget _buildContent(bool isArabic) {
//     return FutureBuilder<List<business_customers>>(
//       future: _customersFuture,
//       builder: (context, snapshot) {
//         if (_isLoading) return const Center(child: CircularProgressIndicator());
//
//         if (snapshot.hasError) {
//           return ErrorWidget(
//             error: snapshot.error.toString(),
//             onRetry: _refreshCustomers,
//             isArabic: isArabic,
//           );
//         }
//
//         if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return EmptyStateWidget(
//             icon: Icons.business_off,
//             message: isArabic ? 'لا يوجد عملاء تجاريين' : 'No business customers',
//             buttonLabel: isArabic ? 'تحديث' : 'Refresh',
//             onPressed: _refreshCustomers,
//           );
//         }
//
//         if (_filteredCustomers.isEmpty) {
//           return EmptyStateWidget(
//             icon: Icons.search_off,
//             message: isArabic
//                 ? 'لا توجد نتائج لـ "${widget.searchQuery}"'
//                 : 'No results for "${widget.searchQuery}"',
//             buttonLabel: isArabic ? 'مسح البحث' : 'Clear search',
//             onPressed: () => _filterCustomers(''),
//           );
//         }
//
//         return RefreshIndicator(
//           onRefresh: () async => _refreshCustomers(),
//           child: ListView.builder(
//             controller: _scrollController,
//             padding: const EdgeInsets.all(8),
//             itemCount: _filteredCustomers.length,
//             itemBuilder: (context, index) {
//               final customer = _filteredCustomers[index];
//               return BusinessCustomerCard(
//                 customer: customer,
//                 onTap: () => _showCustomerDetails(context, customer),
//                 onEdit: () => _showEditDialog(context, customer),
//                 onDelete: () => _showDeleteDialog(context, customer.id),
//                 isArabic: isArabic,
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
//
//
//     void _showAddDialog(BuildContext context) {
//     BusinessCustomerDialogs.showAddOrUpdateDialog(
//       context: context,
//       isBusiness: true,
//       onSubmit: (name, personName, email, phone, personPhone, address, personphonecall) =>
//           _addCustomer(name, personName, email, phone, personPhone, address, personphonecall),
//     );
//   }
//
//
//     Future<void> _addCustomer(String name, String personName, String email, String phone, String personPhone, String address, String personphonecall) async {
//     try {
//       final newCustomer = business_customers(
//         id: '',
//         name: name,
//         personName: personName,
//         email: email,
//         phone: phone,
//         personPhone: personPhone,
//         address: address,
//         personphonecall: personphonecall,
//       );
//       await _repository.addCustomer(newCustomer);
//       _refreshCustomers();
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('تمت إضافة العميل التجاري بنجاح')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('فشل في إضافة العميل: $e')),
//       );
//     }
//   }
//
//   void _showCustomerDetails(BuildContext context, business_customers customer) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(16),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: Container(
//                     width: 40,
//                     height: 4,
//                     margin: const EdgeInsets.only(bottom: 16),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[300],
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                   ),
//                 ),
//                 Text(customer.name, style: Theme.of(context).textTheme.titleLarge),
//                 const SizedBox(height: 16),
//                 _buildDetailItem('اسم المسؤول', customer.personName),
//                 _buildDetailItem('هاتف الشركة', customer.phone),
//                 _buildDetailItem('هاتف المسؤول', customer.personPhone),
//                 _buildDetailItem('واتساب المسؤول', customer.personphonecall),
//                 if (customer.email.isNotEmpty) _buildDetailItem('البريد الإلكتروني', customer.email),
//                 if (customer.address.isNotEmpty) _buildDetailItem('العنوان', customer.address),
//                 const SizedBox(height: 24),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                         _showEditDialog(context, customer);
//                       },
//                       child: const Text('تعديل'),
//                     ),
//                     OutlinedButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: const Text('إغلاق'),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildDetailItem(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
//           Text(value, style: const TextStyle(fontSize: 16)),
//         ],
//       ),
//     );
//   }
//
//   void _showEditDialog(BuildContext context, business_customers customer) {
//     BusinessCustomerDialogs.showAddOrUpdateDialog(
//       context: context,
//       businessCustomer: customer,
//       isBusiness: true,
//       onSubmit: (name, personName, email, phone, personPhone, address, personphonecall) =>
//           _updateCustomer(customer.id, name, personName, email, phone, personPhone, address, personphonecall),
//     );
//   }
//
//   Future<void> _updateCustomer(String id, String name, String personName, String email, String phone, String personPhone, String address, String personphonecall) async {
//     try {
//       final updatedCustomer = business_customers(
//         id: id,
//         name: name,
//         personName: personName,
//         email: email,
//         phone: phone,
//         personPhone: personPhone,
//         personphonecall: personphonecall,
//         address: address,
//       );
//       await _repository.updateCustomer(updatedCustomer);
//       _refreshCustomers();
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('تم تعديل بيانات العميل')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('فشل في تعديل العميل: $e')),
//       );
//     }
//   }
//
//   void _showDeleteDialog(BuildContext context, String id) {
//     BusinessCustomerDialogs.showDeleteConfirmation(
//       context: context,
//       onConfirm: () => _deleteCustomer(id),
//     );
//   }
//
//   Future<void> _deleteCustomer(String id) async {
//     try {
//       await _repository.deleteCustomer(id);
//       _refreshCustomers();
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('تم حذف العميل بنجاح')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('فشل في حذف العميل: $e')),
//       );
//     }
//   }
// }
//
// // ... (keep all the existing CRUD methods and dialogs, but update text based on isArabic)
//
//
// class BusinessCustomerCard extends StatelessWidget {
//   final business_customers customer;
//   final VoidCallback onTap;
//   final VoidCallback onEdit;
//   final VoidCallback onDelete;
//   final bool isArabic;
//
//   const BusinessCustomerCard({
//     required this.customer,
//     required this.onTap,
//     required this.onEdit,
//     required this.onDelete,
//     required this.isArabic,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       elevation: 2,
//       child: InkWell(
//         onTap: onTap,
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Text(
//                       customer.name,
//                       style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.edit, size: 20),
//                         color: Colors.blue,
//                         onPressed: onEdit,
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.delete, size: 20),
//                         color: Colors.red,
//                         onPressed: onDelete,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               _buildInfoRow(Icons.person, isArabic ? 'اسم المسؤول' : 'Contact Person', customer.personName),
//               _buildInfoRow(Icons.phone, isArabic ? 'هاتف الشركة' : 'Company Phone', customer.phone),
//               _buildInfoRow(Icons.phone_android, isArabic ? 'واتساب المسؤول' : 'Contact WhatsApp', customer.personphonecall),
//               if (customer.email.isNotEmpty)
//                 _buildInfoRow(Icons.email, isArabic ? 'البريد الإلكتروني' : 'Email', customer.email),
//               if (customer.address.isNotEmpty)
//                 _buildInfoRow(Icons.location_on, isArabic ? 'العنوان' : 'Address', customer.address),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(IconData icon, String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Icon(icon, size: 16, color: Colors.grey),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text.rich(
//               TextSpan(
//                 children: [
//                   TextSpan(
//                     text: '$label: ',
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   TextSpan(text: value),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
