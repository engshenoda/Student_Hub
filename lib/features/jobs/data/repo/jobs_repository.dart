import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkedin/features/jobs/data/jobs_model.dart';

class JobsRepository {
  final FirebaseFirestore _firestore;

  JobsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// 1️⃣ جلب كل الوظائف (Real-time Stream)
  Stream<List<JobModel>> getJobsStream({required String uid}) {
    try {
      return _firestore
          .collection('jobs')
          .where('uid', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => JobModel.fromMap(doc.data(), doc.id))
              .toList());
    } catch (e) {
      throw Exception('Error fetching jobs stream: $e');
    }
  }

  /// 2️⃣ البحث في الوظائف (Real-time Search Stream)
  Stream<List<JobModel>> searchJobsStream(String query, {required String uid}) {
    try {
      final lowerQuery = query.toLowerCase();
      return _firestore
          .collection('jobs')
          .where('uid', isEqualTo: uid)
          .snapshots()
          .map((snapshot) {
        final allJobs = snapshot.docs
            .map((doc) => JobModel.fromMap(doc.data(), doc.id))
            .toList();

        return allJobs.where((job) {
          final title = job.title.toLowerCase();
          final company = job.company.toLowerCase();
          final desc = job.description.toLowerCase();
          return title.contains(lowerQuery) ||
              company.contains(lowerQuery) ||
              desc.contains(lowerQuery);
        }).toList();
      });
    } catch (e) {
      throw Exception('Error searching jobs: $e');
    }
  }

  /// 3️⃣ جلب وظيفة معينة بالتفصيل (Real-time)
  Stream<JobModel> getJobByIdStream(String jobId, {required String uid}) {
    try {
      return _firestore.collection('jobs').doc(jobId).snapshots().map((doc) {
        if (!doc.exists) throw Exception('Job not found');
        final data = doc.data()!;
        if (data['uid'] != uid) throw Exception('Unauthorized access');
        return JobModel.fromMap(data, doc.id);
      });
    } catch (e) {
      throw Exception('Error fetching job details: $e');
    }
  }

  /// 4️⃣ إضافة وظيفة جديدة (مع ID + refresh)
  Future<void> addJob(JobModel job, {required String uid}) async {
    try {
      // اطبع UID للتأكد إن المستخدم داخل فعلاً
      print("✅ Adding job for user UID: $uid");

      // إضافة الوظيفة إلى Firestore
      final docRef = await _firestore.collection('jobs').add({
        'uid': uid,
        'title': job.title,
        'company': job.company,
        'salary': job.salary,
        'tags': job.tags,
        'description': job.description,
        'requirements': job.requirements,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // تحديث الـ id داخل المستند نفسه (اختياري)
      await _firestore.collection('jobs').doc(docRef.id).update({
        'id': docRef.id,
      });

      print("🎯 Job added successfully with id: ${docRef.id}");
    } catch (e) {
      print("❌ Error adding job: $e");
      throw Exception('Error adding job: $e');
    }
  }
}
