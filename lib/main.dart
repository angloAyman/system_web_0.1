import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/core/themes/AppColors/them_constants.dart';
import 'package:system/core/themes/theme/theme_data_dark.dart';
import 'package:system/core/themes/theme/theme_data_light.dart';
import 'package:system/core/themes/theme/theme_manager.dart';
import 'package:system/features/auth/data/auth_service.dart';
import 'package:system/features/billes/presentation/BillingPage.dart';
import 'package:system/features/auth/presentation/screens/AddUserScreen.dart';
import 'package:system/main_screens/loginLayouts/desktop_layout.dart';
import 'package:system/main_screens/loginLayouts/mobile_layout.dart';
import 'package:system/main_screens/loginLayouts/tablet_layout.dart';
import 'package:system/main_screens/Responsive/LoginResponsive.dart';
import 'package:system/core/shared/app_routes.dart';
import 'package:system/main_screens/Admin/AdminHomeScreen.dart';
import 'package:system/main_screens/User/UserHomeScreen.dart';
import 'package:system/features/auth/presentation/screens/login_screen.dart';

// Responsive loginLayouts
import 'package:system/core/shared/responsive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://mianifmvhtxtqxxhhwpr.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1pYW5pZm12aHR4dHF4eGhod3ByIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTczMjE4NjYxMCwiZXhwIjoyMDQ3NzYyNjEwfQ.eoHNowtHQOXw_hu3lI8glXPTOoMZ1NDUtMphGq3j3nY',
  );

  final authService = AuthService(Supabase.instance.client);

  // runApp();

  runApp(
    EasyLocalization(
        supportedLocales: [
          Locale(
            'en',
          ),
          Locale(
            'ar',
          )
        ],
        path: 'assets/translations',
        // <-- change the path of the translation files
        fallbackLocale: Locale('en', 'US'),
        startLocale: const Locale('ar'),
        child: MyApp(authService: authService)),
  );
}

ThemeManager themeManagermain = ThemeManager();

class MyApp extends StatefulWidget {
  final AuthService authService;

  const MyApp({Key? key, required this.authService}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    themeManagermain.addListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    themeManagermain.addListener(themeListener);
    super.initState();
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: getThemeDataLight(),
      darkTheme: getThemeDataDark(),
      themeMode: themeManagermain.themeMode,


      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      initialRoute: '/',
      routes: routes,
    );
  }
}
