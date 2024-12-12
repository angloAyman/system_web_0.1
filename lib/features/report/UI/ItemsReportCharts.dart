// import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
// import 'package:system/features/category/data/repositories/category_repository.dart';
// import 'package:system/features/category/data/models/category_model.dart';
// import 'package:system/features/category/data/models/subCategory_model.dart';
//
// class ItemsReportCharts extends StatefulWidget {
//   @override
//   _ItemsReportChartsState createState() => _ItemsReportChartsState();
// }
//
// class _ItemsReportChartsState extends State<ItemsReportCharts> {
//   Future<List<Category>>? categories;
//   Map<String, int> categoryUsageCount = {}; // Store category usage count
//   Map<String, Map<String, int>> subcategoryUsageCount = {}; // Store subcategory usage count by category
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchData();
//   }
//
//   void _fetchData() async {
//     categories = CategoryRepository().getCategories();
//     categories?.then((categoryList) {
//       for (var category in categoryList) {
//         // Fetch category usage count
//         CategoryRepository().getCategoryUsageCount(category.id).then((usageCount) {
//           setState(() {
//             categoryUsageCount[category.name] = usageCount;
//           });
//         }).catchError((error) {
//           print('Error fetching category usage count: $error');
//         });
//
//         // Fetch subcategory usage counts
//         CategoryRepository().getSubcategories(category.id).then((subcategories) {
//           for (var subcategory in subcategories) {
//             CategoryRepository().getSubcategoryUsageCount(subcategory.id).then((usageCount) {
//               setState(() {
//                 subcategoryUsageCount.putIfAbsent(category.name, () => {});
//                 subcategoryUsageCount[category.name]![subcategory.name] = usageCount;
//               });
//             }).catchError((error) {
//               print('Error fetching subcategory usage count: $error');
//             });
//           }
//         }).catchError((error) {
//           print('Error fetching subcategories: $error');
//         });
//       }
//     }).catchError((error) {
//       print('Error fetching categories: $error');
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Items Report Charts'),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: FutureBuilder<List<Category>>(
//         future: categories,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No categories available'));
//           } else {
//             final categoryList = snapshot.data!;
//
//             // Generate charts
//             List<charts.Series<dynamic, String>> categoryChartData = _buildCategoryChartData(categoryList);
//             List<charts.Series<dynamic, String>> subcategoryChartData = _buildSubcategoryChartData(categoryList);
//
//             return SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Text(
//                       'Category Usage Chart',
//                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   Container(
//                     height: 300,
//                     child: charts.BarChart(
//                       categoryChartData,
//                       animate: true,
//                       vertical: false,
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Text(
//                       'Subcategory Usage Chart',
//                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   Container(
//                     height: 300,
//                     child: charts.BarChart(
//                       subcategoryChartData,
//                       animate: true,
//                       vertical: false,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
//
//   List<charts.Series<dynamic, String>> _buildCategoryChartData(List<Category> categories) {
//     final data = categories.map((category) {
//       return {
//         'name': category.name,
//         'count': categoryUsageCount[category.name] ?? 0,
//       };
//     }).toList();
//
//     return [
//       charts.Series<dynamic, String>(
//         id: 'Categories',
//         domainFn: (datum, _) => datum['name'] as String,
//         measureFn: (datum, _) => datum['count'] as int,
//         data: data,
//         labelAccessorFn: (datum, _) => '${datum['count']}',
//       )
//     ];
//   }
//
//   List<charts.Series<dynamic, String>> _buildSubcategoryChartData(List<Category> categories) {
//     final data = <Map<String, dynamic>>[];
//
//     for (var category in categories) {
//       final subcategories = subcategoryUsageCount[category.name]?.entries.toList() ?? [];
//       for (var subcategory in subcategories) {
//         data.add({
//           'name': '${category.name} - ${subcategory.key}',
//           'count': subcategory.value,
//         });
//       }
//     }
//
//     return [
//       charts.Series<dynamic, String>(
//         id: 'Subcategories',
//         domainFn: (datum, _) => datum['name'] as String,
//         measureFn: (datum, _) => datum['count'] as int,
//         data: data,
//         labelAccessorFn: (datum, _) => '${datum['count']}',
//       )
//     ];
//   }
// }
