
class Bill {
  final int id;
  final String userId;
  final String customerName;
  final DateTime date;
  final String status; // "تم الدفع" أو "آجل"
  late final double payment;
  late final double total_price;
  final String  vault_id; //
  final List<BillItem> items;
  bool isFavorite;
  String description; // "تم الدفع" أو "آجل"
  String customer_type; // "تم الدفع" أو "آجل"



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
    required this.isFavorite , // Default to false
    required this.description , // Default to false
    required this.customer_type , // Default to false

  });

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
      'description': description, // Include vault_id here
      'customer_type': customer_type, // Include vault_id here
      'isFavorite': isFavorite, // Include vault_id here
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
      vault_id: map['vault_id']?.toString() ?? '', // يحول null إلى String فاضي
      // vault_id: map['vault_id'],
      description: map['description'],
      customer_type: map['customer_type'],
      isFavorite: map['isFavorite'],
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
      'isFavorite': isFavorite, // Include isFavorite here
    };
  }

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'] as int,
      status: json['status'] as String,
      total_price: (json['total_price'] as num).toDouble(),
      payment: (json['payment'] as num).toDouble(),
      isFavorite: (json['isFavorite']) as bool,
      description:json['description'] as String,
      items: json['bill_items'] != null && json['bill_items'] is List
          ? (json['bill_items'] as List<dynamic>)
          .map((item) => BillItem.fromJson(item))
          .toList()
          : [], // ✅ إصلاح المشكلة بجعل `items` قائمة فارغة إذا لم تكن موجودة
          userId: json['user_id'],
          customerName: json['customer_name'],
          date:DateTime.parse(json['date']),
          vault_id: json['vault_id']?.toString() ?? '',
          customer_type: json['customer_type'],
    );
  }
}




class BillItem {
  // int id; // ID field added to uniquely identify the item
  late final String categoryName;
  final String subcategoryName;
  late final double amount;
  late final double price_per_unit;
  late final int discount;
  // final double? discount; // Allow null or ensure a default value is provided
  late final int quantity;
  late final double total_Item_price;
  late final String description; // The new field for description
  late final String discountType; // The new field for description

  BillItem({
    // required this.id, // Initialize ID for the item
    required this.categoryName,
    required this.subcategoryName,
    required this.amount,
    required this.price_per_unit,
    // required this.discount,
    this.discount = 0, // Default value for discount
    required this.quantity,
    required this.total_Item_price,
    required this.description,
    required this.discountType,

  });

  // Factory method to convert JSON to BillItem
  factory BillItem.fromJson(Map<String, dynamic> json) {
    return BillItem(
      // id: json['id'], // Populate ID from JSON
      categoryName: json['category_name'],
      subcategoryName: json['subcategory_name'],
      amount: (json['amount'] as num).toDouble(),
      price_per_unit: (json['price_per_unit'] as num).toDouble(),
      // discount: (json['discount'] as num).toDouble(),
      discount: (json['discount'] as num?)?.toInt() ?? 0, // Handle null gracefully
      quantity: (json['quantity'] as num).toInt(),
      total_Item_price: (json['total_Item_price'] as num).toDouble(),
      description: json['description'] ?? '',
      discountType: json['discountType'] ?? '',
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
      'discount': discount,
      'quantity': quantity,
      'total_Item_price': total_Item_price,
      'description': description, // Add description
      'discountType': discountType, // Add description
    };
  }

}

class Payment {
  String id;
  DateTime createdAt;
  int billId;
  DateTime date;
  String userId;
  String vault_id;
  double payment;
  String payment_status;
  final PaymentDetails? paymentDetails;


  Payment({
    required this.id,
    required this.createdAt,
    required this.billId,
    required this.date,
    required this.userId,
    required this.vault_id,
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
      vault_id: map['vault_id'],
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
      'vault_id': vault_id,
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
