import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkedin/core/theme/app_colors.dart';
import 'package:linkedin/features/profile/logic/profile_cubit/profile_cubit.dart';
import 'package:linkedin/features/profile/presentation/widgets/about_me_section.dart';
import 'package:linkedin/features/profile/presentation/widgets/education_section.dart';
import 'package:linkedin/features/profile/presentation/widgets/languages_section.dart';
import 'package:linkedin/features/profile/presentation/widgets/profile_header.dart';
import 'package:linkedin/features/profile/presentation/widgets/skills_scetion.dart';
import 'package:linkedin/features/profile/presentation/widgets/work_experience_section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.uid});
  final String uid;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(context.read())..loadProfile(uid),
      child: Scaffold(
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
        body: SafeArea(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProfileSuccess) {
                final profile = state.profileModel;
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
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
                );
              } else if (state is ProfileError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
