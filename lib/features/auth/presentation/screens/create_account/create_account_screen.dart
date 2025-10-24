import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin/core/routes/route.dart';
import 'package:linkedin/features/auth/data/auth_repo.dart';
import 'package:linkedin/features/auth/logic/auth_cubit/auth_cubit.dart';
import 'package:linkedin/features/auth/presentation/screens/create_account/create_account_view_model.dart';
import 'package:linkedin/features/auth/presentation/screens/create_account/widget/create_account_form.dart';
import 'package:linkedin/features/auth/presentation/widgets/header.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = CreateAccountViewModel(AuthRepo());
    return BlocProvider(
      create: (_) => AuthCubit(createAuthViewModel: viewModel),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Header(title: "Create Account"),

                /// Form area
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: BlocListener<AuthCubit, AuthCubitState>(
                    listener: (context, state) {
                      if (state is SignUpLoadingState) {
                        showDialog(
                          context: context,
                          builder: (_) =>
                              const Center(child: CircularProgressIndicator()),
                        );
                      } else if (state is SignUpSuccsessState) {
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Account Created!")),
                        );
                        GoRouter.of(context).go(Routes.profileqscreen);
                      } else if (state is SignUpFailureState) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.failure)));
                      }
                    },
                    child: CreateAccountForm(viewModel: viewModel,),
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
