import 'package:system/features/Vaults/data/models/vault_model.dart';

abstract class VaultRepository {
  Future<List<Vault>> getVaults();
  Future<void> addVault(Vault vault);
  Future<void> updateVault(Vault vault);
  Future<void> deleteVault(String id);
}
