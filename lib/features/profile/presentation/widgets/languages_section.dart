import 'package:flutter/material.dart';
import 'package:linkedin/features/profile/presentation/widgets/show_custom_bottom_sheet.dart';

class LanguagesSection extends StatefulWidget {
  const LanguagesSection({super.key});

  @override
  State<LanguagesSection> createState() => _LanguagesSectionState();
}

class _LanguagesSectionState extends State<LanguagesSection> {
  final List<String> _languages = ['Arabic', 'English', 'French'];
  final Set<String> _selectedLanguages = {}; // ✅ store selected languages
  final TextEditingController _newLangController = TextEditingController();

  @override
  void dispose() {
    _newLangController.dispose();
    super.dispose();
  }

  void _toggleLanguage(String lang) {
    setState(() {
      if (_selectedLanguages.contains(lang)) {
        _selectedLanguages.remove(lang);
      } else {
        _selectedLanguages.add(lang);
      }
    });
  }

  void _showEditSheet(BuildContext context) {
    showCustomBottomSheet(
      context: context,
      title: 'Edit Languages',
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _languages.map((lang) {
            final isSelected = _selectedLanguages.contains(lang);
            return FilterChip(
              label: Text(lang),
              selected: isSelected,
              onSelected: (_) => _toggleLanguage(lang),
              selectedColor: Colors.blue.shade100,
              checkmarkColor: Colors.blue,
              backgroundColor: Colors.grey.shade200,
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _newLangController,
          decoration: const InputDecoration(
            labelText: 'Add new language',
            border: OutlineInputBorder(),
          ),
          onFieldSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              setState(() {
                _languages.add(value.trim());
              });
              _newLangController.clear();
            }
          },
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            final newLang = _newLangController.text.trim();
            if (newLang.isNotEmpty) {
              setState(() {
                _languages.add(newLang);
                _newLangController.clear();
              });
            }
          },
          child: const Text('Add Language'),
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
                'Languages',
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
          children: _languages.map((lang) {
            final isSelected = _selectedLanguages.contains(lang);
            return ChoiceChip(
              label: Text(lang),
              selected: isSelected,
              onSelected: (_) => _toggleLanguage(lang),
              selectedColor: Colors.blue.shade100,
              checkmarkColor: Colors.blue,
              backgroundColor: Colors.grey.shade200,
              labelStyle: TextStyle(
                color: isSelected ? Colors.blue : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
