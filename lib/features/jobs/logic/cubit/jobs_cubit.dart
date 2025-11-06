import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linkedin/features/jobs/data/jobs_model.dart';
import 'package:linkedin/features/jobs/data/repo/jobs_repository.dart';
import 'package:linkedin/features/jobs/logic/cubit/jobs_state.dart';

class JobsCubit extends Cubit<JobsState> {
  final JobsRepository _repository;
  final FirebaseAuth _auth;
  StreamSubscription<List<JobModel>>? _jobsSubscription;

  JobsCubit({
    JobsRepository? repository,
    FirebaseAuth? auth,
  })  : _repository = repository ?? JobsRepository(),
        _auth = auth ?? FirebaseAuth.instance,
        super(JobsInitial());

  /// 🔹 تحميل كل الوظائف الخاصة بالمستخدم الحالي (Real-time Stream)
  Future<void> fetchJobs() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      emit(const JobsError('⚠️ User not logged in'));
      return;
    }

    print("📡 Fetching jobs for UID: $uid");
    emit(JobsLoading());

    await _jobsSubscription?.cancel();
    _jobsSubscription = _repository.getJobsStream(uid: uid).listen(
      (jobs) {
        print("✅ Jobs loaded: ${jobs.length}");
        emit(JobsLoaded(jobs));
      },
      onError: (e) {
        print("❌ Error loading jobs: $e");
        emit(JobsError('Failed to load jobs: $e'));
      },
    );
  }

  /// 🔹 البحث عن الوظائف (Real-time)
  Future<void> searchJobs(String query) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      emit(const JobsError('⚠️ User not logged in'));
      return;
    }

    print("🔍 Searching for jobs with query: '$query'");

    // لو البحث فاضي، رجع كل الوظائف من غير تحميل جديد
    if (query.trim().isEmpty) {
      await fetchJobs();
      return;
    }

    await _jobsSubscription?.cancel();
    _jobsSubscription = _repository.searchJobsStream(query, uid: uid).listen(
      (jobs) {
        print("✅ Search result: ${jobs.length} jobs found");
        emit(JobsLoaded(jobs));
      },
      onError: (e) {
        print("❌ Error searching jobs: $e");
        emit(JobsError('Search failed: $e'));
      },
    );
  }

  /// 🔹 إضافة وظيفة جديدة + تحديث بعد الإضافة
  Future<void> addJob(JobModel job) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      emit(const JobsError('⚠️ User not logged in'));
      return;
    }

    print("🟢 Adding new job for UID: $uid");

    try {
      await _repository.addJob(job, uid: uid);
      print("🎯 Job added successfully, refreshing jobs list...");
      await fetchJobs(); // تحديث بعد الإضافة
    } catch (e) {
      print("❌ Failed to add job: $e");
      emit(JobsError('Failed to add job: $e'));
    }
  }

  /// 🔹 تنظيف الاشتراكات عند غلق الكيوبت
  @override
  Future<void> close() {
    print("🧹 Closing JobsCubit and cancelling stream subscription...");
    _jobsSubscription?.cancel();
    return super.close();
  }
}
