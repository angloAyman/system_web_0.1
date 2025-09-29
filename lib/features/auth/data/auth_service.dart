import 'package:easy_localization/easy_localization.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/auth/data/models/user_model.dart';

class AuthService {
  final SupabaseClient supabase;

  AuthService(this.supabase);

  Future<UserModel> signInWithUsernamePassword(String name, String password) async {
    // Fetch user by username
    final response = await supabase
        .from('users')
        .select()
        .eq('name', name)
        .single();


    if (response == null) {
      throw Exception('Failed to fetch user: ${response}');
    }

    final user = UserModel.fromJson(response);

    // Authenticate user with email and password
    final authResponse = await supabase.auth.signInWithPassword(
      email: user.email,
      password: password,
    );

    if (authResponse == null) {
      throw Exception('Failed to sign in: ${authResponse}');
    }

    // Return user model with role
    return user;
  }

  Future<void> signOut() async {

    await supabase.auth.signOut();
  }

  Future<void> logoutUser(String userId) async {
    try {
      final logoutTime = DateFormat('yyyy-MM-dd HH:mm:ss',"en").format(DateTime.now().toLocal());

      // final logoutTime = DateTime.now().toLocal().toIso8601String();

      await supabase
          .from('logins')
          .update({
        'logout_time': logoutTime,
      })
          .eq('user_id', userId)
          .filter('logout_time', 'is', null); // 👈 يعادل IS NULL

      await supabase.auth.signOut();
    } catch (e) {
      print('خطأ أثناء تسجيل وقت الخروج: $e');
    }
  }

  }

