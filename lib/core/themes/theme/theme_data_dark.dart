import 'package:flutter/material.dart';
import 'package:system/core/themes/AppColors/app_colors_dark.dart';
import 'package:system/core/themes/AppColors/them_constants.dart';

// الثيم الغامق
ThemeData getThemeDataDark() => ThemeData(
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        titleTextStyle: TextStyle(
            color: AppColorsDark.titleTextColor,
            fontSize: 25,
            fontWeight: FontWeight.bold),
        color: AppColorsDark.AppbarColor,
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: AppColorsDark.BottomNavigationBarselectedItemColor,
        unselectedItemColor: AppColorsDark.BottomNavigationBarselectedItemColor,

        // selectedLabelStyle:TextStyle(color:AppColorsDark.BottomNavigationBarSelectedLabelColor ),
        backgroundColor: AppColorsDark.BottomNavigationBarbackgroundColor,
        //
      ),
  scaffoldBackgroundColor: AppColors.back,
  brightness: Brightness.light,

      colorScheme: ColorScheme.light(
        background: AppColors.background,
        onSurface: AppColors.surface,
        surface: AppColors.back,

        primary: AppColors.baby,

        secondary: AppColors.primary,
        error: AppColors.error,
        onPrimary: AppColors.primary,
        onSecondary: AppColors.surface,
        onError: AppColors.surface,
        onBackground: AppColors.surface,

      ),



  textTheme: TextTheme(
    bodySmall: TextStyle(color: AppColors.surface),
    bodyLarge: TextStyle(color: AppColors.surface),
    bodyMedium: TextStyle(color: AppColors.surface),
  ),
//   brightness: Brightness.dark,
// primaryColor: AppColors.primary,
// scaffoldBackgroundColor: Color(0xFF121212), // لون خلفية داكن
// colorScheme: ColorScheme.dark(
// background: AppColors.back, // خلفية داكنة
// onSurface: AppColors.white,
//
//
// primary: AppColors.primary,
// secondary: AppColors.secondary,
// surface: AppColors.surface,
// error: AppColors.error,
// onPrimary: AppColors.surface,
// onSecondary: AppColors.textPrimary,
// onError: AppColors.surface,
// onBackground: AppColors.surface,
// ),
// textTheme: TextTheme(
// bodyLarge: TextStyle(color: AppColors.surface),
// bodyMedium: TextStyle(color: AppColors.textSecondary),
// ),
    );
