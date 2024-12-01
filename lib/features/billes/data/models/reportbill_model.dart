class ReportbillBill {
  final int bill_id;
  // final String userId;
  final String userName; // User Name (added)
  final String customerName;
  final String date;
  final List<RBillItem> items;

  ReportbillBill({
    required this.bill_id,
    // required this.userId,
    required this.userName, // Initialize userName
    required this.customerName,
    required this.date,
    required this.items,
  });

  factory ReportbillBill.fromJson(Map<String, dynamic> json) {
    var itemsFromJson = json['bill_items'] as List;
    List<RBillItem> itemsList = itemsFromJson.map((item) => RBillItem.fromJson(item)).toList();

    return ReportbillBill(
      bill_id: json['bill_id'],
      // userId: json['user_id'],
      userName: json['user_name'], // Parse userName from JSON
      customerName: json['customer_name'],
      date: json['date'],
      items: itemsList,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> itemsList = items.map((item) => item.toJson()).toList();

    return {
      'bill_id': bill_id,
      // 'user_id': userId,
      'customer_name': customerName,
      'date': date,
      'items': itemsList,
    };
  }
}

class RBillItem {
  final String categoryName;
  final String subcategoryName;
  final double amount;
  final double price;

  RBillItem({
    required this.categoryName,
    required this.subcategoryName,
    required this.amount,
    required this.price,
  });

  factory RBillItem.fromJson(Map<String, dynamic> json) {
    return RBillItem(
      categoryName: json['category_name'],
      subcategoryName: json['subcategory_name'],
      amount: (json['amount'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_name': categoryName,
      'subcategory_name': subcategoryName,
      'amount': amount,
      'price': price,
    };
  }
}
