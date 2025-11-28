import 'package:flutter/material.dart';
import 'package:linkedin/core/theme/app_colors.dart';
import 'apply_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkedin/features/jobs/logic/job_cubit.dart';

class JobDetailsScreen extends StatelessWidget {
  final String jobId; // <-- 🔥 إضافة jobId
  final String title;
  final String company;
  final String description;
  final IconData icon;
  final String? jobType;
  final String? location;

  const JobDetailsScreen({
    super.key,
    required this.jobId, // <-- 🔥 required
    required this.title,
    required this.company,
    required this.description,
    required this.icon,
    this.jobType,
    this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.tealDark,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit not implemented')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              final parentContext = context;
              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Confirm Delete'),
                  content: const Text(
                    'Are you sure you want to delete this job?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.tealDark,
                      ),
                      onPressed: () async {
                        try {
                          final cubit = parentContext.read<JobCubit>();
                          await cubit.removeJob(jobId);
                          // close dialog
                          Navigator.of(dialogContext).pop();
                          // safely pop the details page if possible
                          if (Navigator.of(parentContext).canPop()) {
                            Navigator.of(parentContext).pop();
                          } else {
                            Navigator.of(
                              parentContext,
                            ).popUntil((route) => route.isFirst);
                          }
                          ScaffoldMessenger.of(parentContext).showSnackBar(
                            const SnackBar(content: Text('Job deleted')),
                          );
                        } catch (e) {
                          Navigator.of(dialogContext).pop();
                          ScaffoldMessenger.of(parentContext).showSnackBar(
                            SnackBar(content: Text('Delete failed: $e')),
                          );
                        }
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.tealLight.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 70, color: AppColors.tealDark),
              ),
            ),
            const SizedBox(height: 18),

            Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.tealDark,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Center(
              child: Text(
                company,
                style: const TextStyle(color: Colors.black54),
              ),
            ),

            const SizedBox(height: 14),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (jobType != null && jobType!.isNotEmpty)
                  Chip(
                    label: Text(jobType!),
                    backgroundColor: Colors.white,
                    avatar: const Icon(
                      Icons.work_outline,
                      color: AppColors.tealDark,
                    ),
                  ),
                const SizedBox(width: 8),
                if (location != null && location!.isNotEmpty)
                  Chip(
                    label: Text(location!),
                    backgroundColor: Colors.white,
                    avatar: const Icon(
                      Icons.location_on,
                      color: AppColors.tealDark,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 18),

            const Text(
              'وصف الوظيفة',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.tealDark,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                description,
                style: const TextStyle(fontSize: 15, height: 1.6),
              ),
            ),

            const Spacer(),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tealDark,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ApplyScreen(jobId: jobId)),
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
