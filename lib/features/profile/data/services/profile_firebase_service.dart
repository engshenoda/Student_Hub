import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkedin/features/profile/data/models/profile_model.dart';

class ProfileFirebaseService {
  final _fireStore = FirebaseFirestore.instance;

  final String collectionProfilePath = 'users';

  Future<ProfileModel> getProfile(String uid) async {
    final doc = await _fireStore
        .collection(collectionProfilePath)
        .doc(uid)
        .get();
    return ProfileModel.fromMap(doc.data()!);
  }

  Future updateProfile(String uid, Map<String, dynamic> data) async {
    await _fireStore.collection(collectionProfilePath).doc(uid).update(data);
  }
}
