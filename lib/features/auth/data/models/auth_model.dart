import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String email;

  UserModel({required this.uid, required this.email});

  factory UserModel.fromFirebaseUser(User? user) {
    if (user == null) {
      return UserModel(uid: '', email: '');
    }

    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
    );
  }

  // 👇 لو هتستخدمها لما تجيب بيانات المستخدم من Firestore:
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
    };
  }
}

