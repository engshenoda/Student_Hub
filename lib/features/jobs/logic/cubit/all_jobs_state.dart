import 'package:linkedin/features/jobs/data/jobs_model.dart';

abstract class AllJobsState {}

class AllJobsInitial extends AllJobsState {}

class AllJobsLoading extends AllJobsState {}

class AllJobsLoaded extends AllJobsState {
  final List<JobModel> jobs;
  AllJobsLoaded(this.jobs);
}

class AllJobsError extends AllJobsState {
  final String message;
  AllJobsError(String s, {required this.message});
}
