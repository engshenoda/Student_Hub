import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin/core/routes/route.dart';
import 'package:linkedin/core/theme/app_colors.dart';
import 'package:linkedin/features/profile/data/repo/profile_repo.dart';
import 'package:linkedin/features/profile/data/services/profile_firebase_service.dart';
import 'package:linkedin/features/profile/logic/profile_cubit/profile_cubit.dart';
import 'package:linkedin/features/profile/presentation/widgets/about_me_section_view.dart';
import 'package:linkedin/features/profile/presentation/widgets/education_section_view.dart';
import 'package:linkedin/features/profile/presentation/widgets/languages_section_view.dart';
import 'package:linkedin/features/profile/presentation/widgets/profile_header_view.dart';
import 'package:linkedin/features/profile/presentation/widgets/skills_section_view.dart';
import 'package:linkedin/features/profile/presentation/widgets/work_experience_section_view.dart';


class ViewProfileScreen extends StatelessWidget {
  final String uid;
  final String? name;

  const ViewProfileScreen({
    super.key,
    required this.uid,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = ProfileCubit(ProfileRepo(ProfileFirebaseService()));
        // 🎯 تحميل بيانات الشخص المحدد فقط
        cubit.loadProfile(uid);
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
          // تحديد العنوان
          String appBarTitle = name ?? 'Profile';
          if (state is ProfileLoaded) {
            appBarTitle = state.user.name;
          }

          return Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                appBarTitle,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
               actions: [
                IconButton(
                  icon: const Icon(Icons.settings, color: AppColors.primary),
                  onPressed: () {
                    GoRouter.of(context).push(Routes.settings);
                  },
                ),
              ],
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                onPressed: () => Navigator.pop(context),
              ),
              // 🚫 لا توجد أزرار إعدادات أو تعديل
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
                context.read<ProfileCubit>().loadProfile(uid);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // 📊 عرض البيانات فقط - بدون إمكانية التعديل
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<ProfileCubit>().loadProfile(uid);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            // 👀 جميع الـ Widgets للعرض فقط
            ProfileHeaderView(),
            const SizedBox(height: 20),
            AboutMeSectionView(),
            const SizedBox(height: 16),
            SkillsSectionView(),
            const SizedBox(height: 16),
            EducationSectionView(),
            const SizedBox(height: 16),
            LanguagesSectionView(),
            const SizedBox(height: 16),
            WorkExperienceSectionView(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}