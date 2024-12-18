//

import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:system/core/themes/AppColors/app_colos_light.dart';
import 'package:system/core/themes/AppColors/them_constants.dart';

// الثيم الفاتح
ThemeData getThemeDataLight() =>
// ThemeData LightTheme =
    ThemeData(
      appBarTheme: const AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(
              color: AppColorsLight.back,
              fontSize: 25,
              fontWeight: FontWeight.bold
          ),
          color: AppColorsLight.AppbarColor),

      bottomNavigationBarTheme:
       BottomNavigationBarThemeData(
          selectedItemColor: AppColorsLight.BottomNavigationBarselectedItemColor,
          unselectedItemColor: AppColorsLight.BottomNavigationBarselectedItemColor,


         // selectedLabelStyle:TextStyle(color:AppColorsLight.BottomNavigationBarSelectedLabelColor ),
         backgroundColor: AppColorsLight.BottomNavigationBarbackgroundColor,

       ),



       // primaryTextTheme: ,
      brightness: Brightness.light,
// primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.light(
        background: AppColors.background,
        // onSurface: AppColors.back,

// primary: AppColors.primary,

        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.surface,
        onSecondary: AppColors.textPrimary,
        onError: AppColors.surface,
        onBackground: AppColors.textPrimary,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: AppColors.textPrimary),
        bodyMedium: TextStyle(color: AppColors.textSecondary),
      ),
    );
