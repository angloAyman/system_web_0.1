// class Customer {
//   final String id;
//   final String name;
//   final String email;
//   final String phone;
//   final String address;
//
//   Customer({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.phone,
//     required this.address,
//   });
//
//   // Convert a customer from a map (e.g., from Firestore or local DB)
//   factory Customer.fromMap(Map<String, dynamic> data) {
//     return Customer(
//       id: data['id'],
//       name: data['name'],
//       email: data['email'],
//       phone: data['phone'],
//       address: data['address'],
//     );
//   }
//
//   // Convert a customer to a map for saving to the database
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'email': email,
//       'phone': phone,
//       'address': address,
//     };
//   }
// }
