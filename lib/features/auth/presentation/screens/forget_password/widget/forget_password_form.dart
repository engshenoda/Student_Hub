import 'package:flutter/material.dart';
import 'package:linkedin/core/widgets/custom_text_form_field.dart';
import 'package:linkedin/features/auth/presentation/screens/set_password_reset/set_new_password_screen.dart';

class ForgetPasswordForm extends StatefulWidget {
  const ForgetPasswordForm({super.key});

  @override
  State<ForgetPasswordForm> createState() => _ForgetPasswordFormState();
}

final TextEditingController _emailController = TextEditingController();
final formKey = GlobalKey<FormState>();

@override
void dispose() {
  _emailController.dispose();
}

class _ForgetPasswordFormState extends State<ForgetPasswordForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),

        // Email
        CustomInputField(
          controller: _emailController,
          label: "Email",
          hint: "Enter your email",
          validator: (value) {
            if (value == null || value.isEmpty)
              return "Please enter your email";
            if (!RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w]{2,4}$').hasMatch(value)) {
              return "Email is invalid";
            }
            return null;
          },
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              // if (formKey.currentState!.validate()) {
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     const SnackBar(
              //       content: Text("Account Created Successfully!"),
              //     ),
              //   );
              // }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SetNewPasswordScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              "Reset password",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
