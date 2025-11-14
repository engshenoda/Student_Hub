import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? username;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.username,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return UserModel(
      id: id ?? map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      username: map['username'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'username': username,
    };
  }
}


class JobModel {
  final String id;
  final String title;
  final String company;
  final String location;
  final String description;
  final DateTime? postedAt;

  JobModel({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.description,
    this.postedAt,
  });

  factory JobModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return JobModel(
      id: id ?? map['id'] ?? '',
      title: map['title'] ?? '',
      company: map['company'] ?? '',
      location: map['location'] ?? '',
      description: map['description'] ?? '',
      postedAt: map['postedAt'] != null
          ? (map['postedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'company': company,
      'location': location,
      'description': description,
      'postedAt': postedAt,
    };
  }
}
