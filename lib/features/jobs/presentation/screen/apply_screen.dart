import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:linkedin/core/theme/app_colors.dart';
import 'success_screen.dart';
import 'package:linkedin/features/jobs/data/job_model.dart'; // ← مسار الموديل

class ApplyScreen extends StatefulWidget {
  final String jobId;   // 👈 مهم جدًا علشان نعرف المستخدم بيقدم على وظيفة إيه

  const ApplyScreen({super.key, required this.jobId});

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

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      /// 1) إنشاء ID للـ Application
      final id = const Uuid().v4();

      /// 2) بناء Model
      final application = JobApplication(
        id: id,
        jobId: widget.jobId,
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        yearsExperience: _experienceController.text.trim(),
        cvLink: _cvLinkController.text.trim(),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        appliedAt: Timestamp.now(),
      );

      /// 3) إرسال البيانات إلى Firestore
      await FirebaseFirestore.instance
          .collection("jobApplications")
          .doc(id)
          .set(application.toJson());

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SuccessScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error submitting jobApplications: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => _isLoading = false);
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
