import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkedin/core/constant/constant_collections.dart';
import 'package:linkedin/features/auth/data/auth_repo.dart';
import 'package:linkedin/features/auth/data/models/auth_model.dart';
import 'package:linkedin/features/auth/presentation/screens/create_account/create_account_view_model.dart';
import 'package:linkedin/features/auth/presentation/screens/forget_password/forget_password_view_model.dart';
import 'package:linkedin/features/auth/presentation/screens/login/Login_view_model.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthCubitState> {
  AuthCubit({
    this.createAuthViewModel,
    this.loginauthAuthViewModel,
    this.forgetPasswordViewModel,
  }) : super(AuthInitial());
  final CreateAccountViewModel? createAuthViewModel;
  final LoginViewModel? loginauthAuthViewModel;
  final AuthRepo _authRepo = AuthRepo();
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    emit(
      AuthPasswordVisibilityChanged(
        obscurePassword: obscurePassword,
        obscureConfirmPassword: obscureConfirmPassword,
      ),
    );
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword = !obscureConfirmPassword;
    emit(
      AuthPasswordVisibilityChanged(
        obscurePassword: obscurePassword,
        obscureConfirmPassword: obscureConfirmPassword,
      ),
    );
  }

  Future<void> register() async {
    emit(SignUpLoadingState());
    try {
      // if (email.isEmpty || password.isEmpty) {
      //   emit(LoginFailureState("Please fill in all fields."));
      //   return;
      // }
      final user = await _authRepo.signUp(
        email: createAuthViewModel!.emailController.text.trim(),
        password: createAuthViewModel!.passwordController.text.trim(),
        fullName: createAuthViewModel!.nameController.text.trim(),
      );
      await FirebaseFirestore.instance
          .collection(ConstantCollections.users)
          .doc(user.uid)
          .set({
            'uid': user.uid,
            'email': user.email,
            'name': createAuthViewModel!.nameController.text.trim(),
            'createdAt': FieldValue.serverTimestamp(),
          });

      emit(SignUpSuccsessState(user));
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password is too weak.';
          break;
        case 'email-already-in-use':
          errorMessage = 'This email is already in use.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format.';
          break;
        default:
          errorMessage = 'An unexpected error occurred. Please try again.';
      }
      emit(SignUpFailureState(errorMessage));
    } catch (e) {
      emit(SignUpFailureState('Registration failed: ${e.toString()}'));
    }
  }

  Future<void> login() async {
    emit(LoginLoadingState());
    try {
      final user = await loginauthAuthViewModel!.login(
        loginauthAuthViewModel!.emailController.text.trim(),
        loginauthAuthViewModel!.passwordController.text.trim(),
      );
      emit(LoginSuccsessState(user));
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        default:
          errorMessage = 'An unexpected error occurred during login.';
      }
      emit(LoginFailureState(errorMessage));
      print("FirebaseAuthException code: ${e.code}, message: ${e.message}");
    } catch (e) {
      emit(LoginFailureState('Login failed: ${e.toString()}'));
    }
  }

  final ForgetPasswordViewModel? forgetPasswordViewModel;

  Future<void> resetPassword() async {
    emit(ResetPasswordLoadingState());
    try {
      if (forgetPasswordViewModel == null) {
        emit(ResetPasswordFailureState("ViewModel not initialized."));
        return;
      }
      final email = forgetPasswordViewModel!.emailController.text.trim();
      if (email.isEmpty) {
        emit(ResetPasswordFailureState("Please enter your email."));
        return;
      }
      await forgetPasswordViewModel!.resetPassword(email);
      emit(
        ResetPasswordSuccessState(
          "Password reset link has been sent to $email",
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = "No user found with this email.";
          break;
        case 'invalid-email':
          message = "Invalid email address.";
          break;
        default:
          message = "An error occurred. Please try again.";
      }
      emit(ResetPasswordFailureState(message));
    } catch (e) {
      emit(ResetPasswordFailureState(e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(GoogleLoginLoadingState());
    try {
      final user = await AuthRepo().signInWithGoogle();
      emit(GoogleLoginSuccessState(user));
    } catch (e) {
      emit(GoogleLoginFailureState(e.toString()));
    }
  }

  Future<void> signInWithFacebook() async {
    emit(FacebookLoginLoadingState());
    try {
      final user = await AuthRepo().signInWithFacebook();
      emit(FacebookLoginSuccessState(user));
    } catch (e) {
      emit(FacebookLoginFailureState(e.toString()));
    }
  }
}
