import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/auth/data/auth_service.dart';
import 'package:system/main_screens/loginLayouts/Logindesktop_layout.dart';
import 'package:system/main_screens/loginLayouts/Loginmobile_layout.dart';
import 'package:system/main_screens/loginLayouts/Logintablet_layout.dart';
import 'package:system/core/shared/responsive.dart';

import '../../main.dart';

class loginResponsive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: LoginMobileLayout(authService: AuthService(Supabase.instance.client),), // تصميم الموبايل
      tablet: LoginTabletLayout(authService: AuthService(Supabase.instance.client),), // تصميم التابلت
      desktop: LoginDesktopLayout(authService: AuthService(Supabase.instance.client), // تصميم الكمبيوتر المكتبي
      )
    );
  }
}
