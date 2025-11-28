import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkedin/core/theme/app_colors.dart';
import 'package:linkedin/features/jobs/data/job_model.dart';
import 'package:linkedin/features/jobs/logic/job_cubit.dart';
import 'package:linkedin/features/jobs/presentation/screen/job_card.dart';
import 'job_details_screen.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({Key? key}) : super(key: key);

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<JobModel> _allJobs = [];
  List<JobModel> _filteredJobs = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterJobs(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filteredJobs = List.from(_allJobs);
      } else {
        _filteredJobs = _allJobs.where((j) {
          return (j.title ?? '').toLowerCase().contains(q) ||
              (j.company ?? '').toLowerCase().contains(q);
        }).toList();
      }
    });
  }

  void _showAddJobDialog(BuildContext context, JobCubit cubit) {
    final Map<String, IconData> iconOptions = {
      'work_outline': Icons.work_outline,
      'computer': Icons.computer,
      'engineering': Icons.engineering,
      'business': Icons.business,
      'school': Icons.school,
    };

    final titleController = TextEditingController();
    final companyController = TextEditingController();
    final jobTypeController = TextEditingController();
    final salaryController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedIconName = iconOptions.keys.first;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'إضافة وظيفة',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.tealDark,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.work,
                      color: AppColors.tealDark,
                    ),
                    labelText: 'عنوان الوظيفة',
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.tealDark,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.tealDark.withOpacity(0.2),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: companyController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.business,
                      color: AppColors.tealDark,
                    ),
                    labelText: 'اسم الشركة',
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.tealDark,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.tealDark.withOpacity(0.2),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: jobTypeController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.work_outline,
                      color: AppColors.tealDark,
                    ),
                    labelText: 'نوع الوظيفة (دوام كامل/جزئي)',
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.tealDark,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.tealDark.withOpacity(0.2),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: salaryController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.attach_money,
                      color: AppColors.tealDark,
                    ),
                    labelText: 'الراتب (اختياري)',
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.tealDark,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.tealDark.withOpacity(0.2),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.description,
                      color: AppColors.tealDark,
                    ),
                    labelText: 'وصف الوظيفة',
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.tealDark,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.tealDark.withOpacity(0.2),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'اختر أيقونة',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: iconOptions.entries.map((entry) {
                    final name = entry.key;
                    final icon = entry.value;
                    final selected = selectedIconName == name;
                    return ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            icon,
                            size: 16,
                            color: selected ? Colors.white : AppColors.tealDark,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            name.replaceAll('_', ' '),
                            style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : AppColors.tealDark,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      selected: selected,
                      onSelected: (_) =>
                          setStateDialog(() => selectedIconName = name),
                      selectedColor: AppColors.tealDark,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tealDark,
              ),
              onPressed: () {
                final title = titleController.text.trim();
                final company = companyController.text.trim();
                final jobType = jobTypeController.text.trim();
                final salary = double.tryParse(salaryController.text.trim());
                final description = descriptionController.text.trim();

                if (title.isEmpty || company.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill title and company'),
                    ),
                  );
                  return;
                }

                cubit.addJob(
                  title: title,
                  company: company,
                  jobType: jobType.isEmpty ? null : jobType,
                  salary: salary,
                  description: description.isEmpty ? null : description,
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
              child: const Text('إضافة'),
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
                'الوظائف',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
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
                // header: count + sort
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${_filteredJobs.length} وظائف',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.tealDark,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Newest',
                          style: TextStyle(color: AppColors.tealDark),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterJobs,
                    decoration: InputDecoration(
                      hintText: 'ابحث عن وظيفة أو شركة...',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.tealDark,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: BlocBuilder<JobCubit, JobState>(
                    builder: (context, state) {
                      if (state is JobLoading)
                        return const Center(child: CircularProgressIndicator());

                      if (state is JobLoaded) {
                        _allJobs = state.jobs;
                        if (_searchController.text.isEmpty)
                          _filteredJobs = _allJobs;

                        if (_filteredJobs.isEmpty)
                          return const Center(
                            child: Text(
                              'No jobs available currently',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          );

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: _filteredJobs.length,
                          itemBuilder: (context, index) {
                            final job = _filteredJobs[index];
                            return JobCard(
                              title: job.title,
                              company: job.company,
                              jobType: job.jobType,
                              salary: job.salary,
                              location: job.location,
                              applicants: job.requirements?.length ?? 0,
                              description: job.description,
                              icon: job.icon,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => JobDetailsScreen(
                                      jobId: job.id,
                                      title: job.title,
                                      company: job.company,
                                      description: job.description ?? "",
                                      icon: job.icon,
                                      jobType: job.jobType,
                                      location: job.location,
                                    ),
                                  ),
                                );
                              },
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (dialogCtx) => AlertDialog(
                                      title: const Text('Confirm Delete'),
                                      content: const Text(
                                        'Are you sure you want to delete this job?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(dialogCtx),
                                          child: const Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.tealDark,
                                          ),
                                          onPressed: () async {
                                            Navigator.pop(dialogCtx);
                                            try {
                                              await cubit.removeJob(job.id);
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Job deleted'),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );
                                            } catch (e) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Delete failed: $e',
                                                  ),
                                                ),
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
                            );
                          },
                        );
                      }

                      if (state is JobError)
                        return Center(
                          child: Text(
                            'خطأ: ${state.message}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        );

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
