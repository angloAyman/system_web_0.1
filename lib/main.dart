// import 'dart:io';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:system/core/themes/theme/theme_data_dark.dart';
// import 'package:system/core/themes/theme/theme_data_light.dart';
// import 'package:system/core/themes/theme/theme_manager.dart';
// import 'package:system/features/auth/data/auth_service.dart';
// import 'package:system/core/shared/app_routes.dart';
// import 'package:window_manager/window_manager.dart';
// import 'package:system/core/services/inactivity_service.dart';
// import 'core/services/Widget/UserActivityListener.dart';
// import 'shutdown_handler.dart';
//
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// final SupabaseClient supabase = Supabase.instance.client;
// final ThemeManager themeManagermain = ThemeManager();
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await EasyLocalization.ensureInitialized();
//   await windowManager.ensureInitialized();
//
//   await Supabase.initialize(
//     url: 'https://mianifmvhtxtqxxhhwpr.supabase.co',
//     anonKey:
//       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1pYW5pZm12aHR4dHF4eGhod3ByIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0NzY1MjczMSwiZXhwIjoyMDYzMjI4NzMxfQ.nDwe8LVD0TqloXAKFlPLpW1t-QQveQMSt5tZSA5rAeU'
//   );
//
//   final authService = AuthService(Supabase.instance.client);
//
//   if (Platform.isWindows) {
//     registerShutdownListener(() async {
//       final user = supabase.auth.currentUser;
//       if (user != null) {
//         await authService.logoutUser(user.id);
//       }
//     });
//
//     windowManager.setPreventClose(true);
//     windowManager.addListener(MyWindowListener());
//   }
//
//   runApp(
//     EasyLocalization(
//       supportedLocales: const [Locale('en'), Locale('ar')],
//       path: 'assets/translations',
//       fallbackLocale: const Locale('en', 'US'),
//       startLocale: const Locale('ar'),
//       child: MyApp(authService: authService),
//     ),
//   );
// }
//
// class MyWindowListener extends WindowListener {
//   @override
//   void onWindowClose() async {
//     final user = supabase.auth.currentUser;
//     if (user != null) {
//       // 1. الحصول على الوقت الحالي وتحويله للمحلي
//       final now = DateTime.now().toLocal();
//
//       // 2. تنسيق الوقت المحلي كـ String
//       final logoutTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
//
//       // 3. إرسال الوقت إلى Supabase
//       await supabase
//           .from('logins')
//           .update({'logout_time': logoutTime})
//           .eq('user_id', user.id);
//     }
//
//     await windowManager.destroy();
//   }
//
// }
//
// class MyApp extends StatefulWidget {
//   final AuthService authService;
//   const MyApp({super.key, required this.authService});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
//   final InactivityService _inactivityService = InactivityService();
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     themeManagermain.addListener(themeListener);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _inactivityService.initialize(context);
//     });
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     themeManagermain.removeListener(themeListener);
//     _inactivityService.dispose();
//     super.dispose();
//   }
//
//   void themeListener() {
//     if (mounted) setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return UserActivityListener(
//       inactivityService: _inactivityService,
//       child: MaterialApp(
//         navigatorKey: navigatorKey,
//         debugShowCheckedModeBanner: false,
//         theme: getThemeDataLight(),
//         darkTheme: getThemeDataDark(),
//         themeMode: themeManagermain.themeMode,
//         localizationsDelegates: context.localizationDelegates,
//         supportedLocales: context.supportedLocales,
//         locale: context.locale,
//         initialRoute: '/',
//         routes: routes,
//       ),
//     );
//   }
// }

//

