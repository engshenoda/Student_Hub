import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkedin/features/jobs/logic/cubit/all_jobs_cubit.dart';
import 'package:linkedin/features/jobs/logic/cubit/all_jobs_state.dart';
import '../widget/job_card.dart';
import 'job_details.dart';
import 'package:linkedin/features/jobs/logic/cubit/job_details_cubit.dart';
class AllJobsScreen extends StatefulWidget {
  const AllJobsScreen({super.key});

  @override
  State<AllJobsScreen> createState() => _AllJobsScreenState();
}

class _AllJobsScreenState extends State<AllJobsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AllJobsCubit>().loadJobs();
    _searchController.addListener(_onSearch);
  }

  void _onSearch() {
    context.read<AllJobsCubit>().searchJobs(_searchController.text);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Jobs"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // Search Bar
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
                hintText: "Search ",
                border: InputBorder.none,
                icon: Icon(Icons.search),
              ),
            ),
          ),

          // Jobs List
          Expanded(
            child: BlocBuilder<AllJobsCubit, AllJobsState>(
              builder: (context, state) {
                if (state is AllJobsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AllJobsLoaded) {
                  if (state.jobs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No jobs found",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: state.jobs.length,
                    itemBuilder: (context, index) {
                      final job = state.jobs[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) => JobDetailsCubit(),
                                child: DetailsJobScreen(job: job),
                              ),
                            ),
                          );
                        },
                        child: JobCard(job: job),
                      );
                    },
                  );
                } else if (state is AllJobsError) {
                  return Center(child: Text(state.message));
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
