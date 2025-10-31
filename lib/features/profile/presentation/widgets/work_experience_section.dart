import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linkedin/core/theme/app_colors.dart';
import 'package:linkedin/features/profile/data/models/profile_model.dart';
import 'package:linkedin/features/profile/logic/profile_cubit/profile_cubit.dart';

class WorkExperienceSection extends StatelessWidget {
  const WorkExperienceSection({super.key});

  void _showAddExperience(BuildContext context) {
    final titleController = TextEditingController();
    final yearController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
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
              'Add Experience',
              style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Job Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: yearController,
              decoration: const InputDecoration(
                labelText: 'Year',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () async {
                final title = titleController.text.trim();
                final year = yearController.text.trim();
                if (title.isNotEmpty && year.isNotEmpty) {
                  final uid = FirebaseAuth.instance.currentUser?.uid;
                  if (uid != null) {
                    final experience = Experience(title: title, year: year);
                    await context.read<ProfileCubit>().addExperience(
                      uid,
                      experience,
                    );
                    if (ctx.mounted) Navigator.pop(ctx);
                  }
                }
              },
              child: const Text(
                'Add Experience',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
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

        final experiences = state.profile.experiences;

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
                  const Icon(Icons.work_outline, color: AppColors.primary),
                  const SizedBox(width: 8),
                  const Text(
                    'Work Experience',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: AppColors.primary,
                    ),
                    onPressed: () => _showAddExperience(context),
                  ),
                ],
              ),
              if (experiences.isNotEmpty) ...[
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: experiences.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final exp = experiences[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        exp.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Text(
                        exp.year,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          // Show confirmation dialog
                          final shouldDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Experience'),
                              content: Text(
                                'Are you sure you want to delete "${exp.title}"?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (shouldDelete == true) {
                            final uid = FirebaseAuth.instance.currentUser?.uid;
                            if (uid != null && context.mounted) {
                              await context
                                  .read<ProfileCubit>()
                                  .removeExperience(uid, exp);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Experience deleted'),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    );
                  },
                ),
              ] else
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Add your work experience',
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
