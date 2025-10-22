import 'package:flutter/material.dart';
import 'package:linkedin/core/theme/app_colors.dart';
import 'package:linkedin/features/profile/presentation/widgets/about_me_section.dart';
import 'package:linkedin/features/profile/presentation/widgets/education_section.dart';
import 'package:linkedin/features/profile/presentation/widgets/languages_section.dart';
import 'package:linkedin/features/profile/presentation/widgets/profile_header.dart';
import 'package:linkedin/features/profile/presentation/widgets/skills_scetion.dart';
import 'package:linkedin/features/profile/presentation/widgets/work_experience_section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'About me',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const Icon(Icons.arrow_back, color: AppColors.primary),
        actions: const [
          Icon(Icons.settings, color: AppColors.primary),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ProfileHeader(),
            SizedBox(height: 20),
            AboutMeSection(),
            SizedBox(height: 18),
            SkillsSection(),
            SizedBox(height: 18),
            EducationSection(),
            SizedBox(height: 18),
            LanguagesSection(),
            SizedBox(height: 18),
            WorkExperienceSection(),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
