import 'package:flutter/material.dart';
import 'package:linkedin/features/profile/presentation/widgets/skill_chip.dart';

class Languageslist extends StatelessWidget {
  const Languageslist({super.key});

  @override
  Widget build(BuildContext context) {
    const langs = ['Arabic', 'English', 'French'];
    return Wrap(
      spacing: 8,
      children: langs.map((l) => SkillChip(label: l)).toList(),
    );
  }
}
