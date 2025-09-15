import 'package:flutter/material.dart';
import 'package:linkedin/features/auth/presentation/widgets/auth_button.dart';

class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({super.key});

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              "Set A New Password",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
             SizedBox(height: 5),
             Text(
              "Lorem Ipsum is simply dummy text",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
             SizedBox(height: 100),
            
            // Password Field
             Text(
              "Password",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
             SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: "Enter your new Password",
                filled: true,
                fillColor: Colors.grey.shade200,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
             SizedBox(height: 20),

            // Confirm Password Field
             Text(
              "Confirm Password",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
             SizedBox(height: 8),
            TextField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                hintText: "Enter your Confirm new Password",
                filled: true,
                fillColor: Colors.grey.shade200,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
             SizedBox(height: 40),

            // Update Button
           AuthButton(text: "Update Password", backgroundColor: Colors.teal,
            onPressed: () { 
              
             },)
          ],
        ),
      ),
    );
  }
}

