import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
  });

  factory UserModel.fromFirebaseUser(User? user) {
    if (user == null) {
      return UserModel(uid: '', email: '', name: '');
    }
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '', // لو كان عنده اسم من جوجل أو فيسبوك
    );
  }

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
    };
  }
}
