import 'package:flutter/material.dart';
import 'package:linkedin/features/auth/data/auth_repo.dart';

class ForgetPasswordViewModel {
  final AuthRepo _authRepo;

  ForgetPasswordViewModel(this._authRepo);
  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
  }

  Future<void> resetPassword(String email) => _authRepo.resetPassword(email);
}
