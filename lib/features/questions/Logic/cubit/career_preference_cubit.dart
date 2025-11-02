// import 'package:bloc/bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:linkedin/features/questions/Model/career_preference_model.dart';
// import 'package:meta/meta.dart';

// part 'career_preference_state.dart';

// class CareerPreferenceCubit extends Cubit<CareerPreferenceState> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   CareerPreferenceCubit() : super(CareerPreferenceInitial());

//   Future<void> fetchCareerPreference(String userId) async {
//     emit(CareerPreferenceLoading());
//     try {
//       final doc = await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('careerPreference')
//           .doc('data')
//           .get();

//       if (doc.exists && doc.data() != null) {
//         final model = CareerPreference.fromMap(doc.data()!);
//         emit(CareerPreferenceLoaded(model.selectedOption));
//       } else {
//         emit(CareerPreferenceLoaded(''));
//       }
//     } catch (e) {
//       emit(CareerPreferenceError('Failed to load career preference: $e'));
//     }
//   }

//   Future<void> updateCareerPreference(String userId, String selectedOption) async {
//     emit(CareerPreferenceUploading());
//     try {
//       final model = CareerPreference(
//         selectedOption: selectedOption,
//         lastUpdated: DateTime.now(),
//       );

//       await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('careerPreference')
//           .doc('data')
//           .set(model.toMap(), SetOptions(merge: true));

//       emit(CareerPreferenceLoaded(selectedOption));
//     } catch (e) {
//       emit(CareerPreferenceError('Failed to update career preference: $e'));
//     }
//   }

//   void resetState() {
//     emit(CareerPreferenceInitial());
//   }
// }
