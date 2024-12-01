import 'package:flutter/material.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/category/data/models/category_model.dart';
import 'package:system/features/category/data/models/subCategory_model.dart';
import 'package:system/features/category/data/repositories/category_repository.dart';

Future<void> showAddItemDialog({
  required BuildContext context,
  required Function(BillItem) onAddItem,
}) async {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController price_per_unitController = TextEditingController();
  final CategoryRepository categoryRepository = CategoryRepository();

  List<Category> categories = [];
  List<Subcategory> subcategories = [];
  Category? selectedCategory;
  Subcategory? selectedSubcategory;

  try {
    categories = await categoryRepository.getCategories();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching categories: $e')),
    );
    return;
  }

  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text('اضافة العناصر'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<Category>(
                  value: selectedCategory,
                  decoration: InputDecoration(labelText: 'Category'),
                  items: categories.map((category) {
                    return DropdownMenuItem<Category>(
                      value: category,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (category) async {
                    setDialogState(() {
                      selectedCategory = category;
                      selectedSubcategory = null;
                      subcategories = [];
                    });

                    if (category != null) {
                      try {
                        subcategories = await categoryRepository.getSubcategories(category.id);
                        setDialogState(() {});
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error fetching subcategories: $e')),
                        );
                      }
                    }
                  },
                ),
                if (selectedCategory != null)
                  DropdownButtonFormField<Subcategory>(
                    value: selectedSubcategory,
                    decoration: InputDecoration(labelText: 'Subcategory'),
                    items: subcategories.map((subcategory) {
                      return DropdownMenuItem<Subcategory>(
                        value: subcategory,
                        child: Text(subcategory.name),
                      );
                    }).toList(),
                    onChanged: (subcategory) {
                      setDialogState(() {
                        selectedSubcategory = subcategory;
                      });
                    },
                  ),
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(labelText: 'الكمية'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: price_per_unitController,
                  decoration: InputDecoration(labelText: 'السعر للوحدة'),
                  keyboardType: TextInputType.number,
                ),

              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('الغاء'),
              ),
              TextButton(
                onPressed: () {
                  if (selectedCategory == null || selectedSubcategory == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('برجاء اختيار العناصر الاساسية و الفرعية')),
                    );
                    return;
                  }

                  final item = BillItem(
                    categoryName: selectedCategory!.name,
                    subcategoryName: selectedSubcategory!.name,
                    amount: double.parse(amountController.text),
                    price_per_unit: double.parse(price_per_unitController.text),
                  );
                  onAddItem(item);
                  Navigator.of(context).pop();
                },
                child: Text('Add'),
              ),
            ],
          );
        },
      );
    },
  );
}
