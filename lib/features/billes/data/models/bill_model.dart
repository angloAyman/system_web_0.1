
class Bill {
  final int id;
  final String userId;
  final String customerName;
  final DateTime date;
  final String status; // "تم الدفع" أو "آجل"
  late final double payment;
  late final double total_price;
  final String vault_id; // New field
  final List<BillItem> items;

  Bill({
    required this.id,
    required this.userId,
    required this.customerName,
    required this.date,
    required this.status,
    required this.payment,
    required this.total_price,
    required this.items,
    required this.vault_id, // Initialize here
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    var itemsFromJson = json['bill_items'] as List;
    List<BillItem> itemsList = itemsFromJson.map((item) => BillItem.fromJson(item)).toList();

    return Bill(
      id: json['id'],
      userId: json['user_id'],
      status: json['status'],
      customerName: json['customer_name'],
      payment: (json['payment'] as num).toDouble(),
      total_price: (json['total_price'] as num).toDouble(),
      date:DateTime.parse(json['date']),
      items: itemsList,
      vault_id: json['vault_id'],
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> itemsList = items.map((item) => item.toJson()).toList();

    return {
      'id': id,
      'user_id': userId,
      'customer_name': customerName,
      'status': status,
      'date': date,
      'payment': payment,
      'total_price': total_price,
      'items': itemsList,
      'vault_id': vault_id, // Include vault_id here
    };
  }

  // Factory constructor to create a Bill from a Map
  factory Bill.fromMap(Map<String, dynamic> map) {
    var itemsFromJson = map['bill_items'] as List;
    List<BillItem> itemsList = itemsFromJson.map((item) => BillItem.fromJson(item)).toList();

    return Bill(
      id: map['id'],
      userId: map['user_id'],
      status: map['status'],
      customerName: map['customer_name'],
      payment: (map['payment'] as num).toDouble(),
      total_price: (map['total_price'] as num).toDouble(),
      date:DateTime.parse(map['date']),
      vault_id: map['vault_id'],
      items: itemsList,
    );
  }

  // Optional: Method to convert the object back to a map if needed
  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> itemsList = items.map((item) => item.toJson()).toList();

    return {
      'id': id,
      'user_id': userId,
      'customer_name': customerName,
      'status': status,
      'date': date,
      'payment': payment,
      'total_price': total_price,
      'items': itemsList,
      'vault_id': vault_id, // Include vault_id here
    };
  }
}

class BillItem {
  // int id; // ID field added to uniquely identify the item
  late final String categoryName;
  final String subcategoryName;
  late final double amount;
  late final double price_per_unit;
  late final double quantity;
  late final String description; // The new field for description

  BillItem({
    // required this.id, // Initialize ID for the item
    required this.categoryName,
    required this.subcategoryName,
    required this.amount,
    required this.price_per_unit,
    required this.quantity,
    required this.description,
  });

  // Factory method to convert JSON to BillItem
  factory BillItem.fromJson(Map<String, dynamic> json) {
    return BillItem(
      // id: json['id'], // Populate ID from JSON
      categoryName: json['category_name'],
      subcategoryName: json['subcategory_name'],
      amount: (json['amount'] as num).toDouble(),
      price_per_unit: (json['price_per_unit'] as num).toDouble(),
      quantity: (json['quantity'] as num).toDouble(),
      description: json['description'] ?? '', // Set description default to empty string if null
    );
  }

  // Convert BillItem to JSON
  Map<String, dynamic> toJson() {
    return {
      // 'id': id, // Include ID in the JSON representation
      'category_name': categoryName,
      'subcategory_name': subcategoryName,
      'amount': amount,
      'price_per_unit': price_per_unit,
      'quantity': quantity,
      'description': description, // Add description
    };
  }

}

class Payment {
  String id;
  DateTime createdAt;
  int billId;
  DateTime date;
  String userId;
  double payment;
  String payment_status;
  final PaymentDetails? paymentDetails; // Nullable payment details

  Payment({
    required this.id,
    required this.createdAt,
    required this.billId,
    required this.date,
    required this.userId,
    required this.payment,
    required this.payment_status,
    this.paymentDetails,
  });

  // Factory method to create a Payment object from a map
  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'],
      createdAt: DateTime.parse(map['created_at']),
      billId: map['bill_id'],
      date: DateTime.parse(map['date']),
      userId: map['user_id'],
      payment: map['payment'],
      payment_status: map['payment_status'],
    );
  }

  // Method to convert a Payment object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'bill_id': billId,
      'date': date.toIso8601String(),
      'user_id': userId,
      'payment': payment,
      'payment_status': payment_status,
    };
  }
}

class PaymentDetails {
  final String userName;
  final double amount;
  final String date;
  final String method;

  PaymentDetails({
    required this.userName,
    required this.amount,
    required this.date,
    required this.method,
  });
}
