import 'package:flutter/material.dart';
import 'package:linkedin/core/theme/app_text_styles.dart';
import 'package:linkedin/features/profile/presentation/widgets/education_card.dart';
import 'package:linkedin/features/profile/presentation/widgets/languages_list.dart';
import 'package:linkedin/features/profile/presentation/widgets/profile_header.dart';
import 'package:linkedin/core/widgets/custom_bottom_navigation.dart';
import 'package:linkedin/features/profile/presentation/widgets/section_title.dart';
import 'package:linkedin/features/profile/presentation/widgets/skills_list.dart';
import 'package:linkedin/features/profile/presentation/widgets/work_item.dart';

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
                Skillslist(),
                SizedBox(height: 18),
                SectionTitle(title: 'Education'),
                SizedBox(height: 8),
                EducationCard(),
                SizedBox(height: 18),
                SectionTitle(title: 'Languages'),
                SizedBox(height: 10),
                Languageslist(),
                SizedBox(height: 18),
                SectionTitle(title: 'Work experience and projects'),
                SizedBox(height: 8),
                WorkItem(),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
