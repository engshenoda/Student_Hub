import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin/core/routes/route.dart';
import 'package:linkedin/core/widgets/custom_bottom.dart';
import 'package:linkedin/features/auth/presentation/widgets/header.dart';

class VerifyCodeScreen extends StatelessWidget {
  const VerifyCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Header(title: "Check your email")],
              ),
              const SizedBox(height: 30),
              const Text(
                "We sent a reset link to alpha...@gmail.com.\nEnter the 5-digit code mentioned in the email.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(5, (index) {
                  return SizedBox(
                    width: 50,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: "",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),

              CustomBottom(
                title: "Verify Code",
                onPressed: () {
                  GoRouter.of(context).push(Routes.setnewpassword);
                },
              ),
              const SizedBox(height: 20),
              const Text(
                "Haven’t got the email yet?",
                style: TextStyle(fontSize: 14),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Resend Email",
                  style: TextStyle(
                    color: Color(0xFF00B894),
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
