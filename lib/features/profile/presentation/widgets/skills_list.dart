import 'package:flutter/material.dart';
import 'package:linkedin/features/profile/presentation/widgets/skill_chip.dart';

class Skillslist extends StatelessWidget {
  const Skillslist({super.key});

  @override
  Widget build(BuildContext context) {
    const skills = [
      'Flutter',
      'UI/UX designer',
      'Game developer',
      'Video editor',
      'C++',
      'C#',
      'Python',
      'Java',
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: skills.map((s) => SkillChip(label: s)).toList(),
    );
  }
}
