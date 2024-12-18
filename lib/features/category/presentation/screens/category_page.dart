// // // import 'package:flutter/material.dart';
// // // import '../../data/repositories/category_repository.dart';
// // // import '../../data/models/category_model.dart';
// // //
// // // class CategoryPage extends StatefulWidget {
// // //   @override
// // //   _CategoryPageState createState() => _CategoryPageState();
// // // }
// // //
// // // class _CategoryPageState extends State<CategoryPage> {
// // //   final CategoryRepository _categoryRepository = CategoryRepository();
// // //   late Future<List<Category>> _categoriesFuture;
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _categoriesFuture = _categoryRepository.getCategories();
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(title: Text('Categories')),
// // //       body: FutureBuilder<List<Category>>(
// // //         future: _categoriesFuture,
// // //         builder: (context, snapshot) {
// // //           if (snapshot.connectionState == ConnectionState.waiting) {
// // //             return Center(child: CircularProgressIndicator());
// // //           } else if (snapshot.hasError) {
// // //             return Center(child: Text('Error: ${snapshot.error}'));
// // //           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
// // //             return Center(child: Text('No categories found.'));
// // //           }
// // //
// // //           final categories = snapshot.data!;
// // //           return ListView.builder(
// // //             itemCount: categories.length,
// // //             itemBuilder: (context, index) {
// // //               final category = categories[index];
// // //               return ListTile(
// // //                 title: Text(category.name),
// // //                 onTap: () {
// // //                   // Handle category tap
// // //                   print('Tapped on: ${category.name}');
// // //                 },
// // //               );
// // //             },
// // //           );
// // //         },
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'dart:ffi';
// //
// // import 'package:flutter/material.dart';
// // import 'package:system/features/category/data/models/subCategory_model.dart';
// // import '../../data/repositories/category_repository.dart';
// // import '../../data/models/category_model.dart';
// //
// // class CategoryPage extends StatefulWidget {
// //   @override
// //   _CategoryPageState createState() => _CategoryPageState();
// // }
// //
// // class _CategoryPageState extends State<CategoryPage> {
// //   final CategoryRepository _categoryRepository = CategoryRepository();
// //   late Future<List<Category>> _categoriesFuture;
// //   Map<String, Future<List<Subcategory>>> _subcategoriesFutures = {};
// //
// //   // Future<List<Subcategory>>? _subcategoriesFuture;
// //   // String? _selectedCategoryId;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _categoriesFuture = _categoryRepository.getCategories();
// //   }
// //
// //   // void _loadSubcategories(String categoryId) {
// //   //   setState(() {
// //   //     _selectedCategoryId = categoryId;
// //   //     _subcategoriesFuture = _categoryRepository.getSubcategories(categoryId);
// //   //   });
// //   // }
// //
// //   void _removeCategory(String categoryId) async {
// //     try {
// //       await _categoryRepository.removeCategory(categoryId);
// //       setState(() {
// //         _categoriesFuture = _categoryRepository.getCategories();
// //       });
// //     } catch (e) {
// //       print('Error removing category: $e');
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Error removing category: $e')),
// //       );
// //     }
// //   }
// //
// //   Future<void> _addSubcategory(
// //     String categoryId,
// //     String name,
// //     String unit,
// //     double pricePerUnit,
// //   ) async {
// //     try {
// //       await _categoryRepository.addSubcategory(
// //           categoryId, name, unit, pricePerUnit);
// //       setState(() {
// //         _subcategoriesFutures[categoryId] =
// //             _categoryRepository.getSubcategories(categoryId);
// //       });
// //     } catch (e) {
// //       print('Error adding subcategory: $e');
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Error adding subcategory: $e')),
// //       );
// //     }
// //   }
// //
// //   void _addCategory(String name) async {
// //     try {
// //       await _categoryRepository.addCategory(name);
// //       setState(() {
// //         _categoriesFuture = _categoryRepository.getCategories();
// //       });
// //     } catch (e) {
// //       print('Error adding category: $e');
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Error adding category: $e')),
// //       );
// //     }
// //   }
// //
// //   void _showAddSubcategoryDialog(String categoryId) {
// //     final TextEditingController _subcategoryController =
// //     TextEditingController();
// //     final TextEditingController _unitsubcategoryController =
// //     TextEditingController();
// //     final TextEditingController _pricePerUnitsubcategoryController =
// //     TextEditingController();
// //
// //     showDialog(
// //         context: context,
// //         builder: (context) {
// //           return AlertDialog(
// //             title: Text('Add Subcategory'),
// //             content: SingleChildScrollView(
// //               child: Column(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   TextField(
// //                     controller: _subcategoryController,
// //                     decoration: InputDecoration(
// //                       labelText: 'اسم الصنف الفرعي',
// //                     ),
// //                   ),
// //                   TextField(
// //                     controller: _unitsubcategoryController,
// //                     decoration: InputDecoration(
// //                       labelText: 'الوحدة الصنف الفرعي',
// //                     ),
// //                   ),
// //                   TextField(
// //                     controller: _pricePerUnitsubcategoryController,
// //                     decoration: InputDecoration(
// //                       labelText: 'سعر الوحدة الصنف الفرعي',
// //                     ),
// //                     keyboardType: TextInputType.number,
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             actions: [
// //               TextButton(
// //                 onPressed: () {
// //                   Navigator.of(context).pop();
// //                 },
// //                 child: Text('Cancel'),
// //               ),
// //               TextButton(
// //                 onPressed: () {
// //                   // تأكد من التحقق من صحة الإدخالات
// //                   final priceText = _pricePerUnitsubcategoryController.text;
// //                   final price = double.tryParse(priceText);
// //
// //                   if (price == null || price <= 0) {
// //                     // إذا كان السعر غير صالح، اعرض رسالة خطأ
// //                     ScaffoldMessenger.of(context).showSnackBar(
// //                       SnackBar(content: Text('الرجاء إدخال سعر صالح.')),
// //                     );
// //                     return;
// //                   }
// //                   _addSubcategory(
// //                     categoryId,
// //                     _subcategoryController.text.trim(),
// //                     _unitsubcategoryController.text.trim(),
// //                     price,
// //                   );
// //                   Navigator.of(context).pop();
// //                 },
// //                 child: Text('Add'),
// //               ),
// //             ],
// //           );
// //         });
// //   }
// //
// //   void _showAddCategoryDialog() {
// //     final TextEditingController _categoryController = TextEditingController();
// //
// //     showDialog(
// //       context: context,
// //       builder: (context) {
// //         return AlertDialog(
// //           title: Text('اضافة صنف'),
// //           content: TextField(
// //             controller: _categoryController,
// //             decoration: InputDecoration(
// //               labelText: 'اسم الصنوف',
// //             ),
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () {
// //                 Navigator.of(context).pop();
// //               },
// //               child: Text('الغاء'),
// //             ),
// //             TextButton(
// //               onPressed: () {
// //                 _addCategory(_categoryController.text);
// //                 ScaffoldMessenger.of(context).showSnackBar(
// //                   SnackBar(content: Text('Sucsses add category')),
// //                 );
// //                 Navigator.of(context).pop();
// //               },
// //               child: Text('اضافة'),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// //
// //   void _removeSubcategory(String categoryId, String subcategoryId) async {
// //     try {
// //       await _categoryRepository.removeSubcategory(subcategoryId);
// //       setState(() {
// //         _subcategoriesFutures[categoryId] =
// //             _categoryRepository.getSubcategories(categoryId);
// //       });
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Subcategory removed successfully.')),
// //       );
// //     } catch (e) {
// //       print('Error removing subcategory: $e');
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Error removing subcategory: $e')),
// //       );
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Categories'),
// //         actions: [
// //           IconButton(
// //             icon: Icon(Icons.add),
// //             onPressed: _showAddCategoryDialog,
// //           ),
// //         ],
// //       ),
// //       body: FutureBuilder<List<Category>>(
// //         future: _categoriesFuture,
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return Center(child: CircularProgressIndicator());
// //           } else if (snapshot.hasError) {
// //             return Center(child: Text('Error: ${snapshot.error}'));
// //           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
// //             return Center(child: Text('No categories found.'));
// //           }
// //
// //           final categories = snapshot.data!;
// //           return ListView.builder(
// //             itemCount: categories.length,
// //             itemBuilder: (context, index) {
// //               final category = categories[index];
// //               return ExpansionTile(
// //                 title: Text(category.name),
// //                 children: [
// //                   FutureBuilder<List<Subcategory>>(
// //                     future: _subcategoriesFutures.putIfAbsent(
// //                       category.id,
// //                       () => _categoryRepository.getSubcategories(category.id),
// //                     ),
// //                     builder: (context, subcatSnapshot) {
// //                       if (subcatSnapshot.connectionState ==
// //                           ConnectionState.waiting) {
// //                         return Center(child: CircularProgressIndicator());
// //                       } else if (subcatSnapshot.hasError) {
// //                         return Center(
// //                             child: Text('Error: ${subcatSnapshot.error}'));
// //                       } else if (!subcatSnapshot.hasData ||
// //                           subcatSnapshot.data!.isEmpty) {
// //                         return Center(child: Text('No subcategories found.'));
// //                       }
// //
// //                       final subcategories = subcatSnapshot.data!;
// //                       return Column(
// //                         children: subcategories.map((subcat) {
// //                           return ListTile(
// //                             title: Row(
// //                               children: [
// //                                 Text(subcat.name,),
// //                                 Text(subcat.unit,),
// //                                 Text(subcat.pricePerUnit.toString(),),
// //                               ],
// //                             ),
// //                             trailing: IconButton(
// //                               onPressed: () =>
// //                                   _removeSubcategory(category.id, subcat.id),
// //                               icon: Icon(Icons.delete),
// //                             ),
// //                           );
// //                         }).toList(),
// //                       );
// //                     },
// //                   ),
// //                   ButtonBar(
// //                     children: [
// //                       IconButton(
// //                         icon: Icon(Icons.add),
// //                         onPressed: () => _showAddSubcategoryDialog(category.id),
// //                       ),
// //                       IconButton(
// //                         icon: Icon(Icons.delete),
// //                         onPressed: () => _removeCategory(category.id),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               );
// //             },
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
//
// import 'dart:ffi';
//
// import 'package:flutter/material.dart';
// import 'package:system/features/category/data/models/subCategory_model.dart';
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
//   Map<String, Future<List<Subcategory>>> _subcategoriesFutures = {};
//
//   @override
//   void initState() {
//     super.initState();
//     _categoriesFuture = _categoryRepository.getCategories();
//   }
//
//   void _removeCategory(String categoryId) async {
//     try {
//       await _categoryRepository.removeCategory(categoryId);
//       setState(() {
//         _categoriesFuture = _categoryRepository.getCategories();
//       });
//     } catch (e) {
//       print('Error removing category: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error removing category: $e')),
//       );
//     }
//   }
//
//   Future<void> _addSubcategory(
//       String categoryId,
//       String name,
//       String unit,
//       double pricePerUnit,
//       ) async {
//     try {
//       await _categoryRepository.addSubcategory(
//           categoryId, name, unit, pricePerUnit);
//       setState(() {
//         _subcategoriesFutures[categoryId] =
//             _categoryRepository.getSubcategories(categoryId);
//       });
//     } catch (e) {
//       print('Error adding subcategory: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error adding subcategory: $e')),
//       );
//     }
//   }
//
//   void _addCategory(String name) async {
//     try {
//       await _categoryRepository.addCategory(name);
//       setState(() {
//         _categoriesFuture = _categoryRepository.getCategories();
//       });
//     } catch (e) {
//       print('Error adding category: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error adding category: $e')),
//       );
//     }
//   }
//
//   void _showAddSubcategoryDialog(String categoryId) {
//     final TextEditingController _subcategoryController =
//     TextEditingController();
//     final TextEditingController _unitsubcategoryController =
//     TextEditingController();
//     final TextEditingController _pricePerUnitsubcategoryController =
//     TextEditingController();
//
//     showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text('Add Subcategory'),
//             content: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextField(
//                     controller: _subcategoryController,
//                     decoration: InputDecoration(
//                       labelText: 'اسم الصنف الفرعي',
//                     ),
//                   ),
//                   TextField(
//                     controller: _unitsubcategoryController,
//                     decoration: InputDecoration(
//                       labelText: 'الوحدة الصنف الفرعي',
//                     ),
//                   ),
//                   TextField(
//                     controller: _pricePerUnitsubcategoryController,
//                     decoration: InputDecoration(
//                       labelText: 'سعر الوحدة الصنف الفرعي',
//                     ),
//                     keyboardType: TextInputType.number,
//                   ),
//                 ],
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('Cancel'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   // تأكد من التحقق من صحة الإدخالات
//                   final priceText = _pricePerUnitsubcategoryController.text;
//                   final price = double.tryParse(priceText);
//
//                   if (price == null || price <= 0) {
//                     // إذا كان السعر غير صالح، اعرض رسالة خطأ
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('الرجاء إدخال سعر صالح.')),
//                     );
//                     return;
//                   }
//                   _addSubcategory(
//                     categoryId,
//                     _subcategoryController.text.trim(),
//                     _unitsubcategoryController.text.trim(),
//                     price,
//                   );
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('Add'),
//               ),
//             ],
//           );
//         });
//   }
//
//   void _showAddCategoryDialog() {
//     final TextEditingController _categoryController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('اضافة صنف'),
//           content: TextField(
//             controller: _categoryController,
//             decoration: InputDecoration(
//               labelText: 'اسم الصنوف',
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('الغاء'),
//             ),
//             TextButton(
//               onPressed: () {
//                 _addCategory(_categoryController.text);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Sucsses add category')),
//                 );
//                 Navigator.of(context).pop();
//               },
//               child: Text('اضافة'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _removeSubcategory(String categoryId, String subcategoryId) async {
//     try {
//       await _categoryRepository.removeSubcategory(subcategoryId);
//       setState(() {
//         _subcategoriesFutures[categoryId] =
//             _categoryRepository.getSubcategories(categoryId);
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Subcategory removed successfully.')),
//       );
//     } catch (e) {
//       print('Error removing subcategory: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error removing subcategory: $e')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Categories'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.add),
//             onPressed: _showAddCategoryDialog,
//           ),
//         ],
//       ),
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
//               return ExpansionTile(
//                 title: Text(category.name),
//                 children: [
//                   FutureBuilder<List<Subcategory>>(
//                     future: _subcategoriesFutures.putIfAbsent(
//                       category.id,
//                           () => _categoryRepository.getSubcategories(category.id),
//                     ),
//                     builder: (context, subcatSnapshot) {
//                       if (subcatSnapshot.connectionState ==
//                           ConnectionState.waiting) {
//                         return Center(child: CircularProgressIndicator());
//                       } else if (subcatSnapshot.hasError) {
//                         return Center(
//                             child: Text('Error: ${subcatSnapshot.error}'));
//                       } else if (!subcatSnapshot.hasData ||
//                           subcatSnapshot.data!.isEmpty) {
//                         return Center(child: Text('No subcategories found.'));
//                       }
//
//                       final subcategories = subcatSnapshot.data!;
//                       return Column(
//                         children: subcategories.map((subcat) {
//                           return ListTile(
//                             title: Row(
//                               children: [
//                                 Text(subcat.name),
//                                 Text(subcat.unit),
//                                 Text(subcat.pricePerUnit.toString()),
//                               ],
//                             ),
//                             trailing: IconButton(
//                               onPressed: () =>
//                                   _removeSubcategory(category.id, subcat.id),
//                               icon: Icon(Icons.delete),
//                             ),
//                           );
//                         }).toList(),
//                       );
//                     },
//                   ),
//                   ButtonBar(
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.add),
//                         onPressed: () => _showAddSubcategoryDialog(category.id),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.delete),
//                         onPressed: () => _removeCategory(category.id),
//                       ),
//                     ],
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//

// import 'package:flutter/material.dart';
// import 'package:system/features/category/data/models/subCategory_model.dart';
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
//   Map<String, Future<List<Subcategory>>> _subcategoriesFutures = {};
//
//   @override
//   void initState() {
//     super.initState();
//     _categoriesFuture = _categoryRepository.getCategories();
//   }
//
//   void _removeCategory(String categoryId)  {
//     try {
//        _categoryRepository.removeCategory(categoryId);
//       setState(() {
//         _categoriesFuture = _categoryRepository.getCategories();
//       });
//     } catch (e) {
//       print('Error removing category: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error removing category: $e')),
//       );
//     }
//   }
//
//   Future<void> _addSubcategory(
//       String categoryId,
//       String name,
//       String unit,
//       double pricePerUnit,
//       )  async {
//     try {
//        _categoryRepository.addSubcategory(
//           categoryId, name, unit, pricePerUnit);
//       setState(() {
//         _subcategoriesFutures[categoryId] =
//             _categoryRepository.getSubcategories(categoryId);
//       });
//     } catch (e) {
//       print('Error adding subcategory: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error adding subcategory: $e')),
//       );
//     }
//   }
//
//   void _addCategory(String name) async {
//     try {
//       await _categoryRepository.addCategory(name);
//       setState(() async{
//         _categoriesFuture = _categoryRepository.getCategories();
//       });
//     } catch (e) {
//       print('Error adding category: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error adding category: $e')),
//       );
//     }
//   }
//
//   void _showAddSubcategoryDialog(String categoryId) {
//     final TextEditingController _subcategoryController =
//     TextEditingController();
//     final TextEditingController _unitsubcategoryController =
//     TextEditingController();
//     final TextEditingController _pricePerUnitsubcategoryController =
//     TextEditingController();
//
//     showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text('Add Subcategory'),
//             content: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextField(
//                     controller: _subcategoryController,
//                     decoration: InputDecoration(
//                       labelText: 'اسم الصنف الفرعي',
//                     ),
//                   ),
//                   TextField(
//                     controller: _unitsubcategoryController,
//                     decoration: InputDecoration(
//                       labelText: 'الوحدة الصنف الفرعي',
//                     ),
//                   ),
//                   TextField(
//                     controller: _pricePerUnitsubcategoryController,
//                     decoration: InputDecoration(
//                       labelText: 'سعر الوحدة الصنف الفرعي',
//                     ),
//                     keyboardType: TextInputType.number,
//                   ),
//                 ],
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('Cancel'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   final priceText = _pricePerUnitsubcategoryController.text;
//                   final price = double.tryParse(priceText);
//
//                   if (price == null || price <= 0) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('الرجاء إدخال سعر صالح.')),
//                     );
//                     return;
//                   }
//                   _addSubcategory(
//                     categoryId,
//                     _subcategoryController.text.trim(),
//                     _unitsubcategoryController.text.trim(),
//                     price,
//                   );
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('Add'),
//               ),
//             ],
//           );
//         });
//   }
//
//   void _showAddCategoryDialog() {
//     final TextEditingController _categoryController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('اضافة صنف'),
//           content: TextField(
//             controller: _categoryController,
//             decoration: InputDecoration(
//               labelText: 'اسم الصنوف',
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('الغاء'),
//             ),
//             TextButton(
//               onPressed: () {
//                  _addCategory(_categoryController.text);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('تم إضافة الصنف بنجاح')),
//                 );
//                 Navigator.of(context).pop();
//               },
//               child: Text('اضافة'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _removeSubcategory(String categoryId, String subcategoryId) async {
//     try {
//       await _categoryRepository.removeSubcategory(subcategoryId);
//       setState(() {
//         _subcategoriesFutures[categoryId] =
//             _categoryRepository.getSubcategories(categoryId);
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('تم إزالة الصنف الفرعي بنجاح.')),
//       );
//     } catch (e) {
//       print('Error removing subcategory: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error removing subcategory: $e')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Categories'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.add),
//             onPressed: _showAddCategoryDialog,
//           ),
//         ],
//       ),
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
//               return ExpansionTile(
//                 title: Text(category.name),
//                 children: [
//                   FutureBuilder<List<Subcategory>>(
//                     future: _subcategoriesFutures.putIfAbsent(
//                       category.id,
//                           () => _categoryRepository.getSubcategories(category.id),
//                     ),
//                     builder: (context, subcatSnapshot) {
//                       if (subcatSnapshot.connectionState == ConnectionState.waiting) {
//                         return Center(child: CircularProgressIndicator());
//                       } else if (subcatSnapshot.hasError) {
//                         return Center(child: Text('Error: ${subcatSnapshot.error}'));
//                       } else if (!subcatSnapshot.hasData || subcatSnapshot.data!.isEmpty) {
//                         return Center(child: Text('No subcategories found.'));
//                       }
//
//                       final subcategories = subcatSnapshot.data!;
//                       return Column(
//                         children: subcategories.map((subcat) {
//                           return ListTile(
//                             title: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(subcat.name),
//                                 Text(subcat.unit),
//                                 Text(subcat.pricePerUnit.toString()),
//                               ],
//                             ),
//                             trailing: IconButton(
//                               onPressed: () =>
//                                   _removeSubcategory(category.id, subcat.id),
//                               icon: Icon(Icons.delete),
//                             ),
//                           );
//                         }).toList(),
//                       );
//                     },
//                   ),
//                   ButtonBar(
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.add),
//                         onPressed: () => _showAddSubcategoryDialog(category.id),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.delete),
//                         onPressed: () => _removeCategory(category.id),
//                       ),
//                     ],
//                   ),
//                 ],
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
