import 'package:flutter/material.dart';
import 'package:linkedin/features/auth/data/auth_repo.dart';
import 'package:linkedin/features/auth/data/models/auth_model.dart';

class CreateAccountViewModel {
  final AuthRepo _authRepo;

  CreateAccountViewModel(this._authRepo);

  // Form Controllers & Keys
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Password Visibility
  // bool obscurePassword = true;
  // bool obscureConfirmPassword = true;


  // void togglePasswordVisibility() {
    
  //   obscurePassword = !obscurePassword;
  // }

  // void toggleConfirmPasswordVisibility() {
  //   obscureConfirmPassword = !obscureConfirmPassword;
  // }

  // Validation
  bool isValidPassword(String password) {
    final passwordRegex = RegExp(
      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$',
    );
    return passwordRegex.hasMatch(password);
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!value.contains('@')) return 'Invalid email address';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (!isValidPassword(value)) {
      return 'Must contain letters, numbers, and symbols';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Confirm your password';
    if (value != passwordController.text) return 'Passwords do not match';
    return null;
  }

  // Auth Logic (delegates to repo)

  Future<UserModel> register(String email, String password) =>
      _authRepo.signUp(email, password);

  Future<UserModel> login(String email, String password) =>
      _authRepo.signIn(email, password);



Future<UserModel> signUpWithGoogle() async {
    return await AuthRepo().signInWithGoogle();
  }

  Future<UserModel> signUpWithFacebook() async {
    return await _authRepo.signInWithFacebook();
  }



  // Cleanup

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
