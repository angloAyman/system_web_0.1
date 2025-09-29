import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/report/data/model/report_model.dart';

class ReportRepository {
  final SupabaseClient _client = Supabase.instance.client;

  // Fetch all reports
  Future<List<Report>> getReports() async {
    final response = await _client.from('reports').select('*')
        .order('operation_number', ascending: true); // ترتيب التقارير حسب الرقم


    if (response == null) {
      throw Exception('Failed to fetch reports');
    }

    return List<Report>.from(response.map((data) => Report.fromMap(data)));
  }

  // Add a new report
  Future<void> addReport(Report report) async {
    final reportData = {
      'title': report.title,
      // 'user_id': report.user_id,
      'user_name': report.user_name,
      'date': report.date.toIso8601String(),
      'description': report.description,
    };

    final response = await _client.from('reports').insert(reportData).select();

    if (response == null) {
      throw Exception('Failed to add report');
    }

    print('Report added successfully');
  }

  //deleteReport
  Future<void> deleteReport(String reportId) async {
    final response = await _client
        .from('report') // اسم جدول التقارير
        .delete()
        .eq('id', reportId)
        ;

    if (response.error != null) {
      throw Exception('خطأ في حذف التقرير: ${response.error!.message}');
    }
  }

//Fetch UserLayouts Data
  Future<String?> getUserNameById(String user_name) async {
    final response = await Supabase.instance.client
        .from('users')
        .select('name')  // Replace 'username' with your actual column name
        .eq('id', user_name)
        .single();  // Assuming 'id' is unique

    if (response == null) {
      print('Error fetching username: ${response}');
      return null;
    }

    return response['name'] as String; // إرجاع اسم المستخدم
  }



  Future<String?> getUserIdFromReport(String userId) async {
    try {
      final response = await Supabase.instance.client
          .from('reports')
          .select('user_name') // العمود اللي فيه الـ id
          .eq('user_name', userId)
          .maybeSingle();

      if (response == null) return null;

      return response['user_name'] as String?;
    } catch (e) {
      throw Exception('Error fetching user_id for $userId: $e');
    }
  }


  Future<List<Map<String, dynamic>>> getItemUsageInBills(DateTime start, DateTime end) async {
    try {
      final response = await _client
          .from('bill_items')
          .select('category_name, quantity, bill_id, bills(date)')
          .gte('bills.date::date', start.toIso8601String()) // تصفية حسب تاريخ البداية
          .lte('bills.date::date', end.toIso8601String()); // تصفية حسب تاريخ النهاية

      if (response == null || response.isEmpty) {
        return [];
      }

      // تجميع البيانات
      final usageData = <String, Map<String, dynamic>>{};

      for (var item in response) {
        final categoryName = item['category_name'] as String;
        final quantity = (item['quantity'] as num).toDouble();

        if (usageData.containsKey(categoryName)) {
          usageData[categoryName]!['total_quantity'] += quantity;
          usageData[categoryName]!['usage_count'] += 1;
        } else {
          usageData[categoryName] = {
            'category_name': categoryName,
            'total_quantity': quantity,
            'usage_count': 1,
          };
        }
      }

      return usageData.values.toList();
    } catch (e) {
      throw Exception('Error fetching item usage in bills: $e');
    }
  }



  // Fetch category usage count by a given date range
  Future<Map<String, int>> getCategoryUsageCountByDateRange(
      String categoryId, DateTime startDate, DateTime endDate) async {
    try {
      final response = await _client
          .from('bill_items')
          .select('category_name, bills(date)')
          .eq('category_name', categoryId)
          .gte('bills.date', startDate.toIso8601String())
          .lte('bills.date', endDate.toIso8601String());

      if (response == null || response.isEmpty) {
        throw Exception('No usage data found for this category in the specified range.');
      }

      // Group data by date and count usage
      Map<String, int> usageCountByDate = {};

      for (var item in response) {
        final date = item['bills']['date'];
        final dateString = date.substring(0, 10); // Format: YYYY-MM-DD

        usageCountByDate[dateString] = (usageCountByDate[dateString] ?? 0) + 1;
      }

      return usageCountByDate;
    } catch (e) {
      throw Exception('Error fetching category usage count by date range: $e');
    }
  }

}
