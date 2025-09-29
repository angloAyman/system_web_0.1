import 'package:system/Adminfeatures/Vaults/data/models/vault_model.dart';
import 'package:system/Adminfeatures/report/data/model/report_model.dart';

abstract class VaultRepository {
  Future<List<Vault>> getVaults();
  Future<void> addVault(Vault vault);
  Future<void> updateVault(Vault vault);
  Future<void> deleteVault(String id);
}
