import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/customer/data/model/customer_model.dart';

class CustomerRepository {
  final SupabaseClient _client = Supabase.instance.client;

  // Fetch customers
  Future<List<Customer>> fetchCustomers() async {
    final response = await _client.from('customers').select();
    final List data = response;
    return data.map((e) => Customer.fromMap(e)).toList();
  }

  // Add customer
  Future<void> addCustomer(Customer customer) async {
    await _client.from('customers').insert({
      'name': customer.name,
      'email': customer.email,
      'phone': customer.phone,
      'address': customer.address,
    });
  }

  // Update customer
  Future<void> updateCustomer(Customer customer) async {
    await _client.from('customers').update({
      'name': customer.name,
      'email': customer.email,
      'phone': customer.phone,
      'address': customer.address,
    }).eq('id', customer.id);
  }

  // Delete customer
  Future<void> deleteCustomer(String id) async {
    await _client.from('customers').delete().eq('id', id);
  }
}
