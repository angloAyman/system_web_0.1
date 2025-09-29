// // // // import 'package:flutter/material.dart';
// // // // import 'package:intl/intl.dart'; // For date formatting
// // // // import 'package:system/core/themes/AppColors/them_constants.dart';
// // // // import 'package:system/features/billes/data/models/bill_model.dart';
// // // // import 'package:system/features/category/data/models/category_model.dart';
// // // // import 'package:system/features/category/data/models/subCategory_model.dart';
// // // // import 'package:system/features/category/data/repositories/category_repository.dart';
// // // // import 'package:system/features/report/UI/reportcategory/ReportCategoryOperationsPage.dart';
// // // //
// // // // class ItemsReportDashboardMobile extends StatefulWidget {
// // // //   @override
// // // //   _ItemsReportDashboardMobileState createState() => _ItemsReportDashboardMobileState();
// // // // }
// // // //
// // // // class _ItemsReportDashboardMobileState extends State<ItemsReportDashboardMobile> {
// // // //   Future<List<Category>>? categories;
// // // //   Map<String, List<Subcategory>> subcategoriesByCategory = {};
// // // //   Map<String, int> categoryUsageCount = {};
// // // //   Map<String, Map<String, int>> subcategoryUsageCount = {};
// // // //   String? selectedCategoryName;
// // // //   int totalBills = 0;
// // // //   int totalDeferredBills = 0;
// // // //   int totalPaidBills = 0;
// // // //   int totalOpenBills = 0;
// // // //
// // // //   List<Bill> bills = [];
// // // //   bool isLoadingBills = false;
// // // //
// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     fetchCategories();
// // // //     _fetchTotalBillsByStatus();
// // // //     _fetchTotalBills();
// // // //   }
// // // //
// // // //   Future<void> fetchCategories() async {
// // // //     try {
// // // //       final categoryList = await CategoryRepository().getCategories();
// // // //       setState(() {
// // // //         categories = Future.value(categoryList);
// // // //       });
// // // //
// // // //       for (var category in categoryList) {
// // // //         await Future.wait([
// // // //           fetchSubcategories(category),
// // // //           fetchCategoryUsageCount(category),
// // // //         ]);
// // // //       }
// // // //     } catch (error) {
// // // //       setState(() {
// // // //         categories = Future.value([]);
// // // //       });
// // // //     }
// // // //   }
// // // //
// // // //   Future<void> fetchSubcategories(Category category) async {
// // // //     try {
// // // //       final subcategories = await CategoryRepository().getSubcategories(category.id);
// // // //       setState(() {
// // // //         subcategoriesByCategory[category.name] = subcategories;
// // // //         subcategoryUsageCount[category.name] = {};
// // // //       });
// // // //
// // // //       for (var subcategory in subcategories) {
// // // //         await fetchSubcategoryUsageCount(subcategory, category.name);
// // // //       }
// // // //     } catch (error) {
// // // //       print('Error fetching subcategories: $error');
// // // //     }
// // // //   }
// // // //
// // // //   Future<void> fetchCategoryUsageCount(Category category) async {
// // // //     try {
// // // //       final usageCount = await CategoryRepository().getCategoryUsageCount(category.id);
// // // //       setState(() {
// // // //         categoryUsageCount[category.name] = usageCount;
// // // //       });
// // // //     } catch (error) {
// // // //       print('Error fetching category usage count: $error');
// // // //     }
// // // //   }
// // // //
// // // //   Future<void> fetchSubcategoryUsageCount(Subcategory subcategory, String categoryName) async {
// // // //     try {
// // // //       final usageSubCount = await CategoryRepository().getSubcategoryUsageCount(subcategory.id);
// // // //       setState(() {
// // // //         subcategoryUsageCount[categoryName]?[subcategory.name] = usageSubCount;
// // // //       });
// // // //     } catch (error) {
// // // //       print('Error fetching subcategory usage count: $error');
// // // //     }
// // // //   }
// // // //
// // // //   Future<void> _fetchTotalBills() async {
// // // //     try {
// // // //       totalBills = await CategoryRepository().getTotalBills();
// // // //       setState(() {});
// // // //     } catch (error) {
// // // //       print('Error fetching total bills: $error');
// // // //     }
// // // //   }
// // // //
// // // //   Future<void> _fetchTotalBillsByStatus() async {
// // // //     try {
// // // //       final statusCounts = await CategoryRepository().getTotalBillsByStatus();
// // // //       setState(() {
// // // //         totalDeferredBills = statusCounts['آجل'] ?? 0;
// // // //         totalPaidBills = statusCounts['تم الدفع'] ?? 0;
// // // //         totalOpenBills = statusCounts['فاتورة مفتوحة'] ?? 0;
// // // //       });
// // // //     } catch (error) {
// // // //       print('Error fetching total bills by status: $error');
// // // //     }
// // // //   }
// // // //
// // // //   Future<void> _fetchBillsByStatus(String status) async {
// // // //     setState(() {
// // // //       isLoadingBills = true;
// // // //     });
// // // //
// // // //     try {
// // // //       final billList = await CategoryRepository().getBillsByStatus(status);
// // // //       setState(() {
// // // //         bills = billList;
// // // //         isLoadingBills = false;
// // // //       });
// // // //     } catch (error) {
// // // //       setState(() {
// // // //         isLoadingBills = false;
// // // //       });
// // // //       print('Error fetching bills: $error');
// // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // //         SnackBar(content: Text('Failed to fetch bills: $error')),
// // // //       );
// // // //     }
// // // //   }
// // // //
// // // //   String formatDate(DateTime date) {
// // // //     return DateFormat('yyyy-MM-dd').format(date);
// // // //   }
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(
// // // //         title: Text(' التقارير بالمنتجات و الفواتير'),
// // // //         // backgroundColor: Colors.blueAccent,
// // // //         actions: [
// // // //           TextButton.icon(
// // // //             onPressed: () {
// // // //               Navigator.push(
// // // //                 context,
// // // //                 MaterialPageRoute(builder: (context) => ReportCategoryOperationsPage()),
// // // //               );
// // // //             },
// // // //             label: Text("bill"),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //       body: SingleChildScrollView(  // Wrap the entire body in SingleChildScrollView for scrolling
// // // //         child: Center(
// // // //           child: Column(
// // // //             children: [
// // // //               Row(
// // // //                 children: [
// // // //                   // Container 1: Total Bills and Statuses
// // // //                   _buildBillStatusContainer(),
// // // //                 ],
// // // //               ),
// // // //               Row(
// // // //                 children: [
// // // //                   // Container 2: List of categories
// // // //                   _buildCategoriesList(),
// // // //                   // Container 3: Subcategories of the selected category
// // // //                   if (selectedCategoryName != null) _buildSubcategoryList(),
// // // //                 ],
// // // //               ),
// // // //
// // // //               // DataTable for Bills (Container 4)
// // // //               isLoadingBills
// // // //                   ? Center(child: CircularProgressIndicator())
// // // //                   : SingleChildScrollView(  // Horizontal scrolling for DataTable
// // // //                 scrollDirection: Axis.horizontal,
// // // //                 child: DataTable(
// // // //                   columns: [
// // // //                     DataColumn(label: Text('Bill ID')),
// // // //                     DataColumn(label: Text('Customer Name')),
// // // //                     DataColumn(label: Text('Date')),
// // // //                     DataColumn(label: Text('Total Price')),
// // // //                     DataColumn(label: Text('Payment Status')),
// // // //                   ],
// // // //                   rows: bills.map((bill) {
// // // //                     return DataRow(cells: [
// // // //                       DataCell(Text(bill.id.toString())),
// // // //                       DataCell(Text(bill.customerName)),
// // // //                       DataCell(Text(formatDate(bill.date))),
// // // //                       DataCell(Text(bill.total_price.toString())),
// // // //                       DataCell(Text(bill.payment.toString())),
// // // //                     ]);
// // // //                   }).toList(),
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildBillStatusContainer() {
// // // //     return Expanded(
// // // //       flex: 1,
// // // //       child: Container(
// // // //         margin: EdgeInsets.all(10),
// // // //         padding: EdgeInsets.all(16),
// // // //         decoration: BoxDecoration(
// // // //           color: AppBarTheme.of(context).surfaceTintColor,
// // // //           borderRadius: BorderRadius.circular(8),
// // // //           boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
// // // //         ),
// // // //         child: Column(
// // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // //           children: [
// // // //             _buildBillStatusText('اجمالي الفواتير: $totalBills', 'All'),
// // // //             _buildBillStatusText('الفواتير المؤجلة: $totalDeferredBills', 'آجل'),
// // // //             _buildBillStatusText('الفواتير المدفوعة: $totalPaidBills', 'تم الدفع'),
// // // //             _buildBillStatusText('الفواتير المفتوحة: $totalOpenBills', 'فاتورة مفتوحة'),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildBillStatusText(String text, String status) {
// // // //     return GestureDetector(
// // // //       onTap: () => _fetchBillsByStatus(status),
// // // //       child: Text(
// // // //         text,
// // // //         style: TextStyle(fontSize: 16,  color: AppBarTheme.of(context).titleTextStyle?.color),
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildCategoriesList() {
// // // //     return Expanded(
// // // //       child: Container(
// // // //         width: 100,
// // // //         height: 500,
// // // //         margin: EdgeInsets.all(10),
// // // //         padding: EdgeInsets.all(8),
// // // //         decoration: BoxDecoration(
// // // //           color: AppBarTheme.of(context).backgroundColor,
// // // //           borderRadius: BorderRadius.circular(8),
// // // //           boxShadow: [BoxShadow(color: Colors.black87, blurRadius: 4)],
// // // //         ),
// // // //         child: FutureBuilder<List<Category>>(
// // // //           future: categories,
// // // //           builder: (context, snapshot) {
// // // //             if (snapshot.connectionState == ConnectionState.waiting) {
// // // //               return Center(child: CircularProgressIndicator());
// // // //             } else if (snapshot.hasError) {
// // // //               return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
// // // //             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
// // // //               return Center(child: Text('No categories available', style: TextStyle(fontStyle: FontStyle.italic)));
// // // //             } else {
// // // //               final categoryList = snapshot.data!;
// // // //               return ListView.builder(
// // // //                 itemCount: categoryList.length,
// // // //                 itemBuilder: (context, index) {
// // // //                   final category = categoryList[index];
// // // //                   return _buildCategoryCard(category);
// // // //                 },
// // // //               );
// // // //             }
// // // //           },
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildCategoryCard(Category category) {
// // // //     return FutureBuilder<int>(
// // // //       future: CategoryRepository().getCategoryUsageCount(category.id),
// // // //       builder: (context, usageSnapshot) {
// // // //         final usageCount = usageSnapshot.data ?? 0;
// // // //
// // // //         return Card(
// // // //           elevation: 5,
// // // //           margin: EdgeInsets.symmetric(vertical: 5),
// // // //           child: ListTile(
// // // //             title: Text(category.name),
// // // //             subtitle: Text('استخدم: $usageCount'),
// // // //             onTap: () {
// // // //               setState(() {
// // // //                 selectedCategoryName = category.name;
// // // //               });
// // // //               fetchSubcategories(category);
// // // //             },
// // // //           ),
// // // //         );
// // // //       },
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildSubcategoryList() {
// // // //     return Container(
// // // //       margin: EdgeInsets.all(10),
// // // //       width: 600,
// // // //       height: 500,
// // // //       decoration: BoxDecoration(
// // // //         color: AppBarTheme.of(context).surfaceTintColor,
// // // //         borderRadius: BorderRadius.circular(8),
// // // //         boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
// // // //       ),
// // // //       child: ListView.builder(
// // // //         itemCount: subcategoriesByCategory[selectedCategoryName]?.length ?? 0,
// // // //         itemBuilder: (context, index) {
// // // //           final subcategory = subcategoriesByCategory[selectedCategoryName]![index];
// // // //
// // // //           return FutureBuilder<int>(
// // // //             future: CategoryRepository().getSubcategoryUsageCount(subcategory.id),
// // // //             builder: (context, usageSnapshot) {
// // // //               final usageSubCount = usageSnapshot.data ?? 0;
// // // //
// // // //               return ListTile(
// // // //                 title: Text(subcategory.name),
// // // //                 subtitle: Text('استخدم: $usageSubCount'),
// // // //               );
// // // //             },
// // // //           );
// // // //         },
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //
// // // // }
// // //
//
//
//
//
// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// // import 'package:system/core/themes/AppColors/them_constants.dart';
// // import 'package:system/features/billes/data/models/bill_model.dart';
// // import 'package:system/features/billes/data/repositories/bill_repository.dart';
// // import 'package:system/features/category/data/models/category_model.dart';
// // import 'package:system/features/category/data/models/subCategory_model.dart';
// // import 'package:system/features/category/data/repositories/category_repository.dart';
// // import 'package:system/features/report/UI/reportcategory/ReportCategoryOperationsPage.dart';
// //
// // class ItemsReportDashboardMobile extends StatefulWidget {
// //   @override
// //   _ItemsReportDashboardMobileState createState() => _ItemsReportDashboardMobileState();
// // }
// //
// // class _ItemsReportDashboardMobileState extends State<ItemsReportDashboardMobile> {
// //   // Repositories
// //   final CategoryRepository _repository = CategoryRepository();
// //   final BillRepository _billRepository = BillRepository();
// //
// //   // Data storage
// //   final Map<String, List<Subcategory>> _subcategoriesByCategory = {};
// //   final Map<String, int> _categoryUsageCount = {};
// //   final Map<String, Map<String, int>> _subcategoryUsageCount = {};
// //   List<Bill> _bills = [];
// //
// //   // UI state
// //   String? _selectedCategoryName;
// //   String? _selectedStatus;
// //   int _currentTabIndex = 0;
// //
// //   // Counters
// //   int _totalBills = 0;
// //   int _totalDeferredBills = 0;
// //   int _totalPaidBills = 0;
// //   int _totalOpenBills = 0;
// //
// //   // Loading states
// //   bool _isLoadingBills = false;
// //   bool _isLoadingCategories = false;
// //
// //   // Controllers and helpers
// //   final ScrollController _scrollController = ScrollController();
// //   final Map<String, String> _subcategoryErrors = {};
// //   final DateFormat _dateFormatter = DateFormat('yyyy/MM/dd');
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadInitialData();
// //   }
// //
// //   @override
// //   void dispose() {
// //     _scrollController.dispose();
// //     super.dispose();
// //   }
// //
// //   // Data loading methods
// //   Future<void> _loadInitialData() async {
// //     try {
// //       await Future.wait([
// //         _fetchCategories(),
// //         _fetchBillStatistics(),
// //         _fetchBillsByStatus(null),
// //       ]);
// //     } catch (e) {
// //       _showErrorSnackbar('فشل تحميل البيانات الأولية: ${e.toString()}');
// //     }
// //   }
// //
// //   Future<void> _fetchBillStatistics() async {
// //     try {
// //       await Future.wait([
// //         _fetchTotalBills(),
// //         _fetchTotalBillsByStatus(),
// //       ]);
// //     } catch (e) {
// //       _showErrorSnackbar('فشل تحميل إحصائيات الفواتير: ${e.toString()}');
// //     }
// //   }
// //
// //   Future<void> _fetchCategories() async {
// //     setState(() => _isLoadingCategories = true);
// //     try {
// //       final categories = await _repository.getCategories();
// //       await Future.wait([
// //         ...categories.map((category) => _fetchCategoryData(category)),
// //       ]);
// //     } catch (error) {
// //       _showErrorSnackbar('فشل تحميل الفئات: ${error.toString()}');
// //     } finally {
// //       setState(() => _isLoadingCategories = false);
// //     }
// //   }
// //
// //
// //
// //
// //   Future<void> _fetchCategoryData(Category category) async {
// //     try {
// //       await Future.wait([
// //         _fetchSubcategories(category),
// //         _fetchCategoryUsageCount(category),
// //       ]);
// //     } catch (e) {
// //       _showErrorSnackbar('فشل تحميل بيانات الفئة: ${e.toString()}');
// //     }
// //   }
// //
// //   Future<void> _fetchSubcategories(Category category) async {
// //     try {
// //       final subcategories = await _repository.getSubcategories(category.id);
// //       setState(() {
// //         _subcategoriesByCategory[category.name] = subcategories;
// //         _subcategoryUsageCount[category.name] = {};
// //       });
// //       await Future.wait(
// //         subcategories.map((sub) => _fetchSubcategoryUsageCount(sub, category.name)),
// //       );
// //     } catch (error) {
// //       _showErrorSnackbar('خطأ في تحميل الفئات الفرعية: ${error.toString()}');
// //     }
// //   }
// //
// //   Future<void> _fetchCategoryUsageCount(Category category) async {
// //     try {
// //       final count = await _repository.getCategoryUsageCount(category.id);
// //       setState(() => _categoryUsageCount[category.name] = count);
// //     } catch (error) {
// //       _showErrorSnackbar('خطأ في تحميل استخدام الفئة: ${error.toString()}');
// //     }
// //   }
// //
// //   Future<void> _fetchSubcategoryUsageCount(Subcategory subcategory, String categoryName) async {
// //     try {
// //       final count = await _repository.getSubcategoryUsageCount(subcategory.id);
// //       setState(() {
// //         _subcategoryUsageCount[categoryName] ??= {};
// //         _subcategoryUsageCount[categoryName]![subcategory.name] = count;
// //       });
// //     } catch (error) {
// //       _showErrorSnackbar('خطأ في تحميل استخدام الفئة الفرعية: ${error.toString()}');
// //     }
// //   }
// //
// //   Future<void> _fetchTotalBills() async {
// //     try {
// //       final count = await _repository.getTotalBills();
// //       setState(() => _totalBills = count);
// //     } catch (error) {
// //       _showErrorSnackbar('خطأ في تحميل إجمالي الفواتير: ${error.toString()}');
// //     }
// //   }
// //
// //   Future<void> _fetchTotalBillsByStatus() async {
// //     try {
// //       final statusCounts = await _repository.getTotalBillsByStatus();
// //       setState(() {
// //         _totalDeferredBills = statusCounts['آجل'] ?? 0;
// //         _totalPaidBills = statusCounts['تم الدفع'] ?? 0;
// //         _totalOpenBills = statusCounts['فاتورة مفتوحة'] ?? 0;
// //       });
// //     } catch (error) {
// //       _showErrorSnackbar('خطأ في تحميل الفواتير حسب الحالة: ${error.toString()}');
// //     }
// //   }
// //
// //   Future<void> _fetchBillsByStatus(String? status) async {
// //     setState(() {
// //       _isLoadingBills = true;
// //       _selectedStatus = status;
// //     });
// //
// //     try {
// //       final bills = await _billRepository.getBills();
// //       setState(() {
// //         _bills = status != null
// //             ? bills.where((bill) => bill.status == status).toList()
// //             : bills;
// //       });
// //     } catch (e) {
// //       _showErrorSnackbar('خطأ في تحميل الفواتير: ${e.toString()}');
// //     } finally {
// //       setState(() => _isLoadingBills = false);
// //     }
// //   }
// //
// //   void _showErrorSnackbar(String message) {
// //     if (!mounted) return;
// //
// //     ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text(message),
// //           backgroundColor: Colors.red,
// //           behavior: SnackBarBehavior.floating,
// //           duration: const Duration(seconds: 3),
// //         ));
// //     }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return DefaultTabController(
// //       length: 3,
// //       child: Scaffold(
// //         appBar: AppBar(
// //           title: const Text('تقارير الفواتير'),
// //           bottom: TabBar(
// //             onTap: (index) => setState(() => _currentTabIndex = index),
// //             tabs: const [
// //               Tab(icon: Icon(Icons.account_tree_sharp), text: 'ملخص'),
// //               Tab(icon: Icon(Icons.category), text: 'الفئات'),
// //               Tab(icon: Icon(Icons.receipt), text: 'الفواتير'),
// //             ],
// //           ),
// //           actions: [
// //             IconButton(
// //               icon: const Icon(Icons.bar_chart),
// //               onPressed: () => Navigator.push(
// //                 context,
// //                 MaterialPageRoute(builder: (context) => ReportCategoryOperationsPage()),
// //               ),
// //             ),
// //             IconButton(
// //               icon: const Icon(Icons.refresh),
// //               onPressed: _loadInitialData,
// //               tooltip: 'تحديث البيانات',
// //             ),
// //           ],
// //         ),
// //         body: RefreshIndicator(
// //           onRefresh: _loadInitialData,
// //           child: TabBarView(
// //             physics: const NeverScrollableScrollPhysics(),
// //             children: [
// //               _buildSummaryTab(),
// //               _buildCategoriesTab(),
// //               _buildBillsTab(),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   // Tab Builders
// //   Widget _buildSummaryTab() {
// //     return SingleChildScrollView(
// //       padding: const EdgeInsets.all(16),
// //       controller: _scrollController,
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.stretch,
// //         children: [
// //           const _SectionHeader(title: 'ملخص الفواتير'),
// //           const SizedBox(height: 16),
// //           _buildStatisticsGrid(),
// //           const SizedBox(height: 20),
// //           const _SectionHeader(title: 'آخر الفواتير'),
// //           const SizedBox(height: 8),
// //           _buildRecentBillsList(),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildCategoriesTab() {
// //     return SingleChildScrollView(
// //       padding: const EdgeInsets.all(16),
// //       child: Column(
// //         children: [
// //           const _SectionHeader(title: 'الفئات والمنتجات'),
// //           const SizedBox(height: 16),
// //           _buildCategoriesAccordion(),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildBillsTab() {
// //     return Column(
// //       children: [
// //         _buildStatusFilter(),
// //         Expanded(
// //           child: _isLoadingBills
// //               ? const Center(child: CircularProgressIndicator())
// //               : _bills.isEmpty
// //               ? const Center(child: Text('لا توجد فواتير لعرضها'))
// //               : _buildBillsListView(),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   // Component Builders
// //   Widget _buildStatisticsGrid() {
// //     return GridView.count(
// //       shrinkWrap: true,
// //       physics: const NeverScrollableScrollPhysics(),
// //       crossAxisCount: 2,
// //       childAspectRatio: 1.2,
// //       mainAxisSpacing: 12,
// //       crossAxisSpacing: 12,
// //       children: [
// //         _StatCard(
// //           title: 'إجمالي الفواتير',
// //           count: _totalBills,
// //           icon: Icons.receipt,
// //           color: Colors.blue,
// //           onTap: () => _showBillsForStatus(null),
// //         ),
// //         _StatCard(
// //           title: 'آجل',
// //           count: _totalDeferredBills,
// //           icon: Icons.pending_actions,
// //           color: Colors.orange,
// //           onTap: () => _showBillsForStatus('آجل'),
// //         ),
// //         _StatCard(
// //           title: 'تم الدفع',
// //           count: _totalPaidBills,
// //           icon: Icons.check_circle,
// //           color: Colors.green,
// //           onTap: () => _showBillsForStatus('تم الدفع'),
// //         ),
// //         _StatCard(
// //           title: 'فاتورة مفتوحة',
// //           count: _totalOpenBills,
// //           icon: Icons.hourglass_empty,
// //           color: Colors.purple,
// //           onTap: () => _showBillsForStatus('فاتورة مفتوحة'),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildRecentBillsList() {
// //     if (_bills.isEmpty) {
// //       return const _EmptyState(message: 'لا توجد فواتير حديثة');
// //     }
// //
// //     final recentBills = _bills.length > 5 ? _bills.sublist(0, 5) : _bills;
// //
// //     return Card(
// //       elevation: 2,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //       child: ListView.builder(
// //         shrinkWrap: true,
// //         physics: const NeverScrollableScrollPhysics(),
// //         itemCount: recentBills.length,
// //         itemBuilder: (context, index) {
// //           final bill = recentBills[index];
// //           return _BillListItem(
// //             bill: bill,
// //             onTap: () => _showBillDetails(bill),
// //           );
// //         },
// //       ),
// //     );
// //   }
// //
// //   Widget _buildCategoriesAccordion() {
// //     if (_isLoadingCategories) {
// //       return const Center(child: CircularProgressIndicator());
// //     }
// //
// //     if (_subcategoriesByCategory.isEmpty) {
// //       return _EmptyState(
// //         message: 'لا توجد فئات متاحة',
// //         action: ElevatedButton(
// //           onPressed: _loadInitialData,
// //           child: const Text('إعادة تحميل'),
// //         ),
// //       );
// //     }
// //
// //     return StatefulBuilder(
// //       builder: (context, setState) {
// //         return ExpansionPanelList(
// //           elevation: 1,
// //           expandedHeaderPadding: EdgeInsets.zero,
// //           expansionCallback: (index, isExpanded) {
// //             final categoryName = _subcategoriesByCategory.keys.elementAt(index);
// //             setState(() {
// //               if (isExpanded) {
// //                 _selectedCategoryName = null;
// //               } else {
// //                 _selectedCategoryName = categoryName;
// //                 if (_subcategoriesByCategory[categoryName]?.isEmpty ?? true) {
// //                   _fetchSubcategoriesForCategory(categoryName).then((_) {
// //                     setState(() {});
// //                   });
// //                 }
// //               }
// //             });
// //           },
// //           children: _subcategoriesByCategory.keys.map<ExpansionPanel>((categoryName) {
// //             final isExpanded = _selectedCategoryName == categoryName;
// //             final usageCount = _categoryUsageCount[categoryName] ?? 0;
// //             final subcategories = _subcategoriesByCategory[categoryName] ?? [];
// //             final isLoadingSubcategories = isExpanded && subcategories.isEmpty;
// //
// //             return ExpansionPanel(
// //               canTapOnHeader: true,
// //               headerBuilder: (context, isExpanded) {
// //                 return ListTile(
// //                   title: Text(categoryName, style: const TextStyle(fontWeight: FontWeight.bold)),
// //                   subtitle: Text('تم استخدامها $usageCount مرة'),
// //                   leading: Icon(
// //                     isExpanded ? Icons.expand_less : Icons.expand_more,
// //                     color: Theme.of(context).primaryColor,
// //                   ),
// //                   trailing: isLoadingSubcategories
// //                       ? const SizedBox(
// //                     width: 20,
// //                     height: 20,
// //                     child: CircularProgressIndicator(strokeWidth: 2),
// //                   )
// //                       : null,
// //                 );
// //               },
// //               body: _buildSubcategoryList(categoryName, subcategories, isLoadingSubcategories),
// //               isExpanded: isExpanded,
// //             );
// //           }).toList(),
// //         );
// //       },
// //     );
// //   }
// //
// //   Widget _buildSubcategoryList(
// //       String categoryName,
// //       List<Subcategory> subcategories,
// //       bool isLoading,
// //       ) {
// //     if (_subcategoryErrors.containsKey(categoryName)) {
// //       return _ErrorState(
// //         message: 'حدث خطأ: ${_subcategoryErrors[categoryName]}',
// //         onRetry: () => _fetchSubcategoriesForCategory(categoryName),
// //       );
// //     }
// //
// //     if (isLoading) {
// //       return const _LoadingState();
// //     }
// //
// //     if (subcategories.isEmpty) {
// //       return const _EmptyState(message: 'لا توجد فئات فرعية');
// //     }
// //
// //     return ListView.builder(
// //       shrinkWrap: true,
// //       physics: const NeverScrollableScrollPhysics(),
// //       itemCount: subcategories.length,
// //       itemBuilder: (context, index) {
// //         final subcategory = subcategories[index];
// //         final usageCount = _subcategoryUsageCount[categoryName]?[subcategory.name] ?? 0;
// //
// //         return Padding(
// //           padding: const EdgeInsets.symmetric(horizontal: 16),
// //           child: Card(
// //             elevation: 1,
// //             margin: const EdgeInsets.only(bottom: 8),
// //             child: ListTile(
// //               title: Text(subcategory.name),
// //               subtitle: Text('تم استخدامها $usageCount مرة'),
// //               leading: const Icon(Icons.category, size: 20),
// //               dense: true,
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }
// //
// //   Widget _buildStatusFilter() {
// //     return Padding(
// //       padding: const EdgeInsets.all(16),
// //       child: Card(
// //         elevation: 2,
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
// //         child: Padding(
// //           padding: const EdgeInsets.symmetric(horizontal: 12),
// //           child: DropdownButtonFormField<String?>(
// //             value: _selectedStatus,
// //             decoration: const InputDecoration(
// //               labelText: 'تصفية حسب الحالة',
// //               border: InputBorder.none,
// //             ),
// //             items: const [
// //               DropdownMenuItem(value: null, child: Text('الكل')),
// //               DropdownMenuItem(value: 'آجل', child: Text('آجل')),
// //               DropdownMenuItem(value: 'تم الدفع', child: Text('تم الدفع')),
// //               DropdownMenuItem(value: 'فاتورة مفتوحة', child: Text('فاتورة مفتوحة')),
// //             ],
// //             onChanged: (value) => _fetchBillsByStatus(value),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildBillsListView() {
// //     return ListView.builder(
// //       itemCount: _bills.length,
// //       itemBuilder: (context, index) {
// //         final bill = _bills[index];
// //         return Padding(
// //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
// //           child: _BillListItem(
// //             bill: bill,
// //             onTap: () => _showBillDetails(bill),
// //           ),
// //         );
// //       },
// //     );
// //   }
// //
// //   // Helper Methods
// //   void _showBillsForStatus(String? status) {
// //     setState(() {
// //       _currentTabIndex = 2;
// //       _fetchBillsByStatus(status);
// //     });
// //   }
// //
// //   void _showBillDetails(Bill bill) {
// //     showDialog(
// //       context: context,
// //       builder: (context) => _BillDetailsDialog(bill: bill),
// //     );
// //   }
// //
// //   Color _getStatusColor(String status) {
// //     switch (status) {
// //       case 'تم الدفع': return Colors.green;
// //       case 'آجل': return Colors.orange;
// //       case 'فاتورة مفتوحة': return Colors.blue;
// //       default: return Colors.grey;
// //     }
// //   }
// // }
// //
// // // Reusable Widgets
// // class _SectionHeader extends StatelessWidget {
// //   final String title;
// //
// //   const _SectionHeader({required this.title});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Text(
// //       title,
// //       style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// //       textAlign: TextAlign.center,
// //     );
// //   }
// // }
// //
// // class _StatCard extends StatelessWidget {
// //   final String title;
// //   final int count;
// //   final IconData icon;
// //   final Color color;
// //   final VoidCallback onTap;
// //
// //   const _StatCard({
// //     required this.title,
// //     required this.count,
// //     required this.icon,
// //     required this.color,
// //     required this.onTap,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Card(
// //       elevation: 4,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //       child: InkWell(
// //         borderRadius: BorderRadius.circular(12),
// //         onTap: onTap,
// //         child: Padding(
// //           padding: const EdgeInsets.all(12),
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               Icon(icon, size: 30, color: color),
// //               const SizedBox(height: 8),
// //               Text(title, style: const TextStyle(fontSize: 14)),
// //               const SizedBox(height: 4),
// //               Text(
// //                 NumberFormat().format(count),
// //                 style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // class _BillListItem extends StatelessWidget {
// //   final Bill bill;
// //   final VoidCallback onTap;
// //
// //   const _BillListItem({
// //     required this.bill,
// //     required this.onTap,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Card(
// //       elevation: 2,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
// //       child: ListTile(
// //         leading: CircleAvatar(
// //           backgroundColor: _statusColor(bill.status).withOpacity(0.2),
// //           child: Icon(
// //             bill.status == 'تم الدفع' ? Icons.check : Icons.pending,
// //             color: _statusColor(bill.status),
// //             size: 20,
// //           ),
// //         ),
// //         title: Text(bill.customerName, style: const TextStyle(fontWeight: FontWeight.bold)),
// //         subtitle: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text('#${bill.id} - ${_formatDate(bill.date)}'),
// //             Text('${NumberFormat().format(bill.total_price)} ر.س'),
// //           ],
// //         ),
// //         trailing: Chip(
// //           label: Text(bill.status),
// //           backgroundColor: _statusColor(bill.status).withOpacity(0.1),
// //           labelStyle: TextStyle(
// //             color: _statusColor(bill.status),
// //             fontWeight: FontWeight.bold,
// //           ),
// //         ),
// //         onTap: onTap,
// //       ),
// //     );
// //   }
// //
// //   Color _statusColor(String status) {
// //     switch (status) {
// //       case 'تم الدفع': return Colors.green;
// //       case 'آجل': return Colors.orange;
// //       case 'فاتورة مفتوحة': return Colors.blue;
// //       default: return Colors.grey;
// //     }
// //   }
// //
// //   String _formatDate(DateTime date) {
// //     return DateFormat('yyyy/MM/dd').format(date);
// //   }
// // }
// //
// // class _BillDetailsDialog extends StatelessWidget {
// //   final Bill bill;
// //
// //   const _BillDetailsDialog({required this.bill});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Dialog(
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //       child: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           crossAxisAlignment: CrossAxisAlignment.stretch,
// //           children: [
// //             Text(
// //               'تفاصيل الفاتورة #${bill.id}',
// //               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //               textAlign: TextAlign.center,
// //             ),
// //             const SizedBox(height: 16),
// //             _DetailRow(label: 'العميل', value: bill.customerName),
// //             _DetailRow(label: 'التاريخ', value: _formatDate(bill.date)),
// //             _DetailRow(
// //                 label: 'المبلغ الإجمالي',
// //                 value: '${NumberFormat().format(bill.total_price)} ر.س'
// //             ),
// //             _DetailRow(label: 'حالة الدفع', value: bill.status),
// //             if (bill.description.isNotEmpty)
// //               _DetailRow(label: 'الوصف', value: bill.description),
// //             const SizedBox(height: 16),
// //             Align(
// //               alignment: Alignment.centerLeft,
// //               child: TextButton(
// //                 onPressed: () => Navigator.pop(context),
// //                 child: const Text('إغلاق'),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   String _formatDate(DateTime date) {
// //     return DateFormat('yyyy/MM/dd').format(date);
// //   }
// // }
// //
// // class _DetailRow extends StatelessWidget {
// //   final String label;
// //   final String value;
// //
// //   const _DetailRow({required this.label, required this.value});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 8),
// //       child: Row(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
// //           Expanded(child: Text(value, style: const TextStyle(color: Colors.grey))),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // class _EmptyState extends StatelessWidget {
// //   final String message;
// //   final Widget? action;
// //
// //   const _EmptyState({required this.message, this.action});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Center(
// //       child: Column(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Text(message),
// //           if (action != null) ...[
// //             const SizedBox(height: 16),
// //             action!,
// //           ],
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // class _LoadingState extends StatelessWidget {
// //   const _LoadingState();
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return const Padding(
// //       padding: EdgeInsets.symmetric(vertical: 16),
// //       child: Center(child: CircularProgressIndicator()),
// //     );
// //   }
// // }
// //
// // class _ErrorState extends StatelessWidget {
// //   final String message;
// //   final VoidCallback onRetry;
// //
// //   const _ErrorState({required this.message, required this.onRetry});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 16),
// //       child: Column(
// //         children: [
// //           Text('حدث خطأ: $message'),
// //           const SizedBox(height: 8),
// //           ElevatedButton(
// //             onPressed: onRetry,
// //             child: const Text('إعادة المحاولة'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:system/core/themes/AppColors/them_constants.dart';
// import 'package:system/features/billes/data/models/bill_model.dart';
// import 'package:system/features/billes/data/repositories/bill_repository.dart';
// import 'package:system/features/category/data/models/category_model.dart';
// import 'package:system/features/category/data/models/subCategory_model.dart';
// import 'package:system/features/category/data/repositories/category_repository.dart';
// import 'package:system/features/report/UI/reportcategory/ReportCategoryOperationsPage.dart';
//
// class ItemsReportDashboardMobile extends StatefulWidget {
//   @override
//   _ItemsReportDashboardMobileState createState() => _ItemsReportDashboardMobileState();
// }
//
// class _ItemsReportDashboardMobileState extends State<ItemsReportDashboardMobile> {
//   // Repositories
//   final CategoryRepository _repository = CategoryRepository();
//   final BillRepository _billRepository = BillRepository();
//
//   // Data storage
//   final Map<String, List<Subcategory>> _subcategoriesByCategory = {};
//   final Map<String, int> _categoryUsageCount = {};
//   final Map<String, Map<String, int>> _subcategoryUsageCount = {};
//   List<Bill> _bills = [];
//
//   // UI state
//   String? _selectedCategoryName;
//   String? _selectedStatus;
//   int _currentTabIndex = 0;
//
//   // Counters
//   int _totalBills = 0;
//   int _totalDeferredBills = 0;
//   int _totalPaidBills = 0;
//   int _totalOpenBills = 0;
//
//   // Loading states
//   bool _isLoadingBills = false;
//   bool _isLoadingCategories = false;
//
//   // Controllers and helpers
//   final ScrollController _scrollController = ScrollController();
//   final Map<String, String> _subcategoryErrors = {};
//   final DateFormat _dateFormatter = DateFormat('yyyy/MM/dd');
//
//   @override
//   void initState() {
//     super.initState();
//     _loadInitialData();
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _fetchSubcategoriesForCategory(String categoryName) async {
//     try {
//       final categories = await _repository.getCategories();
//       final category = categories.firstWhere(
//             (cat) => cat.name == categoryName,
//       );
//
//       final subcategories = await _repository.getSubcategories(category.id);
//       final usageCounts = <String, int>{};
//
//       for (final sub in subcategories) {
//         final count = await _repository.getSubcategoryUsageCount(sub.id);
//         usageCounts[sub.name] = count;
//       }
//
//       setState(() {
//         _subcategoriesByCategory[categoryName] = subcategories;
//         _subcategoryUsageCount[categoryName] = usageCounts;
//       });
//     } catch (error) {
//       _showErrorSnackbar('فشل تحميل الفئات الفرعية: ${error.toString()}');
//     }
//   }
//
//   // Data loading methods
//   Future<void> _loadInitialData() async {
//     try {
//       await Future.wait([
//         _fetchCategories(),
//         _fetchBillStatistics(),
//         _fetchBillsByStatus(null),
//       ]);
//     } catch (e) {
//       _showErrorSnackbar('فشل تحميل البيانات الأولية: ${e.toString()}');
//     }
//   }
//
//   Future<void> _fetchBillStatistics() async {
//     try {
//       await Future.wait([
//         _fetchTotalBills(),
//         _fetchTotalBillsByStatus(),
//       ]);
//     } catch (e) {
//       _showErrorSnackbar('فشل تحميل إحصائيات الفواتير: ${e.toString()}');
//     }
//   }
//
//   Future<void> _fetchCategories() async {
//     setState(() => _isLoadingCategories = true);
//     try {
//       final categories = await _repository.getCategories();
//       await Future.wait([
//         ...categories.map((category) => _fetchCategoryData(category)),
//       ]);
//     } catch (error) {
//       _showErrorSnackbar('فشل تحميل الفئات: ${error.toString()}');
//     } finally {
//       setState(() => _isLoadingCategories = false);
//     }
//   }
//
//   Future<void> _fetchCategoryData(Category category) async {
//     try {
//       await Future.wait([
//         _fetchSubcategories(category),
//         _fetchCategoryUsageCount(category),
//       ]);
//     } catch (e) {
//       _showErrorSnackbar('فشل تحميل بيانات الفئة: ${e.toString()}');
//     }
//   }
//
//   Future<void> _fetchSubcategories(Category category) async {
//     try {
//       final subcategories = await _repository.getSubcategories(category.id);
//       setState(() {
//         _subcategoriesByCategory[category.name] = subcategories;
//         _subcategoryUsageCount[category.name] = {};
//       });
//       await Future.wait(
//         subcategories.map((sub) => _fetchSubcategoryUsageCount(sub, category.name)),
//       );
//     } catch (error) {
//       _showErrorSnackbar('خطأ في تحميل الفئات الفرعية: ${error.toString()}');
//     }
//   }
//
//   Future<void> _fetchCategoryUsageCount(Category category) async {
//     try {
//       final count = await _repository.getCategoryUsageCount(category.id);
//       setState(() => _categoryUsageCount[category.name] = count);
//     } catch (error) {
//       _showErrorSnackbar('خطأ في تحميل استخدام الفئة: ${error.toString()}');
//     }
//   }
//
//   Future<void> _fetchSubcategoryUsageCount(Subcategory subcategory, String categoryName) async {
//     try {
//       final count = await _repository.getSubcategoryUsageCount(subcategory.id);
//       setState(() {
//         _subcategoryUsageCount[categoryName] ??= {};
//         _subcategoryUsageCount[categoryName]![subcategory.name] = count;
//       });
//     } catch (error) {
//       _showErrorSnackbar('خطأ في تحميل استخدام الفئة الفرعية: ${error.toString()}');
//     }
//   }
//
//   Future<void> _fetchTotalBills() async {
//     try {
//       final count = await _repository.getTotalBills();
//       setState(() => _totalBills = count);
//     } catch (error) {
//       _showErrorSnackbar('خطأ في تحميل إجمالي الفواتير: ${error.toString()}');
//     }
//   }
//
//   Future<void> _fetchTotalBillsByStatus() async {
//     try {
//       final statusCounts = await _repository.getTotalBillsByStatus();
//       setState(() {
//         _totalDeferredBills = statusCounts['آجل'] ?? 0;
//         _totalPaidBills = statusCounts['تم الدفع'] ?? 0;
//         _totalOpenBills = statusCounts['فاتورة مفتوحة'] ?? 0;
//       });
//     } catch (error) {
//       _showErrorSnackbar('خطأ في تحميل الفواتير حسب الحالة: ${error.toString()}');
//     }
//   }
//
//   Future<void> _fetchBillsByStatus(String? status) async {
//     setState(() {
//       _isLoadingBills = true;
//       _selectedStatus = status;
//     });
//
//     try {
//       final bills = await _billRepository.getBills();
//       setState(() {
//         _bills = status != null
//             ? bills.where((bill) => bill.status == status).toList()
//             : bills;
//       });
//     } catch (e) {
//       _showErrorSnackbar('خطأ في تحميل الفواتير: ${e.toString()}');
//     } finally {
//       setState(() => _isLoadingBills = false);
//     }
//   }
//
//   void _showErrorSnackbar(String message) {
//     if (!mounted) return;
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('تقارير الفواتير'),
//           bottom: TabBar(
//             onTap: (index) => setState(() => _currentTabIndex = index),
//             tabs: const [
//               Tab(icon: Icon(Icons.account_tree_sharp), text: 'ملخص'),
//               Tab(icon: Icon(Icons.category), text: 'الفئات'),
//               Tab(icon: Icon(Icons.receipt), text: 'الفواتير'),
//             ],
//           ),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.bar_chart),
//               onPressed: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => ReportCategoryOperationsPage()),
//               ),
//             ),
//             IconButton(
//               icon: const Icon(Icons.refresh),
//               onPressed: _loadInitialData,
//               tooltip: 'تحديث البيانات',
//             ),
//           ],
//         ),
//         body: RefreshIndicator(
//           onRefresh: _loadInitialData,
//           child: TabBarView(
//             physics: const NeverScrollableScrollPhysics(),
//             children: [
//               _buildSummaryTab(),
//               _buildCategoriesTab(),
//               _buildBillsTab(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSummaryTab() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       controller: _scrollController,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           const _SectionHeader(title: 'ملخص الفواتير'),
//           const SizedBox(height: 16),
//           _buildStatisticsGrid(),
//           const SizedBox(height: 20),
//           const _SectionHeader(title: 'آخر الفواتير'),
//           const SizedBox(height: 8),
//           _buildRecentBillsList(),
//         ],
//       ),
//     );
//   }
//
//
//   Widget _buildBillsTab() {
//     return Column(
//       children: [
//         _buildStatusFilter(),
//         Expanded(
//           child: _isLoadingBills
//               ? const Center(child: CircularProgressIndicator())
//               : _bills.isEmpty
//               ? const Center(child: Text('لا توجد فواتير لعرضها'))
//               : _buildBillsListView(),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatisticsGrid() {
//     return GridView.count(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       crossAxisCount: 2,
//       childAspectRatio: 1.2,
//       mainAxisSpacing: 12,
//       crossAxisSpacing: 12,
//       children: [
//         _StatCard(
//           title: 'إجمالي الفواتير',
//           count: _totalBills,
//           icon: Icons.receipt,
//           color: Colors.blue,
//           onTap: () => _showBillsForStatus(null),
//         ),
//         _StatCard(
//           title: 'آجل',
//           count: _totalDeferredBills,
//           icon: Icons.pending_actions,
//           color: Colors.orange,
//           onTap: () => _showBillsForStatus('آجل'),
//         ),
//         _StatCard(
//           title: 'تم الدفع',
//           count: _totalPaidBills,
//           icon: Icons.check_circle,
//           color: Colors.green,
//           onTap: () => _showBillsForStatus('تم الدفع'),
//         ),
//         _StatCard(
//           title: 'فاتورة مفتوحة',
//           count: _totalOpenBills,
//           icon: Icons.hourglass_empty,
//           color: Colors.purple,
//           onTap: () => _showBillsForStatus('فاتورة مفتوحة'),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildRecentBillsList() {
//     if (_bills.isEmpty) {
//       return const _EmptyState(message: 'لا توجد فواتير حديثة');
//     }
//
//     final recentBills = _bills.length > 5 ? _bills.sublist(0, 5) : _bills;
//
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ListView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: recentBills.length,
//         itemBuilder: (context, index) {
//           final bill = recentBills[index];
//           return _BillListItem(
//             bill: bill,
//             onTap: () => _showBillDetails(bill),
//           );
//         },
//       ),
//     );
//   }
//
//
//
//   Widget _buildCategoriesTab() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           const _SectionHeader(title: 'الفئات والمنتجات'),
//           const SizedBox(height: 16),
//           _buildCategoriesAccordion(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCategoriesAccordion() {
//     if (_isLoadingCategories) {
//       return const _LoadingState();
//     }
//
//     if (_subcategoriesByCategory.isEmpty) {
//       return _EmptyState(
//         message: 'لا توجد فئات متاحة',
//         action: ElevatedButton(
//           onPressed: _loadInitialData,
//           child: const Text('إعادة تحميل'),
//         ),
//       );
//     }
//
//     return StatefulBuilder(
//       builder: (context, setState) {
//         return ExpansionPanelList(
//           elevation: 1,
//           dividerColor: Theme.of(context).dividerColor,
//           expandedHeaderPadding: EdgeInsets.zero,
//           expansionCallback: (index, isExpanded) =>
//               _handlePanelExpansion(index, isExpanded, setState),
//           children: _buildExpansionPanels(),
//         );
//       },
//     );
//   }
//
//   void _handlePanelExpansion(int index, bool isExpanded, StateSetter setState) {
//     final categoryName = _subcategoriesByCategory.keys.elementAt(index);
//     setState(() {
//       if (isExpanded) {
//         _selectedCategoryName = null;
//       } else {
//         _selectedCategoryName = categoryName;
//         final subcategories = _subcategoriesByCategory[categoryName];
//
//         // Only fetch if not already loaded or errored
//         if ((subcategories == null || subcategories.isEmpty) &&
//             !_subcategoryErrors.containsKey(categoryName)) {
//           _fetchSubcategoriesForCategory(categoryName).then((_) => setState(() {}));
//         }
//       }
//     });
//   }
//
//   List<ExpansionPanel> _buildExpansionPanels() {
//     return _subcategoriesByCategory.keys.map((categoryName) {
//       final isExpanded = _selectedCategoryName == categoryName;
//       final usageCount = _categoryUsageCount[categoryName] ?? 0;
//       final subcategories = _subcategoriesByCategory[categoryName] ?? [];
//       final isLoadingSubcategories = isExpanded && subcategories.isEmpty &&
//           !_subcategoryErrors.containsKey(categoryName);
//
//       return ExpansionPanel(
//         canTapOnHeader: true,
//         headerBuilder: (context, isExpanded) => _buildPanelHeader(
//           context,
//           categoryName,
//           usageCount,
//           isExpanded,
//           isLoadingSubcategories,
//         ),
//         body: _buildSubcategoryList(categoryName, subcategories, isLoadingSubcategories),
//         isExpanded: isExpanded,
//       );
//     }).toList();
//   }
//
//   Widget _buildPanelHeader(
//       BuildContext context,
//       String categoryName,
//       int usageCount,
//       bool isExpanded,
//       bool isLoadingSubcategories,
//       ) {
//     return ListTile(
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16),
//       title: Text(
//         categoryName,
//         style: Theme.of(context).textTheme.titleMedium?.copyWith(
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       subtitle: Text('تم استخدامها $usageCount مرة'),
//       leading: Icon(
//         isExpanded ? Icons.expand_less : Icons.expand_more,
//         color: Theme.of(context).primaryColor,
//       ),
//       trailing: isLoadingSubcategories
//           ? const SizedBox(
//         width: 20,
//         height: 20,
//         child: CircularProgressIndicator(strokeWidth: 2),
//       )
//           : null,
//     );
//   }
//
//   Widget _buildSubcategoryList(
//       String categoryName,
//       List<Subcategory> subcategories,
//       bool isLoading,
//       ) {
//     // Handle error state
//     if (_subcategoryErrors.containsKey(categoryName)) {
//       return _ErrorState(
//         message: 'حدث خطأ: ${_subcategoryErrors[categoryName]}',
//         onRetry: () => _fetchSubcategoriesForCategory(categoryName),
//       );
//     }
//
//     // Handle loading state
//     if (isLoading) {
//       return const _LoadingState();
//     }
//
//     // Handle empty state
//     if (subcategories.isEmpty) {
//       return const _EmptyState(message: 'لا توجد فئات فرعية');
//     }
//
//     return ListView.separated(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       padding: const EdgeInsets.only(bottom: 16),
//       itemCount: subcategories.length,
//       separatorBuilder: (_, __) => const SizedBox(height: 8),
//       itemBuilder: (context, index) {
//         final subcategory = subcategories[index];
//         final usageCount = _subcategoryUsageCount[categoryName]?[subcategory.name] ?? 0;
//
//         return _SubcategoryItem(
//           name: subcategory.name,
//           usageCount: usageCount,
//         );
//       },
//     );
//   }
//
//
//
//   Widget _buildStatusFilter() {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Card(
//         elevation: 2,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           child: DropdownButtonFormField<String?>(
//             value: _selectedStatus,
//             decoration: const InputDecoration(
//               labelText: 'تصفية حسب الحالة',
//               border: InputBorder.none,
//             ),
//             items: const [
//               DropdownMenuItem(value: null, child: Text('الكل')),
//               DropdownMenuItem(value: 'آجل', child: Text('آجل')),
//               DropdownMenuItem(value: 'تم الدفع', child: Text('تم الدفع')),
//               DropdownMenuItem(value: 'فاتورة مفتوحة', child: Text('فاتورة مفتوحة')),
//             ],
//             onChanged: (value) => _fetchBillsByStatus(value),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBillsListView() {
//     return ListView.builder(
//       itemCount: _bills.length,
//       itemBuilder: (context, index) {
//         final bill = _bills[index];
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//           child: _BillListItem(
//             bill: bill,
//             onTap: () => _showBillDetails(bill),
//           ),
//         );
//       },
//     );
//   }
//
//   void _showBillsForStatus(String? status) {
//     setState(() {
//       _currentTabIndex = 2;
//       _fetchBillsByStatus(status);
//     });
//   }
//
//   void _showBillDetails(Bill bill) {
//     showDialog(
//       context: context,
//       builder: (context) => _BillDetailsDialog(bill: bill),
//     );
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'تم الدفع': return Colors.green;
//       case 'آجل': return Colors.orange;
//       case 'فاتورة مفتوحة': return Colors.blue;
//       default: return Colors.grey;
//     }
//   }
// }
//
// class _SectionHeader extends StatelessWidget {
//   final String title;
//
//   const _SectionHeader({required this.title});
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       title,
//       style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//       textAlign: TextAlign.center,
//     );
//   }
// }
//
// class _StatCard extends StatelessWidget {
//   final String title;
//   final int count;
//   final IconData icon;
//   final Color color;
//   final VoidCallback onTap;
//
//   const _StatCard({
//     required this.title,
//     required this.count,
//     required this.icon,
//     required this.color,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: onTap,
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, size: 30, color: color),
//               const SizedBox(height: 8),
//               Text(title, style: const TextStyle(fontSize: 14)),
//               const SizedBox(height: 4),
//               Text(
//                 NumberFormat().format(count),
//                 style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _BillListItem extends StatelessWidget {
//   final Bill bill;
//   final VoidCallback onTap;
//
//   const _BillListItem({
//     required this.bill,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundColor: _statusColor(bill.status).withOpacity(0.2),
//           child: Icon(
//             bill.status == 'تم الدفع' ? Icons.check : Icons.pending,
//             color: _statusColor(bill.status),
//             size: 20,
//           ),
//         ),
//         title: Text(bill.customerName, style: const TextStyle(fontWeight: FontWeight.bold)),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('#${bill.id} - ${_formatDate(bill.date)}'),
//             Text('${NumberFormat().format(bill.total_price)} ر.س'),
//           ],
//         ),
//         trailing: Chip(
//           label: Text(bill.status),
//           backgroundColor: _statusColor(bill.status).withOpacity(0.1),
//           labelStyle: TextStyle(
//             color: _statusColor(bill.status),
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         onTap: onTap,
//       ),
//     );
//   }
//
//   Color _statusColor(String status) {
//     switch (status) {
//       case 'تم الدفع': return Colors.green;
//       case 'آجل': return Colors.orange;
//       case 'فاتورة مفتوحة': return Colors.blue;
//       default: return Colors.grey;
//     }
//   }
//
//   String _formatDate(DateTime date) {
//     return DateFormat('yyyy/MM/dd').format(date);
//   }
// }
//
// class _BillDetailsDialog extends StatelessWidget {
//   final Bill bill;
//
//   const _BillDetailsDialog({required this.bill});
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               'تفاصيل الفاتورة #${bill.id}',
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 16),
//             _DetailRow(label: 'العميل', value: bill.customerName),
//             _DetailRow(label: 'التاريخ', value: _formatDate(bill.date)),
//             _DetailRow(
//                 label: 'المبلغ الإجمالي',
//                 value: '${NumberFormat().format(bill.total_price)} ر.س'
//             ),
//             _DetailRow(label: 'حالة الدفع', value: bill.status),
//             if (bill.description.isNotEmpty)
//               _DetailRow(label: 'الوصف', value: bill.description),
//             const SizedBox(height: 16),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('إغلاق'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String _formatDate(DateTime date) {
//     return DateFormat('yyyy/MM/dd').format(date);
//   }
// }
//
// class _DetailRow extends StatelessWidget {
//   final String label;
//   final String value;
//
//   const _DetailRow({required this.label, required this.value});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
//           Expanded(child: Text(value, style: const TextStyle(color: Colors.grey))),
//         ],
//       ),
//     );
//   }
// }
//
// class _EmptyState extends StatelessWidget {
//   final String message;
//   final Widget? action;
//
//   const _EmptyState({required this.message, this.action});
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(message),
//           if (action != null) ...[
//             const SizedBox(height: 16),
//             action!,
//           ],
//         ],
//       ),
//     );
//   }
// }
//
// class _LoadingState extends StatelessWidget {
//   const _LoadingState();
//
//   @override
//   Widget build(BuildContext context) {
//     return const Padding(
//       padding: EdgeInsets.symmetric(vertical: 16),
//       child: Center(child: CircularProgressIndicator()),
//     );
//   }
// }
//
// class _ErrorState extends StatelessWidget {
//   final String message;
//   final VoidCallback onRetry;
//
//   const _ErrorState({required this.message, required this.onRetry});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       child: Column(
//         children: [
//           Text('حدث خطأ: $message'),
//           const SizedBox(height: 8),
//           ElevatedButton(
//             onPressed: onRetry,
//             child: const Text('إعادة المحاولة'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _SubcategoryItem extends StatelessWidget {
//   final String name;
//   final int usageCount;
//
//   const _SubcategoryItem({
//     required this.name,
//     required this.usageCount,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 1,
//       margin: EdgeInsets.zero,
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         title: Text(name),
//         subtitle: Text('تم استخدامها $usageCount مرة'),
//         leading: const Icon(Icons.category, size: 24),
//         minLeadingWidth: 24,
//         dense: true,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:system/core/themes/AppColors/them_constants.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/billes/data/repositories/bill_repository.dart';
import 'package:system/features/category/data/models/category_model.dart';
import 'package:system/features/category/data/models/subCategory_model.dart';
import 'package:system/features/category/data/repositories/category_repository.dart';
import 'package:system/main_screens/mobile_screens/Drawer/ReportCategoryOperationsPageMobile.dart';

// Report Dashboard State Management
class ReportDashboardState extends ChangeNotifier {
  final CategoryRepository categoryRepo;
  final BillRepository billRepo;

  ReportDashboardState(this.categoryRepo, this.billRepo);

  // Data storage
  final Map<String, List<Subcategory>> _subcategoriesByCategory = {};
  final Map<String, int> _categoryUsageCount = {};
  final Map<String, Map<String, int>> _subcategoryUsageCount = {};
  List<Bill> _bills = [];

  // UI state
  String? _selectedCategoryName;
  String? _selectedStatus;
  int _currentTabIndex = 0;

  // Counters
  int _totalBills = 0;
  int _totalDeferredBills = 0;
  int _totalPaidBills = 0;
  int _totalOpenBills = 0;

  // Loading states
  bool _isLoadingBills = false;
  bool _isLoadingCategories = false;

  // Getters
  Map<String, List<Subcategory>> get subcategoriesByCategory => _subcategoriesByCategory;
  Map<String, int> get categoryUsageCount => _categoryUsageCount;
  Map<String, Map<String, int>> get subcategoryUsageCount => _subcategoryUsageCount;
  List<Bill> get bills => _bills;
  String? get selectedCategoryName => _selectedCategoryName;
  String? get selectedStatus => _selectedStatus;
  int get currentTabIndex => _currentTabIndex;
  int get totalBills => _totalBills;
  int get totalDeferredBills => _totalDeferredBills;
  int get totalPaidBills => _totalPaidBills;
  int get totalOpenBills => _totalOpenBills;
  bool get isLoadingBills => _isLoadingBills;
  bool get isLoadingCategories => _isLoadingCategories;

  // Setters
  set currentTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  // Initialize data
  Future<void> init() async {
    await _loadInitialData();
  }

  // Data loading methods
  Future<void> _loadInitialData() async {
    try {
      await Future.wait([
        _fetchCategories(),
        _fetchBillStatistics(),
        _fetchBillsByStatus(null),
      ]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _fetchBillStatistics() async {
    try {
      await Future.wait([
        _fetchTotalBills(),
        _fetchTotalBillsByStatus(),
      ]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _fetchCategories() async {
    _isLoadingCategories = true;
    notifyListeners();

    try {
      final categories = await categoryRepo.getCategories();
      await Future.wait([
        ...categories.map((category) => _fetchCategoryData(category)),
      ]);
    } finally {
      _isLoadingCategories = false;
      notifyListeners();
    }
  }

  Future<void> _fetchCategoryData(Category category) async {
    try {
      await Future.wait([
        _fetchSubcategories(category),
        _fetchCategoryUsageCount(category),
      ]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _fetchSubcategories(Category category) async {
    try {
      final subcategories = await categoryRepo.getSubcategories(category.id);
      _subcategoriesByCategory[category.name] = subcategories;
      _subcategoryUsageCount[category.name] = {};
      await Future.wait(
        subcategories.map((sub) => _fetchSubcategoryUsageCount(sub, category.name)),
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _fetchCategoryUsageCount(Category category) async {
    try {
      final count = await categoryRepo.getCategoryUsageCount(category.id);
      _categoryUsageCount[category.name] = count;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _fetchSubcategoryUsageCount(Subcategory subcategory, String categoryName) async {
    try {
      final count = await categoryRepo.getSubcategoryUsageCount(subcategory.id);
      _subcategoryUsageCount[categoryName] ??= {};
      _subcategoryUsageCount[categoryName]![subcategory.name] = count;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _fetchTotalBills() async {
    try {
      final count = await categoryRepo.getTotalBills();
      _totalBills = count;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _fetchTotalBillsByStatus() async {
    try {
      final statusCounts = await categoryRepo.getTotalBillsByStatus();
      _totalDeferredBills = statusCounts['آجل'] ?? 0;
      _totalPaidBills = statusCounts['تم الدفع'] ?? 0;
      _totalOpenBills = statusCounts['فاتورة مفتوحة'] ?? 0;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _fetchBillsByStatus(String? status) async {
    _isLoadingBills = true;
    _selectedStatus = status;
    notifyListeners();

    try {
      final bills = await billRepo.getBills();
      _bills = status != null
          ? bills.where((bill) => bill.status == status).toList()
          : bills;
    } finally {
      _isLoadingBills = false;
      notifyListeners();
    }
  }

  Future<void> fetchSubcategoriesForCategory(String categoryName) async {
    print("Fetching subcategories for $categoryName");
    try {
      final categories = await categoryRepo.getCategories();
      final category = categories.firstWhere((cat) => cat.name == categoryName);

      final subcategories = await categoryRepo.getSubcategories(category.id);
      final usageCounts = <String, int>{};

      for (final sub in subcategories) {
        final count = await categoryRepo.getSubcategoryUsageCount(sub.id);
        usageCounts[sub.name] = count;
      }

      _subcategoriesByCategory[categoryName] = subcategories;
      _subcategoryUsageCount[categoryName] = usageCounts;

      print("Fetched ${subcategories.length} subcategories for $categoryName");

      notifyListeners(); // 🔴 Ensure notify after data update

    } catch (error) {
      rethrow;
    }
  }


// ReportDashboardState modifications
  void handlePanelExpansion(int index, bool isExpanded) {
    final categoryName = _subcategoriesByCategory.keys.elementAt(index);

    if (_selectedCategoryName == categoryName) {
      // If tapping the expanded category, collapse it
      _selectedCategoryName = null;
    } else {
      // Expand new category
      _selectedCategoryName = categoryName;

      final subcategories = _subcategoriesByCategory[categoryName];
      if (subcategories == null || subcategories.isEmpty) {
        fetchSubcategoriesForCategory(categoryName);
      }
    }
    notifyListeners();
  }

  void showBillsForStatus(String? status) {
    _currentTabIndex = 2;
    _fetchBillsByStatus(status);
  }
}

class ItemsReportDashboardMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => CategoryRepository()),
        Provider(create: (_) => BillRepository()),
        ChangeNotifierProxyProvider2<CategoryRepository, BillRepository, ReportDashboardState>(
          create: (context) => ReportDashboardState(
            context.read<CategoryRepository>(),
            context.read<BillRepository>(),
          ),
          update: (context, categoryRepo, billRepo, state) {
            state ??= ReportDashboardState(categoryRepo, billRepo);
            return state..init();
          },
        ),
      ],
      child: _ReportDashboardView(),
    );
  }
}

class _ReportDashboardView extends StatefulWidget {
  @override
  State<_ReportDashboardView> createState() => _ReportDashboardViewState();
}

class _ReportDashboardViewState extends State<_ReportDashboardView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ReportDashboardState _state;

  @override
  void initState() {
    super.initState();
    _state = context.read<ReportDashboardState>();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: _state.currentTabIndex,
    );
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.index != _state.currentTabIndex) {
      _state.currentTabIndex = _tabController.index;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newState = context.read<ReportDashboardState>();

    // Update controller if state changed externally
    if (newState.currentTabIndex != _tabController.index) {
      _tabController.animateTo(newState.currentTabIndex);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تقارير الفواتير'),
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            _state.currentTabIndex = index;
            _tabController.animateTo(index);
          },
          tabs: const [
            Tab(icon: Icon(Icons.account_tree_sharp), text: 'ملخص'),
            Tab(icon: Icon(Icons.category), text: 'الفئات'),
            Tab(icon: Icon(Icons.receipt), text: 'الفواتير'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReportCategoryOperationsPageMobile()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _state.init(),
            tooltip: 'تحديث البيانات',
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _SummaryTab(),
          _CategoriesTab(),
          _BillsTab(),
        ],
      ),
    );
  }
}


class _SummaryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<ReportDashboardState>();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionHeader(title: 'ملخص الفواتير'),
          const SizedBox(height: 16),
          _StatisticsGrid(),
          const SizedBox(height: 20),
          const _SectionHeader(title: 'آخر الفواتير'),
          const SizedBox(height: 8),
          _RecentBillsList(),
        ],
      ),
    );
  }
}

class _StatisticsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<ReportDashboardState>();

    // Show shimmer while loading
    if (state.isLoadingCategories) {
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: List.generate(4, (index) => const _StatCardShimmer()),
      );
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.1,
      mainAxisSpacing: 12,
      crossAxisSpacing: 10,
      children: [
        _StatCard(
          title: 'إجمالي الفواتير',
          count: state.totalBills,
          icon: Icons.receipt,
          color: Colors.blue,
          onTap: () => state.showBillsForStatus(null),
        ),
        _StatCard(
          title: 'آجل',
          count: state.totalDeferredBills,
          icon: Icons.pending_actions,
          color: Colors.orange,
          onTap: () => state.showBillsForStatus('آجل'),
        ),
        _StatCard(
          title: 'تم الدفع',
          count: state.totalPaidBills,
          icon: Icons.check_circle,
          color: Colors.green,
          onTap: () => state.showBillsForStatus('تم الدفع'),
        ),
        _StatCard(
          title: 'فاتورة مفتوحة',
          count: state.totalOpenBills,
          icon: Icons.hourglass_empty,
          color: Colors.purple,
          onTap: () => state.showBillsForStatus('فاتورة مفتوحة'),
        ),
      ],
    );
  }
}

class _RecentBillsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<ReportDashboardState>();

    if (state.bills.isEmpty) {
      return const _EmptyState(message: 'لا توجد فواتير حديثة');
    }

    final recentBills = state.bills.length > 5
        ? state.bills.sublist(0, 5)
        : state.bills;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: recentBills.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final bill = recentBills[index];
          return _BillListItem(
            bill: bill,
            onTap: () => _showBillDetails(context, bill),
          );
        },
      ),
    );
  }

  void _showBillDetails(BuildContext context, Bill bill) {
    showDialog(
      context: context,
      builder: (context) => _BillDetailsDialog(bill: bill),
    );
  }
}



class _CategoriesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionHeader(title: 'الفئات والمنتجات'),
          const SizedBox(height: 16),
          _CategoriesAccordion(),
        ],
      ),
    );
  }
}

