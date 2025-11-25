import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// تحويل اسم الأيقونة لـ IconData
IconData getIconFromName(String? iconName) {
  switch (iconName) {
    case 'work_outline':
      return Icons.work_outline;
    case 'computer':
      return Icons.computer;
    case 'engineering':
      return Icons.engineering;
    case 'business':
      return Icons.business;
    case 'school':
      return Icons.school;
    default:
      return Icons.work_outline;
  }
}

// Model for Job (from Available Jobs screen)
class JobModel extends Equatable {
  final String id;
  final String title;
  final String company;
  final String? jobType; // Full-time, Part-time, etc.
  final double? salary;
  final String? description;
  final List<String>? requirements;
  final String? location;
  final String? iconName; // اسم الأيقونة كسلسلة
  final Timestamp createdAt;

  const JobModel({
    required this.id,
    required this.title,
    required this.company,
    this.jobType,
    this.salary,
    this.description,
    this.requirements,
    this.location,
    this.iconName,
    required this.createdAt,
  });

  /// تحويل البيانات من Firebase
  factory JobModel.fromJson(Map<String, dynamic> json, String id) {
    return JobModel(
      id: id,
      title: json['title'] ?? '',
      company: json['company'] ?? '',
      jobType: json['jobType'],
      salary: (json['salary'] != null) ? (json['salary'] as num).toDouble() : null,
      description: json['description'],
      requirements: json['requirements'] != null
          ? List<String>.from(json['requirements'])
          : null,
      location: json['location'],
      iconName: json['iconName'], // قراءة اسم الأيقونة من Firebase
      createdAt: json['createdAt'] != null
          ? json['createdAt'] as Timestamp
          : Timestamp.now(),
    );
  }

  /// تحويل البيانات لـ Firebase
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'company': company,
      'jobType': jobType,
      'salary': salary,
      'description': description,
      'requirements': requirements,
      'location': location,
      'iconName': iconName, // تخزين اسم الأيقونة
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  /// تحويل اسم الأيقونة لـ IconData عند العرض
  IconData get icon => getIconFromName(iconName);

  @override
  List<Object?> get props => [
        id,
        title,
        company,
        jobType,
        salary,
        description,
        requirements,
        location,
        iconName,
        createdAt,
      ];
}

// Model for JobApplication (from Apply for Job screen)
class JobApplication extends Equatable {
  final String id;
  final String jobId;             // الوظيفة اللي بيقدم عليها
  final String fullName;
  final String email;
  final String phone;
  final String yearsExperience;
  final String cvLink;
  final String? notes;
  final Timestamp appliedAt;

  const JobApplication({
    required this.id,
    required this.jobId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.yearsExperience,
    required this.cvLink,
    this.notes,
    required this.appliedAt,
  });

  factory JobApplication.fromJson(Map<String, dynamic> json, String id) {
    return JobApplication(
      id: id,
      jobId: json['jobId'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      yearsExperience: json['yearsExperience'] ?? '',
      cvLink: json['cvLink'] ?? '',
      notes: json['notes'],
      appliedAt: json['appliedAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jobId': jobId,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'yearsExperience': yearsExperience,
      'cvLink': cvLink,
      'notes': notes,
      'appliedAt': FieldValue.serverTimestamp(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        jobId,
        fullName,
        email,
        phone,
        yearsExperience,
        cvLink,
        notes,
        appliedAt,
      ];
}
