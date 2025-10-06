import 'package:flutter/material.dart';
import 'package:linkedin/core/theme/app_colors.dart';
import 'package:linkedin/core/theme/app_text_styles.dart';
import 'package:linkedin/features/profile/presentation/widgets/profile_header.dart';

import 'package:linkedin/core/widgets/custom_bottom_navigation.dart';
import 'package:linkedin/features/profile/presentation/widgets/section_title.dart';
import 'package:linkedin/features/profile/presentation/widgets/skill_chip.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('About me'),
            centerTitle: true,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ProfileHeader(),
                SizedBox(height: 20),
                SectionTitle(title: 'About me'),
                SizedBox(height: 8),
                Text(
                  'Flutter and UI/UX design build good apps and interactive designs',
                  style: AppTextStyles.body,
                ),
                SizedBox(height: 18),
                SectionTitle(title: 'Skills'),
                SizedBox(height: 10),
                _SkillsList(),
                SizedBox(height: 18),
                SectionTitle(title: 'Education'),
                SizedBox(height: 8),
                _EducationCard(),
                SizedBox(height: 18),
                SectionTitle(title: 'Languages'),
                SizedBox(height: 10),
                _LanguagesList(),
                SizedBox(height: 18),
                SectionTitle(title: 'Work experience and projects'),
                SizedBox(height: 8),
                _WorkItem(),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SkillsList extends StatelessWidget {
  const _SkillsList({super.key});
  @override
  Widget build(BuildContext context) {
    const skills = [
      'Flutter',
      'UI/UX designer',
      'Game developer',
      'Video editor',
      'C++',
      'C#',
      'Python',
      'Java',
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: skills.map((s) => SkillChip(label: s)).toList(),
    );
  }
}

class _LanguagesList extends StatelessWidget {
  const _LanguagesList({super.key});
  @override
  Widget build(BuildContext context) {
    const langs = ['Arabic', 'English', 'French'];
    return Wrap(
      spacing: 8,
      children: langs.map((l) => SkillChip(label: l)).toList(),
    );
  }
}

class _EducationCard extends StatelessWidget {
  const _EducationCard({super.key});
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

class _WorkItem extends StatelessWidget {
  const _WorkItem({super.key});
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
          Text('Space war game', style: AppTextStyles.sectionSubtitle),
          SizedBox(height: 6),
          Text('2025', style: AppTextStyles.caption),
          SizedBox(height: 6),
          Text('internship in ABC company', style: AppTextStyles.body),
        ],
      ),
    );
  }
}
