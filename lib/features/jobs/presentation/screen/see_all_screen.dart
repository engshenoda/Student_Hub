
import 'package:flutter/material.dart';
import '../widget/jop_card.dart';


class AllJobsScreen extends StatefulWidget {
  const AllJobsScreen({super.key});

  @override
  State<AllJobsScreen> createState() => _AllJobsScreenState();
}

class _AllJobsScreenState extends State<AllJobsScreen> {
  final TextEditingController _searchController = TextEditingController();

  final Map<String, dynamic> Jobs = {
    "title": "Senior UI Designer",
    "company": "Gojek - Jakarta, ID",
    "salary": "\$70K - \$90K",
    "tags": ["Illustrator", "Social media", "Content data"],
  };
  
  final int jobCount = 5;
  List<Map<String, dynamic>> filteredJobs = [];

  @override
  void initState() {
    super.initState();
    filteredJobs = List.generate(jobCount, (_) => Jobs);
    _searchController.addListener(_filterJobs);
  }

  void _filterJobs() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredJobs = List.generate(
        jobCount,
        (_) => Jobs,
      ).where((job) {
        final title = job["title"].toString().toLowerCase();
        final company = job["company"].toString().toLowerCase();
        return title.contains(query) || company.contains(query);
      }).toList();
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color:Colors.green),
            onPressed: () => Navigator.pop(context),
          ),
          title: Padding(
            padding: const EdgeInsets.all(35.0),
            child: const Text(
              "Featured jobs",
              style: TextStyle(color: Color.fromARGB(255, 0, 145, 73), fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Colors.white,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFA8E6CF), Colors.white], 
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Search bar
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

          Expanded(
            child: filteredJobs.isEmpty
                ? const Center(
                    child: Text(
                      "No jobs found",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: filteredJobs.length,
            itemBuilder: (context, index) {
              final job = filteredJobs[index];
              return JobCard(job: job);
            },
          ),
          )
        ],
      ),
    );
  }
}




