import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linkedin/core/theme/app_colors.dart';
import 'package:linkedin/features/profile/data/models/profile_model.dart';
import 'package:linkedin/features/profile/logic/profile_cubit/profile_cubit.dart';
import 'package:linkedin/features/profile/presentation/widgets/show_custom_bottom_sheet.dart';

class EducationSection extends StatelessWidget {
  const EducationSection({super.key});

Future<void> _editEducation(BuildContext context, Education current) async {
  final universityController = TextEditingController(text: current.university);
  final yearController = TextEditingController(text: current.year);
  final degreeController = TextEditingController(text: current.degree);

  await showCustomBottomSheet(
    context: context,
    title: 'Edit Education',
    children: [
      TextFormField(controller: universityController, decoration: const InputDecoration(labelText: 'University', border: OutlineInputBorder())),
      const SizedBox(height: 12),
      TextFormField(controller: yearController, decoration: const InputDecoration(labelText: 'Graduation Year', border: OutlineInputBorder()), keyboardType: TextInputType.number),
      const SizedBox(height: 12),
      TextFormField(controller: degreeController, decoration: const InputDecoration(labelText: 'Degree', border: OutlineInputBorder())),
    ],
    onSaveAsync: () async {
      final uni = universityController.text.trim();
      final year = yearController.text.trim();
      final deg = degreeController.text.trim();
      if (uni.isEmpty && year.isEmpty && deg.isEmpty) return false;
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception('User not logged in');
      final newEducation = Education(university: uni, year: year, degree: deg);
      final ok = await context.read<ProfileCubit>().updateEducation(uid, newEducation);
      return ok;
    },
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
