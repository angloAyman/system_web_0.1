import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceRepository {
  final SupabaseClient _client = Supabase.instance.client;

  /// Mark attendance for a user using their ID, status, shift ID, and timestamp.
  Future<void> markAttendance({
    required String userId,
    required String status,
    required String shiftId,
    required DateTime timestamp,
  }) async {
    final response = await _client.from('attendance1').insert({
      'user_id': userId,
      'status': status,
      'shift_id': shiftId,
      'timestamp': timestamp.toIso8601String(),
    });

    // if (response == null) {
    //   throw Exception('Failed to mark attendance: ${response}');
    // }
  }

  Future<String> getShiftIdByQrCode(String qrCode) async {
    final response = await _client
        .from('shifts')
        .select('id')
        .eq('qr_code', qrCode)
        ;

    if (response == null) {
      throw Exception('Failed to fetch shift ID: ${response}');
    }

    final data = response as List<dynamic>;
    if (data.isEmpty) {
      throw Exception('Invalid QR code: No matching shift found.');
    }

    final shiftId = data.first['id'] as String; // Ensure it's a String
    return shiftId;
  }


  Future<void> addShift({
    required String start,
    required String end,
    required String qrCode,
  }) async {
    final response = await _client.from('shifts').insert({
      'start_time': start,
      'end_time': end,
      'qr_code': qrCode,
      'created_at': DateTime.now().toIso8601String(),
    });

    if (response == null) {
      throw Exception('Failed to add shift: ${response}');
    }
  }

  Future<List<Map<String, dynamic>>> getShifts() async {
    final response = await _client.from('shifts').select('*');
    if (response == null) {
      throw response;
    }
    return response as List<Map<String, dynamic>>;
  }

  /// Helper to extract user ID from the QR code
  String _getUserIdFromQrCode(String qrCode) {
    // Assuming the QR code directly contains the user ID.
    // Modify this method if the QR code has a more complex structure.
    return qrCode;
  }

  /// Get the start of the day for a given date
  DateTime _getStartOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get the end of the day for a given date
  DateTime _getEndOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }


}
