import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linkedin/core/theme/app_colors.dart';
import 'package:linkedin/features/profile/logic/profile_cubit/profile_cubit.dart';

class LanguagesSection extends StatelessWidget {
  const LanguagesSection({super.key});

  Future<void> _editLanguages(
    BuildContext context,
    List<String> currentLanguages,
  ) async {
    final controller = TextEditingController();
    final tempLanguages = List<String>.from(currentLanguages);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Edit Languages',
                style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: tempLanguages
                    .map(
                      (lang) => Chip(
                        label: Text(lang),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () async {
                          final uid = FirebaseAuth.instance.currentUser?.uid;
                          if (uid != null) {
                            await context.read<ProfileCubit>().removeLanguage(
                              uid,
                              lang,
                            );
                            tempLanguages.remove(lang);
                          }
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        labelText: 'Add Language',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle,
                      color: AppColors.primary,
                    ),
                    onPressed: () async {
                      final newLang = controller.text.trim();
                      if (newLang.isNotEmpty) {
                        final uid = FirebaseAuth.instance.currentUser?.uid;
                        if (uid != null) {
                          await context.read<ProfileCubit>().addLanguage(
                            uid,
                            newLang,
                          );
                          controller.clear();
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is! ProfileSuccess) {
          return const SizedBox();
        }

        final languages = state.profile.languages;

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
                children: [
                  const Icon(Icons.language, color: AppColors.primary),
                  const SizedBox(width: 8),
                  const Text(
                    'Languages',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.primary),
                    onPressed: () => _editLanguages(context, languages),
                  ),
                ],
              ),
              if (languages.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: languages
                      .map(
                        (lang) => Chip(
                          label: Text(lang),
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          labelStyle: const TextStyle(color: AppColors.primary),
                        ),
                      )
                      .toList(),
                ),
              ] else
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Add languages you speak',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
