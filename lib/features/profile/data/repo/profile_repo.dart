import 'package:linkedin/features/profile/data/models/profile_model.dart';
import 'package:linkedin/features/profile/data/services/profile_firebase_service.dart';

class ProfileRepo {
  final ProfileFirebaseService service;
  ProfileRepo(this.service);

  Future<ProfileModel> fetchProfile(String uid) async {
    return await service.getProfile(uid);
  }

  Future<ProfileModel> updateProfile(
    String uid,
    Map<String, dynamic> data,
  ) async {
    return await service.updateProfile(uid, data);
  }
}

// lib/
//  └── features/
//      └── profile/
//          ├── data/
//          │    ├── models/
//          │    │     └── profile_model.dart
//          │    ├── sources/
//          │    │     └── profile_firebase_service.dart
//          │    └── repository/
//          │          └── profile_repo.dart
//          │
//          ├── logic/
//          │    └── cubit/
//          │          ├── profile_cubit.dart
//          │          └── profile_state.dart
//          │
//          └── presentation/
//               ├── screens/
//               │     └── profile_screen.dart
//               └── widgets/
//                     ├── about_me_section.dart
//                     ├── education_section.dart
//                     ├── languages_section.dart
//                     ├── profile_header.dart
//                     ├── show_custom_bottom_sheet.dart
//                     ├── skills_section.dart
//                     └── work_experience_section.dart
