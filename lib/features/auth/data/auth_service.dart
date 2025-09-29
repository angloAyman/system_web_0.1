import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/Adminfeatures/auth/data/models/user_model.dart';

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

  // Future<void> recordLoginTime(String userId) async {
  //   final SupabaseClient supabase = Supabase.instance.client;
  //
  //   final response = await supabase.from('logins').insert([
  //     {
  //       'user_id': userId,
  //       'login_time': DateTime.now().toIso8601String(), // Current time
  //       'logout_time': null, // Logout time will be updated later
  //     }
  //   ]);
  //
  //   if (response == null) {
  //     print("Error recording login time: ${response}");
  //   }
  // }

  Future<void> recordLogoutTime(String userId) async {
    final SupabaseClient supabase = Supabase.instance.client;

    final response = await supabase
        .from('logins')
        .update({
      'logout_time': DateTime.now().toIso8601String() // Set the logout time
    })
        .eq('user_id', userId) // Specify the user
    // Only update if the logout time is null (i.e., user hasn't logged out yet)
        ;

    if (response.error != null) {
      print("Error recording logout time: ${response.error?.message}");
    } else {
      print("Logout time recorded successfully.");
    }
  }
}
