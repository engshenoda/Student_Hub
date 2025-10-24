import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      final user = await createAuthViewModel!.register(
        createAuthViewModel!.emailController.text.trim(),
        createAuthViewModel!.passwordController.text.trim(),
      );
      emit(SignUpSuccsessState(user));
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
    } catch (e) {
      emit(LoginFailureState('Login failed: ${e.toString()}'));
    }
  }

  final ForgetPasswordViewModel? forgetPasswordViewModel;

  Future<void> resetPassword() async {
    emit(ResetPasswordLoadingState());
    try {
      final email = forgetPasswordViewModel!.emailController.text.trim();
      if (email.isEmpty) {
        emit(ResetPasswordFailureState("Please enter your email."));
        return;
      }
      await forgetPasswordViewModel!.resetPassword(email);
      emit(
        ResetPasswordSuccessState("Password reset email sent successfully!"),
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
}
