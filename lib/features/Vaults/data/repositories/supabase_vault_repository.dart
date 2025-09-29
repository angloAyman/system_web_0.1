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

  Future<Map<String, dynamic>?> getAuthenticatedUser() async {
    final session = _client.auth.currentSession;

    if (session != null) {
      final user = session.user;
      final response = await _client
          .from('users')
          .select('id, name, email')
          .eq('id', user.id)
          .single();

      if (response != null) {
        return response;
      }
    }

    return null;
  }


  Future<void> updateVaultStatus(String id, bool isActive) async {
    final response = await Supabase.instance.client
        .from('vaults')
        .update({'isActive': isActive})
        .eq('id', id)
        .select(); // لازم .select() عشان يرجع بيانات محدثة

    if (response == null || response.isEmpty) {
      throw Exception('فشل تحديث حالة الخزنة');
    }
  }



  Future<List<Map<String, dynamic>>> getPaymentsByVaultId(String id) async {
    final response = await _client
        .from('paymentsOut')
        .select('*')
        .eq('vault_id', id)
        .order('timestamp', ascending: false); // Sort in ascending order



    if (response == null) {
      throw Exception('Error fetching payments: ${response}');
    }
print(response);
    return List<Map<String, dynamic>>.from(response);
  }






  // جلب جميع الفواتير المرتبطة بالخزنة
  Future<List<Map<String, dynamic>>> getBillsForVault(String vaultId) async {
    final response = await _client
        .from('bills') // جدول الفواتير
        .select('*')
        .eq('vault_id', vaultId) // الفواتير المرتبطة بـ vault_id
        .order('date', ascending: false); // ترتيب الفواتير حسب التاريخ

    if (response == null) {
      throw Exception('Failed to fetch bills for vault');
    }

    return List<Map<String, dynamic>>.from(response);
  }

  // جلب جميع الفواتير المرتبطة بالخزنة
  Future<List<Map<String, dynamic>>> getpaymentsForVault(String vaultId) async {
    final response = await _client
        .from('payment') // جدول الفواتير
        .select('*')
        .eq('vault_id', vaultId) // الفواتير المرتبطة بـ vault_id
        .order('date', ascending: false); // ترتيب الفواتير حسب التاريخ

    if (response == null) {
      throw Exception('Failed to fetch bills for vault');
    }

    return List<Map<String, dynamic>>.from(response);
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


  Future<void> transferBetweenVaults(String fromVaultId, String toVaultId, int amount) async {
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
    final response = await _client.from('vaults').delete().eq('id', id).asStream();

    if (response == null) {
      throw Exception('Failed to delete vault: No response');
    }

    print('Vault deleted successfully');
  }

  // Update the balance of the vault based on total payments from bills
  Future<void> updateVaultBalance(String vaultId) async {
    try {
      // Get the list of bills for the vault
      final bills = await getBillsForVault(vaultId);

      // Calculate total payment
      final int totalPayment = bills.fold(0, (sum, bill) {
        return (sum + (bill['payment'] ?? 0)).toInt();
      });


      // Update the vault's balance in the database
      final response = await _client
          .from('vaults')
          .update({'balance': totalPayment})
          .eq('id', vaultId)
          .select();

      if (response == null) {
        throw Exception('Failed to update balance');
      }

      print('Vault balance updated successfully');
    } catch (e) {
      print('Error updating vault balance: $e');
      throw Exception('Error updating vault balance: $e');
    }
  }


  Future<List<Map<String, dynamic>>> getAllVaults() async {
    // final response = await _client.from('vaults').select('id,name,balance,isActive');
    final response = await _client
        .from('vaults')
        .select('id,name,balance,isActive')
        .eq('isActive', true); // ✅ شرط يجيب بس الـ Active
    if (response == null) {
      throw Exception('Error fetching vaults: ${response}');
    }
    return List<Map<String, dynamic>>.from(response ?? []);
  }


  Future<List<Map<String, dynamic>>> getAlpaymentsOut() async {
    final response = await _client.from('paymentsOut').select('*');

    if (response == null) {
      throw Exception('Error fetching vaults: ${response}');
    }
    return List<Map<String, dynamic>>.from(response ?? []);
  }


  // تحديث رصيد الخزنة

  // Future<void> subtractFromVaultBalance2(String vaultId, double billPayment) async {
  //   // 1. جيب الرصيد الحالي
  //   final response = await _client
  //       .from('vaults')
  //       .select('balance')
  //       .eq('id', vaultId)
  //       .single();
  //
  //   if (response == null || response['balance'] == null) {
  //     throw Exception("لم يتم العثور على الخزنة أو الرصيد غير موجود");
  //   }
  //
  //   final currentBalance = (response['balance'] as num).toDouble();
  //
  //   // 2. احسب الرصيد الجديد
  //   final newBalance = currentBalance - billPayment;
  //
  //   // 3. حدث الرصيد
  //   await _client
  //       .from('vaults')
  //       .update({'balance': newBalance})
  //       .eq('id', vaultId);
  // }


  Future<bool> subtractFromVaultBalance2(String vaultId, double billPayment) async {
    try {
      // 1. جيب الرصيد الحالي
      final response = await _client
          .from('vaults')
          .select('balance')
          .eq('id', vaultId)
          .single();

      if (response == null || response['balance'] == null) {
        throw Exception("❌ لم يتم العثور على الخزنة أو الرصيد غير موجود");
      }

      final currentBalance = (response['balance'] as num).toDouble();

      // 2. احسب الرصيد الجديد
      final newBalance = currentBalance - billPayment;

      if (newBalance < 0) {
        throw Exception("⚠️ الرصيد لا يكفي لخصم هذا المبلغ");
      }

      // 3. حدث الرصيد
      final updateResponse = await _client
          .from('vaults')
          .update({'balance': newBalance})
          .eq('id', vaultId);

      print("✅ تم تحديث الرصيد بنجاح: $newBalance - response: $updateResponse");
      return true; // ✅ نجاح

    } catch (e, stackTrace) {
      print("🚨 خطأ أثناء خصم الرصيد: $e");
      print(stackTrace);
      return false; // ❌ فشل
    }
  }




  // Future<void> subtractFromVaultBalance({
  //   required String vaultId,
  //   required int amount,
  //   required String description,
  // }) async {
  //   final response = await _client.rpc('paymentsOut', params: {
  //     'vault_id': vaultId,
  //     'amount': amount,
  //     'description': description,
  //   });
  //
  //   if (response == null) {
  //     throw Exception('Error updating vault balance: ${response}');
  //   }
  // }

  Future<void> updateVaultBalanceAndLogPayment({
    required String vault_id,
    required int newBalance,
    // required int amount,
    // required String description,
    // required String timestamp,
  }) async {
    // try {
      // Start a transaction by updating the balance
      final balanceUpdateResponse = await _client
          .from('vaults')
          .update({'balance': newBalance})
          .eq('id', vault_id).asStream()
          ;

      if (balanceUpdateResponse == null) {
        throw Exception('Error updating vault balance: ${balanceUpdateResponse}');
      }

      // Insert the payment log
      // final paymentLogResponse = await _client
      //     .from('paymentsOut')
      //     .insert({
      //   'vault_name': vaultname,
      //   'amount': amount,
      //   'description': description,
      //   'timestamp': timestamp,
      // })
      //     ;
      //
      // if (paymentLogResponse == null) {
      //   throw Exception('Error logging payment: ${paymentLogResponse}');
      // }
    }
    // catch (e) {
    //   // Re-throw the exception for error handling in the caller
    //   throw Exception('Transaction failed: $e');
    // }
  // }


  Future<int> getVaultBalance(String id) async {
    final response = await _client
        .from('vaults')
        .select('balance')
        .eq('id', id)
        .single()
        ;

    if (response == null) {
      throw Exception('Error fetching vault balance: ${response}');
    }

    return response['balance'] as int;
  }


  Future<String> getVaultbyid(String id) async {
    final response = await _client
        .from('vaults')
        .select('name')
        .eq('id', id)
        .single()
        ;

    if (response == null) {
      throw Exception('Error fetching vault balance: ${response}');
    }

    return response['name'] as String;
  }


  Future<void> subtractFromVaultBalance({
  required String vault_id,
  required String vault_name,
  required String userName,
  required int amount,
  required String description,
  required String timestamp,
}) async {
  final response = await _client.from('paymentsOut').insert({
    'vault_id': vault_id,
    'vault_name': vault_name,
    'userName': userName,
    'amount': amount,
    'description': description,
    'timestamp': timestamp,
  });

}

  Future<int> getTotalVaultCount() async {
  final response = await _client.from('vaults').select('*');
  return response.length;
}
  Future<int> getTotalVaultBalance() async {
    final response = await _client
        .from('vaults')
        .select('balance',)
        ;

    if (response == null) {
      throw Exception('Error fetching vault balances: ${response}');
    }

    // Sum the balances manually
    final List<dynamic> vaults = response;
    int totalBalance = vaults.fold(0, (sum, vault) => sum + ((vault['balance'] as num?)?.toInt() ?? 0));

    return totalBalance  ;
  }

  Future<int> getTotalpaymentsOut() async {
    final response = await _client
        .from('paymentsOut')
        .select('amount',)
    ;

    if (response == null) {
      throw Exception('Error fetching vault balances: ${response}');
    }

    // Sum the balances manually
    final List<dynamic> vaults = response;
    int TotalpaymentsOut = vaults.fold(0, (sum, vault) => sum + (vault['amount'] ?? 0) as int);

    return TotalpaymentsOut;
  }


}