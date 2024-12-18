// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // For date formatting
// import 'package:system/features/billes/data/models/bill_model.dart';
// import 'package:system/features/category/data/models/category_model.dart';
// import 'package:system/features/category/data/models/subCategory_model.dart';
// import 'package:system/features/category/data/repositories/category_repository.dart';
// import 'package:system/features/report/UI/ReportCategoryOperationsPage.dart';
//
// class ItemsReportDashboard extends StatefulWidget {
//   @override
//   _ItemsReportDashboardState createState() => _ItemsReportDashboardState();
// }
//
// class _ItemsReportDashboardState extends State<ItemsReportDashboard> {
//   Future<List<Category>>? categories;
//   Map<String, List<Subcategory>> subcategoriesByCategory = {};
//   Map<String, int> categoryUsageCount = {};
//   Map<String, Map<String, int>> subcategoryUsageCount = {};
//   String? selectedCategoryName; // To track the selected category
//   int totalBills = 0; // To track the total number of bills
//   int totalDeferredBills = 0; // To track the total deferred bills
//   int totalPaidBills = 0; // To track the total paid bills
//   int totalOpenBills = 0; // To track the total open bills
//
//   List<Bill> bills = []; // List to store bills
//   bool isLoadingBills = false; // Track if bills are being loaded
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchCategoriesAndSubcategories();
//     _fetchTotalBillsByStatus();
//     _fetchTotalBills();
//   }
//
//   void _fetchCategoriesAndSubcategories() async {
//     categories = CategoryRepository().getCategories();
//     categories?.then((categoryList) {
//       for (var category in categoryList) {
//         _fetchSubcategories(category);
//         _fetchCategoryUsageCount(category);
//       }
//     }).catchError((error) {
//       print('Error fetching categories: $error');
//     });
//   }
//
//   void _fetchTotalBills() {
//     CategoryRepository().getTotalBills().then((count) {
//       setState(() {
//         totalBills = count;
//       });
//     }).catchError((error) {
//       print('Error fetching total bills: $error');
//     });
//   }
//
//   void _fetchTotalBillsByStatus() {
//     CategoryRepository().getTotalBillsByStatus().then((statusCounts) {
//       setState(() {
//         totalDeferredBills = statusCounts['آجل'] ?? 0;
//         totalPaidBills = statusCounts['تم الدفع'] ?? 0;
//         totalOpenBills = statusCounts['فاتورة مفتوحة'] ?? 0;
//       });
//     }).catchError((error) {
//       print('Error fetching total bills by status: $error');
//     });
//   }
//
//   void _fetchSubcategories(Category category) {
//     CategoryRepository().getSubcategories(category.id).then((subcategories) {
//       setState(() {
//         subcategoriesByCategory[category.name] = subcategories;
//         subcategoryUsageCount[category.name] = {};
//       });
//
//       for (var subcategory in subcategories) {
//         _fetchSubcategoryUsageCount(subcategory, category.name);
//       }
//     }).catchError((error) {
//       print('Error fetching subcategories: $error');
//     });
//   }
//
//   void _fetchCategoryUsageCount(Category category) {
//     CategoryRepository().getCategoryUsageCount(category.id).then((usageCount) {
//       if (mounted) {
//         setState(() {
//           categoryUsageCount[category.name] = usageCount;
//         });
//       }
//     }).catchError((error) {
//       print('Error fetching category usage count: $error');
//     });
//   }
//
//   void _fetchSubcategoryUsageCount(Subcategory subcategory, String categoryName) {
//     CategoryRepository().getSubcategoryUsageCount(subcategory.id).then((usageCount) {
//       if (mounted) {
//         setState(() {
//           subcategoryUsageCount[categoryName]?[subcategory.name] = usageCount;
//         });
//       }
//     }).catchError((error) {
//       print('Error fetching subcategory usage count: $error');
//     });
//   }
//
//   void _fetchBillsByStatus(String status) {
//     setState(() {
//       isLoadingBills = true;
//     });
//
//     CategoryRepository().getBillsByStatus(status).then((billList) {
//       if (mounted) {
//         setState(() {
//           bills = billList; // The list of Bill objects returned from getBillsByStatus
//           isLoadingBills = false;
//         });
//       }
//     }).catchError((error) {
//       if (mounted) {
//         setState(() {
//           isLoadingBills = false;
//         });
//       }
//       // Log and show error feedback
//       print('_fetchBillsByStatus Error fetching bills: $error');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('_fetchBillsByStatus Failed to fetch bills: $error')),
//       );
//     });
//   }
//
//   String formatDate(DateTime date) {
//     return DateFormat('yyyy-MM-dd').format(date);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Items Report Dashboard'),
//         backgroundColor: Colors.blueAccent,
//         actions: [
//           TextButton.icon(onPressed: (){
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => ReportCategoryOperationsPage()), // ItemsCharts هي اسم الشاشة التي تريد الانتقال إليها
//             );
//           }, label: Text("bill"))
//         ],
//       ),
//       body: Column(
//         children: [
//           Row(
//             children: [
//               // Container 1: Total Bills and Statuses
//               Expanded(
//                 flex: 1,
//                 child: Container(
//                   margin: EdgeInsets.all(10),
//                   padding: EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.blueAccent,
//                     borderRadius: BorderRadius.circular(8),
//                     boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       GestureDetector(
//                         onTap: () => _fetchBillsByStatus('All'), // View all bills
//                         child: Text(
//                           'اجمالي الفواتير: $totalBills',
//                           style: TextStyle(
//                             fontSize: 20,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       GestureDetector(
//                         onTap: () => _fetchBillsByStatus('آجل'), // View deferred bills
//                         child: Text(
//                           'الفواتير المؤجلة: $totalDeferredBills',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () => _fetchBillsByStatus('تم الدفع'), // View paid bills
//                         child: Text(
//                           'الفواتير المدفوعة: $totalPaidBills',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () => _fetchBillsByStatus('فاتورة مفتوحة'), // View open bills
//                         child: Text(
//                           'الفواتير المفتوحة: $totalOpenBills',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               // Container 2: List of categories
//                 Expanded(
//                   child: Container(
//                     height: 500,
//                     margin: EdgeInsets.all(10),
//                     padding: EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(8),
//                       boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
//                     ),
//                     child: FutureBuilder<List<Category>>(
//                       future: categories,
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState == ConnectionState.waiting) {
//                           return Center(child: CircularProgressIndicator());
//                         } else if (snapshot.hasError) {
//                           return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
//                         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                           return Center(child: Text('No categories available', style: TextStyle(fontStyle: FontStyle.italic)));
//                         } else {
//                           final categoryList = snapshot.data!;
//
//                           // Create a list of FutureBuilders for each category to fetch usage count
//                           return ListView.builder(
//                             itemCount: categoryList.length,
//                             itemBuilder: (context, index) {
//                               final category = categoryList[index];
//
//                               // Fetch the usage count asynchronously for each category
//                               return FutureBuilder<int>(
//                                 future: CategoryRepository().getCategoryUsageCount(category.id),
//                                 builder: (context, usageSnapshot) {
//                                   if (usageSnapshot.connectionState == ConnectionState.waiting) {
//                                     return Card(
//                                       margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                                       elevation: 4,
//                                       child: ListTile(
//                                         title: Text('${category.name} (Loading usage count...)'),
//                                       ),
//                                     );
//                                   } else if (usageSnapshot.hasError) {
//                                     return Card(
//                                       margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                                       elevation: 4,
//                                       child: ListTile(
//                                         title: Text('${category.name} (Error loading count)'),
//                                       ),
//                                     );
//                                   } else if (usageSnapshot.hasData) {
//                                     final categoryCount = usageSnapshot.data ?? 0;
//
//                                     return Card(
//                                       margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                                       elevation: 4,
//                                       child: ListTile(
//                                         contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                                         // leading: Icon(Icons.category, color: Colors.blue),  // Icon for category
//                                         title: Text('${category.name} (استخدم  $categoryCount في فاتورة)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
//                                         // subtitle: Text('Tap to select category', style: TextStyle(color: Colors.grey)),
//                                         onTap: () {
//                                           setState(() {
//                                             selectedCategoryName = category.name; // Set selected category
//                                           });
//                                         },
//                                       ),
//                                     );
//                                   } else {
//                                     return SizedBox.shrink(); // If there's no data, show nothing
//                                   }
//                                 },
//                               );
//                             },
//                           );
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//
//               // Container 3: Subcategories of the selected category
//               if (selectedCategoryName != null)
//                 Expanded(
//                   flex: 2,
//                   child: Container(
//                     height: 500,
//                     margin: EdgeInsets.all(10),
//                     padding: EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(8),
//                       boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
//                     ),
//                     child: subcategoriesByCategory[selectedCategoryName] != null &&
//                         subcategoriesByCategory[selectedCategoryName]!.isNotEmpty
//                         ? ListView.builder(
//                       itemCount: subcategoriesByCategory[selectedCategoryName]!.length,
//                       itemBuilder: (context, index) {
//                         final subcategory = subcategoriesByCategory[selectedCategoryName]![index];
//                         final subcategoryCount = subcategoryUsageCount[selectedCategoryName]?[subcategory.name] ?? 0;
//
//                         return Card(
//                           margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                           elevation: 4,
//                           child: ListTile(
//                             title: Text('${subcategory.name} (Used $subcategoryCount times)'),
//                           ),
//                         );
//                       },
//                     )
//                         : Center(child: Text('No subcategories available')),
//                   ),
//                 ),
//             ],
//           ),
//           // DataTable for Bills
//           Expanded(
//             child: isLoadingBills
//                 ? Center(child: CircularProgressIndicator())
//                 : SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: DataTable(
//                 columns: [
//                   DataColumn(label: Text('Bill ID')),
//                   DataColumn(label: Text('Customer Name')),
//                   DataColumn(label: Text('Date')),
//                   DataColumn(label: Text('Total Price')),
//                   DataColumn(label: Text('Payment Status')),
//                 ],
//                 rows: bills.map((bill) {
//                   return DataRow(cells: [
//                     DataCell(Text(bill.id.toString())),
//                     DataCell(Text(bill.customerName)),
//                     DataCell(Text(formatDate(bill.date))),
//                     DataCell(Text(bill.total_price.toString())),
//                     DataCell(Text(bill.payment.toString())),
//                   ]);
//                 }).toList(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // For date formatting
// import 'package:system/features/billes/data/models/bill_model.dart';
// import 'package:system/features/category/data/models/category_model.dart';
// import 'package:system/features/category/data/models/subCategory_model.dart';
// import 'package:system/features/category/data/repositories/category_repository.dart';
// import 'package:system/features/report/UI/ReportCategoryOperationsPage.dart';
//
// class ItemsReportDashboard extends StatefulWidget {
//   @override
//   _ItemsReportDashboardState createState() => _ItemsReportDashboardState();
// }
//
// class _ItemsReportDashboardState extends State<ItemsReportDashboard> {
//   Future<List<Category>>? categories;
//   Map<String, List<Subcategory>> subcategoriesByCategory = {};
//   Map<String, int> categoryUsageCount = {};
//   Map<String, Map<String, int>> subcategoryUsageCount = {};
//   String? selectedCategoryName;
//   int totalBills = 0;
//   int totalDeferredBills = 0;
//   int totalPaidBills = 0;
//   int totalOpenBills = 0;
//
//   List<Bill> bills = [];
//   bool isLoadingBills = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchCategoriesAndSubcategories();
//     _fetchTotalBillsByStatus();
//     _fetchTotalBills();
//   }
//
//   // Step 1: Create the new fetchCategories method.
//   Future<void> fetchCategories() async {
//     try {
//       final categoryList = await CategoryRepository().getCategories();
//       print('Fetched categories: $categoryList'); // Debugging line
//
//       setState(() {
//         categories = Future.value(categoryList); // Update the categories future.
//       });
//
//       // Step 2: Fetch subcategories and usage count for each category asynchronously.
//       for (var category in categoryList) {
//         await Future.wait([
//           fetchSubcategories(category),
//           fetchCategoryUsageCount(category),
//         ]);
//       }
//     } catch (error) {
//       print('Error fetching categories: $error');
//       setState(() {
//         categories = Future.value([]); // Ensure categories is an empty list on error
//       });
//     }
//   }
//
// // Step 3: Refactor _fetchCategoriesAndSubcategories to simply call fetchCategories.
//   void _fetchCategoriesAndSubcategories() {
//     fetchCategories(); // Call the new fetchCategories function.
//   }
//
// // Step 4: Other helper functions for fetching subcategories and category usage count.
//   Future<void> fetchSubcategories(Category category) async {
//     try {
//       final subcategories = await CategoryRepository().getSubcategories(category.id);
//       setState(() {
//         subcategoriesByCategory[category.name] = subcategories;
//         subcategoryUsageCount[category.name] = {};
//       });
//
//       for (var subcategory in subcategories) {
//         await fetchSubcategoryUsageCount(subcategory, category.name);
//       }
//     } catch (error) {
//       print('Error fetching subcategories: $error');
//     }
//   }
//
//   Future<void> fetchCategoryUsageCount(Category category) async {
//     try {
//       final usageCount = await CategoryRepository().getCategoryUsageCount(category.id);
//       setState(() {
//         categoryUsageCount[category.name] = usageCount;
//       });
//     } catch (error) {
//       print('Error fetching category usage count: $error');
//     }
//   }
//
//   Future<void> fetchSubcategoryUsageCount(Subcategory subcategory, String categoryName) async {
//     try {
//       final usageCount = await CategoryRepository().getSubcategoryUsageCount(subcategory.id);
//       setState(() {
//         subcategoryUsageCount[categoryName]?[subcategory.name] = usageCount;
//       });
//     } catch (error) {
//       print('Error fetching subcategory usage count: $error');
//     }
//   }
//
//
//   Future<void> _fetchTotalBills() async {
//     try {
//       totalBills = await CategoryRepository().getTotalBills();
//       setState(() {});
//     } catch (error) {
//       print('Error fetching total bills: $error');
//     }
//   }
//
//   Future<void> _fetchTotalBillsByStatus() async {
//     try {
//       final statusCounts = await CategoryRepository().getTotalBillsByStatus();
//       setState(() {
//         totalDeferredBills = statusCounts['آجل'] ?? 0;
//         totalPaidBills = statusCounts['تم الدفع'] ?? 0;
//         totalOpenBills = statusCounts['فاتورة مفتوحة'] ?? 0;
//       });
//     } catch (error) {
//       print('Error fetching total bills by status: $error');
//     }
//   }
//
//
//   Future<void> _fetchBillsByStatus(String status) async {
//     setState(() {
//       isLoadingBills = true;
//     });
//
//     try {
//       final billList = await CategoryRepository().getBillsByStatus(status);
//       setState(() {
//         bills = billList;
//         isLoadingBills = false;
//       });
//     } catch (error) {
//       setState(() {
//         isLoadingBills = false;
//       });
//       print('Error fetching bills: $error');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to fetch bills: $error')),
//       );
//     }
//   }
//
//   String formatDate(DateTime date) {
//     return DateFormat('yyyy-MM-dd').format(date);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Items Report Dashboard'),
//         backgroundColor: Colors.blueAccent,
//         actions: [
//           TextButton.icon(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => ReportCategoryOperationsPage()),
//               );
//             },
//             label: Text("bill"),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Row(
//             children: [
//               // Container 1: Total Bills and Statuses
//               _buildBillStatusContainer(),
//                ],
//           ),
//           Row(
//             children: [
//               // Container 2: List of categories
//               _buildCategoriesList(),
//               // Container 3: Subcategories of the selected category
//               if (selectedCategoryName != null)
//                 _buildSubcategoryList(),
//
//             ],
//           ),
//           // DataTable for Bills
//           Expanded(
//             child: isLoadingBills
//                 ? Center(child: CircularProgressIndicator())
//                 : SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: DataTable(
//                 columns: [
//                   DataColumn(label: Text('Bill ID')),
//                   DataColumn(label: Text('Customer Name')),
//                   DataColumn(label: Text('Date')),
//                   DataColumn(label: Text('Total Price')),
//                   DataColumn(label: Text('Payment Status')),
//                 ],
//                 rows: bills.map((bill) {
//                   return DataRow(cells: [
//                     DataCell(Text(bill.id.toString())),
//                     DataCell(Text(bill.customerName)),
//                     DataCell(Text(formatDate(bill.date))),
//                     DataCell(Text(bill.total_price.toString())),
//                     DataCell(Text(bill.payment.toString())),
//                   ]);
//                 }).toList(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBillStatusContainer() {
//     return Expanded(
//       flex: 1,
//       child: Container(
//         margin: EdgeInsets.all(10),
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.blueAccent,
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildBillStatusText('اجمالي الفواتير: $totalBills', 'All'),
//             _buildBillStatusText('الفواتير المؤجلة: $totalDeferredBills', 'آجل'),
//             _buildBillStatusText('الفواتير المدفوعة: $totalPaidBills', 'تم الدفع'),
//             _buildBillStatusText('الفواتير المفتوحة: $totalOpenBills', 'فاتورة مفتوحة'),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBillStatusText(String text, String status) {
//     return GestureDetector(
//       onTap: () => _fetchBillsByStatus(status),
//       child: Text(
//         text,
//         style: TextStyle(fontSize: 16, color: Colors.white),
//       ),
//     );
//   }
//
//   Widget _buildCategoriesList() {
//     return Expanded(
//       child: Container(
//         width: 100,
//         height: 200,
//         margin: EdgeInsets.all(10),
//         padding: EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
//         ),
//         child: FutureBuilder<List<Category>>(
//           future: categories,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return Center(child: Text('No categories available', style: TextStyle(fontStyle: FontStyle.italic)));
//             } else {
//               final categoryList = snapshot.data!;
//               return ListView.builder(
//                 itemCount: categoryList.length,
//                 itemBuilder: (context, index) {
//                   final category = categoryList[index];
//                   return _buildCategoryCard(category);
//                 },
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCategoryCard(Category category) {
//     return FutureBuilder<int>(
//       future: CategoryRepository().getCategoryUsageCount(category.id),
//       builder: (context, usageSnapshot) {
//         if (usageSnapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }
//         if (usageSnapshot.hasError) {
//           return Center(child: Text('Error fetching usage count'));
//         }
//
//         final usageCount = usageSnapshot.data ?? 0;
//
//         return Card(
//           child: ListTile(
//             title: Text(category.name),
//             subtitle: Text('Usage count: $usageCount'),
//             onTap: () {
//               setState(() {
//                 selectedCategoryName = category.name;
//               });
//             },
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildSubcategoryList() {
//     final subcategories = subcategoriesByCategory[selectedCategoryName] ?? [];
//     return Expanded(
//       child: Container(
//         margin: EdgeInsets.all(10),
//         padding: EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
//         ),
//         child: ListView.builder(
//           itemCount: subcategories.length,
//           itemBuilder: (context, index) {
//             final subcategory = subcategories[index];
//             return Card(
//               child: ListTile(
//                 title: Text(subcategory.name),
//                 subtitle: Text('Usage count: ${subcategoryUsageCount[selectedCategoryName]?[subcategory.name] ?? 0}'),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/category/data/models/category_model.dart';
import 'package:system/features/category/data/models/subCategory_model.dart';
import 'package:system/features/category/data/repositories/category_repository.dart';
import 'package:system/features/report/UI/ReportCategoryOperationsPage.dart';

class ItemsReportDashboard extends StatefulWidget {
  @override
  _ItemsReportDashboardState createState() => _ItemsReportDashboardState();
}

class _ItemsReportDashboardState extends State<ItemsReportDashboard> {
  Future<List<Category>>? categories;
  Map<String, List<Subcategory>> subcategoriesByCategory = {};
  Map<String, int> categoryUsageCount = {};
  Map<String, Map<String, int>> subcategoryUsageCount = {};
  String? selectedCategoryName;
  int totalBills = 0;
  int totalDeferredBills = 0;
  int totalPaidBills = 0;
  int totalOpenBills = 0;

  List<Bill> bills = [];
  bool isLoadingBills = false;

  @override
  void initState() {
    super.initState();
     fetchCategories();
    _fetchTotalBillsByStatus();
    _fetchTotalBills();
  }

  Future<void> fetchCategories() async {
    try {
      final categoryList = await CategoryRepository().getCategories();
      setState(() {
        categories = Future.value(categoryList);
      });

      for (var category in categoryList) {
        await Future.wait([
          fetchSubcategories(category),
          fetchCategoryUsageCount(category),
        ]);
      }
    } catch (error) {
      setState(() {
        categories = Future.value([]);
      });
    }
  }

  Future<void> fetchSubcategories(Category category) async {
    try {
      final subcategories = await CategoryRepository().getSubcategories(category.id);
      setState(() {
        subcategoriesByCategory[category.name] = subcategories;
        subcategoryUsageCount[category.name] = {};
      });

      for (var subcategory in subcategories) {
        await fetchSubcategoryUsageCount(subcategory, category.name);
      }
    } catch (error) {
      print('Error fetching subcategories: $error');
    }
  }

  Future<void> fetchCategoryUsageCount(Category category) async {
    try {
      final usageCount = await CategoryRepository().getCategoryUsageCount(category.id);
      setState(() {
        categoryUsageCount[category.name] = usageCount;
      });
    } catch (error) {
      print('Error fetching category usage count: $error');
    }
  }

  Future<void> fetchSubcategoryUsageCount(Subcategory subcategory, String categoryName) async {
    try {
      final usageSubCount = await CategoryRepository().getSubcategoryUsageCount(subcategory.id);
      setState(() {
        subcategoryUsageCount[categoryName]?[subcategory.name] = usageSubCount;
      });
    } catch (error) {
      print('Error fetching subcategory usage count: $error');
    }
  }

  Future<void> _fetchTotalBills() async {
    try {
      totalBills = await CategoryRepository().getTotalBills();
      setState(() {});
    } catch (error) {
      print('Error fetching total bills: $error');
    }
  }

  Future<void> _fetchTotalBillsByStatus() async {
    try {
      final statusCounts = await CategoryRepository().getTotalBillsByStatus();
      setState(() {
        totalDeferredBills = statusCounts['آجل'] ?? 0;
        totalPaidBills = statusCounts['تم الدفع'] ?? 0;
        totalOpenBills = statusCounts['فاتورة مفتوحة'] ?? 0;
      });
    } catch (error) {
      print('Error fetching total bills by status: $error');
    }
  }

  Future<void> _fetchBillsByStatus(String status) async {
    setState(() {
      isLoadingBills = true;
    });

    try {
      final billList = await CategoryRepository().getBillsByStatus(status);
      setState(() {
        bills = billList;
        isLoadingBills = false;
      });
    } catch (error) {
      setState(() {
        isLoadingBills = false;
      });
      print('Error fetching bills: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch bills: $error')),
      );
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' التقارير بالمنتجات و الفواتير'),
        backgroundColor: Colors.blueAccent,
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReportCategoryOperationsPage()),
              );
            },
            label: Text("bill"),
          ),
        ],
      ),
      body: SingleChildScrollView(  // Wrap the entire body in SingleChildScrollView for scrolling
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  // Container 1: Total Bills and Statuses
                  _buildBillStatusContainer(),
                ],
              ),
              Row(
                children: [
                  // Container 2: List of categories
                  _buildCategoriesList(),
                  // Container 3: Subcategories of the selected category
                  if (selectedCategoryName != null) _buildSubcategoryList(),
                ],
              ),

              // DataTable for Bills (Container 4)
              isLoadingBills
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(  // Horizontal scrolling for DataTable
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Bill ID')),
                    DataColumn(label: Text('Customer Name')),
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Total Price')),
                    DataColumn(label: Text('Payment Status')),
                  ],
                  rows: bills.map((bill) {
                    return DataRow(cells: [
                      DataCell(Text(bill.id.toString())),
                      DataCell(Text(bill.customerName)),
                      DataCell(Text(formatDate(bill.date))),
                      DataCell(Text(bill.total_price.toString())),
                      DataCell(Text(bill.payment.toString())),
                    ]);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),

      // body: Center(
      //
      //   child: Column(
      //     children: [
      //       Row(
      //         children: [
      //           // Container 1: Total Bills and Statuses
      //           _buildBillStatusContainer(),
      //         ],
      //       ),
      //      Row(children: [
      //        // Container 2: List of categories
      //        _buildCategoriesList(),
      //        // Container 3: Subcategories of the selected category
      //        if (selectedCategoryName != null) _buildSubcategoryList(),
      //
      //
      //      ],),
      //
      //       // DataTable for Bills (Container 4)
      //       Expanded(
      //         child: isLoadingBills
      //             ? Center(child: CircularProgressIndicator())
      //             : SingleChildScrollView(
      //           scrollDirection: Axis.horizontal,
      //           child: DataTable(
      //             columns: [
      //               DataColumn(label: Text('Bill ID')),
      //               DataColumn(label: Text('Customer Name')),
      //               DataColumn(label: Text('Date')),
      //               DataColumn(label: Text('Total Price')),
      //               DataColumn(label: Text('Payment Status')),
      //             ],
      //             rows: bills.map((bill) {
      //               return DataRow(cells: [
      //                 DataCell(Text(bill.id.toString())),
      //                 DataCell(Text(bill.customerName)),
      //                 DataCell(Text(formatDate(bill.date))),
      //                 DataCell(Text(bill.total_price.toString())),
      //                 DataCell(Text(bill.payment.toString())),
      //               ]);
      //             }).toList(),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  Widget _buildBillStatusContainer() {
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBillStatusText('اجمالي الفواتير: $totalBills', 'All'),
            _buildBillStatusText('الفواتير المؤجلة: $totalDeferredBills', 'آجل'),
            _buildBillStatusText('الفواتير المدفوعة: $totalPaidBills', 'تم الدفع'),
            _buildBillStatusText('الفواتير المفتوحة: $totalOpenBills', 'فاتورة مفتوحة'),
          ],
        ),
      ),
    );
  }

  Widget _buildBillStatusText(String text, String status) {
    return GestureDetector(
      onTap: () => _fetchBillsByStatus(status),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }

  Widget _buildCategoriesList() {
    return Expanded(
      child: Container(
        width: 100,
        height: 500,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
        ),
        child: FutureBuilder<List<Category>>(
          future: categories,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No categories available', style: TextStyle(fontStyle: FontStyle.italic)));
            } else {
              final categoryList = snapshot.data!;
              return ListView.builder(
                itemCount: categoryList.length,
                itemBuilder: (context, index) {
                  final category = categoryList[index];
                  return _buildCategoryCard(category);
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Category category) {
    return FutureBuilder<int>(
      future: CategoryRepository().getCategoryUsageCount(category.id),
      builder: (context, usageSnapshot) {
        final usageCount = usageSnapshot.data ?? 0;

        return Card(
          elevation: 5,
          margin: EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            title: Text(category.name),
            subtitle: Text('استخدم: $usageCount'),
            onTap: () {
              setState(() {
                selectedCategoryName = category.name;
              });
              fetchSubcategories(category);
            },
          ),
        );
      },
    );
  }

  Widget _buildSubcategoryList() {
    return Container(
      margin: EdgeInsets.all(10),
      width: 600,
      height: 500,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: ListView.builder(
        itemCount: subcategoriesByCategory[selectedCategoryName]?.length ?? 0,
        itemBuilder: (context, index) {
          final subcategory = subcategoriesByCategory[selectedCategoryName]![index];

          return FutureBuilder<int>(
            future: CategoryRepository().getSubcategoryUsageCount(subcategory.id),
            builder: (context, usageSnapshot) {
              final usageSubCount = usageSnapshot.data ?? 0;

              return ListTile(
                title: Text(subcategory.name),
                subtitle: Text('استخدم: $usageSubCount'),
              );
            },
          );
        },
      ),
    );
  }


}
