// import 'package:bloc/bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:linkedin/features/questions/Model/career_industry_model.dart';
// import 'package:meta/meta.dart';

// part 'career_industry_state.dart';

// class CareerIndustryCubit extends Cubit<CareerIndustryState> {
//   CareerIndustryCubit() : super(CareerIndustryInitial());

//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> loadSelectedIndustry(String userId) async {
//     emit(CareerIndustryLoading());
//     try {
//       final doc = await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('careerIndustry')
//           .doc('data')
//           .get();

//       if (doc.exists && doc.data() != null) {
//         final data = doc.data()!;
//         final careerIndustry = CareerIndustry.fromFirestore(data);

//         final selectedIndustry = careerIndustry.selectedOptions.isNotEmpty
//             ? careerIndustry.selectedOptions.first
//             : 'No selection';

//         emit(CareerIndustryLoaded(selectedIndustry));
//       } else {
//         emit(CareerIndustryLoaded('No selection'));
//       }
//     } catch (e) {
//       emit(CareerIndustryError('Failed to load data: $e'));
//     }
//   }

//   Future<void> updateSelectedIndustry(String userId, String newSelection) async {
//     emit(CareerIndustryLoading());
//     try {
//       final careerIndustry = CareerIndustry(
//         selectedOptions: [newSelection],
//         lastUpdated: DateTime.now(),
//       );

//       await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('careerIndustry')
//           .doc('data')
//           .set(careerIndustry.toFirestore(), SetOptions(merge: true));

//       emit(CareerIndustryLoaded(newSelection));
//     } catch (e) {
//       emit(CareerIndustryError('Failed to update data: $e'));
//     }
//   }

//   Future<void> clearSelection(String userId) async {
//     emit(CareerIndustryLoading());
//     try {
//       await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('careerIndustry')
//           .doc('data')
//           .delete();
//       emit(CareerIndustryLoaded('No selection'));
//     } catch (e) {
//       emit(CareerIndustryError('Failed to clear selection: $e'));
//     }
//   }
// }
