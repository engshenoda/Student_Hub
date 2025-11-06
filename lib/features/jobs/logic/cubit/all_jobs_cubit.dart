import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkedin/features/jobs/data/jobs_model.dart';
import 'package:linkedin/features/jobs/logic/cubit/all_jobs_state.dart';
import 'package:linkedin/features/jobs/data/repo/jobs_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AllJobsCubit extends Cubit<AllJobsState> {
  final JobsRepository _repository;
  final FirebaseAuth _auth;
  StreamSubscription<List<JobModel>>? _jobsSubscription;

  AllJobsCubit({JobsRepository? repository, FirebaseAuth? auth})
      : _repository = repository ?? JobsRepository(),
        _auth = auth ?? FirebaseAuth.instance,
        super(AllJobsInitial());

  void loadJobs() {
    emit(AllJobsLoading());
    final uid = _auth.currentUser?.uid ?? '';
    
    _jobsSubscription?.cancel(); // إلغاء أي اشتراك سابق
    _jobsSubscription = _repository.getJobsStream(uid: uid).listen(
      (jobs) {
        emit(AllJobsLoaded(jobs));
      },
      onError: (e) {
        emit(AllJobsError('Failed to load jobs: $e', message: ''));
      },
    );
  }

  void searchJobs(String query) {
    emit(AllJobsLoading());
    final uid = _auth.currentUser?.uid ?? '';
    
    _jobsSubscription?.cancel();
    _jobsSubscription = _repository.searchJobsStream(query, uid: uid).listen(
      (jobs) {
        emit(AllJobsLoaded(jobs));
      },
      onError: (e) {
        emit(AllJobsError('Search failed: $e', message: ''));
      },
    );
  }

  @override
  Future<void> close() {
    _jobsSubscription?.cancel();
    return super.close();
  }
}
