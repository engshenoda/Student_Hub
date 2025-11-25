import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkedin/core/theme/app_colors.dart';
import 'package:linkedin/features/jobs/data/job_model.dart';
import 'package:linkedin/features/jobs/logic/job_cubit.dart';
import 'package:linkedin/features/jobs/presentation/screen/job_card.dart';
import 'job_details_screen.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<JobModel> _allJobs = [];
  List<JobModel> _filteredJobs = [];

  // 🔹 أيقونات مرتبطة بمجالات الـ Software
  final Map<String, IconData> iconOptions = {
    'Software Engineer': Icons.computer,
    'Web Developer': Icons.web,
    'Mobile Developer': Icons.smartphone,
    'Data Scientist': Icons.analytics,
    'AI/ML Engineer': Icons.memory,
    'Cybersecurity': Icons.security,
    'DevOps': Icons.settings,
    'Database Admin': Icons.storage,
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterJobs(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      _filteredJobs = _allJobs.where((job) {
        return job.title.toLowerCase().contains(lowerQuery) ||
            job.company.toLowerCase().contains(lowerQuery);
      }).toList();
    });
  }

  void _showAddJobDialog(BuildContext context, JobCubit cubit) {
    final titleController = TextEditingController();
    final companyController = TextEditingController();
    final jobTypeController = TextEditingController();
    final salaryController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedIconName = 'Software Engineer';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Add New Job'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Job Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: companyController,
                  decoration: const InputDecoration(
                    labelText: 'Company Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: jobTypeController,
                  decoration: const InputDecoration(
                    labelText: 'Job Type (Full-time, Part-time, etc.)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: salaryController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Salary',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Job Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Choose a software-related icon:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  children: iconOptions.entries.map((entry) {
                    return GestureDetector(
                      onTap: () {
                        setStateDialog(() {
                          selectedIconName = entry.key;
                        });
                      },
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: selectedIconName == entry.key
                            ? AppColors.tealDark
                            : Colors.grey.shade300,
                        child: Icon(
                          entry.value,
                          color: selectedIconName == entry.key
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: AppColors.tealDark),
              onPressed: () {
                final title = titleController.text.trim();
                final company = companyController.text.trim();
                final jobType = jobTypeController.text.trim();
                final salary = double.tryParse(salaryController.text.trim()) ?? null;
                final description = descriptionController.text.trim();

                if (title.isEmpty ||
                    company.isEmpty ||
                    jobType.isEmpty ||
                    description.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please fill all required fields')),
                  );
                  return;
                }

                cubit.addJob(
                  title: title,
                  company: company,
                  jobType: jobType,
                  salary: salary,
                  description: description,
                  iconName: selectedIconName,
                );

                Navigator.pop(ctx);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Job added successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JobCubit()..fetchJobs(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<JobCubit>();

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.tealDark,
              centerTitle: true,
              elevation: 0,
              title: const Text(
                "Available Jobs",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: AppColors.tealDark,
              onPressed: () => _showAddJobDialog(context, cubit),
              child: const Icon(Icons.add, color: Colors.white),
              tooltip: 'Add Job',
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterJobs,
                    decoration: InputDecoration(
                      hintText: "Search for jobs...",
                      prefixIcon:
                          const Icon(Icons.search, color: AppColors.tealDark),
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
                  child: BlocBuilder<JobCubit, JobState>(
                    builder: (context, state) {
                      if (state is JobLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is JobLoaded) {
                        _allJobs = state.jobs;
                        if (_searchController.text.isEmpty) {
                          _filteredJobs = _allJobs;
                        }

                        if (_filteredJobs.isEmpty) {
                          return const Center(
                            child: Text(
                              "No jobs available currently",
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          );
                        }

                        return GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 5 / 2,
                          ),
                          itemCount: _filteredJobs.length,
                          itemBuilder: (context, index) {
                            final job = _filteredJobs[index];

                            return JobCard(
                              title: job.title,
                              company: job.company,
                              jobType: job.jobType,
                              salary: job.salary,
                              icon: iconOptions[job.iconName] ?? Icons.computer,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => JobDetailsScreen(
                                      jobId: job.id,
                                      title: job.title,
                                      company: job.company,
                                      description: job.description ?? "",
                                      icon:
                                          iconOptions[job.iconName] ?? Icons.computer,
                                    ),
                                  ),
                                );
                              },
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('Confirm Delete'),
                                      content: const Text(
                                          'Are you sure you want to delete this job?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            cubit.removeJob(job.id);
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      }

                      if (state is JobError) {
                        return Center(
                          child: Text(
                            "خطأ: ${state.message}",
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
