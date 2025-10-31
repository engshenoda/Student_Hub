import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:linkedin/features/profile/data/models/profile_model.dart';
import 'package:linkedin/features/profile/data/services/profile_firebase_service.dart';

/// Repository layer:
/// - Connects the Cubit/Logic with Firebase service
/// - Handles errors and data normalization
class ProfileRepo {
  final ProfileFirebaseService service;

  const ProfileRepo(this.service);

  /// Fetch profile data for a given [uid].
  Future<ProfileModel> fetchProfile(String uid) async {
    try {
      final profile = await service.getProfile(uid);
      return profile;
    } catch (e) {
      // You could log stack for debugging
      throw Exception('❌ Failed to fetch profile for $uid: $e');
    }
  }

  /// Update profile document with given [data].
  /// Returns the fresh updated model.
  Future<ProfileModel> updateProfile(
    String uid,
    Map<String, dynamic> data,
  ) async {
    try {
      final updated = await service.updateProfile(uid, data);
      return updated;
    } catch (e) {
      throw Exception('❌ Failed to update profile: $e');
    }
  }

  /// Upload avatar to Firebase Storage and update user document.
  /// Returns the public URL of the uploaded image.
Future<String> saveAvatar(String uid, File file) async {
  try {
    // نحاول نرفع الصورة إلى Firebase Storage
    final imageUrl = await service.uploadAvatar(uid, file);
    await service.updateProfile(uid, {'photoUrl': imageUrl});
    return imageUrl;
  } catch (e) {
    // في حالة الفشل نحفظها محلياً
    debugPrint('⚠️ Failed to upload avatar to Firebase: $e');
    final localPath = await service.saveAvatarLocally(uid, file);
    await service.updateProfile(uid, {'photoUrl': localPath});
    return localPath;
  }
}

}
