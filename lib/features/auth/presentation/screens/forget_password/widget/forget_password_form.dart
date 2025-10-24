import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin/core/routes/route.dart';
import 'package:linkedin/core/widgets/custom_bottom.dart';
import 'package:linkedin/core/widgets/custom_text_form_field.dart';
import 'package:linkedin/features/auth/logic/auth_cubit/auth_cubit.dart';
import 'package:linkedin/features/auth/presentation/screens/forget_password/forget_password_view_model.dart';

class ForgetPasswordForm extends StatelessWidget {
  const ForgetPasswordForm({super.key, required this.forgetPasswordViewModel});
  final ForgetPasswordViewModel forgetPasswordViewModel;

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);

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
            validator: (value) {
              if (value == null || value.isEmpty)
                return "Please enter your email";
              if (!RegExp(
                r'^[\w\.\-]+@([\w\-]+\.)+[\w]{2,4}$',
              ).hasMatch(value)) {
                return "Email is invalid";
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
          ),
          CustomBottom(
            title: "Reset password",
            onPressed: () {
              authCubit.resetPassword();
            },
          ),
        ],
      ),
    );
  }
}
