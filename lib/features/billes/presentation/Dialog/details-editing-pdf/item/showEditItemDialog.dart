import 'package:flutter/material.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/category/data/models/category_model.dart';
import 'package:system/features/category/data/models/subCategory_model.dart';
import 'package:system/features/category/data/repositories/category_repository.dart';

Future<void> showEditItemDialog({
  required BuildContext context,
  required BillItem item, // The item to edit
  required Function(BillItem) onUpdateItem, // Callback to update the item
}) async {
  final TextEditingController amountController = TextEditingController(text: item.amount.toString());
  final TextEditingController price_per_unitController = TextEditingController(text: item.price_per_unit.toString());
  final CategoryRepository categoryRepository = CategoryRepository();
  final TextEditingController descriptionController = TextEditingController(text: item.description);
  final TextEditingController discountController = TextEditingController(text: item.discount.toString());
  final TextEditingController quantityController = TextEditingController(text: item.quantity.toString());

  List<Category> categories = [];
  List<Subcategory> subcategories = [];
  Category? selectedCategory;
  Subcategory? selectedSubcategory;

  // Pre-select category and subcategory based on existing item
  try {
    categories = await categoryRepository.getCategories();
    selectedCategory = categories.firstWhere((category) => category.name == item.categoryName);
    subcategories = await categoryRepository.getSubcategories(selectedCategory!.id);
    selectedSubcategory = subcategories.firstWhere((subcategory) => subcategory.name == item.subcategoryName);
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
            title: Text('تعديل العناصر showEditItemDialoge'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Category dropdown (pre-selected category)
                DropdownButtonFormField<Category>(
                  value: selectedCategory,
                  decoration: InputDecoration(labelText: 'عناصر رئيسية'),
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
                // Subcategory dropdown (pre-selected subcategory)
                if (selectedCategory != null)
                  DropdownButtonFormField<Subcategory>(
                    value: selectedSubcategory,
                    decoration: InputDecoration(labelText: 'عناصر فرعية'),
                    items: subcategories.map((subcategory) {
                      return DropdownMenuItem<Subcategory>(
                        value: subcategory,
                        child: Text(subcategory.name),
                      );
                    }).toList(),
                    onChanged: (subcategory) async {
                      setDialogState(() {
                        selectedSubcategory = subcategory;
                      });

                      if (subcategory != null) {
                        try {
                          final subcategoryDetails = await categoryRepository.getSubcategoryDetails("subcategory.id" as int);
                          setDialogState(() {
                            selectedSubcategory = subcategoryDetails;
                          });
                          price_per_unitController.text = subcategoryDetails.pricePerUnit.toString();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error fetching subcategory details: $e')),
                          );
                        }
                      }
                    },
                  ),
                // Show unit and price per unit for the selected subcategory
                if (selectedSubcategory != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('الوحدة: ${selectedSubcategory!.unit}'),
                      Text('السعر الوحدة: L.E ${selectedSubcategory!.pricePerUnit}'),
                    ],
                  ),
                // Description text field
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'الوصف بداخل الفاتورة'),
                  maxLines: 1,
                ),
                TextField(
                  controller: discountController,
                  decoration: InputDecoration(labelText: 'نسبة الخصم بداخل الفاتورة'),
                  maxLines: 1,
                ),
                // Amount text field
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(labelText: 'عدد الوحدات'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setDialogState(() {}); // Update dialog when value changes
                  },
                ),
                // Price per unit text field (auto-filled with subcategory price)
                TextField(
                  controller: quantityController,
                  decoration: InputDecoration(labelText: 'الكمية'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              // Cancel button
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('الغاء'),
              ),
              // Save button
              TextButton(
                onPressed: () {

                  double? amount = double.tryParse(amountController.text);
                  if (amount == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('برجاء إدخال قيمة صحيحة عدد الوحدات')),
                    );
                    return;
                  }

                  double? quantity = double.tryParse(quantityController.text);
                  if (quantity == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('برجاء إدخال قيمة صحيحة الكمية')),
                    );
                    return;
                  }

                  double? discount = double.tryParse(discountController.text);
                  if (discount == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('برجاء إدخال نسبة الخصم صحيحة ')),
                    );
                    return;
                  }

                  // Creating BillItem with updated data
                  final updatedItem = BillItem(
                    categoryName: selectedCategory!.name,
                    subcategoryName: selectedSubcategory!.name,
                    amount: amount,
                    price_per_unit: selectedSubcategory!.pricePerUnit,
                    discount: discount,
                    description: descriptionController.text,
                    quantity: quantity,
                    // id: item.id,
                  );
                  onUpdateItem(updatedItem);
                  // Pass updated item to callback
                  Navigator.of(context).pop();
                },
                child: Text('تحديث العناصرshow Edit item dialog'),
              ),
            ],
          );
        },
      );
    },
  );
}
