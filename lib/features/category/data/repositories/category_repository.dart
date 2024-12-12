// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:system/features/category/data/models/subCategory_model.dart';
// import '../models/category_model.dart';
//
// class CategoryRepository {
//   final SupabaseClient _client = Supabase.instance.client;
//
//   Future<List<Category>> getCategories() async {
//     final response = await _client
//         .from('categories')
//         .select('*')
//         ;
//
//     if (response == null) {
//       throw Exception('Failed to fetch categories: ${response}');
//     }
//
//     final data = response as List;
//     return data.map((json) => Category.fromJson(json)).toList();
//   }
//
//   Future<void> addCategory(String name) async {
//     final response = await _client
//         .from('categories')
//         .insert({
//       'name': name,
//     });
//          if (response != null) {
//            throw Exception('Failed to add category: ${response.error!.message}');
//          }
//   }
//
//   Future<void> removeCategory(String categoryId) async {
//     final response = await _client
//         .from('categories')
//         .delete()
//         .eq('id', categoryId);
//
//
//     if (response != null) {
//       throw Exception('Failed to remove category: ${response.error!.message}');
//     }
//   }
//
//   Future<List<Subcategory>> getSubcategories(String categoryId) async {
//     final response = await _client
//         .from('sub_categories')
//         .select('*')
//         .eq('category_id', categoryId) ;
//
//
//     if (response == null) {
//       throw Exception('Failed to fetch subcategories: ${response}');
//     }
//
//     final data = response as List;
//     return data.map((json) => Subcategory.fromJson(json)).toList();
//   }
//
//   Future<void> addSubcategory(String categoryId, String name,String unit,double pricePerUnit,) async {
//     final response = await _client
//         .from('sub_categories')
//         .insert({
//       'category_id': categoryId,
//       'name': name,
//       'unit': unit,
//      'pricePerUnit': pricePerUnit,
//     }) ;
//
//      if (response != null) {
//        throw Exception('Failed to add subcategory: ${response.error!.message}');
//      }
//   }
//
//   Future<void> removeSubcategory(String subcategoryId) async {
//     final response = await _client
//         .from('sub_categories')
//         .delete()
//         .eq('id', subcategoryId);
//
//
//     if (response != null) {
//       throw Exception('Failed to remove subcategories: ${response.error!.message}');
//     }
//   }
//
//
// }

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/category/data/models/subCategory_model.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final SupabaseClient _client = Supabase.instance.client;

  // Get list of categories
  Future<List<Category>> getCategories() async {
    final response = await _client.from('categories').select('*');

    if (response == null) {
      throw Exception('Failed to fetch categories: ${response}');
    }

    final data = response as List;
    return data.map((json) => Category.fromJson(json)).toList();
  }

  // Add a new category
  Future<void> addCategory(String name) async {
    final response = await _client.from('categories').insert({
      'name': name,
      'created_at': DateTime.now().toIso8601String(),
    }) .select();

    if (response == null) {
      throw Exception('Failed to add category: ${response}');
    }
  }

  // Remove a category
  Future<void> removeCategory(String categoryId) async {
    final response = await _client
        .from('categories')
        .delete()
        .eq('id', categoryId).select();

    if (response == null) {
      throw Exception('Failed to remove category: ${response}');
    }
  }

  // Get subcategories of a specific category
  Future<List<Subcategory>> getSubcategories(String categoryId) async {
    final response = await _client
        .from('sub_categories')
        .select('*')
        .eq('category_id', categoryId);

    if (response== null) {
      throw Exception('Failed to fetch subcategories: ${response}');
    }

    final data = response as List;
    return data.map((json) => Subcategory.fromJson(json)).toList();
  }

  // Add a new subcategory
  Future<void> addSubcategory(String categoryId, String name, String unit, double pricePerUnit) async {
    final response = await _client.from('sub_categories').insert({
      'category_id': categoryId,
      'name': name,
      'unit': unit,
      'pricePerUnit': pricePerUnit,
    }).select();

    if (response == null) {
      throw Exception('Failed to add subcategory: ${response}');
    }

  }

  // Remove a subcategory
  Future<void> removeSubcategory(String subcategoryId) async {
    final response = await _client
        .from('sub_categories')
        .delete()
        .eq('id', subcategoryId).select();

    if (response == null) {
      throw Exception('Failed to remove subcategory: ${response}');
    }
  }

  // Fetch subcategory details (unit and price per unit) from Supabase
  Future<Subcategory> getSubcategoryDetails(int subcategoryId) async {
    final response = await _client
        .from('subcategory')
        .select()
        .eq('id', subcategoryId)
        .single()
    ;

    if (response == null) {
      throw Exception('Failed to fetch subcategory details: ${response}');
    }

    return Subcategory.fromJson(response);
  }

  // Get category usage count from bill_items (using UUID)
  Future<int> getCategoryUsageCount(String categoryId) async {
    try {
      // Fetch the category name using its ID
      final categoryResponse = await _client
          .from('categories')
          .select('name')
          .eq('id', categoryId)
          .single();

      if (categoryResponse == null) {
        throw Exception('Category not found for ID: $categoryId');
      }

      final categoryName = categoryResponse['name'];
      print("Querying usage count for category name: $categoryName");

      // Query the bill_items table using the category name
      final response = await _client
          .from('bill_items')
          .select('category_name')
          .eq('category_name', categoryName);

      if (response == null || response.isEmpty) {
        print("No records found for category: $categoryName");
        return 0; // Return 0 for no matches
      }

      final data = response as List;
      return data.length;
    } catch (error) {
      print("Error fetching category usage count: $error");
      throw Exception('Failed to fetch category usage count');
    }
  }

  // Get subcategory usage count from bill_items (using UUID)
  Future<int> getSubcategoryUsageCount(String subcategoryId) async {
    try {
      // Fetch the subcategory name using its ID
      final subcategoryResponse = await _client
          .from('sub_categories')
          .select('name')
          .eq('id', subcategoryId)
          .single();

      if (subcategoryResponse == null) {
        throw Exception('Subcategory not found for ID: $subcategoryId');
      }

      final subcategoryName = subcategoryResponse['name'];
      print("Querying usage count for subcategory name: $subcategoryName");

      // Query the bill_items table using the subcategory name
      final response = await _client
          .from('bill_items')
          .select('subcategory_name')
          .eq('subcategory_name', subcategoryName);

      if (response == null || response.isEmpty) {
        print("No records found for subcategory: $subcategoryName");
        return 0; // Return 0 for no matches
      }

      final data = response as List;
      return data.length;
    } catch (error) {
      print("Error fetching subcategory usage count: $error");
      throw Exception('Failed to fetch subcategory usage count');
    }
  }


}
