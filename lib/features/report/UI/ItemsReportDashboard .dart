import 'package:flutter/material.dart';
import 'package:system/features/category/data/repositories/category_repository.dart';
import 'package:system/features/category/data/models/category_model.dart';
import 'package:system/features/category/data/models/subCategory_model.dart';

class ItemsReportDashboard extends StatefulWidget {
  @override
  _ItemsReportDashboardState createState() => _ItemsReportDashboardState();
}

class _ItemsReportDashboardState extends State<ItemsReportDashboard> {
  Future<List<Category>>? categories;
  Map<String, List<Subcategory>> subcategoriesByCategory = {}; // Store subcategories by category
  Map<String, int> categoryUsageCount = {}; // Store category usage count
  Map<String, Map<String, int>> subcategoryUsageCount = {}; // Store subcategory usage count by category

  @override
  void initState() {
    super.initState();
    _fetchCategoriesAndSubcategories();
  }

  void _fetchCategoriesAndSubcategories() async {
    categories = CategoryRepository().getCategories();
    categories?.then((categoryList) {
      for (var category in categoryList) {
        // Fetch subcategories and their usage count
        CategoryRepository().getSubcategories(category.id).then((subcategories) {
          setState(() {
            subcategoriesByCategory[category.name] = subcategories;
            subcategoryUsageCount[category.name] = {};
          });

          for (var subcategory in subcategories) {
            CategoryRepository().getSubcategoryUsageCount(subcategory.id).then((usageCount) {
              setState(() {
                subcategoryUsageCount[category.name]?[subcategory.name] = usageCount;
              });
            }).catchError((error) {
              print('Error fetching subcategory usage count: $error');
            });
          }
        }).catchError((error) {
          print('Error fetching subcategories: $error');
        });

        // Fetch category usage count
        CategoryRepository().getCategoryUsageCount(category.id).then((usageCount) {
          setState(() {
            categoryUsageCount[category.name] = usageCount;
          });
        }).catchError((error) {
          print('Error fetching category usage count: $error');
        });
      }
    }).catchError((error) {
      print('Error fetching categories: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Items Report Dashboard'),
        backgroundColor: Colors.blueAccent,
        actions: [
          TextButton.icon(onPressed: (){
            Navigator.pushReplacementNamed(context, '/ItemsCharts');
          }, label: Icon(Icons.bar_chart)),
        ],
      ),
      body: FutureBuilder<List<Category>>(
        future: categories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No categories available'));
          } else {
            final categoryList = snapshot.data!;

            return ListView.builder(
              itemCount: categoryList.length,
              itemBuilder: (context, index) {
                final category = categoryList[index];
                final subcategories = subcategoriesByCategory[category.name] ?? [];
                final categoryCount = categoryUsageCount[category.name] ?? 0;

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category title and usage count
                        Text(
                          '${category.name} (Used $categoryCount times)',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),

                        // Subcategories list
                        if (subcategories.isNotEmpty)
                          ...subcategories.map((subcategory) {
                            final subcategoryCount = subcategoryUsageCount[category.name]?[subcategory.name] ?? 0;
                            return ListTile(
                              title: Text('${subcategory.name} (Used $subcategoryCount times)'),
                              subtitle: Text('Unit: ${subcategory.unit}, Price: ${subcategory.pricePerUnit}'),
                            );
                          }).toList(),
                        if (subcategories.isEmpty)
                          Text('No subcategories available', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
