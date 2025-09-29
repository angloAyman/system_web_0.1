import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/customer/data/model/business_customer_model.dart';
import 'package:system/features/customer/data/model/normal_customer_model.dart';
import 'package:system/features/report/data/model/report_model.dart';

class BillRepository {
  final SupabaseClient _client = Supabase.instance.client;

// customer
  // Fetch all Normal customer names from the database
  Future<List<String>> getNormalCustomerNames() async {
    try {
      final response = await _client.from('normal_customers').select('name');
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
      final List<dynamic> data = response;
      return data.map((customer) => customer['name'] as String).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Add a new normal customer
  Future<void> addCustomer(normal_customers normal_customers) async {
    await _client.from('normal_customers').insert({
      'name': normal_customers.name,
      'email': normal_customers.email,
      'phone': normal_customers.phone,
      'phonecall': normal_customers.phonecall,
      'address': normal_customers.address,
    });
  }

  // Add a new business customer
  Future<void> addBusinessCustomer(
      business_customers business_customers) async {
    await _client.from('business_customers').insert({
      'name': business_customers.name,
      'personName': business_customers.personName,
      'email': business_customers.email,
      'phone': business_customers.phone,
      'personPhone': business_customers.personPhone,
      'personphonecall': business_customers.personphonecall,
      'address': business_customers.address,
      // 'discount': business_customers.discount,
    });
  }

// Vault
  // Fetch a list of vaults for the dropdown
  Future<List<Map<String, String>>> fetchVaultList() async {
    // final response = await _client.from('vaults').select('id, name');

    final response = await _client
        .from('vaults')
        .select('id,name,isActive')
        .eq('isActive', true); // ✅ شرط يجيب بس الـ Active


    return response.map((vault) {
      return {
        "id": vault['id'] as String,
        "name": vault['name'] as String,
      };
    }).toList();
  }

// bill
  // Add a new bill along with payment and report
  Future<void> addBill(Bill bill, Payment payment, Report report, Report preport,) async {
    try {
      // Insert bill into the 'bills' table
      final billResponse = await _client
          .from('bills')
          .insert({
            'user_id': bill.userId,
            'customer_name': bill.customerName,
            'date': bill.date.toString(),
            'status': bill.status,
            'payment': bill.payment.toInt(),
            'total_price': bill.total_price,
            'vault_id': bill.vault_id,
            'isFavorite': bill.isFavorite,
            'description': bill.description,
            'customer_type': bill.customer_type,
          })
          .select()
          .single();
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
          'total_Item_price': item.total_Item_price,
          'discountType': item.discountType,
        };
      }).toList();

      final itemResponse =await _client.from('bill_items').insert(items).select();

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
        'vault_id': payment.vault_id,
        'created_at': payment.createdAt.toIso8601String(),
      }).select();

      if (paymentResponse == null) {
        throw Exception('Failed to add payment record');
      }

      // Add bill report for this action
      final reportResponse = await _client.from('reports').insert({
        'title': 'اضافة فاتورة',
        'user_name': report.user_name,
        'date': report.date.toIso8601String(),
        'description':
            'رقم الفاتورة : $billId - اسم العميل : ${bill.customerName} - اجمالي الفاتورة : ${bill.total_price.toStringAsFixed(2)}',
      }).select();


      // Add payment report for this action
      final paymentreportResponse = await _client.from('reports').insert({
        'title': 'ايداع',
        'user_name': report.user_name,
        'date': report.date.toIso8601String(),
        'description':"فاتورة جديدة \n"
        // 'رقم الفاتورة : $billId - اسم العميل : ${bill.customerName} - اجمالي الفاتورة : ${bill.total_price.toStringAsFixed(2)}',
        'رقم الفاتورة : $billId - المبلغ المدفوع : ${payment.payment.toStringAsFixed(2)} - اجمالي الفاتورة : ${bill.total_price.toStringAsFixed(2)}',
      }).select();



      // 1. احصل على الرصيد الحالي للخزنة
      final currentBalance = await _client
          .from('vaults')
          .select('balance')
          .eq('id', bill.vault_id)
          .single()
          .then((response) => response['balance'] as int);

      // 2. احسب الرصيد الجديد
      final newBalance = currentBalance + payment.payment.toInt();

      // 3. قم بالتحديث
      await _client.from('vaults')
          .update({'balance': newBalance}).eq('id', bill.vault_id);

      if (reportResponse == null) {
        throw Exception('Failed to add bill report ($reportResponse)');
      }
      if (paymentreportResponse == null) {
        throw Exception('Failed to add paymeny report ($paymentreportResponse)');
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

  Future<List<Bill>> getBillsByStatus(String status) async {
    try {
      // Build the query with the same structure as getBills()
      final response = await _client
          .from('bills')
          .select('*, bill_items(*)')  // Same fields as getBills()
          .eq('status', status);       // Add status filter
          // .order('created_at', ascending: false) // Optional: add sorting

      // Debugging output - consistent with getBills()
      debugPrint('Bills by status ($status) response: ${response.toString()}');

      // Error handling - consistent with getBills()
      if (response == null) {
        throw Exception('Null response received from server');
      }

      // Response processing - matches getBills() structure
      if (response is List) {
        if (response.isEmpty) {
          debugPrint('No bills found with status: $status');
          return [];
        }
        return response.map((json) => Bill.fromJson(json)).toList(); // Using fromJson like getBills()
      } else {
        throw Exception('Unexpected response format: ${response.runtimeType}');
      }
    } catch (e) {
      debugPrint('Error in getBillsByStatus: $e');
      throw Exception('Failed to fetch bills by status: ${e.toString()}');
    }
  }


  // Update bill
  Future<void> updateBill(Bill updatedBill) async {
    try {
      // Update the bill in the 'bills' table
      final billResponse = await _client
          .from('bills')
          .update({
            'customer_name': updatedBill.customerName,
            'total_price': updatedBill.total_price,
            'status': updatedBill.status,
            'vault_id': updatedBill.vault_id,
          })
          .eq('id', updatedBill.id)
          .select()
          .single();

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
          'discount': item.discount,
          'total_Item_price': item.total_Item_price,
          'discountType': item.discountType,

        };
      }).toList();

      final itemResponse =
          await _client.from('bill_items').insert(newItems).select("*");
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
    String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.pdf';

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
    final response = await _client.from('bills').delete().eq('id', billId).select();

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
      final response =
          await Supabase.instance.client.from('reports').insert(report);

      if (response == null) {
        throw Exception('Failed to upload report: ${response.error!.message}');
      }

      debugPrint('Search report uploaded successfully');
    } catch (e) {
      debugPrint('Error uploading search report: $e');
    }
  }

  Future<void> addPayment({
    required int billId,
    required int amount,
    required String userId,
    required String paymentStatus,
    String? vaultId,
  }) async {
    await _client.from('payment').insert({
      'bill_id': billId,
      'date': DateTime.now().toIso8601String(),
      'user_id': userId,
      'payment': amount,
      'payment_status': paymentStatus,
      'vault_id': vaultId,
      'created_at': DateTime.now().toIso8601String(),
    }).select();
  }

  Future<void> updateVaultBalance(String vaultId, double amount) async {
    try {
      // 1. احصل على الرصيد الحالي للخزنة
      final currentBalance = await _client
          .from('vaults')
          .select('balance')
          .eq('id', vaultId)
          .single()
          .then((response) => response['balance']);

      // 2. احسب الرصيد الجديد
      final newBalance = currentBalance + amount;

      // 3. قم بالتحديث
      await _client.from('vaults')
          .update({'balance': newBalance}).eq('id', vaultId);
    } catch (e) {
      throw Exception('Failed to update vault balance: $e');
    }
  }

  Future<int> getTotalBillsCount() async {
    final response = await _client.from('bills').select('*, bill_items(*)');
    return response.length;
  }

  Future<int> getPaidBillsCount() async {
    final response = await _client
        .from('bills')
        .select('*, bill_items(*)')
        .eq('status', 'تم الدفع');
    return response.length;
  }

  Future<int> getDeferredBillsCount() async {
    final response = await _client
        .from('bills')
        .select('*, bill_items(*)')
        .eq('status', 'آجل');
    return response.length;
  }

  Future<int> getOpenBillsCount() async {
    final response = await _client
        .from('bills')
        .select('*, bill_items(*)')
        .eq('status', 'فاتورة مفتوحة');
    return response.length;
  }

