import 'package:flutter/material.dart';
import 'package:linkedin/features/auth/presentation/screens/login/widget/login_form.dart';
import 'package:linkedin/features/auth/presentation/widgets/header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Header(title: "Login",),

              /// Form area
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: LoginForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}