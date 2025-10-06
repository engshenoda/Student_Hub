import 'package:flutter/material.dart';
import 'package:linkedin/core/theme/app_colors.dart';
import 'package:linkedin/core/theme/app_text_styles.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.bookmark, color: AppColors.primary, size: 20),
        const SizedBox(width: 8),
        Text(title, style: AppTextStyles.sectionTitle),
      ],
    );
  }
}
