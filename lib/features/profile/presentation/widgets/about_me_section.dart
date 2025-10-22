import 'package:flutter/material.dart';
import 'package:linkedin/features/profile/presentation/widgets/show_custom_bottom_sheet.dart';

class AboutMeSection extends StatelessWidget {
  const AboutMeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'About me',
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
                  title: 'Edit About Me',
                  children: [
                    TextFormField(
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'About Me',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Flutter and UI/UX design build good apps and interactive designs',
        ),
      ],
    );
  }
}
