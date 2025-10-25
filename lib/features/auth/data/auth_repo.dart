import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:linkedin/features/auth/data/models/auth_model.dart';

class AuthRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn  _googleSignIn = GoogleSignIn ();

  
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

  //  Google Sign-In
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
    return UserModel.fromFirebaseUser(userCredential.user);
  }

  //  Facebook Sign-In
  Future<UserModel> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status != LoginStatus.success) {
      throw Exception('Facebook sign-in failed');
    }

    final OAuthCredential credential =
        FacebookAuthProvider.credential(result.accessToken!.tokenString);

    final userCredential = await _auth.signInWithCredential(credential);
    return UserModel.fromFirebaseUser(userCredential.user);
  }

  //  Reset Password
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  //  Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await FacebookAuth.instance.logOut();
  }
}