import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin/core/routes/route.dart';
import 'package:linkedin/core/widgets/custom_bottom.dart';
import 'package:linkedin/features/auth/presentation/widgets/header.dart';

class PasswordResetScreen extends StatelessWidget {
  const PasswordResetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(title: "Password reset"),

          const SizedBox(height: 120),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  "Your password has been successfully reset. "
                  "click confirm to set a new password",
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 40),
                //
                CustomBottom(
                  title: "Login",
                  onPressed: () {
                    GoRouter.of(context).push(Routes.login);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
