import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linkedin/core/constant/constant_collections.dart';
import 'package:linkedin/features/questions/data/Model/ProfileModel.dart';
import 'profile_state.dart';

class UserCubit extends Cubit<ProfileState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<DocumentSnapshot>? _userSubscription;

  UserCubit() : super(ProfileInitial());

  final String _collectionPath = ConstantCollections.users;

  /// 🔹 الاستماع لبيانات المستخدم وتحديثها في الوقت الحقيقي
  Future<void> listenToUser(String userId) async {
    emit(ProfileLoading());
    _userSubscription?.cancel();

    try {
      _userSubscription = _firestore
          .collection(_collectionPath)
          .doc(userId)
          .snapshots()
          .listen((doc) async {
            if (doc.exists && doc.data() != null) {
              emit(UserLoaded(UserModel.fromMap(userId, doc.data()!)));
            } else {
              // إنشاء مستخدم جديد في حالة عدم وجوده
              final firebaseUser = FirebaseAuth.instance.currentUser;

              final newUser = UserModel(
                id: userId,
                fullName: firebaseUser?.displayName ?? '',
                whatsapp: 0,
                role: '',
                degreeYear: '',
                minSalary: 0.0,
              );

              await _firestore.collection('users').doc(userId).set({
                ...newUser.toMap(forCreate: true),
                'email': firebaseUser?.email,
                'uid': firebaseUser?.uid,
              }, SetOptions(merge: true));

              emit(UserLoaded(newUser));
            }
          });
    } catch (e) {
      emit(UserError('Failed to listen: $e'));
    }
  }

  /// 🔹 تحديث أي حقل للمستخدم في Firestore
  Future<void> updateUserField({
    required String userId,
    required String field,
    required dynamic newValue,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        field: newValue,
      });
    } catch (e) {
      emit(UserError('Failed to update $field: $e'));
    }
  }

  /// 🔹 حذف بيانات المستخدم من Firestore
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
      emit(ProfileInitial());
    } catch (e) {
      emit(UserError('Delete failed: $e'));
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
