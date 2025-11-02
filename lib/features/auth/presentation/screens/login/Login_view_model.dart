// auth_view_model.dart
import 'package:flutter/material.dart';
import 'package:linkedin/features/auth/data/auth_repo.dart';
import 'package:linkedin/features/auth/data/models/auth_model.dart';

class LoginViewModel {
  final AuthRepo _authRepo;

  LoginViewModel(this._authRepo);

  // Form Controllers & Keys
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Password Visibility
  bool obscurePassword = true;

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
  }

  // Validation
  bool isValidPassword(String password) {
    final passwordRegex =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$');
    return passwordRegex.hasMatch(password);
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!value.contains('@')) return 'Invalid email address';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (!isValidPassword(value)) return 'Must contain letters, numbers, and symbols';
    return null;
  }

  // Auth Logic
  Future<UserModel> login(String email, String password) =>
    _authRepo.signIn(email, password);


  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
