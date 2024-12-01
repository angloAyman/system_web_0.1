class Subcategory {
  final String id;
  final String categoryId;
  final String name;

  Subcategory({required this.id, required this.categoryId, required this.name});

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'],
    );
  }
}
