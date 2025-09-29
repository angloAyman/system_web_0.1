class Report {
  final int operationNumber; // الرقم الخاص بالعملية
  final String id;
  final String title;
  // final String user_id;
  final String user_name;
  final DateTime date;
  final String description;

  Report({
    required this.operationNumber,
    required this.id,
    required this.title,
    // required this.user_id,
    required this.user_name,
    required this.date,
    required this.description,
  });

  // From JSON to Report object
  factory Report.fromMap(Map<String, dynamic> data) {
    return Report(
      operationNumber: data['operation_number'] as int,
      id: data['id'] as String,
      title: data['title'] as String,
      // user_id: data['user_id'] as String,
      user_name: data['user_name'] as String,
      date: DateTime.parse(data['date']),
      description: data['description'] as String,
    );
  }

  // From Report object to JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'user_name': user_name,
      'date': date.toIso8601String(),
      'description': description,
    };
  }
}
