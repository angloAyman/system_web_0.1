// import 'package:flutter/material.dart';
// import '../../data/repositories/category_repository.dart';
// import '../../data/models/category_model.dart';
//
// class CategoryPage extends StatefulWidget {
//   @override
//   _CategoryPageState createState() => _CategoryPageState();
// }
//
// class _CategoryPageState extends State<CategoryPage> {
//   final CategoryRepository _categoryRepository = CategoryRepository();
//   late Future<List<Category>> _categoriesFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _categoriesFuture = _categoryRepository.getCategories();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Categories')),
//       body: FutureBuilder<List<Category>>(
//         future: _categoriesFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No categories found.'));
//           }
//
//           final categories = snapshot.data!;
//           return ListView.builder(
//             itemCount: categories.length,
//             itemBuilder: (context, index) {
//               final category = categories[index];
//               return ListTile(
//                 title: Text(category.name),
//                 onTap: () {
//                   // Handle category tap
//                   print('Tapped on: ${category.name}');
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:system/features/category/data/models/subCategory_model.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/models/category_model.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final CategoryRepository _categoryRepository = CategoryRepository();
  late Future<List<Category>> _categoriesFuture;
  Map<String, Future<List<Subcategory>>> _subcategoriesFutures = {};

  // Future<List<Subcategory>>? _subcategoriesFuture;
  // String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _categoryRepository.getCategories();
  }

  // void _loadSubcategories(String categoryId) {
  //   setState(() {
  //     _selectedCategoryId = categoryId;
  //     _subcategoriesFuture = _categoryRepository.getSubcategories(categoryId);
  //   });
  // }

  void _removeCategory(String categoryId) async {
    try {
      await _categoryRepository.removeCategory(categoryId);
      setState(() {
        _categoriesFuture = _categoryRepository.getCategories();
      });
    } catch (e) {
      print('Error removing category: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing category: $e')),
      );
    }
  }

  Future<void> _addSubcategory(String categoryId, String name) async {
    try {
      await _categoryRepository.addSubcategory(categoryId, name);
      setState(() {
        _subcategoriesFutures[categoryId] =
            _categoryRepository.getSubcategories(categoryId);
      });
    } catch (e) {
      print('Error adding subcategory: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding subcategory: $e')),
      );
    }
  }

  void _addCategory(String name) async {
    try {
      await _categoryRepository.addCategory(name);
      setState(() {
        _categoriesFuture = _categoryRepository.getCategories();
      });
    } catch (e) {
      print('Error adding category: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding category: $e')),
      );
    }
  }

  void _showAddSubcategoryDialog(String categoryId) {
    final TextEditingController _subcategoryController =
        TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Subcategory'),
            content: TextField(
              controller: _subcategoryController,
              decoration: InputDecoration(
                labelText: 'Subcategory Name',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  _addSubcategory(categoryId, _subcategoryController.text);
                  Navigator.of(context).pop();
                },
                child: Text('Add'),
              ),
            ],
          );
        });
  }

  void _showAddCategoryDialog() {
    final TextEditingController _categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('اضافة صنف'),
          content: TextField(
            controller: _categoryController,
            decoration: InputDecoration(
              labelText: 'اسم الصنوف',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('الغاء'),
            ),
            TextButton(
              onPressed: () {
                _addCategory(_categoryController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Sucsses add category')),
                );
                Navigator.of(context).pop();
              },
              child: Text('اضافة'),
            ),
          ],
        );
      },
    );
  }

  void _removeSubcategory(String categoryId, String subcategoryId) async {
    try {
      await _categoryRepository.removeSubcategory(subcategoryId);
      setState(() {
        _subcategoriesFutures[categoryId] =
            _categoryRepository.getSubcategories(categoryId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Subcategory removed successfully.')),
      );
    } catch (e) {
      print('Error removing subcategory: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing subcategory: $e')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddCategoryDialog,
          ),
        ],
      ),
      body: FutureBuilder<List<Category>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No categories found.'));
          }

          final categories = snapshot.data!;
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return ExpansionTile(
                title: Text(category.name),
                children: [
                  FutureBuilder<List<Subcategory>>(
                    future: _subcategoriesFutures.putIfAbsent(
                      category.id,
                      () => _categoryRepository.getSubcategories(category.id),
                    ),
                    builder: (context, subcatSnapshot) {
                      if (subcatSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (subcatSnapshot.hasError) {
                        return Center(
                            child: Text('Error: ${subcatSnapshot.error}'));
                      } else if (!subcatSnapshot.hasData ||
                          subcatSnapshot.data!.isEmpty) {
                        return Center(child: Text('No subcategories found.'));
                      }

                      final subcategories = subcatSnapshot.data!;
                      return Column(
                        children: subcategories.map((subcat) {
                          return ListTile(
                            title: Text(subcat.name),
                            trailing: IconButton(
                              onPressed: () => _removeSubcategory(category.id, subcat.id),
                              icon: Icon(Icons.delete),                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  ButtonBar(
                    children: [
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => _showAddSubcategoryDialog(category.id),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _removeCategory(category.id),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
