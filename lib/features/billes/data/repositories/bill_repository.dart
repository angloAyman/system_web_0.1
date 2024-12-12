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


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/category/data/models/subCategory_model.dart';
import 'package:system/features/customer/data/model/business_customer_model.dart';
import 'package:system/features/customer/data/model/normal_customer_model.dart';
import 'package:system/features/report/data/model/report_model.dart';
//
import '../../../customer/data/model/customer_model.dart';
//
// class BillRepository {
//   final SupabaseClient _client = Supabase.instance.client;
//
//
// //Customer
//   // Fetch all Normalcustomer names from the database
//   Future<List<String>> getNormalCustomerNames() async {
//     try {
//       final response = await _client
//           .from('normal_customers')
//           .select('name')
//           ;
//
//       if (response == null) {
//         throw Exception('Error fetching customer names: ${response}');
//       }
//
//       final List<dynamic> data = response;
//       return data.map((normal_customers) => normal_customers['name'] as String).toList();
//     } catch (e) {
//       rethrow;
//     }
//   }
//   // Fetch all businesscustomer names from the database
//   Future<List<String>> getbusinessCustomerNames() async {
//     try {
//       final response = await _client
//           .from('business_customers')
//           .select('name')
//       ;
//
//       if (response == null) {
//         throw Exception('Error fetching customer names: ${response}');
//       }
//
//       final List<dynamic> data = response;
//       return data.map((business_customers) => business_customers['name'] as String).toList();
//     } catch (e) {
//       rethrow;
//     }
//   }
//   // Add a new customer
//   Future<void> addCustomer(normal_customers normal_customers) async {
//     final response = await _client.from('customers').insert({
//       'name': normal_customers.name,
//       'email': normal_customers.email,
//       'phone': normal_customers.phone,
//       'address': normal_customers.address,
//     });
//
//     if (response == null) {
//       throw Exception('Failed to add customer');
//     }
//   }
//
//   Future<void> addBusinessCustomer(business_customers business_customers) async {
//     final response = await _client.from('business_customers').insert({
//       'name': business_customers.name,
//       'personName': business_customers.personName,
//       'email': business_customers.email,
//       'phone': business_customers.phone,
//       'personPhone': business_customers.personPhone,
//       'address': business_customers.address,
//       'discount': business_customers.discount,
//     });
//
//     if (response == null) {
//       throw Exception('Failed to add customer');
//     }
//   }
//
//
//
// //vault
//   // Fetch a list of vaults (e.g., for the dropdown)
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
// //bill
//   //
//     Future<void> addBill(Bill bill, Payment payment,Report report) async {
//     try {
//       // 1. إضافة الفاتورة إلى جدول bills
//       final billResponse = await _client.from('bills').insert({
//         'user_id': bill.userId,
//         'customer_name': bill.customerName,
//         'date': bill.date,
//         'status': bill.status,
//         'payment': bill.payment.toInt(),
//         'total_price': bill.total_price,
//         'vault_id': bill.vault_id,
//       }).select('id').single();
//
//       if (billResponse == null) {
//         throw Exception('Failed to add bill to repository');
//       }
//
//       // استرجاع معرف الفاتورة التي تم إنشاؤها
//       final billId = billResponse['id'];
//        print("bill reposotory : $billResponse ");
//       // 2. إضافة عناصر الفاتورة إلى جدول bill_items
//       final items = bill.items.map((item) {
//         return {
//           'bill_id': billId,
//           'category_name': item.categoryName,
//           'subcategory_name': item.subcategoryName,
//           'amount': item.amount,
//           'price_per_unit': item.price_per_unit,
//           'quantity': item.quantity,
//           'description': item.description,  // إضافة الوصف
//         };
//       }).toList();
//
//       final itemResponse = await _client.from('bill_items').insert(items).select();
//
//       if (itemResponse == null) {
//         throw Exception('Failed to add bill items to repository');
//       }
//       print("itemResponse  : $itemResponse ");
//
//       // 3. إنشاء سجل الدفع في جدول payment
//       final paymentResponse = await _client.from('payment').insert({
//         'bill_id': billId, // استخدم معرف الفاتورة التي تم إنشاؤها
//         'date': payment.date.toIso8601String(),
//         'user_id': payment.userId,
//         'payment': payment.payment.toInt(),
//         'payment_status': payment.payment_status,
//         'created_at': payment.createdAt.toIso8601String(),
//       }).select();
//       print("paymentResponse  : $paymentResponse ");
//
//       if (paymentResponse == null) {
//         throw Exception('Failed to add payment record": $paymentResponse ');
//       }
//      // 4. add report
//         try {
//           final reportResponse =  await _client.from('reports').insert({
//             'title': "اضافة فاتورة",
//             'user_name': report.user_name,
//             'date': report.date.toIso8601String(),
//             "description": 'رقم الفاتورة : $billId - اسم العميل : ${bill.customerName} - اجمالي الفاتورة : ${bill.total_price.toStringAsFixed(2)}',
//
//             // 'description': report.description,
//             // '$customerName - $billId - $totalPrice',
//           });
//
//           // Check for errors in the response
//
//           // If insertion is successful, you can log or handle the success
//           print('Report added successfully!');
//         } catch (e) {
//           // Catch any other errors (e.g., network or database issues)
//           print('Error adding report: $e');
//           rethrow;  // Optionally rethrow the error to handle it higher up the stack
//         }
//       }
//
//      catch (e) {
//       print("error Response payment  : $e ");
//
//       // إعادة رمي الاستثناء إذا حدث أي خطأ
//       rethrow;
//     }
//   }
//   //  Remove a bill
//     Future<void> removeBill(int billId) async {
//     final response = await _client.from('bills').delete().eq('id', billId);
//     if (response != null) {
//       throw Exception('Failed to remove bill');
//     }
//   }
//   // Fetch all bills
//   Future<List<Bill>> getBills() async {
//     final response = await _client.from('bills').select('*, bill_items(*)');
//
//     if (response == null) {
//       throw Exception('Failed to fetch bills');
//     }
//
//   final data = response as List;
//   return data.map((json) => Bill.fromJson(json)).toList();
// }
// // Fetch deferred bills from Supabase
// Future<List<Bill>> getDeferredBills() async {
//   final response = await _client
//       .from('bills')
//       .select('*, bill_items(*)')
//       .eq('status', 'آجل')  // Filter by deferred status
//       ;
//
//   if (response == null) {
//     throw Exception('Error fetching deferred bills: ${response}');
//   }
//
//   final data = response as List;
//   return data.map((json) => Bill.fromJson(json)).toList();
//
// }
// //  updateBill a bill
//   Future<void> updateBill(Bill updatedBill)  async {
//       // Step 1: Update the Bill Table
//       final billResponse =  Supabase.instance.client
//           .from('bills')
//           .update({
//         'customer_name': updatedBill.customerName,
//         'total_price': updatedBill.vault_id,
//         'status': updatedBill.status, // Add other fields as needed
//         'vault_id': updatedBill.vault_id,
//       })
//           .eq('id', updatedBill.id)  // Ensure you're updating the correct bill by its ID
//      . select("*"); // Make sure you're getting a single record back
//
//
//       if (billResponse == null ) {
//         throw Exception('Failed to update the bill');
//       }
//       print("Bill updated successfully: $billResponse");
//
//       // Step 2: Remove old Bill Items
//        Supabase.instance.client
//           .from('bill_items')
//           .delete()
//           .eq('bill_id', updatedBill.id).single();  // Remove old items associated with the bill
//
//       // Step 3: Insert New Bill Items
//       final newItems = updatedBill.items.map((item) {
//         return {
//           'bill_id': updatedBill.id,
//           'category_name': item.categoryName,
//           'subcategory_name': item.subcategoryName,
//           'amount': item.amount,
//           'price_per_unit': item.price_per_unit,
//           'quantity': item.quantity,
//           'description': item.description,  // Include description if needed
//         };
//       }).toList();
//
//       final itemResponse =  Supabase.instance.client
//           .from('bill_items')
//           .insert(newItems).select("*")
//           ;
//
//       if (itemResponse == null) {
//         throw Exception('Failed to update bill items');
//       }
//       print("Bill items updated successfully: $itemResponse");
//
//       // // Step 4: Update the Payment (Optional, if payment is modified)
//       // if (updatedBill.payment != null) {
//       //   final paymentResponse = await Supabase.instance.client
//       //       .from('payment')
//       //       .update({
//       //     'payment': updatedBill.payment.toInt(),
//       //     // 'payment_status': updatedBill.payment_status,
//       //     // 'date': updatedBill.payment_date.toIso8601String(),  // Update the payment details
//       //   })
//       //       .eq('bill_id', updatedBill.id)  // Ensure you are updating the correct payment record
//       //       .select();
//       //
//       //   if (paymentResponse == null) {
//       //     throw Exception('Failed to update payment');
//       //   }
//       //   print("Payment updated successfully: $paymentResponse");
//       // }
//
//     //   // Step 5: Optionally update related tables like reports if necessary
//     //   if (updatedBill == null) {
//     //     final reportResponse = await Supabase.instance.client
//     //         .from('reports')
//     //         .insert({
//     //       'title': "Bill Update",
//     //       'user_name': updatedBill.report.user_name,
//     //       'date': updatedBill.report.date.toIso8601String(),
//     //       'description': 'Updated bill ${updatedBill.id} - Customer: ${updatedBill.customerName}',
//     //     });
//     //
//     //     if (reportResponse == null) {
//     //       throw Exception('Failed to log report');
//     //     }
//     //     print("Report logged successfully: $reportResponse");
//     //   }
//     // } catch (e) {
//     //   print("Error updating bill: $e");
//     //   rethrow;  // Optionally rethrow the error to handle it higher up
//     // }
//   }
//   //uploadSearchReport
//   Future<void> uploadSearchReport(String query) async {
//     try {
//       final userId = Supabase.instance.client.auth.currentUser?.id ?? 'unknown';
//
//       final report = {
//         'title': 'بحث بصفحة الفواتير',
//         'user_name': userId, // Replace 'user.id' with the actual user ID
//         'date': DateTime.now().toIso8601String(),
//         'description': query,
//       };
//
//       // Assuming you have a Supabase client set up
//       final response = await Supabase.instance.client
//           .from('reports')
//           .insert(report);
//
//       if (response == null) {
//         throw Exception('Failed to upload report: ${response.error!.message}');
//       }
//
//       debugPrint('Search report uploaded successfully');
//     } catch (e) {
//       debugPrint('Error uploading search report: $e');
//     }
//   }
// // Update bill item in the database
// //   Future<void> updateBillItem(int billItemId, BillItem updatedItem) async {
// //     final response = await Supabase.instance.client
// //         .from('bill_items')
// //         .update({
// //       "amount": updatedItem.amount,
// //       "price_per_unit": updatedItem.price_per_unit,
// //       "quantity": updatedItem.quantity,
// //       "description": updatedItem.description,
// //     })
// //         .eq('id', billItemId)
// //         .select(); // Use select to fetch updated data
// //     // Use execute to get the response object
// //
// //     if (response == null) {
// //       throw Exception('Failed to update bill item: ${response}');
// //     }
// //
// //     if (response == null || response.isEmpty) {
// //       throw Exception('No data returned while updating bill item');
// //     }
// //
// //     print('Update successful: ${response}');
// //   }
//
//
//   // Future<void> addReport({
//   //   required String title,
//   //   required String user_name,
//   //   // required String customerName,
//   //   required DateTime date,
//   //   required String description,
//   // }) async {
//   //   try {
//   //     final response = await _client.from('reports').insert({
//   //       'title': title,
//   //       'user_name': user_name,  // Ensure this matches the column name in the 'reports' table
//   //       'date': date.toIso8601String(),
//   //       'description': description,
//   //       // '$customerName - $billId - $totalPrice',
//   //     });
//   //
//   //     // Check for errors in the response
//   //     if (response.error != null) {
//   //       throw Exception('Failed to add report: ${response.error!.message}');
//   //     }
//   //
//   //     // If insertion is successful, you can log or handle the success
//   //     print('Report added successfully!');
//   //   } catch (e) {
//   //     // Catch any other errors (e.g., network or database issues)
//   //     print('Error adding report: $e');
//   //     rethrow;  // Optionally rethrow the error to handle it higher up the stack
//   //   }
//   // }
//   Future<Bill> getBillById(int billId) async {
//     final response = await Supabase.instance.client
//         .from('bills')
//         .select('*, bill_items(*), customers(*)') // Join with items and customer details
//         .eq('id', billId)
//         .single();
//
//     if (response == null) {
//       throw Exception('Error fetching bill: ${response}');
//     }
//
//     return Bill.fromJson(response);
//   }
//
//
//
//   Future<Bill?> getBillWithPayment(int billId) async {
//     try {
//       final response = await _client
//           .from('bills')
//           .select('*, items(*), payment(*)') // Include payment table
//           .eq('id', billId)
//           .single();
//
//       if (response == null) {
//         return Bill.fromJson(response);
//       }
//     } catch (e) {
//       print('Error fetching bill with payment: $e');
//     }
//     return null;
//   }
//
//
//   Future<String> uploadPdfToSupabase(Uint8List pdfBytes) async {
//     // Get a reference to the Supabase storage bucket
//     final storage = Supabase.instance.client.storage.from(
//         'pdfs'); // Assuming you have a "pdfs" bucket
//
//     // Generate a unique file name
//     String fileName = DateTime
//         .now()
//         .millisecondsSinceEpoch
//         .toString() + '.pdf';
//
//     // Upload the file to Supabase Storage
//     try {
//       final response = await storage.upload(fileName, pdfBytes as File);
//       if (response == null) {
//         throw 'Error uploading PDF: ${response}';
//       }
//
//       // Get the public URL of the uploaded file
//       String publicUrl = storage.getPublicUrl(fileName);
//       return publicUrl;
//     } catch (e) {
//       throw 'Error uploading PDF: $e';
//     }
//   }
// //payment
//   // Add a payment record
// //   Future<void> addPaymentRecord(Payment payment) async {
// //     try {
// //       final response = await _client.from('payment').insert({
// //         'bill_id': payment.billId,
// //         'date': payment.date.toIso8601String(),
// //         'user_id': payment.userId,
// //         'payment': payment.payment,
// //         'payment_status': payment.payment_status,
// //         'created_at': payment.createdAt.toIso8601String(),
// //       });
// // print("addPaymentRecord : $response");
// //       if (response == null) {
// //         print("null addPaymentRecord : $response");
// //
// //         throw Exception(' reposotory Error adding payment: ${response.error!.message}');
// //       }
// //     } catch (e) {
// //       print("null addPaymentRecord : $e");
// //
// //       rethrow;
// //     }
// //   }
//
//
//   // Add a payment to the vault
//   // Future<void> addPaymentToVault({required String vaultId, required double paymentAmount}) async {
//   //   try {
//   //     final response = await _client
//   //         .from('vaults')
//   //         .update({
//   //       'balance': SupabaseClient('balance + ?', [paymentAmount] as String )
//   //     })
//   //         .eq('id', vaultId)
//   //     ;
//   //
//   //     if (response.error != null) {
//   //       throw Exception('Error updating vault balance: ${response.error!.message}');
//   //     }
//   //   } catch (e) {
//   //     rethrow;
//   //   }
//   // }
//
//
//
//
//
//     Future<int> _fetchBillsCount({String? status}) async {
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
//
//
//
//
//
// }

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/billes/data/models/bill_model.dart';
import 'package:system/features/category/data/models/subCategory_model.dart';
import 'package:system/features/customer/data/model/business_customer_model.dart';
import 'package:system/features/customer/data/model/normal_customer_model.dart';
import 'package:system/features/report/data/model/report_model.dart';

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
        'date': bill.date,
        'status': bill.status,
        'payment': bill.payment.toInt(),
        'total_price': bill.total_price,
        'vault_id': bill.vault_id,
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
        };
      }).toList();

      final itemResponse = await _client.from('bill_items').insert(items).select();

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
        'description': 'رقم الفاتورة : $billId - اسم العميل : ${bill.customerName} - اجمالي الفاتورة : ${bill.total_price.toStringAsFixed(2)}',
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
    if (response == null ) {
      throw Exception('Failed to fetch bills');
    }

    final data = response as List;
    return data.map((json) => Bill.fromJson(json)).toList();
  }

  // Fetch deferred bills
  Future<List<Bill>> getDeferredBills() async {
    final response = await _client.from('bills').select('*, bill_items(*)').eq('status', 'آجل');
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
        };
      }).toList();

      final itemResponse = await _client.from('bill_items').insert(newItems).select("*");
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

  // Fetch bill by ID
  Future<Bill> getBillById(int billId) async {
    final response = await _client.from('bills').select('*, bill_items(*), customers(*)').eq('id', billId).single();
    if (response == null) {
      throw Exception('Bill not found');
    }
    return Bill.fromJson(response);
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

  // Fetch categories for dropdowns
  // Future<List<SubCategoryModel>> fetchCategories() async {
  //   final response = await _client.from('category').select('*');
  //   if (response == null) {
  //     throw Exception('Error fetching categories');
  //   }
  //   return response.map<SubCategoryModel>((json) => SubCategoryModel.fromJson(json)).toList();
  // }


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
}
