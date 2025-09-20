import 'package:flutter/material.dart';
import 'package:linkedin/features/auth/presentation/screens/forget_password/widget/forget_password_form.dart';
import 'package:linkedin/features/auth/presentation/widgets/header.dart';

class ForgetPasword extends StatelessWidget {
  const ForgetPasword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Header(title: "Forget Password",),

              /// Form area
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ForgetPasswordForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}