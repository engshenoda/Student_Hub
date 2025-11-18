import 'package:flutter/material.dart';
import '../constants/constants.dart';
import 'success_screen.dart';

class ApplyScreen extends StatefulWidget {
  const ApplyScreen({super.key});

  @override
  State<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends State<ApplyScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _cvLinkController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool _isLoading = false;

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 1)); // محاكاة إرسال البيانات

    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SuccessScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.tealDark,
        title: const Text("Apply for Job", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),

                _buildField(
                  controller: _nameController,
                  label: "Full Name",
                  hint: "Enter your full name",
                  icon: Icons.person,
                  keyboardType: TextInputType.name,
                  validator: (val) =>
                      val!.trim().isEmpty ? "Full Name is required" : null,
                ),

                _buildField(
                  controller: _emailController,
                  label: "Email Address",
                  hint: "example@mail.com",
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return "Email is required";
                    }
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    return emailRegex.hasMatch(val)
                        ? null
                        : "Please enter a valid email";
                  },
                ),

                _buildField(
                  controller: _phoneController,
                  label: "Phone Number",
                  hint: "e.g. +20",
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return "Phone number is required";
                    }
                    if (val.length < 10) return "Invalid phone number";
                    return null;
                  },
                ),

                _buildField(
                  controller: _experienceController,
                  label: "Years of Experience",
                  hint: "e.g. 3",
                  icon: Icons.timeline,
                  keyboardType: TextInputType.number,
                  validator: (val) =>
                      val!.isEmpty ? "Enter your years of experience" : null,
                ),

                _buildField(
                  controller: _cvLinkController,
                  label: "CV or LinkedIn Profile Link",
                  hint: "https://linkedin.com/in/username",
                  icon: Icons.link,
                  keyboardType: TextInputType.url,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Provide your CV or LinkedIn link";
                    }
                    if (!val.startsWith("http")) {
                      return "Enter a valid URL (starting with http)";
                    }
                    return null;
                  },
                ),

                _buildField(
                  controller: _notesController,
                  label: "Additional Notes (optional)",
                  hint: "Any extra information you want to share",
                  icon: Icons.note_alt,
                  keyboardType: TextInputType.text,
                  maxLines: 3,
                  validator: (_) => null,
                ),

                const SizedBox(height: 25),

                _isLoading
                    ? const CircularProgressIndicator(color: AppColors.tealDark)
                    : ElevatedButton.icon(
                        icon: const Icon(Icons.send, color: Colors.white),
                        label: const Text(
                          "Submit Application",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.tealDark,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          elevation: 3,
                        ),
                        onPressed: _submitForm,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.tealDark),
          labelText: label,
          hintText: hint,
          labelStyle: const TextStyle(color: AppColors.tealDark),
          filled: true,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.tealDark, width: 1.5),
            borderRadius: BorderRadius.circular(15),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: AppColors.tealDark.withOpacity(0.4), width: 1),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
