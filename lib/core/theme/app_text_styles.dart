import 'package:flutter/material.dart';
import 'package:linkedin/core/theme/app_colors.dart';

class AppTextStyle {
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColor.textDark,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColor.textDark,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColor.textDark,
  );

  static const TextStyle bodyGray = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColor.gray,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColor.white,
  );
}
