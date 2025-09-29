
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/category/data/models/subCategory_model.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final SupabaseClient _client = Supabase.instance.client;

  // دالة لاسترجاع تقرير العمليات المتعلقة بالصنف خلال مدة زمنية
  Future<List<Bill>> getCategoryOperationsReport(
      String categoryId, String? subcategoryId, DateTime startDate, DateTime endDate) async
  {
    final startIso = startDate.toIso8601String();
    final endIso = endDate.toIso8601String();

    final query = _client
        .from('bills')
        .select('*, bill_items(category_name, subcategory_name)') // Include the bill_items data
        .eq('category_name', categoryId) // Filter by category ID
        .gte('date', startIso) // Filter by start date
        .lte('date', endIso); // Filter by end date

    if (subcategoryId != null) {
      query.eq('bill_items.subcategory_name', subcategoryId); // If subcategory is selected, filter by it
    }

    final response = await query.order('date', ascending: true);

    if (response == null) {
      throw Exception('Failed to fetch category operations report');
    }

    final data = response as List;
    return data.map((json) => Bill.fromJson(json)).toList();
  }



  Future<Map<String, dynamic>> getBillsFiltered({
    required String categoryName,
    String? subcategoryName,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      // Fetch bills with related bill_items within the date range
      final response = await _client
          .from('bills')
          .select('*, bill_items(*)') // Join bill_items
          .gte('date', startDate) // Filter by start date
          .lte('date', endDate) // Filter by end date
          ; // Execute query

      if (response == null || response.isEmpty) {
        throw Exception('No bills found for the given filters');
      }

      // Parse the response into Bill objects
      List<Bill> bills = (response as List).map((json) => Bill.fromJson(json)).toList();

      // Initialize counters
      int totalCategoryUsage = 0;
      int totalSubcategoryUsage = 0;
      double totalSubcategoryPrice = 0.0;
      double totalcategoryPrice = 0.0;

      for (var bill in bills) {
        for (var item in bill.items) {
          if (item.categoryName == categoryName) {
            totalCategoryUsage++; // Count category usage
            totalcategoryPrice += item.total_Item_price ?? 0.0; // Sum subcategory price

          }
          if (subcategoryName != null && item.subcategoryName == subcategoryName) {
            totalSubcategoryUsage++; // Count subcategory usage
            totalSubcategoryPrice += item.total_Item_price ?? 0.0; // Sum subcategory price
          }
        }
      }

      return {
        'bills': bills,
        'totalCategoryUsage': totalCategoryUsage,
        'totalSubcategoryUsage': totalSubcategoryUsage,
        'totalSubcategoryPrice': totalSubcategoryPrice,
        'totalcategoryPrice': totalcategoryPrice,
      };
    } catch (error) {
      print('Error fetching filtered bills: $error');
      throw Exception('Failed to fetch filtered bills');
    }
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


  // Get list of categories
  Future<List<Category>> getCategories() async {
    final response = await _client.from('categories').select('*');

    if (response == null) {
      throw Exception('Failed to fetch categories: ${response}');
    }

    final data = response as List;
    return data.map((json) => Category.fromJson(json)).toList();
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
  Future<void> addSubcategory(String categoryId, String name, String unit, double pricePerUnit,String discountPercentage) async {
    final response = await _client.from('sub_categories').insert({
      'category_id': categoryId,
      'name': name,
      'unit': unit,
      'pricePerUnit': pricePerUnit,
      'discountPercentage': discountPercentage,
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



  Future<List<Bill>> getBillsByStatus(String status) async {
    try {
      // Start building the query
      final query = _client.from('bills').select('*, bill_items(*)');

      // Only apply status filter if not 'All'
      if (status != 'All') {
        query.eq('status', status);
      }

      // Add consistent ordering
      // query.order('created_at', ascending: false);

      final response = await query;

      // Debug output
      debugPrint('Bills response (status: $status): ${response.toString()}');

      // Handle null response
      if (response == null) {
        throw Exception('Null response received from server');
      }

      // Handle unexpected response format
      if (response is! List) {
        throw Exception('Expected List but got ${response.runtimeType}');
      }

      // Return empty list if no bills found
      if (response.isEmpty) {
        debugPrint('No bills found for status: $status');
        return [];
      }

      // Convert to Bill objects
      return response.map((json) => Bill.fromJson(json)).toList();

    } catch (e) {
      debugPrint('Error fetching bills by status: $e');
      throw Exception('Failed to load bills: ${e.toString()}');
    }
  }



  Future<Map<String, int>> getTotalBillsByStatus() async {
    try {
      final response = await _client
          .from('bills')  // Assuming the 'bills' table exists
          .select('status');  // Only select the 'status' column

      if (response == null) {
        throw Exception('Error fetching total bills by status: ${response}');
      }

      // Creating a map to store the count for each status
      Map<String, int> statusCounts = {
        'آجل': 0,
        'تم الدفع': 0,
        'فاتورة مفتوحة': 0,
      };

      // Looping through the fetched data and counting each status
      for (var bill in response) {
        String status = bill['status'];
        if (statusCounts.containsKey(status)) {
          statusCounts[status] = (statusCounts[status] ?? 0) + 1;
        }
      }

      return statusCounts; // Return the counts by status
    } catch (e) {
      throw Exception('Error fetching total bills by status: $e');
    }
  }


  // Method to fetch total number of bills
  Future<int> getTotalBills() async {
    try {
      final response = await  _client
          .from('bills')  // Assuming the 'bills' table exists
          .select('id')  // Selecting only the 'id' column to count rows
          .count();  // Count the rows in the 'bills' table

      if (response == null) {
        throw Exception('Error fetching total bills: ${response}');
      }

      // Return the total count of bills
      return response.count ?? 0;
    } catch (e) {
      throw Exception('Error fetching total bills: $e');
    }
  }



// Get category usage count within a specific date range
  Future<Map<String, int>> getCategoryUsageCountByDateRange(
      String categoryId, DateTime startDate, DateTime endDate) async
  {
    try {
      // Convert DateTime to ISO 8601 string (including time)
      final startIso = startDate.toIso8601String();
      final endIso = endDate.toIso8601String();

      final response = await _client
          .from('bill_items')
          .select('category_name, bills(date)')
          .eq('category_name', categoryId)
          .gte('bills.date', startIso) // Filter by start date (timestamp)
          .lte('bills.date', endIso)   // Filter by end date (timestamp)
          // .order('bills.date', ascending: false); // Simplified order
;
      print("getCategoryUsageCountByDateRange response: $response");

      if (response == null || response.isEmpty) {
        print("getCategoryUsageCountByDateRange response == null or empty");
        return {};  // Return empty map if no data found
      }

      // Group data by date and count usage
      Map<String, int> usageCountByDate = {};

      for (var item in response) {
        final date = item['bills']['date']; // e.g., "2024-12-12 09:24:32"
        final dateString = date.substring(0, 10); // Extract YYYY-MM-DD from the timestamp

        usageCountByDate[dateString] = (usageCountByDate[dateString] ?? 0) + 1;
      }

      return usageCountByDate;
    } catch (e) {
      print("$e");
      throw Exception('Error fetching category usage count by date range: $e');
    }
  }


  Future<void> updateCategory(String categoryId, String newName) async {
    await _client
        .from('categories')
        .update({'name': newName})
        .eq('id', categoryId);
  }

  Future<void> updateSubcategory(String categoryId, String subcategoryId, String newName, String newUnit, double newPrice, double newDiscount) async {
    await _client
        .from('sub_categories')
        .update({
      'name': newName,
      'unit': newUnit,
      'pricePerUnit': newPrice,
      'discountPercentage': newDiscount,
    })
        .eq('id', subcategoryId);
  }




}
