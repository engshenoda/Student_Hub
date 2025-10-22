import 'package:flutter/material.dart';
import 'package:linkedin/features/profile/presentation/widgets/show_custom_bottom_sheet.dart';

class WorkExperienceSection extends StatelessWidget {
  const WorkExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final works = [
      {'title': 'Space war game', 'year': '2025'},
      {'title': 'Internship in ABC company', 'year': '2025'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Work experience and projects',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () {
                showCustomBottomSheet(
                  context: context,
                  title: 'Edit Work Experience',
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Project or Company Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Year',
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: works
              .map(
                (work) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    '${work['title']} (${work['year']})',
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
