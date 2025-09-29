// import 'package:flutter/material.dart';
// import 'package:system/features/customer/presentation/normal/normal_customer_page.dart';
// import 'package:system/features/customer/presentation/business/business_customer_page.dart';
// import 'package:system/main_screens/mobile_screens/Drawer/widget/CustomerPageMobile/BusinessCustomerPageMobile.dart';
// import 'package:system/main_screens/mobile_screens/Drawer/widget/CustomerPageMobile/NormalCustomerPageMobile.dart';
//
// class CustomerPageMobile extends StatefulWidget {
//   @override
//   _CustomerPageMobileState createState() => _CustomerPageMobileState();
// }
//
// class _CustomerPageMobileState extends State<CustomerPageMobile> {
//   String _selectedCustomerType = 'normal';
//   String _searchQuery = '';
//   final TextEditingController _searchController = TextEditingController();
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
//     final theme = Theme.of(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('إدارة العملاء', style: TextStyle(fontSize: isPortrait ? 18 : 22)),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.home),
//             onPressed: () => Navigator.pushReplacementNamed(context, '/adminHome'),
//             tooltip: 'الرئيسية',
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Search bar with improved spacing
//             Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: isPortrait ? 12.0 : 24.0,
//                 vertical: 8.0,
//               ),
//               child: TextField(
//                 controller: _searchController,
//                 onChanged: (query) => setState(() => _searchQuery = query),
//                 decoration: InputDecoration(
//                   labelText: 'ابحث عن عميل',
//                   hintText: 'ادخل اسم العميل أو المعرف...',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   prefixIcon: Icon(Icons.search),
//                   suffixIcon: _searchQuery.isNotEmpty
//                       ? IconButton(
//                     icon: Icon(Icons.clear),
//                     onPressed: () {
//                       setState(() {
//                         _searchQuery = '';
//                         _searchController.clear();
//                       });
//                     },
//                   )
//                       : null,
//                   contentPadding: EdgeInsets.symmetric(vertical: 12),
//                 ),
//               ),
//             ),
//
//             // Customer type selector with improved layout
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: isPortrait ? 12.0 : 24.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Flexible(
//                     child: Text(
//                       "نوع العملاء",
//                       style: theme.textTheme.titleMedium?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   SizedBox(width: 12),
//                   Flexible(
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 12),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: theme.dividerColor),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: DropdownButtonHideUnderline(
//                         child: DropdownButton<String>(
//                           isExpanded: true,
//                           value: _selectedCustomerType,
//                           items: [
//                             DropdownMenuItem(
//                               value: 'normal',
//                               child: Text(
//                                 'العملاء',
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                             DropdownMenuItem(
//                               value: 'business',
//                               child: Text(
//                                 'العملاء التجارين',
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
//                           onChanged: (value) {
//                             if (value != null) {
//                               setState(() => _selectedCustomerType = value);
//                             }
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // Divider for visual separation
//             Divider(height: 24, thickness: 1),
//
//             // Display the selected table with proper constraints
//
//             Expanded(
//               child: Container(
//                 constraints: BoxConstraints(
//                   maxWidth: isPortrait ? double.infinity : 600,
//                 ),
//                 margin: EdgeInsets.symmetric(horizontal: isPortrait ? 8.0 : 24.0),
//                 child: _selectedCustomerType == 'normal'
//                     ? NormalCustomerPageMobile(searchQuery: _searchQuery)
//                     : BusinessCustomerPageMobile(searchQuery: _searchQuery),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:system/main_screens/mobile_screens/Drawer/widget/CustomerPageMobile/BusinessCustomerPageMobile.dart';
import 'package:system/main_screens/mobile_screens/Drawer/widget/CustomerPageMobile/NormalCustomerPageMobile.dart';

class CustomerPageMobile extends StatefulWidget {
  @override
  _CustomerPageMobileState createState() => _CustomerPageMobileState();
}

class _CustomerPageMobileState extends State<CustomerPageMobile> {
  String _selectedCustomerType = 'normal';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'إدارة العملاء' : 'Customers Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () => Navigator.pushReplacementNamed(context, '/adminHome'),
            tooltip: isArabic ? 'الرئيسية' : 'Home',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _searchQuery = '';
                        _searchController.clear();
                      });
                    },
                  )
                      : null,
                  hintText: isArabic ? 'ابحث عن عميل...' : 'Search customers...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                ),
                onChanged: (query) {
                  setState(() => _searchQuery = query);
                },
              ),
            ),

            // Customer type selector
            CustomerTypeSelector(
              selectedType: _selectedCustomerType,
              onChanged: (value) => setState(() => _selectedCustomerType = value!),
              isArabic: isArabic,
            ),

            // Divider
            SizedBox(height: 10),
            const Divider(height: 1, thickness: 1),
            SizedBox(height: 10),

            // Customer list
            Expanded(
              child: _selectedCustomerType == 'normal'
                  ? NormalCustomerPageMobile(searchQuery: _searchQuery)
                  : BusinessCustomerPageMobile(searchQuery: _searchQuery),
            ),

          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final bool hasText;

  const SearchBar({
    required this.controller,
    required this.hintText,
    required this.onChanged,
    required this.onClear,
    required this.hasText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(Icons.search),
        suffixIcon: hasText
            ? IconButton(
          icon: Icon(Icons.clear),
          onPressed: onClear,
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
      ),
    );
  }
}

class CustomerTypeSelector extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String?> onChanged;
  final bool isArabic;

  const CustomerTypeSelector({
    required this.selectedType,
    required this.onChanged,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Text(
            isArabic ? 'نوع العملاء:' : 'Customer Type:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: selectedType,
                  items: [
                    DropdownMenuItem(
                      value: 'normal',
                      child: Text(isArabic ? 'العملاء العاديين' : 'Normal Customers'),
                    ),
                    DropdownMenuItem(
                      value: 'business',
                      child: Text(isArabic ? 'العملاء التجاريين' : 'Business Customers'),
                    ),
                  ],
                  onChanged: onChanged,
                ),

              ),

            ),

          ),

        ],
      ),
    );
  }
}