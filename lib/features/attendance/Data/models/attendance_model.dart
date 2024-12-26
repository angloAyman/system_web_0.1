class AttendanceModel {
  final String id; // Unique ID for the attendance record
  final String userId; // User ID of the person
  final DateTime createdAt; // Date and time of attendance
  final String status; // Attendance status, e.g., "present", "absent", "dismissed"

  AttendanceModel({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.status,
  });

  /// Factory method to create an `AttendanceModel` from a JSON object
  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      status: json['status'] as String,
    );
  }

  /// Converts the `AttendanceModel` instance into a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'status': status,
    };
  }
}
