import 'package:flutter/material.dart';
import 'package:linkedin/features/auth/data/auth_repo.dart';

class ForgetPasswordViewModel {
  final AuthRepo _authRepo;

  ForgetPasswordViewModel(this._authRepo);
  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void dispose() {
    emailController.dispose();
  }

  //Validation logic here
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email";
    }
    if (!RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w]{2,4}$').hasMatch(value)) {
      return "Invalid email address";
    }
    return null;
  }

  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      throw Exception("Please enter your email address");
    }

    await _authRepo.resetPassword(email);
  }
}
