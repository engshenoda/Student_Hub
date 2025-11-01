import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linkedin/core/theme/app_colors.dart';
import 'package:linkedin/features/profile/logic/profile_cubit/profile_cubit.dart';
import 'package:linkedin/features/profile/presentation/widgets/show_custom_bottom_sheet.dart';

class AboutMeSection extends StatelessWidget {
  const AboutMeSection({super.key});

Future<void> _editAbout(BuildContext context, String currentAbout) async {
  final controller = TextEditingController(text: currentAbout);

  await showCustomBottomSheet(
    context: context,
    title: 'Edit About Me',
    children: [
      TextField(
        controller: controller,
        maxLines: 4,
        decoration: const InputDecoration(
          hintText: 'Write a few lines about yourself...',
          border: OutlineInputBorder(),
        ),
      ),
    ],
    onSaveAsync: () async {
      final newAbout = controller.text.trim();
      if (newAbout.isEmpty) return false;
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception('User not logged in');
      final ok = await context.read<ProfileCubit>().updateAbout(uid, newAbout);
      return ok;
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is! ProfileSuccess) return const SizedBox();

        final about = state.profile.aboutMe;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person_outline, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text(
                  'About me',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit, color: AppColors.primary),
                  onPressed: () => _editAbout(context, about),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              about.isEmpty ? 'Add something about yourself' : about,
              style: TextStyle(
                color: about.isEmpty ? Colors.grey : Colors.black87,
                fontSize: 14,
              ),
            ),
          ],
        );
      },
    );
  }
}
