import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkedin/core/theme/app_colors.dart';
import 'package:linkedin/core/theme/app_text_styles.dart';
import 'package:linkedin/features/profile/logic/profile_cubit/profile_cubit.dart';

class ProfileHeaderView extends StatelessWidget {
  const ProfileHeaderView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProfileSuccess) {
          final profile = state.profile;

          return Row(
            children: [
              ClipOval(
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  child: profile.photoUrl.isEmpty
                      ? const Icon(
                          Icons.person,
                          size: 40,
                          color: AppColors.primary,
                        )
                      : Image(
                          image: profile.photoUrl.startsWith('http')
                              ? NetworkImage(profile.photoUrl)
                              : FileImage(File(profile.photoUrl))
                                  as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name.isNotEmpty ? profile.name : 'No Name',
                      style: AppTextStyles.title,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.jobTitle.isNotEmpty
                          ? profile.jobTitle
                          : 'No Title',
                      style: AppTextStyles.subtitle,
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
