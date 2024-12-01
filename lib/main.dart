// // // import 'package:flutter/material.dart';
// // // import 'package:provider/provider.dart';
// // // import 'package:supabase_flutter/supabase_flutter.dart';
// // // import 'features/auth/data/auth_service.dart';
// // // import 'features/auth/domain/usecases/sign_in_usecase.dart';
// // // import 'features/auth/presentation/auth_provider.dart';
// // // import 'features/auth/presentation/login_screen.dart';
// // //
// // // void main() async {
// // //   WidgetsFlutterBinding.ensureInitialized();
// // //   await Supabase.initialize(
// // //     url: 'https://mianifmvhtxtqxxhhwpr.supabase.co',
// // //     anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1pYW5pZm12aHR4dHF4eGhod3ByIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzIxODY2MTAsImV4cCI6MjA0Nzc2MjYxMH0.blrfnraxP9t7EXztwnYsEp_TzJGD_sr__cZI-ymDDdc',
// // //   );
// // //
// // //   final authService = AuthService(Supabase.instance.client);
// // //   final signInUseCase = SignInUseCase(authService);
// // //
// // //   runApp(
// // //     MultiProvider(
// // //       providers: [
// // //         ChangeNotifierProvider(create: (_) => AuthProvider(signInUseCase)),
// // //       ],
// // //       child: MyApp(),
// // //     ),
// // //   );
// // // }
// // //
// // // class MyApp extends StatelessWidget {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return MaterialApp(
// // //       title: 'Flutter Authentication',
// // //       theme: ThemeData(
// // //         primarySwatch: Colors.blue,
// // //       ),
// // //       home: LoginScreen(),
// // //     );
// // //   }
// // // }
// // import 'package:flutter/material.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart';
// // import 'package:system/features/auth/presentation/screens/login_screen.dart';
// // import 'package:system/features/auth/presentation/screens/GetAllUsersScreen.dart';
// //
// // void main() async {
// //   await Supabase.initialize(
// //      url: 'https://mianifmvhtxtqxxhhwpr.supabase.co',
// //      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1pYW5pZm12aHR4dHF4eGhod3ByIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzIxODY2MTAsImV4cCI6MjA0Nzc2MjYxMH0.blrfnraxP9t7EXztwnYsEp_TzJGD_sr__cZI-ymDDdc',
// //   );
// //   runApp(MyApp());
// // }
// //
// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Supabase Auth Example',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //       ),
// //       home: LoginScreen(),
// //       routes: { '/users': (context) => GetUsersScreen(), },
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:system/features/auth/data/auth_service.dart';
// import 'package:system/main_screens/Admin/AddUserScreen.dart';
// import 'package:system/main_screens/Admin/AdminHomeScreen.dart';
// import 'package:system/main_screens/User/UserHomeScreen.dart';
// import 'package:system/features/auth/presentation/screens/login_screen.dart';
// import 'package:system/shared/app_routes.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Supabase.initialize(
//       url: 'https://mianifmvhtxtqxxhhwpr.supabase.co',
//       // anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1pYW5pZm12aHR4dHF4eGhod3ByIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzIxODY2MTAsImV4cCI6MjA0Nzc2MjYxMH0.blrfnraxP9t7EXztwnYsEp_TzJGD_sr__cZI-ymDDdc',
//       anonKey : 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1pYW5pZm12aHR4dHF4eGhod3ByIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTczMjE4NjYxMCwiZXhwIjoyMDQ3NzYyNjEwfQ.eoHNowtHQOXw_hu3lI8glXPTOoMZ1NDUtMphGq3j3nY', // Add the service role key here
//
//   );
//   runApp(MyApp(authService: AuthService(Supabase.instance.client)));
// }
//
// class MyApp extends StatelessWidget {
//   final AuthService authService;
//
//   const MyApp({Key? key, required this.authService}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Role-Based Auth',
//       initialRoute: AppRoutes.login,
//       routes: {
//         AppRoutes.login: (context) => LoginScreen(authService: authService),
//         AppRoutes.adminHome: (context) => AdminHomeScreen(),
//         AppRoutes.userHome: (context) => UserHomeScreen(),
//         AppRoutes.addUser: (context) => AddUserScreen(),
//       },
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:system/features/auth/data/auth_service.dart';
// import 'package:system/features/bill/data/data_sources/remote_data_source.dart';
// import 'package:system/features/bill/data/repositories/bill_repository_impl.dart';
// import 'package:system/features/bill/data/repositories/category_repository.dart';
// import 'package:system/features/bill/domain/repository/bill_repository.dart';
// import 'package:system/features/bill/domain/usecases/add_bill_use_case.dart';
// import 'package:system/features/bill/domain/usecases/add_item_to_bill.dart';
// import 'package:system/features/bill/domain/usecases/fetch_bills.dart';
// import 'package:system/features/bill/domain/usecases/fetch_categories.dart';
// import 'package:system/features/bill/domain/usecases/remove_bill_use_case.dart';
// import 'package:system/features/bill/presentation/category_view_model.dart';
// import 'package:system/features/bill/presentation/pages/billing_page.dart';
// import 'package:system/features/billes/presentation/BillingPage.dart';
// import 'package:system/main_screens/Admin/AddUserScreen.dart';
// import 'package:system/main_screens/Layouts/desktop_layout.dart';
// import 'package:system/main_screens/Layouts/mobile_layout.dart';
// import 'package:system/main_screens/Layouts/tablet_layout.dart';
// import 'package:system/main_screens/MyHomeScreen.dart';
// import 'package:system/shared/app_routes.dart';
// import 'package:system/main_screens/Admin/AdminHomeScreen.dart';
// import 'package:system/main_screens/User/UserHomeScreen.dart';
// import 'package:system/features/auth/presentation/screens/login_screen.dart';
//
// // Responsive Layouts
// import 'package:system/shared/responsive.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Initialize Supabase
//   await Supabase.initialize(
//     url: 'https://mianifmvhtxtqxxhhwpr.supabase.co',
//     anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1pYW5pZm12aHR4dHF4eGhod3ByIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTczMjE4NjYxMCwiZXhwIjoyMDQ3NzYyNjEwfQ.eoHNowtHQOXw_hu3lI8glXPTOoMZ1NDUtMphGq3j3nY',
//   );
// // Initialize all use cases and repositories
//   final remoteDataSource = RemoteDataSource(client: Supabase.instance.client);
//   final billRepository = BillRepositoryImpl(remoteDataSource: remoteDataSource);
//   final categoryRepository = CategoryRepositoryImpl(remoteDataSource: remoteDataSource);
//
//   // Initialize Use Cases
//   final fetchBills = FetchBills(billRepository: billRepository);
//   final addBill = AddBill(billRepository: billRepository);
//   final addItemToBill = AddItemToBill(billRepository: billRepository);
//   final fetchCategories = FetchCategories(categoryRepository: categoryRepository);
//   final removeBill = RemoveBill(billRepository: billRepository);
//
//   // Initialize CategoryViewModel
//   final categoryViewModel = CategoryViewModel(
//     fetchBills: fetchBills,
//     addBill: addBill,
//     addItemToBill: addItemToBill,
//     fetchCategories: fetchCategories,
//     removeBill: removeBill,
//   );
//
//   final authService = AuthService(Supabase.instance.client);
//
//   runApp(MyApp(authService: authService, fetchBills: fetchBills, categoryViewModel: categoryViewModel,));
// }
//
// class MyApp extends StatelessWidget {
//
//   final AuthService authService;
//   final FetchBills fetchBills;
//
//   const MyApp({
//     Key? key,
//     required this.authService,
//     required this.fetchBills, required this.categoryViewModel,
//   }) : super(key: key);
//   final CategoryViewModel categoryViewModel;
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         // Provide the auth service
//         Provider<AuthService>(create: (_) => authService),
//
//         // Provide the FetchBills use case
//         Provider<FetchBills>(create: (_) => fetchBills),
//       ],
//       child: MaterialApp(
//         title: 'Role-Based Auth',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         initialRoute: '/', // Default route
//         routes: {
//           '/': (context) => MyHomeScreen(),
//           AppRoutes.adminHome: (context) => AdminHomeScreen(),
//           AppRoutes.userHome: (context) => UserHomeScreen(),
//           AppRoutes.addUser: (context) => AddUserScreen(),
//           AppRoutes.billing: (context) => BillingPage(),
//           // Add billing route
//
//         },
//       ),
//     );
//   }
// }
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart'; // Add this import
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:system/features/auth/data/auth_service.dart';
// import 'package:system/features/billes/presentation/BillingPage.dart';
// import 'package:system/features/billes/presentation/report_page.dart';
// import 'package:system/main_screens/Admin/AddUserScreen.dart';
// import 'package:system/main_screens/Layouts/desktop_layout.dart';
// import 'package:system/main_screens/Layouts/mobile_layout.dart';
// import 'package:system/main_screens/Layouts/tablet_layout.dart';
// import 'package:system/main_screens/MyHomeScreen.dart';
// import 'package:system/shared/app_routes.dart';
// import 'package:system/main_screens/Admin/AdminHomeScreen.dart';
// import 'package:system/main_screens/User/UserHomeScreen.dart';
// import 'package:system/features/auth/presentation/screens/login_screen.dart';
//
// // Responsive Layouts
// import 'package:system/shared/responsive.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Initialize Supabase
//   await Supabase.initialize(
//     url: 'https://mianifmvhtxtqxxhhwpr.supabase.co',
//     anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1pYW5pZm12aHR4dHF4eGhod3ByIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTczMjE4NjYxMCwiZXhwIjoyMDQ3NzYyNjEwfQ.eoHNowtHQOXw_hu3lI8glXPTOoMZ1NDUtMphGq3j3nY',
//   );
//
//   final authService = AuthService(Supabase.instance.client);
//
//   runApp(MyApp(authService: authService));
// }
//
// class MyApp extends StatelessWidget {
//   final AuthService authService;
//
//   const MyApp({Key? key, required this.authService}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => BillState()), // Add BillState provider
//       ],
//       child: MaterialApp(
//         title: 'Role-Based Auth',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         initialRoute: '/', // الشاشة الرئيسية
//         routes: {
//           '/': (context) => MyHomeScreen(),
//           AppRoutes.adminHome: (context) => AdminHomeScreen(),
//           AppRoutes.userHome: (context) => UserHomeScreen(),
//           AppRoutes.addUser: (context) => AddUserScreen(),
//           AppRoutes.report: (context) => ReportPage(),
//           AppRoutes.billing: (context) => BillingPage(),
//         },
//       ),
//     );
//   }
// }
//
//
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/core/themes/AppColors/them_constants.dart';
import 'package:system/core/themes/theme/theme_data_dark.dart';
import 'package:system/core/themes/theme/theme_data_light.dart';
import 'package:system/core/themes/theme/theme_manager.dart';
import 'package:system/features/auth/data/auth_service.dart';
import 'package:system/features/billes/presentation/BillingPage.dart';
import 'package:system/features/billes/presentation/report_page.dart';
import 'package:system/main_screens/Admin/AddUserScreen.dart';
import 'package:system/main_screens/Layouts/desktop_layout.dart';
import 'package:system/main_screens/Layouts/mobile_layout.dart';
import 'package:system/main_screens/Layouts/tablet_layout.dart';
import 'package:system/main_screens/MyHomeScreen.dart';
import 'package:system/core/shared/app_routes.dart';
import 'package:system/main_screens/Admin/AdminHomeScreen.dart';
import 'package:system/main_screens/User/UserHomeScreen.dart';
import 'package:system/features/auth/presentation/screens/login_screen.dart';

// Responsive Layouts
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

      // ThemeData(
      //   primarySwatch: Colors.blue,
      // ),

      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      initialRoute: '/',
      // الشاشة الرئيسية
      // routes: {
      //   '/': (context) => MyHomeScreen(),
      //   // AppRoutes.login: (context) => LoginScreen(authService: authService),
      //   AppRoutes.adminHome: (context) => AdminHomeScreen(),
      //   AppRoutes.userHome: (context) => UserHomeScreen(),
      //   AppRoutes.addUser: (context) => AddUserScreen(),
      //   AppRoutes.report: (context) => ReportPage(),
      //   AppRoutes.billing: (context) => BillingPage(),
      //   // '/details': (context) => DetailsScreen(),
      // },
      routes: routes,
    );
  }
}
