
import 'package:flutter/material.dart';
import 'package:system/Adminfeatures/category/data/models/subCategory_model.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/models/category_model.dart';

class UserCategoryPage extends StatefulWidget {
  @override
  _UserCategoryPageState createState() => _UserCategoryPageState();
}

class _UserCategoryPageState extends State<UserCategoryPage> {
  final CategoryRepository _categoryRepository = CategoryRepository();
  late Future<List<Category>> _categoriesFuture;
  Map<String, Future<List<Subcategory>>> _subcategoriesFutures = {};

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _categoryRepository.getCategories();
  }

  @override
  void dispose() {
    _subcategoriesFutures.clear(); // Clear futures when disposing the widget
    super.dispose();
  }

  void _removeCategory(String categoryId) async {
    try {
      await _categoryRepository.removeCategory(categoryId);
      if (mounted) {
        setState(() {
          _categoriesFuture = _categoryRepository.getCategories();
        });
      }
    } catch (e) {
      print('Error removing category: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error removing category: $e')),
        );
      }
    }
  }

  Future<void> _addSubcategory(
      String categoryId,
      String name,
      String unit,
      double pricePerUnit,
      double discountPercentage,
      ) async {
    try {
      await _categoryRepository.addSubcategory(categoryId, name, unit, pricePerUnit, discountPercentage);
      if (mounted) {
        setState(() {
          _subcategoriesFutures[categoryId] =
              _categoryRepository.getSubcategories(categoryId);
        });
      }
    } catch (e) {
      print('Error adding subcategory: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding subcategory: $e')),
        );
      }
    }
  }

  void _addCategory(String name) async {
    try {
      await _categoryRepository.addCategory(name);
      if (mounted) {
        setState(() {
          _categoriesFuture = _categoryRepository.getCategories();
        });
      }
    } catch (e) {
      print('Error adding category: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding category: $e')),
        );
      }
    }
  }

  void _showAddSubcategoryDialog(String categoryId) {
    final TextEditingController _subcategoryController = TextEditingController();
    final TextEditingController _unitSubcategoryController = TextEditingController();
    final TextEditingController _discountPercentageSubcategoryController = TextEditingController();
    final TextEditingController _pricePerUnitSubcategoryController =
    TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('اضافة صنف فرعي'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _subcategoryController,
                  decoration: InputDecoration(labelText: 'اسم الصنف الفرعي'),
                ),
                TextField(
                  controller: _unitSubcategoryController,
                  decoration: InputDecoration(labelText: 'الوحدة الصنف الفرعي'),
                ),
                TextField(
                  controller: _pricePerUnitSubcategoryController,
                  decoration: InputDecoration(labelText: 'سعر الوحدة الصنف الفرعي'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _discountPercentageSubcategoryController,
                  decoration: InputDecoration(labelText: 'نسبة الخصم'),
                  keyboardType: TextInputType.number,
                ),
              ],
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
                final priceText = _pricePerUnitSubcategoryController.text;
                final price = double.tryParse(priceText);

                final discountPercentageText = _discountPercentageSubcategoryController.text;
                final discountPercentage = double.tryParse(discountPercentageText);

                if (price == null || price <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('الرجاء إدخال سعر صالح.')),
                  );
                  return;
                }
                if (discountPercentage == null || discountPercentage <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('الرجاء إدخال الخصم بطريقة صحيحة.')),
                  );
                  return;
                }

                _addSubcategory(
                  categoryId,
                  _subcategoryController.text.trim(),
                  _unitSubcategoryController.text.trim(),
                  price,
                  discountPercentage,
                );
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
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
            decoration: InputDecoration(labelText: 'اسم الصنوف'),
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
                  SnackBar(content: Text('تم إضافة الصنف بنجاح')),
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
      if (mounted) {
        setState(() {
          _subcategoriesFutures[categoryId] =
              _categoryRepository.getSubcategories(categoryId);
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم إزالة الصنف الفرعي بنجاح.')),
      );
    } catch (e) {
      print('Error removing subcategory: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error removing subcategory: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الصنف'),
        actions: [

          TextButton.icon(onPressed: (){
            Navigator.pushReplacementNamed(context, '/userMainScreen'); // توجيه المستخدم إلى صفحة تسجيل الدخول
          }, label: Icon(Icons.home)),

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
            return Center(child: Text('لا يوجد اصناف.'));
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
                          child: Text('Error: ${subcatSnapshot.error}'),
                        );
                      } else if (!subcatSnapshot.hasData ||
                          subcatSnapshot.data!.isEmpty) {
                        return Center(child: Text('No subcategories found.'));
                      }

                      final subcategories = subcatSnapshot.data!;
                      return Column(
                        children: subcategories.map((subcat) {
                          return ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(subcat.name),
                                Text(subcat.unit),
                                Text(subcat.pricePerUnit.toString()),
                                Text(subcat.discountPercentage.toString()),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () =>
                                  _removeSubcategory(category.id, subcat.id),
                              icon: Icon(Icons.delete),
                            ),
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