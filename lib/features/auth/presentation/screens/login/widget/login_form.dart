import 'package:flutter/material.dart';
import 'package:linkedin/features/auth/presentation/screens/create_account/createAcount_screen.dart';
import 'package:linkedin/features/auth/presentation/screens/forget_password/forget_pasword.dart';
import 'package:linkedin/core/widgets/custom_text_form_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final formKey = GlobalKey<FormState>();

  // controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  // password regex
  bool _isValidPassword(String password) {
    final passwordRegex = RegExp(
      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$',
    );
    return passwordRegex.hasMatch(password);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
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

          // Password
          CustomInputField(
            controller: _passwordController,
            label: "Password",
            hint: "Enter your password",
            isPassword: true,
            obscureText: _obscurePassword,
            toggle: () => setState(() => _obscurePassword = !_obscurePassword),
            validator: (value) {
              if (value == null || value.isEmpty)
                return "Please enter your password";
              if (!_isValidPassword(value)) {
                return "Password must be at least 8 chars,\ninclude letters, numbers & symbols";
              }
              return null;
            },
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgetPasword(),
                    ),
                  );
                  },
                child: Text("Forgot Password?", style: TextStyle(color: Colors.teal))),
            ],
          ),
          SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Account Created Successfully!"),
                    ),
                  );
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateAccountScreen(),
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
                "Login",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),

          SizedBox(height: 20),

          //divider
          Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text("Or Create Account with"),
              ),
              Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 20),

          // Social Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialButton(Icons.facebook, Colors.blue),
              _buildSocialButton(Icons.g_mobiledata, Colors.red),
              _buildSocialButton(Icons.apple, Colors.black),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("don't have an account? "),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateAccountScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Create Account",
                  style: TextStyle(
                    color: Colors.teal,
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

  /// Social Buttons
  Widget _buildSocialButton(IconData icon, Color color) {
    return InkWell(
      onTap: () {
        ////////////////////////
      },
      child: Container(
        height: 40,
        width: 80,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(40),
          color: Colors.white70,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(2, 4),
              blurRadius: 6,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}