class _CategoriesAccordion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<ReportDashboardState>();

    if (state.isLoadingCategories) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 2,
        itemBuilder: (_, index) => const _CategoryShimmerItem(),
      );
    }

    if (state.subcategoriesByCategory.isEmpty) {
      print("state.subcategoriesByCategory.isEmpty");
      return _EmptyState(
        message: 'لا توجد فئات متاحة',
        action: ElevatedButton(
          onPressed: () => context.read<ReportDashboardState>().init(),
          child: const Text('إعادة تحميل'),
        ),
      );
    }


        return ExpansionPanelList(
          elevation: 1,
          dividerColor: Theme.of(context).dividerColor,
          expandedHeaderPadding: EdgeInsets.zero,
          expansionCallback: (index, isExpanded) =>
              context.read<ReportDashboardState>().handlePanelExpansion(index, isExpanded),
          children: _buildExpansionPanels(context),
        );

  }

  List<ExpansionPanel> _buildExpansionPanels(BuildContext context) {
    final state = context.watch<ReportDashboardState>();
    print("Building expansion panels for ${state.subcategoriesByCategory.length} categories");
    print("Building expansion panels for ${state.selectedCategoryName} categories");

    return state.subcategoriesByCategory.keys.map((categoryName) {
      final isExpanded = state.selectedCategoryName == categoryName;
      final usageCount = state.categoryUsageCount[categoryName] ?? 0;
      final subcategories = state.subcategoriesByCategory[categoryName] ?? [];
      final isLoadingSubcategories = isExpanded && subcategories.isEmpty;
      return ExpansionPanel(
        canTapOnHeader: true,
        headerBuilder: (context, isExpanded) => _buildPanelHeader(
          context,
          categoryName,
          usageCount,
          isExpanded,
        ),
        body: _buildSubcategoryList(context, categoryName, subcategories, isLoadingSubcategories),
        isExpanded: isExpanded,

      );
    }).toList();
  }

