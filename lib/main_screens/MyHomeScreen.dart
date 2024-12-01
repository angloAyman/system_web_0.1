import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/auth/data/auth_service.dart';
import 'package:system/main_screens/Layouts/desktop_layout.dart';
import 'package:system/main_screens/Layouts/mobile_layout.dart';
import 'package:system/main_screens/Layouts/tablet_layout.dart';
import 'package:system/core/shared/responsive.dart';

import '../main.dart';

class MyHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: MobileLayout(authService: AuthService(Supabase.instance.client),), // تصميم الموبايل
      tablet: TabletLayout(authService: AuthService(Supabase.instance.client),), // تصميم التابلت
      desktop: DesktopLayout(authService: AuthService(Supabase.instance.client), // تصميم الكمبيوتر المكتبي
      )
    );
  }
}
