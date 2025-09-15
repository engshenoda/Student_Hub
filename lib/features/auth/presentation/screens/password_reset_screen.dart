import 'package:flutter/material.dart';
import 'package:linkedin/features/auth/presentation/widgets/auth_button.dart';


class PasswordResetScreen extends StatelessWidget {
  const PasswordResetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
 
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Password reset",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Lorem Ipsum is simply dummy text",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 120),

            const Text(
              "Your password has been successfully reset. "
              "click confirm to set a new password",
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 40),

            // زرار Confirm Button
            AuthButton(
              text: "Confirm",
              backgroundColor: Colors.teal,
              onPressed: () {
              
              },
            ),
          ],
        ),
      ),
    );
  }
}
