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
                Header(title: "Login"),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: BlocListener<AuthCubit, AuthCubitState>(
                    listener: (context, state) {
                      if (state is LoginLoadingState) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) =>
                              const Center(child: CircularProgressIndicator()),
                        );
                      } else if (state is LoginSuccsessState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Welcome back!")),
                        );
                        GoRouter.of(context).go(Routes.Home);
                      } else if (state is LoginFailureState) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.failure)));
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
