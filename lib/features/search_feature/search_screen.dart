import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _people = [
    'Alice Johnson',
    'Bob Smith',
    'Charlie Adams',
    'David Wright',
    'Emma Brown',
  ];

  final List<String> _posts = [
    'Flutter 3.24 released!',
    'New Dart features you should know',
    'How to design better UIs',
    'Understanding Bloc pattern',
    'Top Flutter packages 2025',
  ];

  final List<String> _jobs = [
    'Flutter Developer - Remote',
    'UI/UX Designer - Cairo',
    'Mobile App Engineer',
    'Frontend Developer',
    'Backend Python Engineer',
  ];

  final List<String> _companies = [
    'Google',
    'Microsoft',
    'Apple',
    'Amazon',
    'Meta',
  ];

  String query = '';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFAAE7DB), Color(0xFFFBF9FC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              height: 45,
              child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search...",
                  prefixIcon: const Icon(Icons.qr_code, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => query = '');
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 16,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    query = value.toLowerCase();
                  });
                },
              ),
            ),
          ),
          bottom: const TabBar(
            labelColor: Colors.black,
            indicatorColor: Colors.teal,
            tabs: [
              Tab(text: "People"),
              Tab(text: "Posts"),
              Tab(text: "Jobs"),
              Tab(text: "Companies"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildList(_people),
            _buildList(_posts),
            _buildList(_jobs),
            _buildList(_companies),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<String> items) {
    final filtered = items
        .where((item) => item.toLowerCase().contains(query))
        .toList();

    if (filtered.isEmpty) {
      return const Center(
        child: Text(
          "No results found",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.teal,
            child: Icon(Icons.person, color: Colors.white),
          ),
          title: Text(
            filtered[index],
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            "Tap to view details",
            style: TextStyle(color: Colors.grey.shade600),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("You tapped on: ${filtered[index]}")),
            );
          },
        );
      },
    );
  }
}
