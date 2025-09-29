import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/customer/data/model/normal_customer_model.dart';

class NormalCustomerRepository {
  final SupabaseClient _client = Supabase.instance.client;

  // Fetch customers
  Future<List<normal_customers>> fetchCustomers() async {
    final response = await _client.from('normal_customers').select();
    final List data = response;
    return data.map((e) => normal_customers.fromMap(e)).toList();
  }

  // Add customer
  Future<void> addCustomer(normal_customers normal_customers) async {
    await _client.from('normal_customers').insert({
      'name': normal_customers.name,
      'email': normal_customers.email,
      'phone': normal_customers.phone,
      'phonecall': normal_customers.phonecall,
      'address': normal_customers.address,
    });
  }

  // Update customer
  Future<void> updateCustomer(normal_customers normal_customers) async {
    await _client.from('normal_customers').update({
      'name': normal_customers.name,
      'email': normal_customers.email,
      'phone': normal_customers.phone,
      'address': normal_customers.address,
    }).eq('id', normal_customers.id);
  }

  // Delete customer
  Future<void> deleteCustomer(String id) async {
    await _client.from('normal_customers').delete().eq('id', id);
  }
}
