import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/category/data/models/category_model.dart';
import 'package:system/features/category/data/models/subCategory_model.dart';
import 'package:system/features/category/data/repositories/category_repository.dart'; // Replace with your repository imports

class ReportCategoryOperationsPage extends StatefulWidget {
  @override
  _ReportCategoryOperationsPageState createState() => _ReportCategoryOperationsPageState();
}

class _ReportCategoryOperationsPageState extends State<ReportCategoryOperationsPage> {
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  Category? selectedCategory;
  Subcategory? selectedSubcategory;
  List<Category> categories = [];
  List<Subcategory> subcategories = [];
  List<Bill> bills = [];
  bool isLoading = false;

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
      final List<Category> categoryList = await CategoryRepository().getCategories();
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
      final List<Subcategory> subcategoryList = await CategoryRepository().getSubcategories(categoryId);
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
    if (selectedStartDate == null || selectedEndDate == null || selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('برجاء ادخال التاريخ و الصنف الفرعي ')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final billsList = await CategoryRepository().getBillsFiltered(
        categoryName: selectedCategory!.name,
        subcategoryName: selectedSubcategory?.name,
        startDate: selectedStartDate!,
        endDate: selectedEndDate!,
      );

      // Check if the widget is still mounted before calling setState()
      if (mounted) {
        setState(() {
          bills = billsList;
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
            Text("تقرير عمليات صنف خلال مدة زمنية :", style: TextStyle(fontSize: 16 ,fontWeight: FontWeight.bold),),
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
            // Bills List
            isLoading
                ? Center(child: CircularProgressIndicator())
                :
// Bills List
            isLoading
                ? Center(child: CircularProgressIndicator())
                : bills.isEmpty
                ? Center(child: Text('لا يوجد فواتير .'))
                : SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Enable horizontal scrolling for the table
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('رقم الفاتورة')),
                  DataColumn(label: Text('تاريخ ')),
                  DataColumn(label: Text('اسم العميل ')),
                  DataColumn(label: Text('الصنف الرئسي')),
                  DataColumn(label: Text('الصنف الفرعي')),
                  DataColumn(label: Text('الكمية')),
                  DataColumn(label: Text('Items')),
                ],
                rows: bills
                    .where((bill) {
                  // Filter by selected category
                  final categoriesMatch = bill.items.any((item) => item.categoryName == selectedCategory?.name);
                  // Filter by selected subcategory if it's selected
                  final subcategoriesMatch = selectedSubcategory == null ||
                      bill.items.any((item) => item.subcategoryName == selectedSubcategory?.name);

                  return categoriesMatch && subcategoriesMatch;
                })
                    .map((bill) {
                  // Handle empty categories and subcategories
                  final categories = bill.items.isEmpty
                      ? 'No category in bills'
                      : bill.items.map((item) => item.categoryName).join(', ');

                  final subcategories = bill.items.isEmpty
                      ? 'No subcategory in bills'
                      : bill.items.map((item) => item.subcategoryName).join(', ');

                  final displayCategory = categories.isEmpty ? 'N/A' : categories;
                  final displaySubcategory = subcategories.isEmpty ? 'N/A' : subcategories;

                  return DataRow(cells: [
                    DataCell(Text(bill.id.toString())),
                    DataCell(Text(DateFormat('yyyy-MM-dd').format(bill.date))),
                    DataCell(Text(bill.customerName.toString())),
                    DataCell(Text(displayCategory)),
                    DataCell(Text(displaySubcategory)),
                    DataCell(Text(bill.items.first.quantity.toString())),
                    DataCell(Text(bill.items.length.toString())),

                  ]);
                })
                    .toList(),
              ),
            ),          ],
        ),
      ),
    );
  }
}
