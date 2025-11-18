import 'package:flutter/material.dart';
import 'package:linkedin/core/theme/app_colors.dart';
import 'package:linkedin/features/jobs/presentation/screen/job_card.dart';
import 'job_details_screen.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _allJobs = [
    {
      "title": "Flutter Developer",
      "company": "Tech Co.",
      "icon": Icons.mobile_screen_share_rounded,
      "description":
          "Develop and maintain cross-platform mobile applications using Flutter and Dart. Collaborate with designers to deliver elegant UI experiences."
    },
    {
      "title": "UI/UX Designer",
      "company": "Creative Studio",
      "icon": Icons.design_services,
      "description":
          "Design clean, modern, and user-friendly interfaces for mobile and web platforms."
    },
    {
      "title": "Backend Engineer",
      "company": "Cloud Corp",
      "icon": Icons.cloud,
      "description":
          "Develop scalable REST APIs and manage cloud infrastructure using Firebase or AWS."
    },
    {
      "title": "Data Analyst",
      "company": "Insight AI",
      "icon": Icons.analytics,
      "description":
          "Analyze business data, visualize insights, and generate detailed reports."
    },
  ];

  List<Map<String, dynamic>> _filteredJobs = [];

  @override
  void initState() {
    super.initState();
    _filteredJobs = _allJobs;
    _searchController.addListener(_filterJobs);
  }

  void _filterJobs() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredJobs = _allJobs
          .where((job) =>
              job["title"].toLowerCase().contains(query) ||
              job["company"].toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.tealDark,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Available Jobs",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
     
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search for jobs...",
                prefixIcon: const Icon(Icons.search, color: AppColors.tealDark),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: AppColors.tealDark),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredJobs.length,
              itemBuilder: (context, index) {
                final job = _filteredJobs[index];
                return JobCard(
                  title: job["title"]!,
                  company: job["company"]!,
                  icon: job["icon"] as IconData,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => JobDetailsScreen(
                          title: job["title"]!,
                          company: job["company"]!,
                          description: job["description"]!,
                          icon: job["icon"] as IconData,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
