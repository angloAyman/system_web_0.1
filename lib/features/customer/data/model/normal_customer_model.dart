class normal_customers {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;

  normal_customers({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  // Factory method for JSON deserialization
  factory normal_customers.fromJson(Map<String, dynamic> json) {
    return normal_customers(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
    );
  }

  // Method for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
    };
  }

  // Convert a customer from a map (e.g., from Firestore or local DB)
  factory normal_customers.fromMap(Map<String, dynamic> data) {
    return normal_customers(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      phone: data['phone'],
      address: data['address'],
    );
  }

  // Convert a customer to a map for saving to the database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
    };
  }
}
