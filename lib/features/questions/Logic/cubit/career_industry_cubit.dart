import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Model/career_industry_model.dart';

part 'career_industry_state.dart';

class CareerIndustryCubit extends Cubit<CareerIndustryState> {
  CareerIndustryCubit() : super(CareerIndustryInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'career_industry';
  final String _documentId = 'user_selection';

  
  Future<void> loadSelectedIndustry() async {
    emit(CareerIndustryLoading());
    try {
      final doc = await _firestore
          .collection(_collectionPath)
          .doc(_documentId)
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        final careerIndustry = CareerIndustry.fromFirestore(data);

        final selectedIndustry = careerIndustry.selectedOptions.isNotEmpty
            ? careerIndustry.selectedOptions.first
            : 'No selection';

        emit(CareerIndustryLoaded(selectedIndustry));
      } else {
        emit(CareerIndustryLoaded('No selection'));
      }
    } catch (e) {
      emit(CareerIndustryError('Failed to load data: $e'));
    }
  }

  
  Future<void> updateSelectedIndustry(String newSelection) async {
    emit(CareerIndustryLoading());
    try {
      final careerIndustry = CareerIndustry(
        selectedOptions: [newSelection],
        lastUpdated: DateTime.now(),
      );

      await _firestore
          .collection(_collectionPath)
          .doc(_documentId)
          .set(careerIndustry.toFirestore(), SetOptions(merge: true));

      emit(CareerIndustryLoaded(newSelection));
    } catch (e) {
      emit(CareerIndustryError('Failed to update data: $e'));
    }
  }


  Future<void> clearSelection() async {
    emit(CareerIndustryLoading());
    try {
      await _firestore
          .collection(_collectionPath)
          .doc(_documentId)
          .delete();
      emit(CareerIndustryLoaded('No selection'));
    } catch (e) {
      emit(CareerIndustryError('Failed to clear selection: $e'));
    }
  }
}
