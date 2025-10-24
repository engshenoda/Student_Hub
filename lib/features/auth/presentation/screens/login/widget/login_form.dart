import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkedin/core/widgets/custom_bottom.dart';
import 'package:linkedin/core/widgets/custom_text_form_field.dart';
import 'package:linkedin/features/auth/logic/auth_cubit/auth_cubit.dart';
import 'package:linkedin/features/auth/presentation/screens/login/Login_view_model.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key, required this.viewModel});
  final LoginViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);

    return BlocBuilder<AuthCubit, AuthCubitState>(
      builder: (context, state) {
        final obscurePassword = authCubit.obscurePassword;

        return Form(
          key: viewModel.formKey,
          child: Column(
            children: [
              CustomInputField(
                controller: viewModel.emailController,
                label: "Email",
                hint: "Enter your email",
                validator: viewModel.validateEmail,
              ),
              CustomInputField(
                controller: viewModel.passwordController,
                label: "Password",
                hint: "Enter your password",
                isPassword: true,
                obscureText: obscurePassword,
                toggle: () => authCubit.togglePasswordVisibility(),
                validator: viewModel.validatePassword,
              ),
              CustomBottom(
                title: "Login",
                onPressed: () {
                  if (viewModel.formKey.currentState!.validate()) {
                    authCubit.login();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
