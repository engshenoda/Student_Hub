import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = ProfileCubit(ProfileRepo(ProfileFirebaseService()));
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) {
          cubit.loadProfile(uid);
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
          return Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                'Profile',
                style: TextStyle(
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
                IconButton(
                  icon: const Icon(Icons.refresh, color: AppColors.primary),
                  onPressed: () {
                    final uid = FirebaseAuth.instance.currentUser?.uid;
                    if (uid != null) {
                      context.read<ProfileCubit>().loadProfile(uid);
                    }
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
            body: _buildBody(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProfileState state) {
    if (state is ProfileLoading) {
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
                final uid = FirebaseAuth.instance.currentUser?.uid;
                if (uid != null) {
                  context.read<ProfileCubit>().loadProfile(uid);
                }
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Success state or initial state
    return RefreshIndicator(
      onRefresh: () async {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) {
          await context.read<ProfileCubit>().loadProfile(uid);
        }
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            // Remove const to allow rebuilding
            ProfileHeader(),
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
}
