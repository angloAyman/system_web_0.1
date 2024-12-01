import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/category/data/models/subCategory_model.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Category>> getCategories() async {
    final response = await _client
        .from('categories')
        .select('*')
        ;

    if (response == null) {
      throw Exception('Failed to fetch categories: ${response}');
    }

    final data = response as List;
    return data.map((json) => Category.fromJson(json)).toList();
  }

  Future<void> addCategory(String name) async {
    final response = await _client
        .from('categories')
        .insert({
      'name': name,
    });
         if (response != null) {
           throw Exception('Failed to add category: ${response.error!.message}');
         }
  }

  Future<void> removeCategory(String categoryId) async {
    final response = await _client
        .from('categories')
        .delete()
        .eq('id', categoryId);


    if (response != null) {
      throw Exception('Failed to remove category: ${response.error!.message}');
    }
  }

  Future<List<Subcategory>> getSubcategories(String categoryId) async {
    final response = await _client
        .from('sub_categories')
        .select('*')
        .eq('category_id', categoryId) ;


    if (response == null) {
      throw Exception('Failed to fetch subcategories: ${response}');
    }

    final data = response as List;
    return data.map((json) => Subcategory.fromJson(json)).toList();
  }

  Future<void> addSubcategory(String categoryId, String name) async {
    final response = await _client
        .from('sub_categories')
        .insert({
      'category_id': categoryId,
      'name': name,
    }) ;

     if (response != null) {
       throw Exception('Failed to add subcategory: ${response.error!.message}');
     }
  }

  Future<void> removeSubcategory(String subcategoryId) async {
    final response = await _client
        .from('sub_categories')
        .delete()
        .eq('id', subcategoryId);


    if (response != null) {
      throw Exception('Failed to remove subcategories: ${response.error!.message}');
    }
  }


}
