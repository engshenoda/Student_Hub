import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin/core/routes/route.dart';
import 'package:linkedin/core/theme/app_colors.dart';
import 'package:linkedin/features/profile/data/repo/profile_repo.dart';
import 'package:linkedin/features/profile/data/services/profile_firebase_service.dart';
import 'package:linkedin/features/profile/logic/profile_cubit/profile_cubit.dart';
import 'package:linkedin/features/profile/presentation/widgets/about_me_section.dart';
import 'package:linkedin/features/profile/presentation/widgets/education_section.dart';
import 'package:linkedin/features/profile/presentation/widgets/languages_section.dart';
import 'package:linkedin/features/profile/presentation/widgets/profile_header.dart';
import 'package:linkedin/features/profile/presentation/widgets/skills_section.dart';
import 'package:linkedin/features/profile/presentation/widgets/work_experience_section.dart';

class ProfileScreen extends StatelessWidget {
  final String? uid;
  final String? name;

  const ProfileScreen({super.key, this.uid, this.name});

  @override
  Widget build(BuildContext context) {
    final currentAuthUid = FirebaseAuth.instance.currentUser?.uid;
    final targetUid = uid ?? currentAuthUid;
    final isCurrentUserProfile = targetUid == currentAuthUid;

    return BlocProvider(
      create: (context) {
        final cubit = ProfileCubit(ProfileRepo(ProfileFirebaseService()));
        if (targetUid != null) {
          cubit.loadProfile(targetUid);
        }
        return cubit;
      },
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          // Dynamically set AppBar title
          String appBarTitle = 'Profile';
          if (state is ProfileLoaded) {
            appBarTitle = state.user.name;
          } else if (name != null && name!.isNotEmpty) {
            appBarTitle = name!;
          } else if (isCurrentUserProfile) {
            appBarTitle = "My Profile";
          }

          return Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                appBarTitle, // ✅ تم التصحيح هنا
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                if (isCurrentUserProfile)
                  IconButton(
                    icon: const Icon(Icons.settings, color: AppColors.primary),
                    onPressed: () {
                      GoRouter.of(context).push(Routes.settings);
                    },
                  ),
                const SizedBox(width: 8),
              ],
            ),
            body: _buildBody(context, state, targetUid, isCurrentUserProfile),
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ProfileState state,
    String? targetUid,
    bool isCurrentUserProfile,
  ) {
    // ✅ إضافة معالجة للحالة الأولية
    if (state is ProfileInitial || state is ProfileLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (state is ProfileError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (targetUid != null) {
                  context.read<ProfileCubit>().loadProfile(targetUid);
                }
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Success state
    if (state is ProfileLoaded) {
      return RefreshIndicator(
        onRefresh: () async {
          if (targetUid != null) {
            await context.read<ProfileCubit>().loadProfile(targetUid);
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              ProfileHeader(isCurrentUserProfile: isCurrentUserProfile),
              const SizedBox(height: 20),
              AboutMeSection(),
              const SizedBox(height: 16),
              SkillsSection(),
              const SizedBox(height: 16),
              EducationSection(),
              const SizedBox(height: 16),
              LanguagesSection(),
              const SizedBox(height: 16),
              WorkExperienceSection(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      );
    }

    // Fallback للدول الأخرى
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }
}