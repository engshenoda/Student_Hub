import 'package:firebase_auth/firebase_auth.dart';
import 'package:linkedin/features/auth/data/models/auth_model.dart';

class AuthRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel> signUp(String email, String password) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return UserModel.fromFirebaseUser(result.user);
  }

  Future<UserModel> signIn(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return UserModel.fromFirebaseUser(result.user);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
