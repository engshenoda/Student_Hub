import 'package:flutter/material.dart';
import 'package:linkedin/core/theme/app_colors.dart';
import 'package:linkedin/features/profile/presentation/widgets/show_custom_bottom_sheet.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  final List<String> _skills = [
    'Flutter',
    'UI/UX designer',
    'Game developer',
    'C++',
    'Python',
  ];

  final Set<String> _selectedSkills = {}; // ✅ store selected skills
  final TextEditingController _newSkillController = TextEditingController();

  @override
  void dispose() {
    _newSkillController.dispose();
    super.dispose();
  }

  void _toggleSkill(String skill) {
    setState(() {
      if (_selectedSkills.contains(skill)) {
        _selectedSkills.remove(skill);
      } else {
        _selectedSkills.add(skill);
      }
    });
  }

  void _showEditSheet(BuildContext context) {
    showCustomBottomSheet(
      context: context,
      title: 'Edit Skills',
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _skills.map((skill) {
            final isSelected = _selectedSkills.contains(skill);
            return FilterChip(
              label: Text(skill),
              selected: isSelected,
              onSelected: (_) => _toggleSkill(skill),
              selectedColor: AppColors.primary.withOpacity(0.2),
              checkmarkColor: AppColors.primary,
              backgroundColor: Colors.grey.shade200,
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _newSkillController,
          decoration: const InputDecoration(
            labelText: 'Add new skill',
            border: OutlineInputBorder(),
          ),
          onFieldSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              setState(() {
                _skills.add(value.trim());
              });
              _newSkillController.clear();
            }
          },
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            final newSkill = _newSkillController.text.trim();
            if (newSkill.isNotEmpty) {
              setState(() {
                _skills.add(newSkill);
                _newSkillController.clear();
              });
            }
          },
          child: const Text('Add Skill'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Skills',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () => _showEditSheet(context),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _skills.map((skill) {
            final isSelected = _selectedSkills.contains(skill);
            return ChoiceChip(
              label: Text(skill),
              selected: isSelected,
              onSelected: (_) => _toggleSkill(skill),
              selectedColor: AppColors.primary.withOpacity(0.2),
              checkmarkColor: AppColors.primary,
              backgroundColor: Colors.grey.shade200,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
