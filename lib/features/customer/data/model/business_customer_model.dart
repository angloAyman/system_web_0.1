class business_customers {
  final String id;
  final String name;
  final String personName;
  final String email;
  final String phone;
  final String personPhone;
  final String personphonecall;
  final String address;
  // final String discount;

  business_customers({
    required this.id,
    required this.name,
    required this.personName,
    required this.email,
    required this.phone,
    required this.personPhone,
    required this.personphonecall,
    required this.address,
    // required this.discount,
  });

  // Factory method for JSON deserialization
  factory business_customers.fromJson(Map<String, dynamic> json) {
    return business_customers(
      id: json['id'] as String,
      name: json['name'] as String,
      personName: json['personName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      personPhone: json['personPhone'] as String,
      personphonecall: json['personphonecall'] as String,
      address: json['address'] as String,
      // discount: json['discount'] as String,
    );
  }

  // Method for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'person_name': personName,
      'email': email,
      'phone': phone,
      'person_phone': personPhone,
      'personphonecall': personphonecall,
      'address': address,
      // 'discount': discount,
    };
  }

  // Convert a customer from a map (e.g., from Firestore or local DB)
  factory business_customers.fromMap(Map<String, dynamic> data) {
    return business_customers(
      id: data['id'],
      name: data['name'] ,
      personName: data['personName'],
      email: data['email'] ,
      phone: data['phone'] ,
      personPhone: data['personPhone'] ,
      personphonecall: data['personphonecall'] ,
      address: data['address'] ,
      // discount: data['discount'] ,
    );
  }

  // Convert a customer to a map for saving to the database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'person_name': personName,
      'email': email,
      'phone': phone,
      'person_phone': personPhone,
      'personphonecall': personphonecall,
      'address': address,
      // 'discount': discount,
    };
  }

}
