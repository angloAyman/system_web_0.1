
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


  Future<List<Bill>> getBillsFiltered({
    required String categoryName,
    String? subcategoryName,
    required DateTime startDate,
    required DateTime endDate,
  }) async
  {
    // Create query to filter by date range first
    final query = _client
        .from('bills')
        .select('*, bill_items(*)') // Include related bill items
        .eq('bill_items.category_name', categoryName)
        .eq('bill_items.subcategory_name', subcategoryName!)
        .gte('date', startDate) // Filter by start date
        .lte('date', endDate); // Filter by end date


    try {
      final response = await query;

      // Handle the case where the response is empty or null
      if (response == null || response.isEmpty) {
        throw Exception('No bills found for the given filters');
      }

      // Parse the response and convert to Bill objects
      final data = response as List;
      return data.map((json) => Bill.fromJson(json)).toList();
    } catch (error) {
      // Catch and log the error if query fails
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
  Future<void> addSubcategory(String categoryId, String name, String unit, double pricePerUnit,double discountPercentage) async {
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


  // // Fetch bills based on status
  // Future<List<Bill>> getBillsByStatus(String status) async {
  //   final response = await _client
  //       .from('bills')
  //       .select('*') // Fetch all fields
  //       .eq('status', status) // Filter by status
  //       ; // Ensure you call `.execute()` to get the response
  //
  //   // Debugging output
  //   print('Raw Response Data: ${response}');
  //
  //   // Check for errors
  //   if (response == null) {
  //     throw Exception('Error fetching bills: ${response}');
  //   }
  //
  //   // Extract the data
  //   final data = response;
  //
  //   if (data is List) {
  //     // Map the list of dynamic maps to a list of Bill objects
  //     return data.map((item) => Bill.fromMap(item as Map<String, dynamic>)).toList();
  //   } else {
  //     throw Exception('Unexpected response format: ${data.runtimeType}');
  //   }
  // }
  Future<List<Bill>> getBillsByStatus(String status) async {
    final response = await _client
        .from('bills')
        .select('*') // Fetch all fields
        .eq('status', status) // Filter by status
        ; // Make sure to call .execute() to get the response

    // Debugging output
    print('Raw Response Data: ${response}');

    // Check for errors
    if (response == null) {
      throw Exception('Error fetching bills: ${response}');
    }

    // Extract the data
    final data = response;

    if (data is List) {
      // Map the list of dynamic maps to a list of Bill objects
      return data.map((item) => Bill.fromMap(item as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Unexpected response format: ${data.runtimeType}');
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



}
