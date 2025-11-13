import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin/core/routes/route.dart';
import 'package:linkedin/features/auth/data/auth_repo.dart';
import 'package:linkedin/features/auth/logic/auth_cubit/auth_cubit.dart';
import 'package:linkedin/features/auth/presentation/screens/login/Login_view_model.dart';
import 'package:linkedin/features/auth/presentation/screens/login/widget/login_form.dart';
import 'package:linkedin/features/auth/presentation/widgets/header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = LoginViewModel(AuthRepo());

    return BlocProvider(
      create: (_) => AuthCubit(loginauthAuthViewModel: viewModel),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Header(title: "Login"),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BlocListener<AuthCubit, AuthCubitState>(
                    listener: (context, state) {
                      // 👇 حالات تسجيل الدخول بالبريد
                      if (state is LoginLoadingState) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) =>
                              const Center(child: CircularProgressIndicator()),
                        );
                      } else if (state is LoginSuccsessState) {
                        Navigator.of(context).pop(); // close loader
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Welcome back!")),
                        );
                        GoRouter.of(context).go(Routes.home);
                      } else if (state is LoginFailureState) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.failure)),
                        );
                      }

                      // 👇 حالات تسجيل الدخول بجوجل
                      else if (state is GoogleLoginLoadingState) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) =>
                              const Center(child: CircularProgressIndicator()),
                        );
                      } else if (state is GoogleLoginSuccessState) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text("✅ Logged in successfully with Google!")),
                        );
                        GoRouter.of(context).go(Routes.home);
                      } else if (state is GoogleLoginFailureState) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text("❌ Google login failed: ${state.error}")),
                        );
                      }
                    },
                    child: LoginForm(viewModel: viewModel),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
