import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/vault_model.dart';
import '../../domain/repositories/vault_repository.dart';

class SupabaseVaultRepository implements VaultRepository {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<List<Vault>> getVaults() async {
    final response = await _client.from('vaults').select('*');
    final List data = response;
    if (response == null) {
      throw Exception('Failed to fetch vaults: ${response}');
    }
    return data.map((e) => Vault.fromMap(e)).toList();

  }

  Future<void> addVault(Vault vault) async {
    final vaultData = {
      'name': vault.name,
      'balance': vault.balance,
    };

    final response = await _client.from('vaults').insert(vaultData).select();;

    if (response == null) {
      throw Exception('Failed to add vault: ${response}');
    }

    print('Vault added successfully');

  }


  @override
  Future<void> updateVault(Vault vault) async {
    final response = await _client.from('vaults').update({
      'id':vault.id,
      'name':vault.name,
      'balance':vault.balance,
    }).eq('id', vault.id);
    if (response == null) {
      throw Exception('Failed to update vault: ${response}');
    }
  }


  Future<void> transferBetweenVaults(String fromVaultId, String toVaultId, double amount) async {
    try {
      final fromVault = await _client
          .from('vaults')
          .select('*')
          .eq('id', fromVaultId)
          .single();

      final toVault = await _client
          .from('vaults')
          .select('*')
          .eq('id', toVaultId)
          .single();

      if (fromVault['balance'] < amount) {
        throw Exception('Insufficient balance in source vault');
      }

      await _client.from('vaults').update({
        'balance': fromVault['balance'] - amount,
      }).eq('id', fromVaultId);

      await _client.from('vaults').update({
        'balance': toVault['balance'] + amount,
      }).eq('id', toVaultId);

      print('Transfer completed successfully');
    } catch (e) {
      print('Error during transfer: $e');
      throw Exception('Error during transfer: $e');
    }
  }


  @override
  Future<void> deleteVault(String id) async {
    final response = await _client.from('vaults').delete().eq('id', id).single();

    if (response == null) {
      throw Exception('Failed to delete vault: No response');
    }

    print('Vault deleted successfully');
  }
}