// for user2
  // Fetch normal Costumer only bills
  Future<List<Bill>> getNormalCustomerBills() async {
    final response = await _client
        .from('bills')
        .select('*, bill_items(*)') // List the fields you want
        .eq('customer_type', 'عميل عادي');
    // .single() // Make sure to call .single() to get one result.

    if (response == null) {
      throw Exception('Failed to fetch bills');
    }
    final data = response as List;
    return data
        .map((json) => Bill.fromJson(json))
        .toList(); // Assuming you have a fromMap method
  }
  // __________________________________________________________________________________________________________/
  // // Update favorite status and description
  // Future<void> updateFavoriteStatusAndDescription({
  //   required int billId,
  //   required bool isFavorite,
  //   required String description,
  // }) async {
  //
  // }
  //
  //
  // Future<void> removeFromFavorites(Bill bill) async {
  //   final response = await _client
  //       .from('bills')
  //       .update({'isFavorite': false,'description':'تم التنفيذ'})
  //       .eq('id', bill.id)
  //   ;
  //   print("removeFromFavorites");
  //   print(response);
  //
  //   if (response == null) {
  //     throw Exception('Failed to remove favorite: ${response}');
  //   }
  // }

//for favoreit bill

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

  // ✅ تحديث حالة المفضلة والوصف
  Future<void> updateFavoriteStatusAndDescription({
    required int billId,
    required bool isFavorite,
    required String description,
  }) async {
      final response = await _client.from('bills').update({
        'isFavorite': isFavorite,
        'description': description,
      }).eq('id', billId);

      // if (response == null) {
      //   throw Exception('❌ فشل في التحديث: ${response}');
      // }

      print('✅ تم تحديث حالة المفضلة والوصف بنجاح');
  }

  // ✅ إزالة الفاتورة من المفضلة مع تحديث الوصف إلى "تم التنفيذ"
  Future<void> removeFromFavorites(Bill bill) async {

      final response = await _client.from('bills').update({
        'isFavorite': false,
        'description': 'تم التنفيذ',
      }).eq('id', bill.id);

      if (response == null) {
        throw Exception('❌ فشل في الإزالة: ${response}');
      }

      print("✅ تم إزالة الفاتورة من المفضلة بنجاح");

  }

  Future<void> updatedescriptionbybillid(Bill bill, String description) async {

    final response = await _client.from('bills').update({
      'description': description,
    }).eq('id', bill.id);

    print("✅ تم تحديث الوصف بنجاح");

  }

// _________________________________________________________________________________________
}
