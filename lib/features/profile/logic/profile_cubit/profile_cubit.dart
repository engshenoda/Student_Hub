import 'package:bloc/bloc.dart';
import 'package:linkedin/features/profile/data/models/profile_model.dart';
import 'package:linkedin/features/profile/data/repo/profile_repo.dart';
import 'package:meta/meta.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this.repo) : super(ProfileInitial());

  final ProfileRepo repo;

  Future<void> loadProfile(String uid) async {
    emit(ProfileLoading());
    try {
      final profile = await repo.fetchProfile(uid);
      emit(ProfileSuccess(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateProfile(String uid, Map<String, dynamic> data) async {
    try {
      await repo.updateProfile(uid, data);
      await loadProfile(uid);
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
