
import 'package:flutter/material.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/category/data/models/category_model.dart';
import 'package:system/features/category/data/models/subCategory_model.dart';
import 'package:system/features/category/data/repositories/category_repository.dart';

Future<void> showEditItemDialogMobile({
  required BuildContext context,
  required BillItem item,
  required Function(BillItem) onUpdateItem,
}) async {
  final TextEditingController amountController = TextEditingController(text: item.amount.toString());
  final TextEditingController price_per_unitController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController(text: item.description);
  final TextEditingController quantityController = TextEditingController(text: item.quantity.toString());
  final TextEditingController discountController = TextEditingController(text: item.discount.toString());

  final CategoryRepository categoryRepository = CategoryRepository();

  List<Category> categories = [];
  List<Subcategory> subcategories = [];
  Category? selectedCategory;
  Subcategory? selectedSubcategory;

  bool applyDiscount = item.discount > 0; // Initialize based on existing item
  String discountType = item.discountType == '(%)' ? '(%)' : item.discountType == '(ج م)' ? '(ج م)' : 'لا يوجد';

  try {
    categories = await categoryRepository.getCategories();
    selectedCategory = categories.firstWhere((category) => category.name == item.categoryName);
    subcategories = await categoryRepository.getSubcategories(selectedCategory.id);
    selectedSubcategory = subcategories.firstWhere((subcategory) => subcategory.name == item.subcategoryName);
    price_per_unitController.text = selectedSubcategory.pricePerUnit.toString();
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
          num? calculatepecePrice() {
            double amount = double.tryParse(amountController.text) ?? 0.0;
            double pricePerUnit = selectedSubcategory?.pricePerUnit ?? 0.0;
            double subtotal = amount * pricePerUnit;
            int finalTotal = subtotal.toInt();
            return finalTotal < 0 ? 0 : finalTotal;
          }

          double calculateTotalPrice() {
            double amount = double.tryParse(amountController.text) ?? 0.0;
            double quantity = double.tryParse(quantityController.text) ?? 0.0;
            double pricePerUnit = selectedSubcategory?.pricePerUnit ?? 0.0;

            double subtotal = amount * quantity * pricePerUnit;
            int discountValue = int.tryParse(discountController.text) ?? 0;
            double finalTotal = subtotal;

            if (applyDiscount) {
              if (discountType == '(%)') {
                int discountAmount = ((subtotal * discountValue) / 100).toInt();
                finalTotal -= discountAmount;
              } else if (discountType == '(ج م)') {
                finalTotal -= discountValue;
              }
            }

            return finalTotal < 0 ? 0 : finalTotal;
          }

          return AlertDialog(
            title: Text('تعديل العناصر'),
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/Category');
                          },
                          child: Text("اضافة عنصر جديد")),
                    ],
                  ),
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

                        if (subcategory != null) {
                          try {
                            final subcategoryDetails = await categoryRepository
                                .getSubcategoryDetails(subcategory.id as int);
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
                        Text('نسبة الخصم: % ${selectedSubcategory!.discountPercentage}'),
                      ],
                    ),

                  // Description text field
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'الوصف بداخل الفاتورة '),
                    maxLines: 1,
                  ),

                  // Amount text field
                  TextField(
                    controller: amountController,
                    decoration: InputDecoration(labelText: ' عدد الوحدات'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setDialogState(() {});
                    },
                  ),

                  if (selectedSubcategory != null && amountController.text.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'السعر القطعة: L.E ${calculatepecePrice()?.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                      ],
                    ),

                  TextField(
                    controller: quantityController,
                    decoration: InputDecoration(labelText: 'الكمية'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setDialogState(() {});
                    },
                  ),

                  // Checkbox for applying discount
                  CheckboxListTile(
                    title: Text('تطبيق خصم'),
                    value: applyDiscount,
                    onChanged: (value) {
                      setDialogState(() {
                        applyDiscount = value ?? false;
                        discountType = '(%)';
                        discountController.clear();
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),

                  // Show discount type selection when discount is applied
                  if (applyDiscount)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('نوع الخصم:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            DropdownButton<String>(
                              value: discountType,
                              onChanged: (String? newValue) {
                                setDialogState(() {
                                  discountType = newValue!;
                                  discountController.clear();
                                });
                              },
                              items: [
                                DropdownMenuItem(
                                    value: '(%)',
                                    child: Text('نسبة مئوية (%)')),
                                DropdownMenuItem(
                                    value: '(ج م)',
                                    child: Text('قيمة ثابتة (مبلغ)')),
                              ],
                            ),
                          ],
                        ),
                        TextField(
                          controller: discountController,
                          decoration: InputDecoration(
                            labelText: discountType == '(%)'
                                ? 'قيمة الخصم (%)'
                                : 'قيمة الخصم (مبلغ)',
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setDialogState(() {});
                          },
                        ),
                      ],
                    ),

                  // Total Price
                  Text(
                    'الإجمالي: L.E ${calculateTotalPrice().toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('الغاء'),
              ),
              TextButton(
                onPressed: () {
                  int? quantity = int.tryParse(quantityController.text);
                  if (quantity == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('برجاء إدخال قيمة صحيحة الكمية')),
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

                  int discount = applyDiscount
                      ? int.tryParse(discountController.text) ?? 0
                      : 0;

                  final updatedItem = BillItem(
                    categoryName: selectedCategory!.name,
                    subcategoryName: selectedSubcategory!.name,
                    amount: amount,
                    price_per_unit: selectedSubcategory!.pricePerUnit,
                    description: descriptionController.text,
                    quantity: quantity,
                    discount: discount,
                    total_Item_price: calculateTotalPrice(),
                    discountType: discountType,
                  );

                  onUpdateItem(updatedItem);
                  Navigator.of(context).pop();
                },
                child: Text('تحديث العناصر'),
              ),
            ],
          );
        },
      );
    },
  );
}