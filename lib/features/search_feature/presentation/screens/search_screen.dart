import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkedin/features/search_feature/logic/cubit/search_cubit.dart';
import 'package:linkedin/features/search_feature/logic/cubit/search_state.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
                      context.read<SearchCubit>().searchAll('');
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
                  context.read<SearchCubit>().searchAll(value.trim().toLowerCase());
                },
              ),
            ),
          ),
          bottom: const TabBar(
            labelColor: Colors.black,
            indicatorColor: Colors.teal,
            tabs: [
              Tab(text: "People"),
              Tab(text: "Jobs"),
            ],
          ),
        ),
        body: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            if (state is SearchLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SearchLoaded) {
              final query = _searchController.text.toLowerCase();
              return TabBarView(
                children: [
                  _buildList(state.people.map((u) => u.name).toList(), query, Icons.person),
                  _buildList(state.jobs.map((j) => j.title).toList(), query, Icons.work),
                ],
              );
            } else if (state is SearchError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return const Center(
              child: Text(
                "Start typing to search...",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildList(List<String> items, String query, IconData icon) {
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
          leading: CircleAvatar(
            backgroundColor: Colors.teal,
            child: Icon(icon, color: Colors.white),
          ),
          title: Text(
            filtered[index],
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          subtitle: const Text(
            "Tap to view details",
            style: TextStyle(color: Colors.grey),
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
