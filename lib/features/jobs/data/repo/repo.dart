// lib/repositories/job_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkedin/features/jobs/data/job_model.dart'; // تأكد إن الـ path ده صحيح عندك

class JobRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  static const String jobsCollection = 'jobs';
  static const String applicationsCollection = 'applications';

  // 1. جلب كل الوظايف (مرتبة من الأحدث)
  Future<List<JobModel>> getAllJobs() async {
    try {
      final querySnapshot = await _firestore
          .collection(jobsCollection)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return JobModel.fromJson(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      throw Exception('خطأ في جلب الوظايف: $e');
    }
  }

  // 2. إرسال تقديم جديد
  Future<void> submitApplication(JobApplication application) async {
    try {
      await _firestore.collection(applicationsCollection).add(application.toJson());
    } catch (e) {
      throw Exception('خطأ في إرسال التقديم: $e');
    }
  }

  // 3. حذف وظيفة حسب الـ id
  Future<void> deleteJob(String jobId) async {
    try {
      await _firestore.collection(jobsCollection).doc(jobId).delete();
    } catch (e) {
      throw Exception('خطأ في حذف الوظيفة: $e');
    }
  }

  // 4. إضافة وظيفة جديدة مع الحقول الكاملة بما فيها الأيقونة
  Future<void> addJob({
    required String title,
    required String company,
    String? jobType,
    double? salary,
    String? description,
    List<String>? requirements,
    String? location,
    String? iconName, // 🔹 دعم اختيار أيقونة
  }) async {
    try {
      await _firestore.collection(jobsCollection).add({
        'title': title,
        'company': company,
        'jobType': jobType ?? '',
        'salary': salary ?? 0.0,
        'description': description ?? '',
        'requirements': requirements ?? [],
        'location': location ?? '',
        'iconName': iconName ?? '', // 🔹 تخزين اسم الأيقونة
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('خطأ في إضافة الوظيفة: $e');
    }
  }
}
