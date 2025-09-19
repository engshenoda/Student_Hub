import 'package:flutter/material.dart';
import 'package:linkedin/features/auth/presentation/screens/create_account_screen.dart';
import 'package:linkedin/features/auth/presentation/widgets/header.dart';


class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Header(),

              /// Form area
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CreateAccountForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
