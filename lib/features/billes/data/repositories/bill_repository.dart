// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:system/features/Vaults/data/models/vault_model.dart';
// import 'package:system/features/billes/data/models/reportbill_model.dart';
// import 'package:system/features/customer/data/model/customer_model.dart';
// import '../models/bill_model.dart';
//
// class BillRepository {
//   final SupabaseClient _client = Supabase.instance.client;
//
// // Check if a customer exists by name
//   Future<bool> checkCustomerExistence(String customerName) async {
//     final response = await _client
//         .from('customers')
//         .select('id')
//         .eq('name', customerName)
//         .single();
//
//     // If the response is not null, the customer exists
//     if (response != null) {
//       return true;
//     } else {
//       return false;
//     }
//   }
//
//   // Add a new customer
//   Future<void> addCustomer(Customer customer) async {
//     final response = await _client.from('customers').insert({
//       'name': customer.name,
//       'email': customer.email,
//       'phone': customer.phone,
//       'address': customer.address,
//     });
//
//     if (response == null) {
//       throw Exception('Failed to add customer');
//     }
//   }
//
//
//
//
//
//

//
//   // Fetch bills with users
//   Future<List<ReportbillBill>> getBills_with_users() async {
//     final response = await _client
//         .from('bills_with_users')
//         .select('bill_id, user_name, customer_name, date, bill_items (*)');
//
//     if (response == null) {
//       throw Exception('Failed to fetch bills with users');
//     }
//
//     final data = response as List;
//     return data.map((json) => ReportbillBill.fromJson(json)).toList();
//   }
//
//   // Add a new bill
//   // Future<void> createBill(Bill bill) async {
//   //   final response = await _client.from('bills').insert({
//   //     'user_id': bill.userId,
//   //     'customer_name': bill.customerName,
//   //     'date': bill.date,
//   //     'status': bill.status,
//   //     'payment': bill.payment,
//   //     'total_price': bill.total_price,
//   //     'vault_id': bill.vault_id,
//   //   }).select('id');
//   //
//   //   if (response == null) {
//   //     throw Exception('Failed to add bill repository');
//   //   }
//   //
//   //   final billId = response[0]['id'];
//   //
//   //   final items = bill.items
//   //       .map((item) => {
//   //     'bill_id': billId,
//   //     'category_name': item.categoryName,
//   //     'subcategory_name': item.subcategoryName,
//   //     'amount': item.amount,
//   //     'price_per_unit': item.price_per_unit,
//   //   })
//   //       .toList();
//   //
//   //   final itemResponse = await _client.from('bill_items').insert(items);
//   //
//   //   if (itemResponse != null) {
//   //     throw Exception('Failed to add bill items repositoy');
//   //   }
//   // }
//
//   Future<void> createBill(Bill bill) async {
//     try {
//       // Insert the bill into the `bills` table and retrieve the ID
//       final response = await _client.from('bills').insert({
//         'user_id': bill.userId,
//         'customer_name': bill.customerName,
//         'date': bill.date,
//         'status': bill.status,
//         'payment': bill.payment,
//         'total_price': bill.total_price,
//         'vault_id': bill.vault_id,
//       }).select('id').single();
//
//       if (response == null || response['id'] == null) {
//         throw Exception('Failed to add bill to the repository');
//       }
//
//       final billId = response['id'];
//
//       // Map the bill items to the required format
//       final items = bill.items.map((item) => {
//         'bill_id': billId,
//         'category_name': item.categoryName,
//         'subcategory_name': item.subcategoryName,
//         'amount': item.amount,
//         'price_per_unit': item.price_per_unit,
//       }).toList();
//
//       // Insert the bill items into the `bill_items` table
//       if (items.isNotEmpty) {
//         final itemResponse = await _client.from('bill_items').insert(items);
//         if (itemResponse == null) {
//           throw Exception('Failed to add bill items to the repository');
//         }
//       }
//     } catch (e) {
//       // Log the error for debugging purposes
//       print('Error in createBill: $e');
//       rethrow; // Rethrow the exception to allow the calling code to handle it
//     }
//   }
//
//
//   // Remove a bill
//   Future<void> removeBill(int billId) async {
//     final response = await _client.from('bills').delete().eq('id', billId);
//
//     if (response != null) {
//       throw Exception('Failed to remove bill');
//     }
//   }
//
//   // Fetch customer names
//   Future<List<String>> getCustomerNames() async {
//     final response = await _client.from('customers').select('name');
//
//     if (response == null) {
//       throw Exception('Failed to fetch customer names');
//     }
//
//     final data = response as List;
//     return data.map((e) => e['name'] as String).toList();
//   }
//
//
//
//   // Method to add a payment to a bill
//   Future<void> addPaymentRecord(Payment payment) async {
//     final response = await _client
//         .from('payment')
//         .insert([payment.toMap()]) ;
//
//     if (response.error != null) {
//       print('Failed to add payment record: ${response.error.message}'
//       );
//       throw Exception('Failed to add payment record: ${response.error.message}');
//     } print('Payment record added successfully');
//   }
//
//
//
//   // Method to fetch all payments for a specific bill
//   // Future<List<Payment>> getPaymentsForBill(int billId) async {
//   //   final response = await _client
//   //       .from('payments')
//   //       .select()
//   //       .eq('bill_id', billId);
//   //
//   //   if (response == null) {
//   //     throw Exception('Failed to fetch payments');
//   //   }
//   //
//   //   final data = response as List;
//   //   return data.map((json) => Payment.fromJson(json)).toList();
//   // }
//
//
//   // Get total cost of a bill
//   Future<double> getBillTotal(int billId) async {
//     final response = await _client
//         .from('bill_items')
//         .select('amount, price')
//         .eq('bill_id', billId);
//
//     if (response == null) {
//       throw Exception('Failed to fetch bill items for total calculation');
//     }
//
//     final List data = response;
//
//     // Safely calculate the total amount
//     return data.fold<double>(
//       0.0,
//           (sum, item) {
//         final amount = item['amount'] as num? ?? 0.0; // Handle null or missing values
//         final price = item['price'] as num? ?? 0.0; // Handle null or missing values
//         return sum + (amount * price);
//       },
//     );
//   }
//
//   // Fetch deferred bills from Supabase
//   Future<List<Bill>> getDeferredBills() async {
//     final response = await _client
//         .from('bills')
//         .select('*, bill_items(*)')
//         .eq('status', 'آجل')  // Filter by deferred status
//         ;
//
//     if (response == null) {
//       throw Exception('Error fetching deferred bills: ${response}');
//     }
//
//     final data = response as List;
//     return data.map((json) => Bill.fromJson(json)).toList();
//
//   }
//
//
//   Future<List<Map<String, String>>> fetchVaultList() async {
//     final response = await Supabase.instance.client.from('vaults').select('id, name');
//     if (response is List) {
//       return response.map((vault) {
//         return {
//           "id": vault['id'] as String,
//           "name": vault['name'] as String,
//         };
//       }).toList();
//     }
//     return [];
//   }
//
//
//
//
//   Future<void> addPaymentToVault({
//     required String vault_id,
//     required double paymentAmount,
//   }) async {
//     final supabase = Supabase.instance.client;
//
//     try {
//       // Fetch the current balance of the vault
//       final response = await supabase
//           .from('vaults')
//           .select('balance')
//           .eq('id', vault_id)
//           .single();
//
//       if (response == null || response['balance'] == null) {
//         throw Exception('Vault not found or balance is null');
//       }
//
//       final currentBalance = response['balance'] as double;
//
//       // Update the balance by adding the payment amount
//       final updatedBalance = currentBalance + paymentAmount;
//
//       final updateResponse = await supabase
//           .from('vaults')
//           .update({'balance': updatedBalance})
//           .eq('id', vault_id);
//
//       if (updateResponse == null) {
//         throw Exception('Failed to update vault balance');
//       }
//
//       print('Vault balance updated successfully to $updatedBalance');
//     } catch (e) {
//       print('Error updating vault balance: $e');
//     }
//   }
//
//
//
// //   Future<int> _fetchBillsCount({String? status}) async {
// //     final query = _client
// //         .from('bills')
// //         .select('*'); // Select all columns as a workaround
// //
// //     // Apply status filter if provided
// //     if (status != null) {
// //       query.eq('status', status);
// //     }
// //
// //     final response = await query;
// //
// //     if (response == null) {
// //       print('Failed to fetch bills count: ${response}');
// //       throw Exception('Failed to fetch bills count: ${response}');
// //     }
// //
// //     // Use the length of the response data
// //     return response.length;
// //   }
// //
// // // Fetch total bills count
// //   Future<int> getTotalBillsCount() async {
// //     return _fetchBillsCount();
// //   }
// //
// // // Fetch paid bills count
// //   Future<int> getPaidBillsCount() async {
// //     return _fetchBillsCount(status: 'تم الدفع');
// //   }
// //
// // // Fetch deferred bills count
// //   Future<int> getDeferredBillsCount() async {
// //     return _fetchBillsCount(status: 'آجل');
// //   }
// //
//
//   Future<int> _fetchBillsCount({String? status}) async {
//     // Fetch only `id` column to minimize data payload
//     final query = _client.from('bills').select('id',);
//
//     // Apply status filter if provided
//     if (status != null) {
//       query.eq('status', status);
//     }
//
//     final response = await query;
//
//     if (response == null) {
//       print('Failed to fetch bills count.');
//       throw Exception('Failed to fetch bills count.');
//     }
//
//     // Use the length of the fetched response
//     return response.length;
//   }
//
//   Future<int> getTotalBillsCount() async {
//     return _fetchBillsCount();
//   }
//
//   Future<int> getPaidBillsCount() async {
//     return _fetchBillsCount(status: 'تم الدفع');
//   }
//
//   Future<int> getDeferredBillsCount() async {
//     return _fetchBillsCount(status: 'آجل');
//   }
//
//
// }
//
//


