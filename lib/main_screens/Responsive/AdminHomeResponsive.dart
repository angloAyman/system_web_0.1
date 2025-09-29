import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:system/features/auth/data/auth_service.dart';
import 'package:system/main_screens/AdminLayouts/Admindesktop_layout.dart';
import 'package:system/main_screens/AdminLayouts/Adminmobile_layout.dart';
import 'package:system/main_screens/AdminLayouts/Admintablet_layout.dart';
import 'package:system/core/shared/responsive.dart';

import '../../main.dart';

class adminHomeResponsive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Responsive(
        mobile: AdminMobileLayout(authService: AuthService(Supabase.instance.client),), // تصميم الموبايل
        tablet: AdminTabletLayout(authService: AuthService(Supabase.instance.client),), // تصميم التابلت
        desktop: AdminDesktopLayout(authService: AuthService(Supabase.instance.client), // تصميم الكمبيوتر المكتبي
        )
    );
  }
}
