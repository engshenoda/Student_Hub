import 'package:flutter/material.dart';
import '../constants/constants.dart';

class JobCard extends StatelessWidget {
  final String title;
  final String company;
  final IconData icon;
  final VoidCallback onTap;

  const JobCard({
    super.key,
    required this.title,
    required this.company,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.background,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.tealLight.withOpacity(0.3),
                child: Icon(icon, color: AppColors.tealDark, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.tealDark)),
                    const SizedBox(height: 4),
                    Text(company,
                        style: const TextStyle(color: Colors.black54)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: AppColors.tealDark)
            ],
          ),
        ),
      ),
    );
  }
}
