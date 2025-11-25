import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linkedin/core/theme/app_colors.dart';
import 'package:linkedin/features/profile/logic/profile_cubit/profile_cubit.dart';

class AboutMeSectionView extends StatelessWidget {
  const AboutMeSectionView({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔹 الحصول على UID من FirebaseAuth
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Text(
        "User not logged in",
        style: TextStyle(color: Colors.red),
      );
    }

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (state is! ProfileSuccess) {
          return const SizedBox();
        }

        final about = state.profile.aboutMe;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 عنوان السكشن فقط
            Row(
              children: const [
                Icon(Icons.person_outline, color: AppColors.primary),
                SizedBox(width: 8),
                Text(
                  'About me',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // 🔹 المحتوى
            Text(
              about.isEmpty
                  ? 'No information available'
                  : about,
              style: TextStyle(
                fontSize: 14,
                color: about.isEmpty ? Colors.grey : Colors.black87,
                height: 1.5,
              ),
            ),
          ],
        );
      },
    );
  }
}
