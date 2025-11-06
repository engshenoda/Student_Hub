import 'package:linkedin/features/jobs/data/jobs_model.dart';

abstract class JobDetailsState {}

class JobDetailsInitial extends JobDetailsState {}

class JobDetailsLoading extends JobDetailsState {}

class JobDetailsLoaded extends JobDetailsState {
  final JobModel job;
  final bool isSaved;
  final bool isApplied;

  JobDetailsLoaded({
    required this.job,
    this.isSaved = false,
    this.isApplied = false,
  });

  JobDetailsLoaded copyWith({
    JobModel? job,
    bool? isSaved,
    bool? isApplied,
  }) {
    return JobDetailsLoaded(
      job: job ?? this.job,
      isSaved: isSaved ?? this.isSaved,
      isApplied: isApplied ?? this.isApplied,
    );
  }
}

class JobDetailsError extends JobDetailsState {
  final String message;
  JobDetailsError(this.message);
}
