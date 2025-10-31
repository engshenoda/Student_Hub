import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkedin/features/questions/Model/career_role.dart';

class CareerRoleCubit extends Cubit<String?> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String collectionPath = "career_roles";

  CareerRoleCubit() : super(null);

  Future<void> fetchCareerRole(String userId) async {
    try {
      final doc = await firestore.collection(collectionPath).doc(userId).get();
      if (doc.exists && doc.data() != null) {
        final model = CareerRoleModel.fromMap(doc.data()!);
        emit(model.selectedRole);
      } else {
        emit(null);
      }
    } catch (_) {
      emit(null);
    }
  }

  Future<void> updateCareerRole(String userId, String selectedRole) async {
    try {
      final model = CareerRoleModel(
        selectedRole: selectedRole,
        lastUpdated: DateTime.now(),
      );
      await firestore
          .collection(collectionPath)
          .doc(userId)
          .set(model.toMap(), SetOptions(merge: true));
      emit(selectedRole);
    } catch (_) {}
  }
}
