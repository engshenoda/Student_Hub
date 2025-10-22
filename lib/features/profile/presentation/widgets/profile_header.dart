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

  /// ✅ Safely load cached image
  Future<void> _loadImageFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final imagePath = prefs.getString(_imageKey);

      if (imagePath == null) return;

      final file = File(imagePath);
      final exists = await file.exists();

      if (exists) {
        setState(() {
          _profileImage = file;
        });
      } else {
        // ⚠ If cached image was deleted or moved, remove from cache
        await prefs.remove(_imageKey);
      }
    } catch (e) {
      debugPrint('⚠ Error loading cached image: $e');
    }
  }

  /// ✅ Pick image and save safely
  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage == null) return;

      final file = File(pickedImage.path);
      final prefs = await SharedPreferences.getInstance();

      // Save image path
      await prefs.setString(_imageKey, file.path);

      setState(() => _profileImage = file);
    } catch (e) {
      debugPrint('⚠ Error picking image: $e');

      // Optional: show error dialog to the user
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load image. Please try again.')),
        );
      }
    }
  }

  /// ✅ Reset image to default
  Future<void> _removeImage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_imageKey);
    setState(() => _profileImage = null);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ✅ Profile Image (with fallback)
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 3),
          ),
          child: ClipOval(
            child: _profileImage != null
                ? Image.file(
                    _profileImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // ✅ Handle corrupted or missing file gracefully
                      return _buildDefaultImage();
                    },
                  )
                : _buildDefaultImage(),
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
                const SizedBox(height: 8),

                // ✅ Remove image button
                TextButton.icon(
                  onPressed: _removeImage,
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  label: const Text('Remove Image', style: TextStyle(color: Colors.red)),
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

  /// ✅ Default fallback image widget
  Widget _buildDefaultImage() {
    return Image.asset(
      'assets/profile.jpg',
      fit: BoxFit.cover,
    );
  }
}
