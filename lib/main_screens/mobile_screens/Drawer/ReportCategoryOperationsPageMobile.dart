import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/category/data/models/category_model.dart';
import 'package:system/features/category/data/models/subCategory_model.dart';
import 'package:system/features/category/data/repositories/category_repository.dart';
import 'package:system/features/report/UI/reportcategory/pdf/generatePdf.dart'; // Replace with your repository imports

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/category/data/models/category_model.dart';
import 'package:system/features/category/data/models/subCategory_model.dart';
import 'package:system/features/category/data/repositories/category_repository.dart';
import 'package:system/features/report/UI/reportcategory/pdf/generatePdf.dart';

class ReportCategoryOperationsPageMobile extends StatefulWidget {
  @override
  _ReportCategoryOperationsPageMobileState createState() =>
      _ReportCategoryOperationsPageMobileState();
}

class _ReportCategoryOperationsPageMobileState
    extends State<ReportCategoryOperationsPageMobile> {
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  Category? selectedCategory;
  Subcategory? selectedSubcategory;
  List<Category> categories = [];
  List<Subcategory> subcategories = [];
  List<Bill> bills = [];
  bool isLoading = false;

  int totalCategoryUsage = 0;
  int totalSubcategoryUsage = 0;
  double totalSubcategoryPrice = 0;
  double totalcategoryPrice = 0;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          selectedStartDate = picked;
        } else {
          selectedEndDate = picked;
        }
      });
    }
  }

  void _fetchCategories() async {
    try {
      setState(() => isLoading = true);
      final List<Category> categoryList =
          await CategoryRepository().getCategories();
      setState(() => categories = categoryList);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في جلب الفئات: $error')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _fetchSubcategories(String categoryId) async {
    try {
      setState(() => isLoading = true);
      final List<Subcategory> subcategoryList =
          await CategoryRepository().getSubcategories(categoryId);
      setState(() => subcategories = subcategoryList);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في جلب الأصناف الفرعية: $error')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _fetchFilteredBills() async {
    if (selectedStartDate == null ||
        selectedEndDate == null ||
        selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('برجاء إدخال التاريخ و الصنف الرئيسي')),
      );
      return;
    }

    try {
      setState(() => isLoading = true);
      final result = await CategoryRepository().getBillsFiltered(
        categoryName: selectedCategory!.name,
        subcategoryName: selectedSubcategory?.name,
        startDate: selectedStartDate!,
        endDate: selectedEndDate!,
      );

      if (mounted) {
        setState(() {
          bills = result['bills'] as List<Bill>;
          totalCategoryUsage = result['totalCategoryUsage'] ?? 0;
          totalSubcategoryUsage = result['totalSubcategoryUsage'] ?? 0;
          totalSubcategoryPrice = result['totalSubcategoryPrice'] ?? 0.0;
          totalcategoryPrice = result['totalcategoryPrice'] ?? 0.0;
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في جلب الفواتير: $error')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  String formatDate(DateTime? date) =>
      date != null ? DateFormat('yyyy-MM-dd').format(date) : 'اختيار تاريخ';

  Widget _buildFilterSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "تقرير عمليات صنف خلال مدة زمنية:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Category selection
            const Text("الصنف الرئيسي:",
                style: TextStyle(fontWeight: FontWeight.w500)),
            DropdownButtonFormField<Category>(
              value: selectedCategory,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                hintText: 'اختر الصنف الرئيسي',
              ),
              onChanged: (newValue) {
                setState(() {
                  selectedCategory = newValue;
                  selectedSubcategory = null;
                  subcategories = [];
                });
                if (newValue != null) {
                  _fetchSubcategories(newValue.id);
                }
              },
              items: categories.map((category) {
                return DropdownMenuItem<Category>(
                  value: category,
                  child: Text(category.name),
                );
              }).toList(),
            ),
            SizedBox(height: 16),

            // Subcategory selection
            const Text("الصنف الفرعي:",
                style: TextStyle(fontWeight: FontWeight.w500)),
            DropdownButtonFormField<Subcategory>(
              value: selectedSubcategory,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                hintText: "اختر الصنف الفرعي",
              ),
              items: subcategories.map((subcategory) {
                return DropdownMenuItem<Subcategory>(
                  value: subcategory,
                  child: Text(subcategory.name),
                );
              }).toList(),
              onChanged: (newValue) =>
                  setState(() => selectedSubcategory = newValue),
            ),
            const SizedBox(height: 16),

            // Date range selection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('تاريخ البدء:',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      OutlinedButton(
                        onPressed: () => _selectDate(context, true),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formatDate(selectedStartDate)),
                            const Icon(Icons.calendar_today, size: 18),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('تاريخ الانهاء:',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      OutlinedButton(
                        onPressed: () => _selectDate(context, false),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formatDate(selectedEndDate)),
                            const Icon(Icons.calendar_today, size: 18),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _fetchFilteredBills,
                    icon: const Icon(Icons.search),
                    label: const Text('تقرير'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: bills.isEmpty
                        ? null
                        : () => generatePdf(
                            bills, selectedCategory, selectedSubcategory),
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text("PDF"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Column(
      children: [
        Card(
          color: Colors.blue[50],
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('📊 إجماليات الصنف الرئيسي',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('عدد مرات الاستخدام:'),
                    Text(totalCategoryUsage.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('إجمالي المبيعات:'),
                    Text('$totalcategoryPrice ج.م',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          color: Colors.green[50],
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('📊 إجماليات الصنف الفرعي',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('عدد مرات الاستخدام:'),
                    Text(totalSubcategoryUsage.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('إجمالي المبيعات:'),
                    Text('$totalSubcategoryPrice ج.م ',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildBillItem(Bill bill) {
    // Filter items within the bill according to selected filters
    final filteredItems = bill.items.where((item) {
      final matchesCategory = selectedCategory == null ||
          item.categoryName == selectedCategory?.name;
      final matchesSubcategory = selectedSubcategory == null ||
          item.subcategoryName == selectedSubcategory?.name;
      return matchesCategory && matchesSubcategory;
    }).toList();

    // If no items match, return an empty SizedBox to exclude from the list
    if (filteredItems.isEmpty) {
      return const SizedBox.shrink();
    }

    // You can display each matching item, or just the first match if summarizing
    // Below shows only the first match for brevity, adjust as needed.
    final item = filteredItems.first;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ExpansionTile(
        title: Text(
          'فاتورة #${bill.id}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(DateFormat('yyyy-MM-dd').format(bill.date)),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildInfoRow('العميل:', bill.customerName),
                _buildInfoRow('الصنف الرئيسي:', item.categoryName),
                _buildInfoRow('الصنف الفرعي:', item.subcategoryName ?? 'N/A'),
                _buildInfoRow('الكمية:', item.quantity.toString()),
                // Uncomment if unit is important
                // _buildInfoRow('الوحدة:', item.unit ?? 'N/A'),
                _buildInfoRow(
                    'عدد مرات الاستخدام:', filteredItems.length.toString()),
                _buildInfoRow(
                    'السعر:', '${item.total_Item_price} ج.م'),
              ],
            ),
          ),
        ],
      ),
    );
  }


  // Widget _buildBillItem(Bill bill) {
  //   // Safely find the matching item within bill.items based on current filter
  //   final matchingItem = bill.items.isNotEmpty
  //       ? bill.items.firstWhere(
  //         (item) =>
  //     (selectedCategory == null ||
  //         item.categoryName == selectedCategory?.name) &&
  //         (selectedSubcategory == null ||
  //             item.subcategoryName == selectedSubcategory?.name),
  //     orElse: () => bill.items.first,
  //   )
  //       : null;
  //
  //   return Card(
  //     margin: const EdgeInsets.symmetric(vertical: 4),
  //     child: ExpansionTile(
  //       title: Text(
  //         'فاتورة #${bill.id}',
  //         style: const TextStyle(fontWeight: FontWeight.bold),
  //       ),
  //       subtitle: Text(DateFormat('yyyy-MM-dd').format(bill.date)),
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.stretch,
  //             children: [
  //               _buildInfoRow('العميل:', bill.customerName),
  //               _buildInfoRow(
  //                   'الصنف الرئيسي:',
  //                   matchingItem?.categoryName ??
  //                       selectedCategory?.name ??
  //                       'N/A'),
  //               _buildInfoRow(
  //                   'الصنف الفرعي:',
  //                   matchingItem?.subcategoryName ??
  //                       selectedSubcategory?.name ??
  //                       'N/A'),
  //               _buildInfoRow(
  //                   'الكمية:',
  //                   matchingItem != null
  //                       ? matchingItem.quantity.toString()
  //                       : 'N/A'),
  //               // Uncomment if unit is important
  //               // _buildInfoRow('الوحدة:', matchingItem?.unit ?? 'N/A'),
  //               _buildInfoRow(
  //                   'عدد الأصناف في الفاتورة:', bill.items.length.toString()),
  //               _buildInfoRow(
  //                   'السعر:',
  //                   matchingItem != null
  //                       ? '${matchingItem.total_Item_price} ج.م'
  //                       : 'N/A'),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تقارير عمليات الصنف'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilterSection(),
            const SizedBox(height: 16),
            _buildSummaryCards(),
            const SizedBox(height: 16),
            // Render all bills in the scroll view
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (bills.isEmpty)
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_long, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('لا توجد فواتير', style: TextStyle(fontSize: 16)),
                  ],
                ),
              )
            else
              ListView.builder(
                itemCount: bills.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => _buildBillItem(bills[index]),
              ),
          ],
        ),
      ),
    );
  }

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: const Text('تقارير عمليات الصنف'),
//     ),
//     body: Scrollable(
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           children: [
//             // Filter section
//             _buildFilterSection(),
//             const SizedBox(height: 16),
//
//             // Summary cards
//             _buildSummaryCards(),
//             const SizedBox(height: 16),
//
//             // Bills list
//             Expanded(
//               child: isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : bills.isEmpty
//                   ? const Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.receipt_long, size: 48, color: Colors.grey),
//                     SizedBox(height: 16),
//                     Text('لا توجد فواتير', style: TextStyle(fontSize: 16)),
//                   ],
//                 ),
//               )
//                   : ListView.builder(
//                 itemCount: bills.length,
//                 itemBuilder: (context, index) => _buildBillItem(bills[index]),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
}

//_____________________________________________________________________________________
// rows: bills.where((bill) {
//   // Ensure only selected category and subcategory are considered
//   final categoryMatch = bill.items.any(
//           (item) => item.categoryName == selectedCategory?.name);
//   final subcategoryMatch = selectedSubcategory == null ||
//       bill.items.any((item) => item.subcategoryName == selectedSubcategory?.name);
//
//   return categoryMatch && subcategoryMatch;
// }).map((bill) {
//   // Find the first matching item for the selected category and subcategory

//
//   return DataRow(cells: [
//     DataCell(Text(bill.id.toString())),
//     DataCell(Text(DateFormat('yyyy-MM-dd').format(bill.date))),
//     DataCell(Text(bill.customerName.toString())),
//     DataCell(Text(selectedCategory?.name ?? 'N/A')), // Show only selected category
//     DataCell(Text(selectedSubcategory?.name ?? 'N/A')), // Show only selected subcategory
//     DataCell(Text(matchingItem != null ? matchingItem.total_Item_price.toString() : 'N/A')),
//   ]);
// }).toList(),
// ),

// _____________________________________________________________________-
// ✅ إنشاء مصدر البيانات لـ PaginatedDataTable
// class BillsDataSource extends DataTableSource {
//   final List<Bill> bills;
//
//   BillsDataSource(this.bills);
//
//   @override
//   DataRow getRow(int index) {
//     if (index >= bills.length) return null as DataRow;
//
//     final bill = bills[index];
//
//     final categories = bill.items.isEmpty ? 'No category' : bill.items.map((item) => item.categoryName).join(', ');
//     final subcategories = bill.items.isEmpty ? 'No subcategory' : bill.items.map((item) => item.subcategoryName).join(', ');
//     final total_Item_price = bill.items.isEmpty ? 'No total price' : bill.items.map((item) => item.total_Item_price).join(', ');
//
//     return DataRow(cells: [
//       DataCell(Text(bill.id.toString())),
//       DataCell(Text(DateFormat('yyyy-MM-dd').format(bill.date))),
//       DataCell(Text(bill.customerName.toString())),
//       DataCell(Text(categories.isEmpty ? 'N/A' : categories)),
//       DataCell(Text(subcategories.isEmpty ? 'N/A' : subcategories)),
//       DataCell(Text(bill.items.isNotEmpty ? bill.items.first.quantity.toString() : 'N/A')),
//       // DataCell(Text(selectedSubcategory?.unit?.toString() ?? 'N/A')),
//       DataCell(Text(bill.items.length.toString())),
//       DataCell(Text(total_Item_price.isEmpty ? 'N/A' : total_Item_price)),
//     ]);
//   }
//
//   @override
//   int get rowCount => bills.length;
//
//   @override
//   bool get isRowCountApproximate => false;
//
//   @override
//   int get selectedRowCount => 0;
// }
