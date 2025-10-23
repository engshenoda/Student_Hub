import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linkedin/features/auth/data/models/auth_model.dart';
import 'package:linkedin/features/auth/presentation/screens/create_account/auth_view_model.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthCubitState> {
  AuthCubit(this.authViewModel) : super(AuthInitial());
  final AuthViewModel authViewModel;

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
    emit(AuthLoadingState());
    try {
      final user = await authViewModel.register(
        authViewModel.emailController.text.trim(),
        authViewModel.passwordController.text.trim(),
      );
      emit(AuthSuccsessState(user));
    } on FirebaseAuthException catch (e) {
      print("🔥 Firebase Error Code: ${e.code}");
      print("🔥 Firebase Message: ${e.message}");
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
      emit(AuthFailureState(errorMessage));
    } catch (e) {
      emit(AuthFailureState('Registration failed: ${e.toString()}'));
    }
  }

  Future<void> login() async {
    emit(AuthLoadingState());
    try {
      final user = await authViewModel.login(
        authViewModel.emailController.text.trim(),
        authViewModel.passwordController.text.trim(),
      );
      emit(AuthSuccsessState(user));
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
      emit(AuthFailureState(errorMessage));
    } catch (e) {
      emit(AuthFailureState('Login failed: ${e.toString()}'));
    }
  }
}
