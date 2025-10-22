import 'package:flutter/material.dart';
import 'package:linkedin/features/profile/presentation/widgets/show_custom_bottom_sheet.dart';

class EducationSection extends StatelessWidget {
  const EducationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Education',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () {
                showCustomBottomSheet(
                  context: context,
                  title: 'Edit Education',
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'University',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Department',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Graduation Year',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Menoufia National University\n2023\nBachelor’s Degree in Computer Science',
        ),
      ],
    );
  }
}
