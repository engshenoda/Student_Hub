import 'package:flutter/material.dart';
import 'package:linkedin/core/theme/app_colors.dart';
import 'package:linkedin/features/profile/presentation/widgets/custom_button_profile.dart';

Future<void> showCustomBottomSheet({
  required BuildContext context,
  required String title,
  required List<Widget> children,
  VoidCallback? onSave,
  bool isSaving = false,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              ...children,
              const SizedBox(height: 24),
              CustomButton(
                text: 'Save',
                isLoading: isSaving,
                onPressed: onSave ?? () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      );
    },
  );
}
