import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin/core/routes/route.dart';
import 'package:linkedin/core/widgets/custom_bottom.dart';
import 'package:linkedin/core/widgets/custom_text_form_field.dart';

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
    return Form(
      key: formKey,
      child: Column(
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
              if (!RegExp(
                r'^[\w\.\-]+@([\w\-]+\.)+[\w]{2,4}$',
              ).hasMatch(value)) {
                return "Email is invalid";
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
          ),
          CustomBottom(
            title: "Reset password",
            onPressed: () {
              if (formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Account Created Successfully!"),
                  ),
                );
              }
              GoRouter.of(context).push(Routes.veryfypassword);
            },
          ),
        ],
      ),
    );
  }
}
