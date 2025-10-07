import 'package:flutter/material.dart';
import 'package:linkedin/core/theme/app_colors.dart';
import 'package:linkedin/core/theme/app_text_styles.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 3),
            image: DecorationImage(
              image: AssetImage('assets/profile.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('shenoda ashraf', style: AppTextStyles.heading1),
              SizedBox(height: 6),
              Text('UI / UX Designer', style: AppTextStyles.heading2),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.edit, color: AppColors.primary),
        ),
      ],
    );
  }
}
