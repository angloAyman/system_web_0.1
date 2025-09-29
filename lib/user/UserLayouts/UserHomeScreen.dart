import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/core/constants/colors.dart';
import 'package:system/core/themes/AppColors/them_constants.dart';
import 'package:system/features/Vaults/vaults_page.dart';
import 'package:system/features/auth/data/auth_service.dart';
import 'package:system/features/payment/PaymentPage.dart';
import 'package:system/features/payment/PaymentPage.dart';
import 'package:system/features/billes/presentation/BillingPage.dart';
import 'package:system/features/billes/presentation/safe/report_page.dart';
import 'package:system/features/category/presentation/screens/category_page.dart';
import 'package:system/features/customer/presentation/customerPage.dart';
import 'package:system/features/report/UI/ReportsPage.dart';
import 'package:system/main.dart';
import 'package:system/features/auth/presentation/screens/GetAllUsersScreen.dart';
import 'package:system/user/UserLayouts/admin.dart';

class UserHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('UserLayouts Home')),
      body: UserDashboard(),
    );
  }
}
