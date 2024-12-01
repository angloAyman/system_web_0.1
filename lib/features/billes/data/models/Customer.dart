class Customer {
  final String name;
  final String email;
  final String phone;
  final String address;

  Customer({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  // Optionally, add a `toMap()` method if needed for insertion
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
    };
  }
}
