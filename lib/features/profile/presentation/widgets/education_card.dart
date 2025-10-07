import 'package:flutter/material.dart';
import 'package:linkedin/core/theme/app_colors.dart';
import 'package:linkedin/core/theme/app_text_styles.dart';

class EducationCard extends StatelessWidget {
  const EducationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Menoufia National University',
            style: AppTextStyles.sectionSubtitle,
          ),
          SizedBox(height: 6),
          Text('2023', style: AppTextStyles.caption),
          SizedBox(height: 6),
          Text(
            "Bachelor's Degree in Computer science",
            style: AppTextStyles.body,
          ),
        ],
      ),
    );
  }
}