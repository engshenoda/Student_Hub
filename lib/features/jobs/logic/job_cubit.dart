import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkedin/features/jobs/data/repo/repo.dart';
import 'package:linkedin/features/jobs/data/job_model.dart';
part 'package:linkedin/features/jobs/logic/job_state.dart';

class JobCubit extends Cubit<JobState> {
  final JobRepository _repository = JobRepository();

  JobCubit() : super(JobInitial());

  // جلب كل الوظائف من Firebase
  Future<void> fetchJobs() async {
    emit(JobLoading());
    try {
      final jobs = await _repository.getAllJobs();
      emit(JobLoaded(jobs));
    } catch (e) {
      emit(JobError(e.toString()));
    }
  }

  // إرسال تقديم جديد
  Future<void> applyForJob(JobApplication application) async {
    emit(ApplyLoading());
    try {
      await _repository.submitApplication(application);
      emit(ApplySuccess());
    } catch (e) {
      emit(ApplyError(e.toString()));
    }
  }

  // إضافة وظيفة جديدة مع دعم أيقونة
  Future<void> addJob({
    required String title,
    required String company,
    String? jobType,
    double? salary,
    String? description,
    List<String>? requirements,
    String? location,
    String? iconName, // 🔹 اسم الأيقونة
  }) async {
    emit(JobLoading());
    try {
      await _repository.addJob(
        title: title,
        company: company,
        jobType: jobType,
        salary: salary,
        description: description,
        requirements: requirements,
        location: location,
        iconName: iconName, // 🔹 إرسال اسم الأيقونة للمستودع
      );

      await fetchJobs(); // لتحديث القائمة مباشرة بعد الإضافة
    } catch (e) {
      emit(JobError(e.toString()));
    }
  }

  // حذف وظيفة
  Future<void> removeJob(String jobId) async {
    emit(JobLoading());
    try {
      await _repository.deleteJob(jobId);
      await fetchJobs(); // تحديث الليست بعد الحذف
    } catch (e) {
      emit(JobError(e.toString()));
    }
  }

  // إعادة حالة الـ apply بعد Success أو Error
  void resetApplyState() {
    if (state is ApplySuccess || state is ApplyError) {
      emit(JobLoaded((state as dynamic).jobs ?? []));
    }
  }
}
