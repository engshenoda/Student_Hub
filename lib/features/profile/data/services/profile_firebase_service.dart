import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:linkedin/features/profile/data/models/profile_model.dart';

class ProfileFirebaseService {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final String collectionProfilePath;

  ProfileFirebaseService({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    this.collectionProfilePath = 'users',
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  DocumentReference<Map<String, dynamic>> _docRef(String uid) =>
      _firestore.collection(collectionProfilePath).doc(uid);

  /// 🔹 Get user profile
  Future<ProfileModel> getProfile(String uid) async {
    try {
      final doc = await _docRef(uid).get();
      if (!doc.exists) return ProfileModel.empty();
      final data = doc.data();
      if (data == null) throw Exception('Profile data is null for uid: $uid');
      return ProfileModel.fromMap(Map<String, dynamic>.from(data));
    } on FirebaseException catch (e) {
      throw Exception('Failed to get profile: ${e.message}');
    }
  }

  /// 🔹 Update user profile fields
  Future<ProfileModel> updateProfile(String uid, Map<String, dynamic> data) async {
    try {
      await _docRef(uid).set(data, SetOptions(merge: true));
      return await getProfile(uid);
    } on FirebaseException catch (e) {
      throw Exception('Failed to update profile: ${e.message}');
    }
  }

  /// 🔹 Upload avatar to Firebase Storage (if possible)
  /// If fails, fallback to local storage
 Future<String> uploadAvatar(String uid, File file) async {
  try {
    final ref = FirebaseStorage.instance.ref().child('avatars/$uid.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  } catch (e) {
    throw Exception('Failed to upload avatar: $e');
  }
}

  /// 🔹 Save avatar locally and return file path
  Future<String> saveAvatarLocally(String uid, File file) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final avatarDir = Directory('${dir.path}/avatars/$uid');

      // Create folder if not exists
      if (!(await avatarDir.exists())) {
        await avatarDir.create(recursive: true);
      }

      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}';
      final savedFile = await file.copy('${avatarDir.path}/$fileName');
      return savedFile.path;
    } catch (e) {
      throw Exception('Failed to save avatar locally: $e');
    }
  }
}
