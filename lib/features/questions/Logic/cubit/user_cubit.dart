import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linkedin/features/questions/data/Model/user_model.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<DocumentSnapshot>? _userSubscription;

  UserCubit() : super(UserInitial());

  final String _collectionPath = 'users';

  Future<void> listenToUser(String userId) async {
    emit(UserLoading());
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
              final firebaseUser = FirebaseAuth.instance.currentUser;

              final newUser = UserModel(
                id: userId,
                gender: '',
                whatsapp: 0,
                jobTitle: '',
                birthday: null,
                isClient: true,
              );

              await _firestore.collection(_collectionPath).doc(userId).set({
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

  Future<void> updateUserField({
    required String userId,
    required String field,
    required dynamic newValue,
  }) async {
    try {
      dynamic valueToUpdate = newValue;
      if (field == 'birthday' && newValue is DateTime) {
        valueToUpdate = Timestamp.fromDate(newValue);
      }

      await _firestore.collection(_collectionPath).doc(userId).update({
        field: valueToUpdate,
      });
    } catch (e) {
      emit(UserError('Failed to update $field: $e'));
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