import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/billes/data/models/bill_model.dart';

import '../../../customer/data/model/customer_model.dart';

class BillRepository {
  final SupabaseClient _client = Supabase.instance.client;


//Customer
  // Fetch all customer names from the database
  Future<List<String>> getCustomerNames() async {
    try {
      final response = await _client
          .from('customers')
          .select('name')
          ;

      if (response == null) {
        throw Exception('Error fetching customer names: ${response}');
      }

      final List<dynamic> data = response;
      return data.map((customer) => customer['name'] as String).toList();
    } catch (e) {
      rethrow;
    }
  }
  // Add a new customer
  Future<void> addCustomer(Customer customer) async {
    final response = await _client.from('customers').insert({
      'name': customer.name,
      'email': customer.email,
      'phone': customer.phone,
      'address': customer.address,
    });

    if (response == null) {
      throw Exception('Failed to add customer');
    }
  }


//vault
  // Fetch a list of vaults (e.g., for the dropdown)
  Future<List<Map<String, String>>> fetchVaultList() async {
    final response = await Supabase.instance.client.from('vaults').select('id, name');
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


//bill
  // Add a new bill
  // Future<void> addBill(Bill bill) async {
  //   final response = await _client.from('bills').insert({
  //     'user_id': bill.userId,
  //     'customer_name': bill.customerName,
  //     'date': bill.date,
  //     'status': bill.status,
  //     'payment': bill.payment,
  //     'total_price': bill.total_price,
  //     'vault_id': bill.vault_id,
  //   }).select('id');
  //   print("addBill $response");
  //   if (response == null) {
  //     throw Exception('Failed to add bill repository');
  //   }
  //
  //   final billId = response[0]['id'];
  //
  //   final items = bill.items
  //       .map((item) => {
  //     'bill_id': billId,
  //     'category_name': item.categoryName,
  //     'subcategory_name': item.subcategoryName,
  //     'amount': item.amount,
  //     'price_per_unit': item.price_per_unit,
  //   })
  //       .toList();
  //
  //   final itemResponse = await _client.from('bill_items').insert(items);
  //
  //   if (itemResponse != null) {
  //     throw Exception('Failed to add bill items repositoy');
  //   }
  //   print("itemResponse : $itemResponse");
  //
  // }

  Future<void> addBill(Bill bill, Payment payment) async {
    try {
      // 1. إضافة الفاتورة إلى جدول bills
      final billResponse = await _client.from('bills').insert({
        'user_id': bill.userId,
        'customer_name': bill.customerName,
        'date': bill.date,
        'status': bill.status,
        'payment': bill.payment.toInt(),
        'total_price': bill.total_price,
        'vault_id': bill.vault_id,
      }).select('id').single();

      if (billResponse == null) {
        throw Exception('Failed to add bill to repository');
      }

      // استرجاع معرف الفاتورة التي تم إنشاؤها
      final billId = billResponse['id'];
       print("bill reposotory : $billResponse ");
      // 2. إضافة عناصر الفاتورة إلى جدول bill_items
      final items = bill.items.map((item) {
        return {
          'bill_id': billId,
          'category_name': item.categoryName,
          'subcategory_name': item.subcategoryName,
          'amount': item.amount,
          'price_per_unit': item.price_per_unit,
        };
      }).toList();

      final itemResponse = await _client.from('bill_items').insert(items).select();

      if (itemResponse == null) {
        throw Exception('Failed to add bill items to repository');
      }
      print("itemResponse  : $itemResponse ");

      // 3. إنشاء سجل الدفع في جدول payment
      final paymentResponse = await _client.from('payment').insert({
        'bill_id': billId, // استخدم معرف الفاتورة التي تم إنشاؤها
        'date': payment.date.toIso8601String(),
        'user_id': payment.userId,
        'payment': payment.payment.toInt(),
        'payment_status': payment.payment_status,
        'created_at': payment.createdAt.toIso8601String(),
      }).select();
      print("paymentResponse  : $paymentResponse ");

      if (paymentResponse == null) {
        throw Exception('Failed to add payment record": $paymentResponse ');
      }
    } catch (e) {
      print("error Response payment  : $e ");

      // إعادة رمي الاستثناء إذا حدث أي خطأ
      rethrow;
    }
  }

  //  Remove a bill
  Future<void> removeBill(int billId) async {
    final response = await _client.from('bills').delete().eq('id', billId);

    if (response != null) {
      throw Exception('Failed to remove bill');
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
  // Fetch deferred bills from Supabase
  Future<List<Bill>> getDeferredBills() async {
    final response = await _client
        .from('bills')
        .select('*, bill_items(*)')
        .eq('status', 'آجل')  // Filter by deferred status
        ;

    if (response == null) {
      throw Exception('Error fetching deferred bills: ${response}');
    }

    final data = response as List;
    return data.map((json) => Bill.fromJson(json)).toList();

  }

//payment
  // Add a payment record
//   Future<void> addPaymentRecord(Payment payment) async {
//     try {
//       final response = await _client.from('payment').insert({
//         'bill_id': payment.billId,
//         'date': payment.date.toIso8601String(),
//         'user_id': payment.userId,
//         'payment': payment.payment,
//         'payment_status': payment.payment_status,
//         'created_at': payment.createdAt.toIso8601String(),
//       });
// print("addPaymentRecord : $response");
//       if (response == null) {
//         print("null addPaymentRecord : $response");
//
//         throw Exception(' reposotory Error adding payment: ${response.error!.message}');
//       }
//     } catch (e) {
//       print("null addPaymentRecord : $e");
//
//       rethrow;
//     }
//   }


  // Add a payment to the vault
  // Future<void> addPaymentToVault({required String vaultId, required double paymentAmount}) async {
  //   try {
  //     final response = await _client
  //         .from('vaults')
  //         .update({
  //       'balance': SupabaseClient('balance + ?', [paymentAmount] as String )
  //     })
  //         .eq('id', vaultId)
  //     ;
  //
  //     if (response.error != null) {
  //       throw Exception('Error updating vault balance: ${response.error!.message}');
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }





    Future<int> _fetchBillsCount({String? status}) async {
    // Fetch only `id` column to minimize data payload
    final query = _client.from('bills').select('id',);

    // Apply status filter if provided
    if (status != null) {
      query.eq('status', status);
    }

    final response = await query;

    if (response == null) {
      print('Failed to fetch bills count.');
      throw Exception('Failed to fetch bills count.');
    }

    // Use the length of the fetched response
    return response.length;
  }

  Future<int> getTotalBillsCount() async {
    return _fetchBillsCount();
  }

  Future<int> getPaidBillsCount() async {
    return _fetchBillsCount(status: 'تم الدفع');
  }

  Future<int> getDeferredBillsCount() async {
    return _fetchBillsCount(status: 'آجل');
  }







}

// // Bill class
// class Bill {
//   final int id;
//   final String userId;
//   final String customerName;
//   final String date;
//   final String status;
//   final double totalPrice;
//   final double payment;
//   final List<BillItem> items;
//   final String vaultId;
//
//   Bill({
//     required this.id,
//     required this.userId,
//     required this.customerName,
//     required this.date,
//     required this.status,
//     required this.totalPrice,
//     required this.payment,
//     required this.items,
//     required this.vaultId,
//   });
// }
//
// // BillItem class
// class BillItem {
//   final String categoryName;
//   final String subcategoryName;
//   final int amount;
//   final double pricePerUnit;
//
//   BillItem({
//     required this.categoryName,
//     required this.subcategoryName,
//     required this.amount,
//     required this.pricePerUnit,
//   });
// }
//
// // Payment class
// class Payment {
//   final String userId;
//   final String billId;
//   final DateTime date;
//   final double paymentAmount;
//   final String status;
//   final DateTime createdAt;
//
//   Payment({
//     required this.userId,
//     required this.billId,
//     required this.date,
//     required this.paymentAmount,
//     required this.status,
//     required this.createdAt,
//   });
// }
