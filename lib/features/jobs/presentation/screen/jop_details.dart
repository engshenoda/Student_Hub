
import 'package:flutter/material.dart';

class DetailsJobScreen extends StatefulWidget {
  final Map<String, dynamic> job;
  const DetailsJobScreen({super.key, required this.job});

  @override
  State<DetailsJobScreen> createState() => _DetailsJobScreenState();
}

class _DetailsJobScreenState extends State<DetailsJobScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget _buildDescription() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        "This is the job description. Here you can add all the job details such as responsibilities, working hours, and benefits.",
        style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.4),
      ),
    );
  }
  
  @override
  Widget _buildRequirement() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        "Requirements:\n• Bachelor's degree in related field\n• 2+ years experience\n• Good communication skills",
        style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.4),
      ),
    );
  }

  @override
  Widget _buildReviews() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        "No reviews yet. Reviews will appear here once users start submitting feedback.",
        style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              
              Container(
                
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFA8E6CF), 
                      Colors.white,
                    ],
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
                              color:Colors.green ),
                        ),
                        SizedBox(width: 60,),
                        Text(
                          "Details Job",
                          style: TextStyle(
                            color: Colors.green.shade800,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    Center(
                      child: Column(
                        children: [
                          Text(
                            widget.job["title"] ?? "Job Title",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.job["company"] ??
                                "Company - Location, Country",
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          // Tags
                          Wrap(
                            spacing: 8,
                            children: (widget.job["tags"] ??
                                    ["Illustrator", "Social media", "Content data"])
                                .map<Widget>((tag) => Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.grey),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.grey.withOpacity(0.2),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        tag,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black87),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Tabs
              TabBar(
                controller: _tabController,
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
                  controller: _tabController,
                  children: [
                    _buildDescription(),
                    _buildRequirement(),
                    _buildReviews(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
    }

