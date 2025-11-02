import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkedin/features/auth/data/models/auth_model.dart';

class AuthRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // 🔹 Email & Password Sign Up
  Future<UserModel> signUp(String email, String password, String name) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = result.user;

    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)); 
    }

    return UserModel.fromFirebaseUser(user);
  }

  // 🔹 Email & Password Sign In
  Future<UserModel> signIn(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = result.user;

    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'name': user.displayName ?? 'User',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    return UserModel.fromFirebaseUser(user);
  }

  // 🔹 Google Sign-In
  Future<UserModel> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Google sign-in cancelled');

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user;

    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'name': user.displayName ?? 'No Name',
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    return UserModel.fromFirebaseUser(user);
  }

  // 🔹 Facebook Sign-In
  Future<UserModel> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status != LoginStatus.success) {
      throw Exception('Facebook sign-in failed');
    }

    final OAuthCredential credential =
        FacebookAuthProvider.credential(result.accessToken!.tokenString);

    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user;

    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'name': user.displayName ?? 'No Name',
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    return UserModel.fromFirebaseUser(user);
  }

  // 🔹 Reset Password
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // 🔹 Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await FacebookAuth.instance.logOut();
  }
}
