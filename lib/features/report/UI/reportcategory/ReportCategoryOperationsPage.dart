import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/category/data/models/category_model.dart';
import 'package:system/features/category/data/models/subCategory_model.dart';
import 'package:system/features/category/data/repositories/category_repository.dart'; // Replace with your repository imports

class ReportCategoryOperationsPage extends StatefulWidget {
  @override
  _ReportCategoryOperationsPageState createState() =>
      _ReportCategoryOperationsPageState();
}

class _ReportCategoryOperationsPageState
    extends State<ReportCategoryOperationsPage> {
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  Category? selectedCategory;
  Subcategory? selectedSubcategory;
  List<Category> categories = [];
  List<Subcategory> subcategories = [];
  List<Bill> bills = [];
  bool isLoading = false;

  int totalCategoryUsage = 0; // إجمالي عدد استخدام الصنف الرئيسي
  int totalSubcategoryUsage = 0; // إجمالي عدد استخدام الصنف الرئيسي
  double totalSubcategoryPrice = 0; // إجمالي عدد استخدام الصنف الرئيسي
  double totalcategoryPrice = 0; // إجمالي عدد استخدام الصنف الرئيسي

  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedStartDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedEndDate = picked;
      });
    }
  }

  void _fetchCategories() async {
    try {
      final List<Category> categoryList =
          await CategoryRepository().getCategories();
      setState(() {
        categories = categoryList;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching categories: $error')),
      );
    }
  }

  void _fetchSubcategories(String categoryId) async {
    try {
      final List<Subcategory> subcategoryList =
          await CategoryRepository().getSubcategories(categoryId);
      setState(() {
        subcategories = subcategoryList;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching subcategories: $error')),
      );
    }
  }

  void _fetchFilteredBills() async {
    if (selectedStartDate == null ||
        selectedEndDate == null ||
        selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('برجاء ادخال التاريخ و الصنف الفرعي ')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Fetch filtered bills and additional data
      final result = await CategoryRepository().getBillsFiltered(
        categoryName: selectedCategory!.name,
        subcategoryName: selectedSubcategory?.name,
        startDate: selectedStartDate!,
        endDate: selectedEndDate!,
      );

      // Extract data
      final billsList = result['bills'] as List<Bill>;
      final totalCategoryUsage = result['totalCategoryUsage'] as int;
      final totalSubcategoryUsage = result['totalSubcategoryUsage'] as int;
      final totalSubcategoryPrice = result['totalSubcategoryPrice'] as double;
      final totalcategoryPrice = result['totalcategoryPrice'] as double;

      // Check if the widget is still mounted before calling setState()
      if (mounted) {
        setState(() {
          bills = billsList;
          this.totalCategoryUsage = totalCategoryUsage;
          this.totalSubcategoryUsage = totalSubcategoryUsage;
          this.totalSubcategoryPrice = totalSubcategoryPrice;
          this.totalcategoryPrice = totalcategoryPrice;
          isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching bills: $error')),
      );
    }
  }



  String formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  @override
  void dispose() {
    _verticalScrollController.dispose();
    _horizontalScrollController.dispose();
    // Perform any necessary cleanup here.
    super.dispose(); // Always call super.dispose() to ensure proper cleanup.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تقارير عمليات الصنف'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "تقرير عمليات صنف خلال مدة زمنية :",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                // Category Dropdown
                Text("الصنف الرئسي :"),
                SizedBox(width: 16),
                DropdownButton<Category>(
                  value: selectedCategory,
                  hint: Text(' اختار الصنف الرئسي'),
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
                SizedBox(width: 16),
                Text("الصنف الفرعي  :"),
                SizedBox(width: 16),
                // Subcategory Dropdown
                DropdownButton<Subcategory>(
                  value: selectedSubcategory,
                  hint: Text('اختار الصنف الفرعي'),
                  onChanged: (newValue) {
                    setState(() {
                      selectedSubcategory = newValue;
                    });
                  },
                  items: subcategories.map((subcategory) {
                    return DropdownMenuItem<Subcategory>(
                      value: subcategory,
                      child: Text(subcategory.name),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Date Range Pickers
            Row(
              children: [
                Text('تاريخ البدء: '),
                TextButton(
                  onPressed: () => _selectStartDate(context),
                  child: Text(
                    selectedStartDate == null
                        ? 'Select Date'
                        : formatDate(selectedStartDate!),
                  ),
                ),
                Text('تاريخ الانهاء: '),
                TextButton(
                  onPressed: () => _selectEndDate(context),
                  child: Text(
                    selectedEndDate == null
                        ? 'Select Date'
                        : formatDate(selectedEndDate!),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Fetch Bills Button
            ElevatedButton(
              onPressed: _fetchFilteredBills,
              child: Text('تقرير'),
            ),
            SizedBox(height: 16),

            Column(
              children: [

                Center(
                  child: Text('📊 إجمالي استخدام الصنف الرئيسي: $totalCategoryUsage',
                      style: TextStyle(fontSize: 16)),
                ),
                Center(
                  child: Text('📊 إجمالي استخدام الصنف الفرعي: $totalSubcategoryUsage',
                      style: TextStyle(fontSize: 16)),
                ),
                Center(
                  child: Text('💰 اجمالي مبيعات الصنف الرئيسي : $totalcategoryPrice',                    style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),

                Center(
                  child: Text('💰 اجمالي مبيعات الصنف الفرعي: $totalSubcategoryPrice',                    style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),


// Bills List
            isLoading
                ? Center(child: CircularProgressIndicator())
                : bills.isEmpty
                    ? Center(child: Text('لا يوجد فواتير .'))
                    : Expanded(
                        child: Scrollbar(
                          controller: _verticalScrollController,
                          thumbVisibility: true,// يجعل شريط التمرير مرئيًا دائمًا
                          interactive: true, // يسمح بالتحكم بالماوس
                          thickness: 10,
                          trackVisibility: true,
                          child: SingleChildScrollView(
                            controller: _verticalScrollController,
                            scrollDirection:Axis.vertical, // تمكين التمرير العمودي
                            child: Scrollbar(
                              trackVisibility: true,
                              controller: _horizontalScrollController,
                              interactive: true,
                              thumbVisibility: true,
                              thickness: 10,
                              child: SingleChildScrollView(
                                controller: _horizontalScrollController,
                                scrollDirection:
                                    Axis.horizontal, // تمكين التمرير الأفقي
                                child: DataTable(
                                  showBottomBorder: true,
                                  columnSpacing: 30,
                                  columns: const [
                                    DataColumn(label: Text('رقم الفاتورة')),
                                    DataColumn(label: Text('تاريخ ')),
                                    DataColumn(label: Text('اسم العميل ')),
                                    DataColumn(label: Text('الصنف الرئسي')),
                                    DataColumn(label: Text('الصنف الفرعي')),
                                    DataColumn(label: Text('الكمية')),
                                    DataColumn(label: Text('الوحدة')),
                                    DataColumn(
                                        label: Text('عدد مرات الاستخدام ')),
                                    DataColumn(
                                        label: Text('السعر داخل الفاتورة')),
                                  ],
                                  rows: bills.where((bill) {
                                    // تصفية البيانات بناءً على الفئة والصنف الفرعي
                                    final categoriesMatch = bill.items.any(
                                        (item) =>
                                            item.categoryName ==
                                                selectedCategory?.name);
                                    final subcategoriesMatch =
                                        selectedSubcategory == null ||
                                            bill.items.any((item) =>
                                                item.subcategoryName ==
                                                selectedSubcategory?.name);
                                    return categoriesMatch &&
                                        subcategoriesMatch;
                                  }).map((bill) {
                                    final matchingItem = bill.items.firstWhere(
                                          (item) =>
                                      item.categoryName == selectedCategory?.name &&
                                          (selectedSubcategory == null || item.subcategoryName == selectedSubcategory?.name),

                                    );
                                    return DataRow(cells: [
                                      DataCell(Text(bill.id.toString())),
                                      DataCell(Text(DateFormat('yyyy-MM-dd')
                                          .format(bill.date))),
                                      DataCell(
                                          Text(bill.customerName.toString())),
                                          DataCell(Text(selectedCategory?.name ?? 'N/A')), // Show only selected category

                                          DataCell(Text(selectedSubcategory?.name ?? 'N/A')), // Show only selected subcategory

                                      DataCell(Text(bill.items.first.quantity
                                          .toString())),
                                      DataCell(Text(selectedSubcategory?.unit
                                              ?.toString() ??
                                          'N/A')),
                                      DataCell(Text(bill.items.length.toString())),
                                          DataCell(Text(matchingItem != null ? matchingItem.total_Item_price.toString() : 'N/A')),

                                    ]);
                                  }
                                  ).toList(),
                                ),

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
                              ),
                            ),
                          ),
                        ),
                      ),
          ],
        ),
      ),
    );
  }

}

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