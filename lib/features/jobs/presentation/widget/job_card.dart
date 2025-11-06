import 'package:flutter/material.dart';
import 'package:linkedin/features/jobs/data/jobs_model.dart';
import 'package:linkedin/features/jobs/presentation/screen/job_details.dart';

class JobCard extends StatelessWidget {
  final JobModel job;

  const JobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsJobScreen(job: job),
          ),
        );
      },
      child: Container(
        height: 168,
        width: 383,
        margin: const EdgeInsets.only(bottom: 12),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 0, 121, 91),
                  Color.fromARGB(255, 10, 207, 168),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.design_services,
                        color: Colors.white, size: 23),
                    Text(
                      job.salary,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  job.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  job.company,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: job.tags
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
