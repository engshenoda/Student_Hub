import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkedin/core/widgets/custom_bottom.dart';
import 'package:linkedin/core/widgets/custom_bottom_social_media.dart';
import 'package:linkedin/features/auth/logic/auth_cubit/auth_cubit.dart';
import 'package:linkedin/features/auth/presentation/screens/create_account/create_account_view_model.dart';
import 'package:linkedin/features/auth/presentation/screens/login/login_screen.dart';
import 'package:linkedin/core/widgets/custom_text_form_field.dart';

class CreateAccountForm extends StatelessWidget {
  const CreateAccountForm({super.key, required this.viewModel});
  final CreateAccountViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    return Form(
      key: viewModel.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CustomInputField(
          //   controller: viewModel.nameController,
          //   label: "Name",
          //   hint: "Enter your name",
          //   validator: (value) {
          //     if (value == null || value.isEmpty) {
          //       return "Please enter your name";
          //     }
          //     return null;
          //   },
          //   keyboardType: TextInputType.text,
          // ),
          CustomInputField(
            controller: viewModel.emailController,
            label: "Email",
            hint: "Enter your email",
            validator: viewModel.validateEmail,
            keyboardType: TextInputType.emailAddress,
          ),

          // Password
          BlocBuilder<AuthCubit, AuthCubitState>(
            builder: (context, state) {
              final authCubit = BlocProvider.of<AuthCubit>(context);
              return CustomInputField(
                controller: viewModel.passwordController,
                label: "Password",
                hint: "Enter your password",
                isPassword: true,
                obscureText: authCubit.obscurePassword,
                toggle: () => authCubit.togglePasswordVisibility(),
                validator: viewModel.validatePassword,
              );
            },
          ),

          // Confirm Password
          BlocBuilder<AuthCubit, AuthCubitState>(
            builder: (context, state) {
              final authCubit = BlocProvider.of<AuthCubit>(context);
              return CustomInputField(
                controller: viewModel.confirmPasswordController,
                label: "Confirm Password",
                hint: "Enter your confirm password",
                isPassword: true,
                obscureText: authCubit.obscureConfirmPassword,
                toggle: () => authCubit.toggleConfirmPasswordVisibility(),
                validator: viewModel.validateConfirmPassword,
              );
            },
          ),

          // CustomInputField(
          //   controller: viewModel.confirmPasswordController,
          //   label: "Confirm Password",
          //   hint: "Enter your confirm password",
          //   isPassword: true,
          //   obscureText: authCubit.obscureConfirmPassword,
          //   toggle: () => authCubit.toggleConfirmPasswordVisibility(),
          //   validator: viewModel.validateConfirmPassword,
          // ),
          CustomBottom(
            title: "Create Account",
            onPressed: () {
              final state = context.read<AuthCubit>().state;
              if (state is! SignUpLoadingState &&
                  viewModel.formKey.currentState!.validate()) {
                authCubit.register();
              }
            },
          ),
          SizedBox(height: 10),

          //divider
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
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomBottomSocialMedia(icon: Icons.facebook, color: Colors.blue),
              CustomBottomSocialMedia(
                icon: Icons.g_mobiledata,
                color: Colors.red,
              ),
              CustomBottomSocialMedia(icon: Icons.apple, color: Colors.black),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account? "),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Login",
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
  }
}
