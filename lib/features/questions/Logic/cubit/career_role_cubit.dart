// import 'package:bloc/bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:linkedin/features/questions/Model/career_jobTitle.dart';

// class CareerjobTitleCubit extends Cubit<String?> {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final String collectionPath = "career_jobTitles";

//   CareerjobTitleCubit() : super(null);

//   Future<void> fetchCareerjobTitle(String userId) async {
//     try {
//       final doc = await firestore.collection(collectionPath).doc(userId).get();
//       if (doc.exists && doc.data() != null) {
//         final model = CareerjobTitleModel.fromMap(doc.data()!);
//         emit(model.selectedjobTitle);
//       } else {
//         emit(null);
//       }
//     } catch (_) {
//       emit(null);
//     }
//   }

//   Future<void> updateCareerjobTitle(String userId, String selectedjobTitle) async {
//     try {
//       final model = CareerjobTitleModel(
//         selectedjobTitle: selectedjobTitle,
//         lastUpdated: DateTime.now(),
//       );
//       await firestore
//           .collection(collectionPath)
//           .doc(userId)
//           .set(model.toMap(), SetOptions(merge: true));
//       emit(selectedjobTitle);
//     } catch (_) {}
//   }
// }
