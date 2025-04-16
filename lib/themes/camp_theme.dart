// lib/themes/camp_theme.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class CampTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.green,
    scaffoldBackgroundColor: AppColors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.black,
      elevation: 0,
    ),
    colorScheme: ColorScheme.light(
      primary: AppColors.green,
      secondary: AppColors.darkGreen,
      surface: AppColors.white,
      onSurface: AppColors.black,
    ),
    textTheme: TextTheme(
      
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}
