import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkedin/features/jobs/data/jobs_model.dart';
import 'package:linkedin/features/jobs/logic/cubit/job_details_cubit.dart';
import 'package:linkedin/features/jobs/logic/cubit/job_details_state.dart';

class DetailsJobScreen extends StatelessWidget {
  final JobModel job;
  const DetailsJobScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => JobDetailsCubit()..loadJob(job),
      child: BlocBuilder<JobDetailsCubit, JobDetailsState>(
        builder: (context, state) {
          if (state is JobDetailsLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is JobDetailsError) {
            return Scaffold(
              body: Center(child: Text(state.message)),
            );
          } else if (state is JobDetailsLoaded) {
            return Scaffold(
              backgroundColor: Colors.white,
              floatingActionButton: FloatingActionButton.extended(
                onPressed: state.isApplied
                    ? null
                    : () => context.read<JobDetailsCubit>().applyForJob(),
                label: Text(
                  state.isApplied ? "Applied" : "Apply Now",
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor:
                    state.isApplied ? Colors.grey : const Color(0xFF00A86B),
                icon: const Icon(Icons.work_outline, color: Colors.white),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 24),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFFA8E6CF), Colors.white],
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(Icons.arrow_back_ios_new,
                                      color: Colors.green),
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: Icon(
                                    state.isSaved
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color: Colors.green,
                                  ),
                                  onPressed: () => context
                                      .read<JobDetailsCubit>()
                                      .toggleSaveJob(),
                                ),
                              ],
                            ),
                            Center(
                              child: Column(
                                children: [
                                  Text(job.title,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(job.company,
                                      style: const TextStyle(color: Colors.grey)),
                                  const SizedBox(height: 16),
                                  Wrap(
                                    spacing: 8,
                                    children: job.tags
                                        .map((tag) => Chip(label: Text(tag)))
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      DefaultTabController(
                        length: 3,
                        child: Column(
                          children: [
                            TabBar(
                              labelColor: Colors.green.shade700,
                              unselectedLabelColor: Colors.grey,
                              indicatorColor: Colors.green,
                              tabs: const [
                                Tab(text: "Description"),
                                Tab(text: "Requirement"),
                                Tab(text: "Reviews"),
                              ],
                            ),
                            SizedBox(
                              height: 400,
                              child: TabBarView(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(job.description),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(job.requirements.join('\n• ')),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text("No reviews yet."),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
