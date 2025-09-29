class Vault {
  final String id; // تعديل النوع إلى String
  final String name;
  final int balance;
   bool isActive;

  Vault({
    required this.id,
    required this.name,
    required this.balance,
    required this.isActive,
  });

  // من JSON إلى كائن Vault
  factory Vault.fromMap(Map<String, dynamic> data) {
    return Vault(
      id: data['id']as String,
      name: data['name'] as String,
      balance: (data['balance'] as num).toInt(),
      isActive: data['isActive'] as bool,
    );
  }

  // من كائن Vault إلى JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
      'isActive': isActive,
    };
  }
}
