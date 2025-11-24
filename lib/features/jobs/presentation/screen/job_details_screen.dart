import 'package:flutter/material.dart';
import 'package:linkedin/core/theme/app_colors.dart';
import 'apply_screen.dart';

class JobDetailsScreen extends StatelessWidget {
  final String jobId;        // <-- 🔥 إضافة jobId
  final String title;
  final String company;
  final String description;
  final IconData icon;

  const JobDetailsScreen({
    super.key,
    required this.jobId,     // <-- 🔥 required
    required this.title,
    required this.company,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.tealDark,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔹 Icon circle
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.tealLight.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 70, color: AppColors.tealDark),
            ),
            const SizedBox(height: 20),

            Text(
              company,
              style: const TextStyle(
                color: AppColors.tealDark,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                height: 1.5,
              ),
            ),

            const Spacer(),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tealDark,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ApplyScreen(jobId: jobId), // <-- 🔥 تم التمرير
                  ),
                );
              },
              child: const Text(
                "Apply Now",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
