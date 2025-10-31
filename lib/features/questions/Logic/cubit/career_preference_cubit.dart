import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkedin/features/questions/Model/career_preference_model.dart';
import 'package:meta/meta.dart';

part 'career_preference_state.dart';

class CareerPreferenceCubit extends Cubit<CareerPreferenceState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'career_preferences';

  CareerPreferenceCubit() : super(CareerPreferenceInitial());

  Future<void> fetchCareerPreference(String userId) async {
    emit(CareerPreferenceLoading());
    try {
      final doc = await _firestore.collection(_collectionPath).doc(userId).get();
      if (doc.exists && doc.data() != null) {
        final model = CareerPreference.fromMap(doc.data()!);
        emit(CareerPreferenceLoaded(model.selectedOption));
      } else {
        emit(CareerPreferenceLoaded(''));
      }
    } catch (e) {
      emit(CareerPreferenceError('Failed to load career preference'));
    }
  }

  Future<void> updateCareerPreference(String userId, String selectedOption) async {
    emit(CareerPreferenceUploading());
    try {
      final model = CareerPreference(
        selectedOption: selectedOption,
        lastUpdated: DateTime.now(),
      );
      await _firestore
          .collection(_collectionPath)
          .doc(userId)
          .set(model.toMap(), SetOptions(merge: true));
      emit(CareerPreferenceLoaded(selectedOption));
    } catch (e) {
      emit(CareerPreferenceError('Failed to update career preference'));
    }
  }

  void resetState() {
    emit(CareerPreferenceInitial());
  }
}