//
// // main for android
//
// import 'dart:io';
//
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:system/core/themes/theme/theme_data_dark.dart';
// import 'package:system/core/themes/theme/theme_data_light.dart';
// import 'package:system/core/themes/theme/theme_manager.dart';
// import 'package:system/features/auth/data/auth_service.dart';
// import 'package:system/core/shared/app_routes.dart';
// import 'package:system/core/services/inactivity_service.dart';
// import 'package:system/core/services/Widget/UserActivityListener.dart';
// import 'package:system/shutdown_handler.dart';
// import 'package:window_manager/window_manager.dart';
//
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// final SupabaseClient supabase = Supabase.instance.client;
// final ThemeManager themeManagermain = ThemeManager();
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await EasyLocalization.ensureInitialized();
//   await windowManager.ensureInitialized();
//
//   await Supabase.initialize(
//       url: 'https://mianifmvhtxtqxxhhwpr.supabase.co',
//       anonKey:
//       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1pYW5pZm12aHR4dHF4eGhod3ByIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0NzY1MjczMSwiZXhwIjoyMDYzMjI4NzMxfQ.nDwe8LVD0TqloXAKFlPLpW1t-QQveQMSt5tZSA5rAeU'
//   );
//
//     if (Platform.isWindows) {
//     registerShutdownListener(() async {
//       final user = supabase.auth.currentUser;
//       if (user != null) {
//         await authService.logoutUser(user.id);
//       }
//     });
//
//     windowManager.setPreventClose(true);
//     // await windowManager.destroy();
//
//   }
//
//
//   runApp(
//     EasyLocalization(
//       supportedLocales: const [Locale('en'), Locale('ar')],
//       path: 'assets/translations',
//       fallbackLocale: const Locale('en', 'US'),
//       startLocale: const Locale('ar'),
//       child: MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> with WidgetsBindingObserver, WindowListener {
//   final InactivityService _inactivityService = InactivityService();
//   late final AuthService _authService;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _authService = AuthService(Supabase.instance.client);
//
//     themeManagermain.addListener(themeListener);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _inactivityService.initialize(context);
//     });
//
//     if (Platform.isWindows) {
//       windowManager.addListener(this); // ✅ اسمع أحداث الإغلاق
//     }
//
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     themeManagermain.removeListener(themeListener);
//     _inactivityService.dispose();
//     if (Platform.isWindows) {
//       windowManager.removeListener(this);
//     }
//     super.dispose();
//   }
//
//   // 🔴 هنا منطق الإغلاق عند الضغط على X
//   @override
//   void onWindowClose() async {
//     bool isPreventClose = await windowManager.isPreventClose();
//     if (isPreventClose) {
//       final user = supabase.auth.currentUser;
//       if (user != null) {
//         await _authService.logoutUser(user.id); // ✅ تسجيل الخروج
//       }
//       await windowManager.destroy(); // ✅ إغلاق فعلي
//     }
//   }
//
//
//
//   void themeListener() {
//     if (mounted) setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return UserActivityListener(
//       inactivityService: _inactivityService,
//       child: MaterialApp(
//         navigatorKey: navigatorKey,
//         debugShowCheckedModeBanner: false,
//         theme: getThemeDataLight(),
//         darkTheme: getThemeDataDark(),
//         themeMode: themeManagermain.themeMode,
//         localizationsDelegates: context.localizationDelegates,
//         supportedLocales: context.supportedLocales,
//         locale: context.locale,
//         initialRoute: '/',
//         routes: routes,
//       ),
//     );
//   }
// }


// for web
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/core/themes/theme/theme_data_dark.dart';
import 'package:system/core/themes/theme/theme_data_light.dart';
import 'package:system/core/themes/theme/theme_manager.dart';
import 'package:system/features/auth/data/auth_service.dart';
import 'package:system/core/shared/app_routes.dart';
import 'package:system/core/services/inactivity_service.dart';
import 'package:system/core/services/Widget/UserActivityListener.dart';
import 'package:system/shutdown_handler.dart';
import 'window_manager_stub.dart'
if (dart.library.io) 'window_manager_desktop.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final SupabaseClient supabase = Supabase.instance.client;
final ThemeManager themeManagermain = ThemeManager();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  // await windowManager.ensureInitialized();

  await Supabase.initialize(
      url: 'https://mianifmvhtxtqxxhhwpr.supabase.co',
      anonKey:
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1pYW5pZm12aHR4dHF4eGhod3ByIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0NzY1MjczMSwiZXhwIjoyMDYzMjI4NzMxfQ.nDwe8LVD0TqloXAKFlPLpW1t-QQveQMSt5tZSA5rAeU'
  );



  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      startLocale: const Locale('ar'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver, WindowListener {
  final InactivityService _inactivityService = InactivityService();
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _authService = AuthService(Supabase.instance.client);

    themeManagermain.addListener(themeListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _inactivityService.initialize(context);
    });




  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    themeManagermain.removeListener(themeListener);
    _inactivityService.dispose();




    super.dispose();
  }

  // 🔴 هنا منطق الإغلاق عند الضغط على X
  // ✅ جعل الدالة مشروطة بالنظام


  void themeListener() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return UserActivityListener(
      inactivityService: _inactivityService,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: getThemeDataLight(),
        darkTheme: getThemeDataDark(),
        themeMode: themeManagermain.themeMode,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        initialRoute: '/',
        routes: routes,
      ),
    );
  }
}

