import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:linkedin/features/auth/data/models/auth_model.dart';
import 'package:meta/meta.dart';
import 'package:linkedin/features/profile/data/models/profile_model.dart';
import 'package:linkedin/features/profile/data/repo/profile_repo.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo repo;

  ProfileCubit(this.repo) : super(ProfileInitial());

  /// تحميل الملف الشخصي
  Future<void> loadProfile(String uid) async {
    emit(ProfileLoading());
    try {
      final profile = await repo.fetchProfile(uid);
      emit(ProfileSuccess(profile));
    } catch (e) {
      emit(ProfileError('Failed to load profile: $e'));
    }
  }

  /// تحديث أي جزء من البروفايل وإعادة تحميله
  Future<bool> _updateAndReload(String uid, Map<String, dynamic> data) async {
    try {
      await repo.updateProfile(uid, data);
      await loadProfile(uid);
      return true;
    } catch (e) {
      emit(ProfileError('⚠️ فشل في تحديث الملف: $e'));
      return false;
    }
  }

  // 🧩 تحديث الـ About Me
  Future<bool> updateAbout(String uid, String about) =>
      _updateAndReload(uid, {'aboutMe': about});

  // 🧩 تحديث الاسم واللقب
  Future<bool> updateHeader(String uid, {String? name, String? title}) {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (title != null) data['title'] = title;
    return _updateAndReload(uid, data);
  }

  // 🎓 تحديث التعليم
  Future<bool> updateEducation(String uid, Education edu) =>
      _updateAndReload(uid, {'education': edu.toMap()});

  // 💪 إضافة مهارة
  Future<bool> addSkill(String uid, String skill) async {
    if (state is! ProfileSuccess) return false;
    final profile = (state as ProfileSuccess).profile;
    final newSkills = List<String>.from(profile.skills)..add(skill);
    return _updateAndReload(uid, {'skills': newSkills});
  }

  // ❌ حذف مهارة
  Future<bool> removeSkill(String uid, String skill) async {
    if (state is! ProfileSuccess) return false;
    final profile = (state as ProfileSuccess).profile;
    final newSkills = List<String>.from(profile.skills)..remove(skill);
    return _updateAndReload(uid, {'skills': newSkills});
  }

  // 🌍 اللغات
  Future<bool> addLanguage(String uid, String lang) async {
    if (state is! ProfileSuccess) return false;
    final profile = (state as ProfileSuccess).profile;
    final newLangs = List<String>.from(profile.languages)..add(lang);
    return _updateAndReload(uid, {'languages': newLangs});
  }

  Future<bool> removeLanguage(String uid, String lang) async {
    if (state is! ProfileSuccess) return false;
    final profile = (state as ProfileSuccess).profile;
    final newLangs = List<String>.from(profile.languages)..remove(lang);
    return _updateAndReload(uid, {'languages': newLangs});
  }

  // 🏢 الخبرات
  Future<bool> addExperience(String uid, Experience exp) async {
    if (state is! ProfileSuccess) return false;
    final profile = (state as ProfileSuccess).profile;
    final newExps = List<Experience>.from(profile.experiences)..add(exp);
    return _updateAndReload(uid, {'experiences': newExps.map((e) => e.toMap()).toList()});
  }

  Future<bool> removeExperience(String uid, Experience exp) async {
    if (state is! ProfileSuccess) return false;
    final profile = (state as ProfileSuccess).profile;
    final newExps = List<Experience>.from(profile.experiences)
      ..removeWhere((e) => e.title == exp.title && e.year == exp.year);
    return _updateAndReload(uid, {'experiences': newExps.map((e) => e.toMap()).toList()});
  }

  // 🖼️ تحديث الصورة (Firebase أو Local fallback)
  Future<bool> updateAvatar(String uid, File file) async {
    emit(ProfileLoading());
    try {
      final imageUrl = await repo.saveAvatar(uid, file);
      await repo.updateProfile(uid, {'photoUrl': imageUrl});
      await loadProfile(uid);
      return true;
    } catch (e) {
      emit(ProfileError('⚠️ فشل في رفع الصورة: $e'));
      return false;
    }
  }
}
