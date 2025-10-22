import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:linkedin/core/theme/app_colors.dart';
import 'package:linkedin/core/theme/app_text_styles.dart';
import 'package:linkedin/features/profile/presentation/widgets/show_custom_bottom_sheet.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  File? _profileImage;
  final String _imageKey = 'profile_image_path';

  @override
  void initState() {
    super.initState();
    _loadImageFromCache();
  }

  /// ✅ Load the saved image path when the widget is initialized
  Future<void> _loadImageFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString(_imageKey);
    if (imagePath != null && File(imagePath).existsSync()) {
      setState(() {
        _profileImage = File(imagePath);
      });
    }
  }

  /// ✅ Pick image from gallery and save to cache
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final file = File(pickedImage.path);
      setState(() {
        _profileImage = file;
      });

      // Save image path in cache
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_imageKey, file.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ✅ Profile image container
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 3),
            image: DecorationImage(
              image: _profileImage != null
                  ? FileImage(_profileImage!) as ImageProvider
                  : const AssetImage('assets/profile.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('shenoda ashraf', style: AppTextStyles.heading1),
              SizedBox(height: 6),
              Text('UI / UX Designer', style: AppTextStyles.heading2),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            showCustomBottomSheet(
              context: context,
              title: 'Edit Profile',
              children: [
                // ✅ Image picker button
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Change Profile Picture'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),

                // ✅ Name field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                // ✅ Job title field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Job Title',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            );
          },
          icon: const Icon(Icons.edit, color: AppColors.primary),
        ),
      ],
    );
  }
}
