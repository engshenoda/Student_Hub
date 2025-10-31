import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linkedin/core/theme/app_colors.dart';
import 'package:linkedin/features/profile/logic/profile_cubit/profile_cubit.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  Future<void> _editSkills(BuildContext context, List<String> currentSkills) async {
    final controller = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 16,
          right: 16,
          top: 20,
        ),
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit Skills',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),

                // قائمة الـ skills الحالية
                if (currentSkills.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: currentSkills
                        .map(
                          (skill) => Chip(
                            label: Text(skill),
                            deleteIcon: const Icon(Icons.close, size: 18),
                            onDeleted: () async {
                              final uid = FirebaseAuth.instance.currentUser?.uid;
                              if (uid != null) {
                                await context.read<ProfileCubit>().removeSkill(uid, skill);
                              }
                            },
                          ),
                        )
                        .toList(),
                  )
                else
                  const Text(
                    'No skills added yet.',
                    style: TextStyle(color: Colors.grey),
                  ),

                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          labelText: 'Add a skill',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: AppColors.primary, size: 30),
                      onPressed: () async {
                        final newSkill = controller.text.trim();
                        if (newSkill.isNotEmpty) {
                          final uid = FirebaseAuth.instance.currentUser?.uid;
                          if (uid != null) {
                            await context.read<ProfileCubit>().addSkill(uid, newSkill);
                            controller.clear();
                          }
                        }
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Done',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is! ProfileSuccess) return const SizedBox.shrink();

        final skills = state.profile.skills;

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
                  const Icon(Icons.lightbulb_outline, color: AppColors.primary),
                  const SizedBox(width: 8),
                  const Text(
                    'Skills',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.primary),
                    onPressed: () => _editSkills(context, skills),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (skills.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: skills
                      .map(
                        (skill) => Chip(
                          label: Text(skill),
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          labelStyle: const TextStyle(color: AppColors.primary),
                        ),
                      )
                      .toList(),
                )
              else
                const Text(
                  'Add your skills',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
            ],
          ),
        );
      },
    );
  }
}
