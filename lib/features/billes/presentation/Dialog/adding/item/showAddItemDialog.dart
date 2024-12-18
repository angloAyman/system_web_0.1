
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
  final TextEditingController descriptionController = TextEditingController(); // حقل الوصف
  final TextEditingController quantityController = TextEditingController(); // حقل العدد
  final TextEditingController discountController = TextEditingController();

  final CategoryRepository categoryRepository = CategoryRepository();

  List<Category> categories = [];
  List<Subcategory> subcategories = [];
  Category? selectedCategory;
  Subcategory? selectedSubcategory;

  bool applyDiscount = false; // Track the checkbox state


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
          double totalPrice = 0.0;
          double discount = 0.0;

          // Calculate total price dynamically
          if (selectedSubcategory != null && amountController.text.isNotEmpty && quantityController.text.isNotEmpty ) {
            double amount = double.tryParse(amountController.text) ?? 0;
            double quantity = double.tryParse(quantityController.text)?? 0;
            totalPrice = amount * quantity * selectedSubcategory!.pricePerUnit;

            // // Apply discount if checkbox is enabled
            // if (applyDiscount && discountController.text.isNotEmpty) {
            //   discount = double.tryParse(discountController.text) ?? 0;
            //   totalPrice -= discount;
            // }
          }

          double calculateTotalPrice() {
            double amount = double.tryParse(amountController.text) ?? 0;
            double quantity = double.tryParse(quantityController.text) ?? 0;
            double pricePerUnit = selectedSubcategory?.pricePerUnit ?? 0;

            double subtotal = amount * quantity * pricePerUnit;

            double discountPercentage = applyDiscount
                ? (double.tryParse(discountController.text) ?? 0) / 100
                : 0;

            double discountAmount = subtotal * discountPercentage;

            return subtotal - discountAmount;
          }


          return AlertDialog(
            title: Text('اضافة العناصر'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Category dropdown
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
                // Subcategory dropdown
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

                      // Fetch unit and price_per_unit from Supabase when a subcategory is selected
                      if (subcategory != null) {
                        try {
                          // Fetch unit and price_per_unit from Supabase
                          final subcategoryDetails = await categoryRepository.getSubcategoryDetails(subcategory.id as int);

                          setDialogState(() {
                            // Update the subcategory with fetched data
                            selectedSubcategory = subcategoryDetails;
                          });

                          // Populate the price per unit controller
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
                      Text('نسبة الخصم: % ${selectedSubcategory!.discountPercentage}'),
                    ],
                  ),

                // Description text field (new field)
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'الوصف بداخل الفاتورة '),
                  maxLines: 1, // Allow multiple lines for description
                ),

                // Amount text field
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(labelText: ' عدد الوحدات'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setDialogState(() {}); // إعادة تحديث الحوار عند تغيير المدخلات
                  },
                ),

                if (selectedSubcategory != null && amountController.text.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text('الوحدة: ${selectedSubcategory!.unit}'),
                      Text(
                        'السعر القطعة: L.E ${(double.tryParse(amountController.text) ?? 0) * selectedSubcategory!.pricePerUnit}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),                    ],
                  ),


                TextField(
                  // controller: price_per_unitController..text = selectedSubcategory?.pricePerUnit.toString() ?? '',
                  controller: quantityController,
                  decoration: InputDecoration(labelText: 'الكمية'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setDialogState(() {}); // إعادة تحديث الحوار عند تغيير المدخلات
                  },
                  // readOnly: true, // Optionally, make this read-only if price is fixed
                ),

                // Checkbox for applying discount
                CheckboxListTile(
                  title: Text('تطبيق خصم'),
                  value: applyDiscount,
                  onChanged: (value) {
                    setDialogState(() {
                      applyDiscount = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),

             // Discount Percentage TextField (only visible if checkbox is checked)
                if (applyDiscount)
                  TextField(
                    controller: discountController,
                    decoration: InputDecoration(labelText: 'قيمة الخصم (%)'), // Label shows percentage
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setDialogState(() {}); // Recalculate total price when discount changes
                    },
                  ),

                // Total Price (with discount applied if checked)
                Text(
                  'الإجمالي: L.E ${calculateTotalPrice().toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                ),



              ],
            ),
            actions: [
              // Cancel button
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('الغاء'),
              ),

              // Add Button
              TextButton(
                onPressed: () {

                  // Validate amount
                  double? quantity = double.tryParse(quantityController.text);
                  if (quantity == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('برجاء إدخال قيمة صحيحة الكمية  ')),
                    );
                    return;
                  }



                  if (selectedCategory == null || selectedSubcategory == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('برجاء اختيار العناصر الاساسية و الفرعية')),
                    );
                    return;
                  }

                  double? amount = double.tryParse(amountController.text);
                  if (amount == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('برجاء إدخال قيمة صحيحة لعدد الوحدات')),
                    );
                    return;
                  }

                  double discount = applyDiscount
                      ? double.tryParse(discountController.text) ?? 0.0
                      : 0.0;


                  // Creating BillItem and passing it to onAddItem callback
                  final item = BillItem(
                    categoryName: selectedCategory!.name,
                    subcategoryName: selectedSubcategory!.name,
                    amount: amount,
                    price_per_unit: selectedSubcategory!.pricePerUnit,
                    description: descriptionController.text,
                    quantity: quantity,
                  );
                  onAddItem(item);
                  Navigator.of(context).pop();
                },
                child: Text('اضافة العناصر'),
              ),
            ],
          );
        },
      );
    },
  );
}
