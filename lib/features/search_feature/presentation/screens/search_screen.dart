import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/list_view.dart';
import '../widgets/search_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String query = '';

  final List<String> _people = [
    'Alice Johnson',
    'Bob Smith',
    'Charlie Adams',
    'David Wright',
    'Emma Brown',
  ];

  final List<String> _posts = [
    'Flutter 3.24 released!',
    'New Dart features',
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Search"),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFAAE7DB), Color(0xFFFBF9FC)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          leading: IconButton(
            onPressed: () {
              GoRouter.of(context).go('/home');
            },
            icon: Icon(Icons.arrow_back_ios),
          ),

          bottom: const TabBar(
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            tabs: [
              Tab(text: "People"),
              Tab(text: "Posts"),
              Tab(text: "Jobs"),
              Tab(text: "Companies"),
            ],
          ),
        ),
        body: Column(
          children: [
            SearchWidget(
              controller: _searchController,
              onChanged: (value) => setState(() => query = value.toLowerCase()),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  TabsListView(
                    items: _people,
                    icon: Icons.person,
                    query: query,
                  ),
                  TabsListView(
                    items: _posts,
                    icon: Icons.article,
                    query: query,
                  ),
                  TabsListView(items: _jobs, icon: Icons.work, query: query),
                  TabsListView(
                    items: _companies,
                    icon: Icons.business,
                    query: query,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
