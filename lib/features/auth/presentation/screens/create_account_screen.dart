
import 'package:flutter/material.dart';
import 'package:linkedin/features/auth/presentation/widgets/customInputFiald.dart';



class CreateAccountForm extends StatefulWidget {
  const CreateAccountForm({super.key});

  @override
  State<CreateAccountForm> createState() => _CreateAccountFormState();
}

class _CreateAccountFormState extends State<CreateAccountForm> {
  final formKey = GlobalKey<FormState>();

  // controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // password regex
  bool _isValidPassword(String password) {
    final passwordRegex =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$');
    return passwordRegex.hasMatch(password);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          CustomInputField(
            controller: _nameController,
            label: "Name",
            hint: "Enter your name",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your name";
              }
              return null;
            },
            keyboardType: TextInputType.text,
          ),

          // Email
          CustomInputField(
            controller: _emailController,
            label: "Email",
            hint: "Enter your email",
            validator: (value) {
              if (value == null || value.isEmpty) return "Please enter your email";
              if (!RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w]{2,4}$').hasMatch(value)) {
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
              if (value == null || value.isEmpty) return "Please enter your password";
              if (!_isValidPassword(value)) {
                return "Password must be at least 8 chars,\ninclude letters, numbers & symbols";
              }
              return null;
            },
          ),

          // Confirm Password
          CustomInputField(
            controller: _confirmPasswordController,
            label: "Confirm Password",
            hint: "Enter your confirm password",
            isPassword: true,
            obscureText: _obscureConfirmPassword,
            toggle: () =>
                setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
            validator: (value) {
              if (value == null || value.isEmpty) return "Please re-enter your password";
              if (value != _passwordController.text) return "Passwords do not match";
              return null;
            },
          ),

          
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                //Navigator.push(context, route)
                if (formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Account Created Successfully!")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              child: const Text("Create Account", style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),

          SizedBox(height: 10,),

          //divider
           Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text("Or Login with"),
              ),
              Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 10),

          // Social Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialButton(Icons.facebook, Colors.blue),
              _buildSocialButton(Icons.g_mobiledata, Colors.red),
              _buildSocialButton(Icons.apple, Colors.black),
            ],
          ),

          const SizedBox(height: 10),

          // Already have account
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account? "),
              GestureDetector(
                onTap: () {
                  //Navigator.push(context, route)
                },
                child: const Text("Login", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
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
          color:Colors.white70 ,
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
