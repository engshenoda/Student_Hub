import 'package:flutter/material.dart';
import 'package:linkedin/core/theme/app_colors.dart';

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const TextStyle bodyGray = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.gray,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const title = TextStyle(
    color: AppColors.text,
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );
  static const subtitle = TextStyle(color: Color(0xFF2D6A62), fontSize: 14);
  static const sectionTitle = TextStyle(
    color: AppColors.primary,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );
  static const sectionSubtitle = TextStyle(
    color: AppColors.text,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );
  static const body = TextStyle(color: AppColors.text, fontSize: 13);
  static const chip = TextStyle(color: AppColors.primary, fontSize: 13);
  static const caption = TextStyle(color: Colors.grey, fontSize: 12);
}
