import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linkedin/core/theme/app_colors.dart';
import 'package:linkedin/features/profile/data/models/profile_model.dart';
import 'package:linkedin/features/profile/logic/profile_cubit/profile_cubit.dart';

class EducationSection extends StatelessWidget {
  const EducationSection({super.key});

  Future<void> _editEducation(BuildContext context, Education current) async {
    final universityController = TextEditingController(
      text: current.university,
    );
    final yearController = TextEditingController(text: current.year);
    final degreeController = TextEditingController(text: current.degree);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Edit Education',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: universityController,
              decoration: const InputDecoration(
                labelText: 'University',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: yearController,
              decoration: const InputDecoration(
                labelText: 'Graduation Year',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: degreeController,
              decoration: const InputDecoration(
                labelText: 'Degree',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () async {
                final uid = FirebaseAuth.instance.currentUser?.uid;
                if (uid != null) {
                  final newEducation = Education(
                    university: universityController.text.trim(),
                    year: yearController.text.trim(),
                    degree: degreeController.text.trim(),
                  );
                  await context.read<ProfileCubit>().updateEducation(
                    uid,
                    newEducation,
                  );
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
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
        if (state is! ProfileSuccess) return const SizedBox();

        final education = state.profile.education;

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
                  const Icon(Icons.school_outlined, color: AppColors.primary),
                  const SizedBox(width: 8),
                  const Text(
                    'Education',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.primary),
                    onPressed: () => _editEducation(context, education),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (education.university.isNotEmpty) ...[
                Text(
                  education.university,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  education.degree,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  'Graduation Year: ${education.year}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ] else
                const Text(
                  'Add your education details',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
            ],
          ),
        );
      },
    );
  }
}
