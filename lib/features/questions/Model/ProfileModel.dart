import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String fullName;
  final int whatsapp;
  final String role;
  final String degreeYear;
  final double minSalary;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.fullName,
    required this.whatsapp,
    required this.role,
    required this.degreeYear,
    required this.minSalary,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromMap(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      fullName: data['fullName'] ?? '',
      whatsapp: (data['whatsapp'] is String)
          ? int.tryParse(data['whatsapp']) ?? 0
          : (data['whatsapp'] ?? 0),
      role: data['role'] ?? '',
      degreeYear: data['degreeYear'] ?? '',
      minSalary: data['minSalary'] == null
          ? 0.0
          : (data['minSalary'] is num)
              ? (data['minSalary'] as num).toDouble()
              : double.tryParse(data['minSalary'].toString()) ?? 0.0,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'whatsapp': whatsapp,
      'role': role,
      'degreeYear': degreeYear,
      'minSalary': minSalary,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
