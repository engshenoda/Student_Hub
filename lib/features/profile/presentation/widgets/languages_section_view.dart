import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkedin/core/theme/app_colors.dart';
import 'package:linkedin/features/profile/logic/profile_cubit/profile_cubit.dart';

class LanguagesSectionView extends StatelessWidget {
  const LanguagesSectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is! ProfileSuccess) {
          return const SizedBox();
        }

        final languages = state.profile.languages; // <-- من Firebase

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
              Row(
                children: const [
                  Icon(Icons.language, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                    'Languages',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              
              if (languages.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: languages
                      .map(
                        (lang) => Chip(
                          label: Text(lang),
                          backgroundColor:
                              AppColors.primary.withOpacity(0.1),
                          labelStyle: const TextStyle(
                            color: AppColors.primary,
                          ),
                        ),
                      )
                      .toList(),
                )
              else
                const Text(
                  'No languages found.',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
            ],
          ),
        );
      },
    );
  }
}
