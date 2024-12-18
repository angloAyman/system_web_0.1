class Subcategory {
  final String id;
  final String categoryId;
  final String name;
  final String unit;
  final double pricePerUnit;
  final double discountPercentage;
  Subcategory({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.unit,
    required this.pricePerUnit,
    required this.discountPercentage,
  });

  // Method to create Subcategory from JSON
  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      id: json['id'] as String,
      categoryId: json['category_id'] as String,
      name: json['name'] as String,
      unit: json['unit'] as String,
      pricePerUnit: (json['pricePerUnit'] as num).toDouble(),
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
    );
  }

  // Method to convert Subcategory to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
      'unit': unit,
      'pricePerUnit': pricePerUnit,
      'discountPercentage': discountPercentage,
    };
  }
}
