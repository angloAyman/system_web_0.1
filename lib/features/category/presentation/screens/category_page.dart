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
  @override
  void initState() {
    super.initState();
    _loadCategories();

  }

  void _loadCategories() {
    setState(() {
      _categoriesFuture = _categoryRepository.getCategories();
    });
  }



  @override
  void dispose() {
    _subcategoriesFutures.clear(); // Clear futures when disposing the widget
    super.dispose();
  }

  Future<void> _showEditCategoryDialog(Category category) async {
    TextEditingController nameController = TextEditingController(text: category.name);

    bool updated = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('تحديث الصنف الرئسي'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'اسم الصنف'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('الغاء'),
            ),


            ElevatedButton(
              onPressed: () async {
                String newName = nameController.text.trim();
                if (newName.isNotEmpty && newName != category.name) {
                  await _categoryRepository.updateCategory(category.id, newName);
                  Navigator.of(context).pop(true);
                } else {
                  Navigator.of(context).pop(false);
                }
              },
              child: Text('تحديث'),
            ),
          ],
        );
      },
    );

    if (updated == true) {
      _loadCategories();
    }
  }

  Future<void> _showEditSubcategoryDialog(String categoryId, Subcategory subcategory) async {
    TextEditingController nameController = TextEditingController(text: subcategory.name);
    TextEditingController unitController = TextEditingController(text: subcategory.unit);
    TextEditingController priceController = TextEditingController(text: subcategory.pricePerUnit.toString());
    TextEditingController discountController = TextEditingController(text: subcategory.discountPercentage.toString());

    bool updated = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('تحديث الصنف الفرعي'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: 'الاسم')),
              TextField(controller: unitController, decoration: InputDecoration(labelText: 'الوحدة')),
              TextField(controller: priceController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'سعر الوحدة')),
              TextField(controller: discountController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'نسبة الخصم')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('الغاء'),
            ),

            ElevatedButton(
              onPressed: () async {
                String newName = nameController.text.trim();
                String newUnit = unitController.text.trim();
                double newPrice = double.tryParse(priceController.text) ?? 0.0;
                double newDiscount = double.tryParse(discountController.text) ?? 0.0;

                if (newName.isNotEmpty && newPrice > 0) {
                  await _categoryRepository.updateSubcategory(
                    categoryId,
                    subcategory.id,
                    newName,
                    newUnit,
                    newPrice,
                    newDiscount,
                  );
                  Navigator.of(context).pop(true);
                } else {
                  Navigator.of(context).pop(false);
                }
              },
              child: Text('تحديث'),
            ),
          ],
        );
      },
    );

    if (updated == true) {
      setState(() {
        _subcategoriesFutures[categoryId] = _categoryRepository.getSubcategories(categoryId);
      });
    }
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
      String discountPercentage,
      ) async
  {try {
      await _categoryRepository.addSubcategory(categoryId, name, unit, pricePerUnit, discountPercentage);
      if (mounted) { setState(() {
          _subcategoriesFutures[categoryId] =
              _categoryRepository.getSubcategories(categoryId);
        });}} catch (e) {
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
                final discountPercentage = discountPercentageText.toString();
                // final discountPercentage = double.tryParse(discountPercentageText);

                if (price == null || price <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('الرجاء إدخال سعر صالح.')),
                  );
                  return;
                }
                if (discountPercentage == null ) {
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
            decoration: InputDecoration(labelText: 'اسم الصنف'),
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
        title: Text('الاصناف'),
        actions: [

          TextButton.icon(onPressed: (){
            Navigator.pushReplacementNamed(context, '/adminHome'); // توجيه المستخدم إلى صفحة تسجيل الدخول
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
                      () {
                        return _categoryRepository
                            .getSubcategories(category.id);
                      },
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
                        return Center(child: Text(" لا يوجد اصناف فرعية"));
                      }

                      final subcategories = subcatSnapshot.data!;
                      return Column(
                        children: subcategories.map((subcat) {
                          return ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("اسم الصنف الفرعي : " + subcat.name),
                                Text("الوحدة : " + subcat.unit),
                                Text("سعر الوحدة : " +
                                    subcat.pricePerUnit.toString()),
                                Text("نسبة الخصم : " +
                                    subcat.discountPercentage.toString()),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _showEditSubcategoryDialog(
                                        category.id, subcat);
                                    setState(() {

                                    });
                                  },
                                  tooltip: "تحديث الصنف الفرعي",
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                ),
                                IconButton(
                                  onPressed: () => _removeSubcategory(
                                      category.id, subcat.id),
                                  icon: Icon(Icons.delete, color: Colors.red),
                                ),
                              ],
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
                        tooltip: "اضافة عنصر فرعي",
                        onPressed: () => _showAddSubcategoryDialog(category.id),
                      ),
                      IconButton(
                        tooltip: "تحديث الصنف الرئيسي",
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _showEditCategoryDialog(category);
                          setState(() {

                          });();
                        },
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


