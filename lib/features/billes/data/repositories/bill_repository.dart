import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/Adminfeatures/billes/data/models/bill_model.dart';
import 'package:system/Adminfeatures/category/data/models/subCategory_model.dart';
import 'package:system/Adminfeatures/customer/data/model/business_customer_model.dart';
import 'package:system/Adminfeatures/customer/data/model/normal_customer_model.dart';
import 'package:system/Adminfeatures/report/data/model/report_model.dart';

import '../../../customer/data/model/customer_model.dart';

class BillRepository {
  final SupabaseClient _client = Supabase.instance.client;

// customer
  // Fetch all Normal customer names from the database
  Future<List<String>> getNormalCustomerNames() async {
    try {
      final response = await _client.from('normal_customers').select('name');
      if (response == null) {
        throw Exception('Error fetching customer names');
      }
      final List<dynamic> data = response;
      return data.map((customer) => customer['name'] as String).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Fetch all business customer names from the database
  Future<List<String>> getBusinessCustomerNames() async {
    try {
      final response = await _client.from('business_customers').select('name');
      if (response == null) {
        throw Exception('Error fetching customer names');
      }
      final List<dynamic> data = response;
      return data.map((customer) => customer['name'] as String).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Add a new normal customer
  Future<void> addCustomer(normal_customers customer) async {
    final response = await _client.from('customers').insert({
      'name': customer.name,
      'email': customer.email,
      'phone': customer.phone,
      'address': customer.address,
    }).select();

    if (response == null || response.isEmpty) {
      throw Exception('Failed to add customer');
    }
  }

  // Add a new business customer
  Future<void> addBusinessCustomer(business_customers customer) async {
    final response = await _client.from('business_customers').insert({
      'name': customer.name,
      'personName': customer.personName,
      'email': customer.email,
      'phone': customer.phone,
      'personPhone': customer.personPhone,
      'address': customer.address,
      'discount': customer.discount,
    }).select();

    if (response == null || response.isEmpty) {
      throw Exception('Failed to add business customer');
    }
  }

// Vault
  // Fetch a list of vaults for the dropdown
  Future<List<Map<String, String>>> fetchVaultList() async {
    final response = await _client.from('vaults').select('id, name');
    if (response is List) {
      return response.map((vault) {
        return {
          "id": vault['id'] as String,
          "name": vault['name'] as String,
        };
      }).toList();
    }
    return [];
  }

// bill
  // Add a new bill along with payment and report
  Future<void> addBill(Bill bill, Payment payment, Report report) async {
    try {
      // Insert bill into the 'bills' table
      final billResponse = await _client.from('bills').insert({
        'user_id': bill.userId,
        'customer_name': bill.customerName,
        'date': bill.date.toString(),
        'status': bill.status,
        'payment': bill.payment.toInt(),
        'total_price': bill.total_price,
        'vault_id': bill.vault_id,
        'isFavorite': bill.isFavorite,
        'description': bill.description,
      }).select().single();

      if (billResponse == null) {
        throw Exception('Failed to add bill to repository');
      }
      final billId = billResponse['id'];

      // Insert bill items into the 'bill_items' table
      final items = bill.items.map((item) {
        return {
          'bill_id': billId,
          'category_name': item.categoryName,
          'subcategory_name': item.subcategoryName,
          'amount': item.amount,
          'price_per_unit': item.price_per_unit,
          'quantity': item.quantity,
          'description': item.description,
          'discount': item.discount,
        };
      }).toList();

      final itemResponse = await _client.from('bill_items')
          .insert(items)
          .select();

      if (itemResponse == null) {
        throw Exception('Failed to add bill items to repository');
      }

      // Insert payment record into 'payment' table
      final paymentResponse = await _client.from('payment').insert({
        'bill_id': billId,
        'date': payment.date.toIso8601String(),
        'user_id': payment.userId,
        'payment': payment.payment.toInt(),
        'payment_status': payment.payment_status,
        'created_at': payment.createdAt.toIso8601String(),
      }).select();

      if (paymentResponse == null) {
        throw Exception('Failed to add payment record');
      }

      // Add report for this action
      final reportResponse = await _client.from('reports').insert({
        'title': 'اضافة فاتورة',
        'user_name': report.user_name,
        'date': report.date.toIso8601String(),
        'description': 'رقم الفاتورة : $billId - اسم العميل : ${bill
            .customerName} - اجمالي الفاتورة : ${bill.total_price
            .toStringAsFixed(2)}',
      }).select();

      if (reportResponse == null) {
        throw Exception('Failed to add report ($reportResponse)');
      }
    } catch (e) {
      print('Error adding bill: $e');
      rethrow;
    }
  }

  // Fetch all bills
  Future<List<Bill>> getBills() async {
    final response = await _client.from('bills').select('*, bill_items(*)');
    if (response == null) {
      throw Exception('Failed to fetch bills');
    }

    final data = response as List;
    return data.map((json) => Bill.fromJson(json)).toList();
  }

  // Fetch deferred bills
  Future<List<Bill>> getDeferredBills() async {
    final response = await _client
        .from('bills')
        .select('*, bill_items(*)').eq(
        'status', 'آجل');
    if (response == null || response.isEmpty) {
      throw Exception('Error fetching deferred bills');
    }

    final data = response as List;
    return data.map((json) => Bill.fromJson(json)).toList();
  }

  // Update bill
  Future<void> updateBill(Bill updatedBill) async {
    try {
      // Update the bill in the 'bills' table
      final billResponse = await _client.from('bills').update({
        'customer_name': updatedBill.customerName,
        'total_price': updatedBill.total_price,
        'status': updatedBill.status,
        'vault_id': updatedBill.vault_id,
      }).eq('id', updatedBill.id).select().single();

      if (billResponse == null) {
        throw Exception('Failed to update the bill');
      }

      // Remove old bill items
      await _client.from('bill_items').delete().eq('bill_id', updatedBill.id);

      // Insert new bill items
      final newItems = updatedBill.items.map((item) {
        return {
          'bill_id': updatedBill.id,
          'category_name': item.categoryName,
          'subcategory_name': item.subcategoryName,
          'amount': item.amount,
          'price_per_unit': item.price_per_unit,
          'quantity': item.quantity,
          'description': item.description,
          'discount':item.discount,
        };
      }).toList();

      final itemResponse = await _client.from('bill_items')
          .insert(newItems)
          .select("*");
      if (itemResponse == null) {
        throw Exception('Failed to update bill items');
      }

      print('Bill and items updated successfully');
    } catch (e) {
      print('Error updating bill: $e');
      rethrow;
    }
  }

  // Upload PDF to Supabase storage
  Future<String> uploadPdfToSupabase(Uint8List pdfBytes) async {
    final storage = _client.storage.from('pdfs');
    String fileName = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString() + '.pdf';

    try {
      final response = await storage.upload(fileName, pdfBytes as File);
      if (response == null) {
        throw Exception('Error uploading PDF');
      }
      String publicUrl = storage.getPublicUrl(fileName);
      return publicUrl;
    } catch (e) {
      throw 'Error uploading PDF: $e';
    }
  }

  // // Fetch bill by ID
  // Future<Bill> getBillById(int billId) async {
  //   final response = await _client.from('bills').select(
  //       '*, bill_items(*), customers(*)').eq('id', billId).single();
  //   if (response == null) {
  //     throw Exception('Bill not found');
  //   }
  //   return Bill.fromJson(response);
  // }

  Future<Bill> getBillById(int billId) async {
    final response = await Supabase.instance.client
        .from('bills')
        .select('*') // List the fields you want
        .eq('id', billId)
        .single(); // Make sure to call .single() to get one result.

    if (response == null) {
      throw Exception('Error fetching bill: ${response}');
    }
    print(response);
    return Bill.fromMap(response); // Assuming you have a fromMap method
  }



  //  Remove a bill
  Future<void> removeBill(int billId) async {
    final response = await _client.from('bills').delete()
        .eq('id', billId)
        .select();

    if (response == null) {
      throw Exception('Failed to remove bill');
    }
  }

  //uploadSearchReport
  Future<void> uploadSearchReport(String query) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id ?? 'unknown';

      final report = {
        'title': 'بحث بصفحة الفواتير',
        'user_name': userId, // Replace 'user.id' with the actual user ID
        'date': DateTime.now().toIso8601String(),
        'description': query,
      };

      // Assuming you have a Supabase client set up
      final response = await Supabase.instance.client
          .from('reports')
          .insert(report);

      if (response == null) {
        throw Exception('Failed to upload report: ${response.error!.message}');
      }

      debugPrint('Search report uploaded successfully');
    } catch (e) {
      debugPrint('Error uploading search report: $e');
    }
  }




  // Update favorite status and description
  Future<void> updateFavoriteStatusAndDescription({
    required int billId,
    required bool isFavorite,
    required String description,
  }) async {
    final response = await _client
        .from('bills')
        .update({
      'isFavorite': isFavorite, // Update the `isFavorite` column
      'description': description, // Update the `description` column
    })
        .eq('id', billId) // Identify the row to update
        ;

  }


  Future<void> removeFromFavorites(Bill bill) async {
    final response = await _client
        .from('bills')
        .update({'isFavorite': false,'description':'تم التنفيذ'})
        .eq('id', bill.id)
    ;
    print("removeFromFavorites");
    print(response);

    if (response == null) {
      throw Exception('Failed to remove favorite: ${response}');
    }
  }

  Future<List<Bill>> getFavoriteBills() async {
    final response = await _client
        .from('bills')
        .select('*, bill_items(*)')
        .eq('isFavorite', true);


    final data = response as List;


    return data.map((json) => Bill.fromJson(json)).toList();
  }

  Future<List<Bill>> getNotFavoriteBills() async {
    final response = await _client
        .from('bills')
        .select('*, bill_items(*)')
        .eq('isFavorite', false)
        .eq('description', 'تم التنفيذ');
    final data = response as List;
    return data.map((json) => Bill.fromJson(json)).toList();
  }





Future<int> getTotalBillsCount() async {
  final response = await _client.from('bills').select('*, bill_items(*)');
  return response.length;
}

Future<int> getPaidBillsCount() async {
  final response = await _client.from('bills').select('*, bill_items(*)').eq(
      'status', 'تم الدفع');
  return response.length;
}

Future<int> getDeferredBillsCount() async {
  final response = await _client.from('bills').select('*, bill_items(*)').eq(
      'status', 'آجل');
  return response.length;
}

Future<int> getOpenBillsCount() async {
  final response = await _client.from('bills').select('*, bill_items(*)').eq(
      'status', 'فاتورة مفتوحة');
  return response.length;
}}