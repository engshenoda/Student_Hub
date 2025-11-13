import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin/core/routes/route.dart';
import 'package:linkedin/core/theme/app_colors.dart';
import 'package:linkedin/core/widgets/custom_bottom.dart';
import 'package:linkedin/core/widgets/custom_bottom_social_media.dart';
import 'package:linkedin/core/widgets/custom_text_form_field.dart';
import 'package:linkedin/features/auth/logic/auth_cubit/auth_cubit.dart';
import 'package:linkedin/features/auth/presentation/screens/create_account/create_account_screen.dart';
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
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    GoRouter.of(context).go(Routes.forgetpassword);
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              CustomBottom(
                title: "Login",
                onPressed: () {
                  if (viewModel.formKey.currentState!.validate()) {
                    authCubit.login();
                  }
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Or Login with"),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomBottomSocialMedia(
                    icon: Icons.facebook,
                    color: Colors.blue,
                    onTap: () {
                      final state = context.read<AuthCubit>().state;
                      if (state is! FacebookLoginLoadingState) {
                        authCubit.signInWithFacebook();
                      }
                    },
                  ),
                  CustomBottomSocialMedia(
                    icon: Icons.g_mobiledata,
                    color: Colors.red,
                    onTap: () {
                      final state = context.read<AuthCubit>().state;
                      if (state is! GoogleLoginLoadingState) {
                        authCubit.signInWithGoogle();
                      }
                    },

                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Dont have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateAccountScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Create Account",
                      style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
