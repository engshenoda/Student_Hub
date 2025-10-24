import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkedin/features/questions/Model/ProfileModel.dart';
import 'profile_state.dart';

class UserCubit extends Cubit<ProfileState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<DocumentSnapshot>? _userSubscription;

  UserCubit() : super(ProfileInitial());

  /// Start listening to Firestore user document in real-time
  Future<void> listenToUser(String userId) async {
    emit(ProfileLoading());
    _userSubscription?.cancel();

    try {
      _userSubscription = _firestore
          .collection('users')
          .doc(userId)
          .snapshots()
          .listen((doc) async {
        if (doc.exists && doc.data() != null) {
          emit(UserLoaded(UserModel.fromMap(userId, doc.data()!)));
        } else {
          // Create a new user if none exists
          final newUser = UserModel(
            id: userId,
            fullName: '',
            whatsapp: 0,
            role: '',
            degreeYear: '',
            minSalary: 0.0,
          );
          await _firestore.collection('users').doc(userId).set(newUser.toMap());
          emit(UserLoaded(newUser));
        }
      });
    } catch (e) {
      emit(UserError('Failed to listen: $e'));
    }
  }

  /// Update a single user field in Firestore
  Future<void> updateUserField(String field, String newValue, String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({field: newValue});
    } catch (e) {
      emit(UserError('Failed to update $field: $e'));
    }
  }

  /// Delete user document from Firestore
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
