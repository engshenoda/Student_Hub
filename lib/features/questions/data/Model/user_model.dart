import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String gender;
  final int whatsapp;
  final String jobTitle;
  final DateTime? birthday;
  final bool isClient;

  UserModel({
    required this.id,
    required this.gender,
    required this.whatsapp,
    required this.jobTitle,
    required this.birthday,
    required this.isClient,
  });

  factory UserModel.fromMap(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      gender: data['gender'] ?? '',
      whatsapp: data['whatsapp'] ?? 0,
      jobTitle: data['jobTitle'] ?? '',
      birthday: data['birthday'] != null
          ? (data['birthday'] is Timestamp
              ? (data['birthday'] as Timestamp).toDate()
              : DateTime.tryParse(data['birthday'].toString()))
          : null,
      isClient: data['isClient'] ?? true,
    );
  }

  Map<String, dynamic> toMap({bool forCreate = false}) {
    return {
      'gender': gender,
      'whatsapp': whatsapp,
      'jobTitle': jobTitle,
      'birthday': birthday != null ? Timestamp.fromDate(birthday!) : null,
      'isClient': isClient,
      if (forCreate) 'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
