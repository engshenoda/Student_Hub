import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin/core/routes/route.dart';
import 'package:linkedin/core/theme/app_colors.dart';
import 'package:linkedin/features/auth/data/auth_repo.dart';
import 'package:linkedin/features/auth/logic/auth_cubit/auth_cubit.dart';
import 'package:linkedin/features/auth/presentation/screens/forget_password/forget_password_view_model.dart';
import 'package:linkedin/features/auth/presentation/screens/forget_password/widget/forget_password_form.dart';
import 'package:linkedin/features/auth/presentation/widgets/header.dart';

class ForgetPasword extends StatelessWidget {
  const ForgetPasword({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ForgetPasswordViewModel(AuthRepo());
    return BlocProvider(
      create: (_) => AuthCubit(forgetPasswordViewModel: viewModel),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocConsumer<AuthCubit, AuthCubitState>(
            listener: (context, state) {
              if (state is ResetPasswordSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                GoRouter.of(context).go(Routes.login);
              } else if (state is ResetPasswordFailureState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.failure),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is ResetPasswordLoadingState;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Header(title: "Forget Password"),

                    /// Form area
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: ForgetPasswordForm(
                        forgetPasswordViewModel: viewModel,
                        isLoading: isLoading,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