// In _CategoriesAccordion's _buildPanelHeader
  Widget _buildPanelHeader(
      BuildContext context,
      String categoryName,
      int usageCount,
      bool isExpanded,
      ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(
        categoryName,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text('تم استخدامها $usageCount مرة'),
      leading: Icon(
        isExpanded ? Icons.expand_less : Icons.expand_more,
        color: Theme.of(context).primaryColor,
      ),
    );
  }


  Widget _buildSubcategoryList(
      BuildContext context,
      String categoryName,
      List<Subcategory> subcategories, // This is now the filtered list
      bool isLoading,
      ) {
    final state = context.watch<ReportDashboardState>();

    if (isLoading) {
      return const _LoadingState();
    }

    if (subcategories.isEmpty) {
      return const _EmptyState(message: 'لا توجد فئات فرعية مستخدمة');
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: subcategories.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final subcategory = subcategories[index];
        final usageCount = state.subcategoryUsageCount[categoryName]?[subcategory.name] ?? 0;

        return _SubcategoryItem(
          name: subcategory.name,
          usageCount: usageCount,
        );
      },
    );
  }
}




class _BillsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StatusFilter(),
        Expanded(child: _BillsListView()),
      ],
    );
  }
}

class _StatusFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<ReportDashboardState>();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonFormField<String?>(
            value: state.selectedStatus,
            decoration: const InputDecoration(
              labelText: 'تصفية حسب الحالة',
              border: InputBorder.none,
            ),
            items: const [
              DropdownMenuItem(value: null, child: Text('الكل')),
              DropdownMenuItem(value: 'آجل', child: Text('آجل')),
              DropdownMenuItem(value: 'تم الدفع', child: Text('تم الدفع')),
              DropdownMenuItem(value: 'فاتورة مفتوحة', child: Text('فاتورة مفتوحة')),
            ],
            onChanged: (value) => context.read<ReportDashboardState>()._fetchBillsByStatus(value),
          ),
        ),
      ),
    );
  }
}

