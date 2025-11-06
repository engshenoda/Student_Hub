import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkedin/features/jobs/data/jobs_model.dart';
import 'package:linkedin/features/jobs/data/repo/jobs_repository.dart';
import 'job_details_state.dart';

class JobDetailsCubit extends Cubit<JobDetailsState> {

  JobDetailsCubit({JobsRepository? repository})
      : super(JobDetailsInitial());

  Future<void> loadJob(JobModel job) async {
    emit(JobDetailsLoaded(job: job));
  }

  void toggleSaveJob() {
    final stateCurrent = state;
    if (stateCurrent is JobDetailsLoaded) {
      emit(stateCurrent.copyWith(isSaved: !stateCurrent.isSaved));
    }
  }

  void applyForJob() {
    final stateCurrent = state;
    if (stateCurrent is JobDetailsLoaded) {
      emit(stateCurrent.copyWith(isApplied: true));
    }
  }
}
