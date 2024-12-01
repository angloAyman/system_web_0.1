// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:system/features/auth/data/models/user_model.dart';
//
// class AuthService {
//   final SupabaseClient supabase;
//
//   AuthService(this.supabase);
//
//   // Future<UserModel> signInWithEmailPassword(String email, String password) async {
//   //   final AuthResponse res = await supabase.auth.signInWithPassword(
//   //     email: email,
//   //     password: password,
//   //   );
//   //
//   //   final User? user = res.user;
//   //
//   //   if (user == null) {
//   //     throw Exception('Authentication failed. User not found.');
//   //   }
//   //
//   //   final profileResponse = await supabase
//   //       .from('users')
//   //       .select('*')
//   //       .eq('id', user.id)
//   //       .single();
//   //
//   //   if (profileResponse == null) {
//   //     throw Exception('Error fetching user profile: ${profileResponse!}');
//   //   }
//   //
//   //   final data = profileResponse;
//   //
//   //   if (data == null) {
//   //     throw Exception('User profile not found.');
//   //   }
//   //
//   //   return UserModel.fromJson(data);
//   // }
//
//   Future<UserModel> signInWithUsernamePassword(String username, String password) async {
//     // Fetch user by username
//     final response = await supabase
//         .from('users')
//         .select()
//         .eq('username', username)
//         .single()
//         ;
//
//     if (response == null) {
//       throw Exception('Failed to fetch user: ${response}');
//     }
//     final user = UserModel.fromJson(response);
//
//     // Authenticate user with email and password
//     final authResponse = await supabase.auth.signInWithPassword(
//       email: user.email,
//       password: password,
//     );
//
//     if (authResponse != null) {
//       throw Exception('Failed to sign in: ${authResponse}');
//     }
//   }
//
//   // Return auth model with user role
//   return UserModel(user.id, user.email, user.username, user.role);
// }
// }
//
// Future<void> signOut() async {
//     await supabase.auth.signOut();
//   }
//
// }
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
}
