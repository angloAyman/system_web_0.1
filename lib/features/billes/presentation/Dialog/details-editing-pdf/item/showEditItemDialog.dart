import 'package:flutter/material.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/category/data/models/category_model.dart';
import 'package:system/features/category/data/models/subCategory_model.dart';
import 'package:system/features/category/data/repositories/category_repository.dart';
//
// Future<void> showEditItemDialog({
//   required BuildContext context,
//   required BillItem item,
//   required Function(BillItem updatedItem) onSave,
// }) async {
//   // Controllers to hold the values for editing
//   final TextEditingController amountController =
//   TextEditingController(text: item.amount.toString());
//   final TextEditingController quantityController =
//   TextEditingController(text: item.quantity.toString());
//   final TextEditingController priceController =
//   TextEditingController(text: item.price_per_unit.toStringAsFixed(2));
//   final TextEditingController categoryController =
//   TextEditingController(text: item.categoryName);
//   final TextEditingController subcategoryController =
//   TextEditingController(text: item.subcategoryName);
//   final TextEditingController descriptionController =
//   TextEditingController(text: item.description);
//
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('تعديل تفاصيل العنصر'),
//         content: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//
//               // الفئة
//               TextField(
//                 controller: categoryController,
//                 decoration: const InputDecoration(
//                   labelText: 'الفئة',
//                   border: OutlineInputBorder(),
//                   enabled: false,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               // الفئة الفرعية
//               TextField(
//                 controller: subcategoryController,
//                 decoration: const InputDecoration(
//                   labelText: 'الفئة الفرعية',
//                   border: OutlineInputBorder(),
//                   enabled: false,
//
//                 ),
//               ),
//               const SizedBox(height: 8),
//               // الوصف
//               TextField(
//                 controller: descriptionController,
//                 keyboardType: TextInputType.text,
//                 decoration: const InputDecoration(
//                   labelText: 'الوصف',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               // عدد الوحدات
//               TextField(
//                 controller: amountController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   labelText: 'عدد الوحدات',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               // السعر للوحدة
//               TextField(
//                 controller: priceController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   labelText: 'السعر للوحدة',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               // العدد
//               TextField(
//                 controller: quantityController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   labelText: 'الكمية',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 8),
//
//             ],
//           ),
//         ),
//         actions: [
//           // زر الإلغاء
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: const Text('إلغاء'),
//           ),
//           // زر حفظ التعديلات
//           ElevatedButton(
//             onPressed: () {
//               // تحديث العنصر بناءً على القيم المدخلة
//               final updatedItem = BillItem(
//                 categoryName: categoryController.text,
//                 subcategoryName: subcategoryController.text,
//                 amount: double.tryParse(amountController.text) ?? item.amount,
//                 price_per_unit: double.tryParse(priceController.text) ?? item.price_per_unit,
//                 description: descriptionController.text,
//                 quantity: double.tryParse(quantityController.text) ?? item.quantity,
//               );
//
//               // استدعاء دالة onSave لتمرير العنصر المعدل
//               onSave(updatedItem);
//
//               // إغلاق نافذة الحوار بعد حفظ التعديلات
//               Navigator.of(context).pop();
//             },
//             child: const Text('حفظ'),
//           ),
//         ],
//       );
//     },
//   );
// }
Future<void> showEditItemDialog({
  required BuildContext context,
  required BillItem item, // The item to edit
  required Function(BillItem) onUpdateItem, // Callback to update the item
}) async {
  final TextEditingController amountController = TextEditingController(text: item.amount.toString());
  final TextEditingController price_per_unitController = TextEditingController(text: item.price_per_unit.toString());
  final CategoryRepository categoryRepository = CategoryRepository();
  final TextEditingController descriptionController = TextEditingController(text: item.description);
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
                  // if (selectedCategory == null || selectedSubcategory == null) {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(content: Text('برجاء اختيار العناصر الاساسية و الفرعية')),
                  //   );
                  //   return;
                  // }

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

                  // Creating BillItem with updated data
                  final updatedItem = BillItem(
                    categoryName: selectedCategory!.name,
                    subcategoryName: selectedSubcategory!.name,
                    amount: amount,
                    price_per_unit: selectedSubcategory!.pricePerUnit,
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
