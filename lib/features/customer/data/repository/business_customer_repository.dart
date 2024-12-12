import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/customer/data/model/business_customer_model.dart';
import 'package:system/features/customer/data/model/customer_model.dart';

class BusinessCustomerRepository {
  final SupabaseClient _client = Supabase.instance.client;

  // Fetch customers
  Future<List<business_customers>> fetchCustomers() async {
    final response = await _client.from('business_customers').select();
    final List data = response;
    return data.map((e) => business_customers.fromMap(e)).toList();
  }

  // Add customer
  Future<void> addCustomer(business_customers business_customers) async {
    await _client.from('business_customers').insert({
      'name': business_customers.name,
      'personName': business_customers.personName,
      'email': business_customers.email,
      'phone': business_customers.phone,
      'personPhone': business_customers.personPhone,
      'address': business_customers.address,
      'discount': business_customers.discount,
    });
  }

  // Update customer
  Future<void> updateCustomer(business_customers business_customers) async {
    await _client.from('business_customers').update({
      'id': business_customers.id,
      'name': business_customers.name,
      'personName': business_customers.personName,
      'email': business_customers.email,
      'phone': business_customers.phone,
      'personPhone': business_customers.personPhone,
      'address': business_customers.address,
      'discount': business_customers.discount,
    }).eq('id', business_customers.id);
  }

  // Delete customer
  Future<void> deleteCustomer(String id) async {
    await _client.from('business_customers').delete().eq('id', id);
  }
}
