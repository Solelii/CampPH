import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {

// Input prompt (in add campsite)

  static const TextStyle header1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.normal,
    color: AppColors.black,
    letterSpacing: -2,
    
  );

// Campsite name (in sheet)

  static const TextStyle header2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
    letterSpacing: -2,
    fontFamily: 'Inter'
  );

// Input label (in add campsite)

  static const TextStyle header3 = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.normal,
    color: AppColors.black,
    letterSpacing: -2
  );  

// User input (in add campsite) + rate and review text, write a review, and filter tabs in sheet, and add photo text

  static const TextStyle body1 = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    color: AppColors.black,
    letterSpacing: -2
  );

// User input + about and review in sheet, and filter chips

  static const TextStyle body2 = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.normal,
    color: AppColors.black,
    letterSpacing: -2
  );

// subtext in add campsite

  static const TextStyle subtext1 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.gray,
    letterSpacing: -2,
    fontFamily: 'Inter'
  );
}
