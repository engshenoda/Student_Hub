import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:linkedin/core/widgets/custom_bottom.dart';
import 'package:linkedin/core/widgets/custom_text_form_field.dart';
import 'package:linkedin/features/auth/logic/auth_cubit/auth_cubit.dart';
import 'package:linkedin/features/auth/presentation/screens/forget_password/forget_password_view_model.dart';

class ForgetPasswordForm extends StatelessWidget {
  const ForgetPasswordForm({
    super.key,
    required this.forgetPasswordViewModel,
    required this.isLoading,
  });
  final ForgetPasswordViewModel forgetPasswordViewModel;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {

    return Form(
      key: forgetPasswordViewModel.formKey,
      child: Column(
        children: [
          const SizedBox(height: 40),

          // Email
          CustomInputField(
            controller: forgetPasswordViewModel.emailController,
            label: "Email",
            hint: "Enter your email",
            validator: forgetPasswordViewModel.validateEmail,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 30),
          CustomBottom(
            title: isLoading ? "Loading..." : "Reset password",
            onPressed: isLoading
                ? null
                : () {
                    if (forgetPasswordViewModel.formKey.currentState!
                        .validate()) {
                          context.read<AuthCubit>().resetPassword();
                        }
                  },
          ),
        ],
      ),
    );
  }
}
