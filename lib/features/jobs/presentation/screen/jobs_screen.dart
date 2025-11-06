import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin/features/jobs/logic/cubit/jobs_cubit.dart';
import 'package:linkedin/features/jobs/logic/cubit/jobs_state.dart';
import 'package:linkedin/features/jobs/logic/cubit/all_jobs_cubit.dart';
import 'package:linkedin/features/jobs/presentation/screen/see_all_screen.dart';
import 'package:linkedin/features/jobs/presentation/screen/job_details.dart';
import '../widget/job_card.dart';
import '../widget/job_tile.dart';
import 'package:linkedin/features/jobs/data/jobs_model.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedCategory = "All";

  Widget categoryButton(String text, {VoidCallback? onTap, bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap ?? () {},
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF00A651).withOpacity(0.2) : Colors.white70,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? const Color(0xFF00A651) : Colors.grey,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.25),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? const Color(0xFF00A651) : Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ BlocProvider اتشال من هنا – اتحط برا الصفحة في GoRoute أو Navigator
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFA8E6CF), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.green),
              onPressed: () {
                final router = GoRouter.of(context);
                if (router.canPop()) {
                  router.pop();
                } else {
                  router.go('/');
                }
              },
            ),
            title: const Text(
              "Jobs",
              style: TextStyle(
                color: Color.fromARGB(255, 0, 145, 73),
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
        ),
      ),

      body: BlocBuilder<JobsCubit, JobsState>(
        builder: (context, state) {
          if (state is JobsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is JobsError) {
            return Center(child: Text(state.message));
          } else if (state is JobsLoaded) {
            final jobs = state.jobs;

            return SingleChildScrollView(
              child: Column(
                children: [
                  // 🔍 Search bar
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: "Search for jobs...",
                        border: InputBorder.none,
                        icon: Icon(Icons.search),
                      ),
                      onChanged: (query) {
                        final cubit = context.read<JobsCubit>();
                        if (query.trim().isEmpty) {
                          cubit.fetchJobs();
                        } else {
                          cubit.searchJobs(query.trim());
                        }
                      },
                    ),
                  ),

                  // 🏆 Featured Jobs header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          "Featured jobs",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                            color: Color.fromARGB(255, 0, 145, 73),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) => AllJobsCubit(),
                                child: const AllJobsScreen(),
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          "See All",
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 145, 73),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // 💼 Featured Job
                  if (jobs.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailsJobScreen(job: jobs.first),
                          ),
                        );
                      },
                      child: JobCard(job: jobs.first),
                    ),

                  const SizedBox(height: 12),

                  // 🧩 Categories Buttons
                  Container(
                    height: 40,
                    color: Colors.white,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        categoryButton(
                          "All",
                          isSelected: selectedCategory == "All",
                          onTap: () {
                            setState(() => selectedCategory = "All");
                            context.read<JobsCubit>().fetchJobs();
                          },
                        ),
                        categoryButton(
                          "Researcher",
                          isSelected: selectedCategory == "Researcher",
                          onTap: () {
                            setState(() => selectedCategory = "Researcher");
                            context.read<JobsCubit>().searchJobs("Researcher");
                          },
                        ),
                        categoryButton(
                          "UI Designer",
                          isSelected: selectedCategory == "UI Designer",
                          onTap: () {
                            setState(() => selectedCategory = "UI Designer");
                            context.read<JobsCubit>().searchJobs("UI Designer");
                          },
                        ),
                        categoryButton(
                          "Developer",
                          isSelected: selectedCategory == "Developer",
                          onTap: () {
                            setState(() => selectedCategory = "Developer");
                            context.read<JobsCubit>().searchJobs("Developer");
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 🔷 Jobs list
                  if (jobs.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text("No jobs found.", style: TextStyle(color: Colors.grey)),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: jobs.map((job) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailsJobScreen(job: job),
                                ),
                              );
                            },
                            child: JobTile(
                              title: job.title,
                              icon: Icons.work_outline,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),

      // 🟢 Floating Action Button – Add Job
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 0, 145, 73),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              final titleController = TextEditingController();
              final companyController = TextEditingController();
              final salaryController = TextEditingController();
              final descriptionController = TextEditingController();

              return AlertDialog(
                title: const Text("Add New Job"),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: "Job Title"),
                      ),
                      TextField(
                        controller: companyController,
                        decoration: const InputDecoration(labelText: "Company Name"),
                      ),
                      TextField(
                        controller: salaryController,
                        decoration: const InputDecoration(labelText: "Salary"),
                      ),
                      TextField(
                        controller: descriptionController,
                        decoration: const InputDecoration(labelText: "Description"),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 145, 73),
                    ),
                    onPressed: () async {
                      final job = JobModel(
                        id: '',
                        title: titleController.text.trim(),
                        company: companyController.text.trim(),
                        salary: salaryController.text.trim(),
                        description: descriptionController.text.trim(),
                        tags: [],
                        requirements: [],
                      );

                      await context.read<JobsCubit>().addJob(job);
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('✅ Job added successfully!')),
                      );

                      context.read<JobsCubit>().fetchJobs();
                    },
                    child: const Text("Save"),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