class _BillsListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<ReportDashboardState>();

    if (state.isLoadingBills) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.bills.isEmpty) {
      return const Center(child: Text('لا توجد فواتير لعرضها'));
    }

    return ListView.builder(
      itemCount: state.bills.length,
      itemBuilder: (context, index) {
        final bill = state.bills[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: _BillListItem(
            bill: bill,
            onTap: () => _showBillDetails(context, bill),
          ),
        );
      },
    );
  }

  void _showBillDetails(BuildContext context, Bill bill) {
    showDialog(
      context: context,
      builder: (context) => _BillDetailsDialog(bill: bill),
    );
  }
}

// UI Components
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _StatCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                radius: 24,
                child: Icon(icon, size: 22, color: color),
              ),
              // const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontSize: 14)),
              // const SizedBox(height: 10),
              Text(
                NumberFormat().format(count),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCardShimmer extends StatelessWidget {
  const _StatCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 60),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: CircleAvatar(backgroundColor: Colors.white),
                  ),
                ),
                // const SizedBox(height: 8),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Container(width: 60, height: 13, color: Colors.white),
                  ),
                ),
                // const SizedBox(height: 4),
                 Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Container(width: 40, height: 10, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BillListItem extends StatelessWidget {
  final Bill bill;
  final VoidCallback onTap;

  const _BillListItem({
    required this.bill,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: CircleAvatar(
          backgroundColor: _statusColor(bill.status).withOpacity(0.1),
          child: Icon(
            _statusIcon(bill.status),
            color: _statusColor(bill.status),
            size: 20,
          ),
        ),
        title: Text(bill.customerName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('#${bill.id} - ${_formatDate(bill.date)}'),
            const SizedBox(height: 4),
            Text('${NumberFormat().format(bill.total_price)} ر.س'),
          ],
        ),
        trailing: Chip(
          label: Text(bill.status),
          backgroundColor: _statusColor(bill.status).withOpacity(0.1),
          labelStyle: TextStyle(
            color: _statusColor(bill.status),
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'تم الدفع': return Icons.check;
      case 'آجل': return Icons.pending;
      case 'فاتورة مفتوحة': return Icons.hourglass_empty;
      default: return Icons.receipt;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'تم الدفع': return Colors.green;
      case 'آجل': return Colors.orange;
      case 'فاتورة مفتوحة': return Colors.blue;
      default: return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy/MM/dd').format(date);
  }
}

class _BillDetailsDialog extends StatelessWidget {
  final Bill bill;

  const _BillDetailsDialog({required this.bill});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'تفاصيل الفاتورة #${bill.id}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            _DetailRow(label: 'العميل', value: bill.customerName),
            _DetailRow(label: 'التاريخ', value: _formatDate(bill.date)),
            _DetailRow(
                label: 'المبلغ الإجمالي',
                value: '${NumberFormat().format(bill.total_price)} ر.س'
            ),
            _DetailRow(label: 'حالة الدفع', value: bill.status),
            if (bill.description.isNotEmpty)
              _DetailRow(label: 'الوصف', value: bill.description),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إغلاق'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy/MM/dd').format(date);
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.grey))),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  final Widget? action;

  const _EmptyState({required this.message, this.action});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          if (action != null) ...[
            const SizedBox(height: 24),
            action!,
          ],
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _SubcategoryItem extends StatefulWidget {
  final String name;
  final int usageCount;

  const _SubcategoryItem({
    required this.name,
    required this.usageCount,
  });

  @override
  State<_SubcategoryItem> createState() => _SubcategoryItemState();
}

class _SubcategoryItemState extends State<_SubcategoryItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Text(widget.name, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text('تم استخدامها ${widget.usageCount} مرة'),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.category, size: 18),
        ),
      ),
    );
  }
}

class _CategoryShimmerItem extends StatefulWidget {
  const _CategoryShimmerItem();

  @override
  State<_CategoryShimmerItem> createState() => _CategoryShimmerItemState();
}

class _CategoryShimmerItemState extends State<_CategoryShimmerItem> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          leading: const CircleAvatar(radius: 24, backgroundColor: Colors.white),
          title: Container(width: 120, height: 16, color: Colors.white),
          subtitle: Container(width: 80, height: 14, color: Colors.white),
          trailing: const Icon(Icons.expand_more, color: Colors.white),
        ),
      ),
    );
  }
}