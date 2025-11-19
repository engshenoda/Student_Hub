import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// 💡 استيراد شاشة البروفايل
import 'package:linkedin/features/profile/presentation/screens/profile_screen.dart'; 
import 'package:linkedin/features/search_feature/logic/cubit/search_cubit.dart';
import 'package:linkedin/features/search_feature/logic/cubit/search_state.dart';
// 💡 استيراد UserModel
import 'package:linkedin/features/search_feature/model/search_model.dart'; 

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
        // 💡 استخدام BlocConsumer للاستماع لحالة التنقل وتنفيذ Navigator.push
        body: BlocConsumer<SearchCubit, SearchState>(
          listener: (context, state) {
            if (state is SearchNavigateToProfile) {
              // 🎯 التنقل الفعلي باستخدام Navigator.push
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    uid: state.uid, // تمرير UID الصديق
                    name: state.name,  // تمرير اسمه
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is SearchLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SearchLoaded) {
              final query = _searchController.text.toLowerCase();
              return TabBarView(
                children: [
                  // 💡 دالة عرض قائمة الأشخاص الجديدة
                  _buildListPeople(context, state.people, query),
                  // استخدام الدالة القديمة للوظائف
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
  
  // 💡 الدالة الجديدة: تصل إلى UserModel لتمرير الـ UID والـ Name
  Widget _buildListPeople(BuildContext context, List<UserModel> users, String query) {
    // تصفية بناءً على الاسم
    final filtered = users
        .where((user) => user.name.toLowerCase().contains(query))
        .toList();

    if (filtered.isEmpty) {
      return const Center(
        child: Text(
          "No people found",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final user = filtered[index];
        return ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.teal,
            child: Icon(Icons.person, color: Colors.white),
          ),
          title: Text(
            user.name, 
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          // 💡 عرض الـ ID في الـ Subtitle للتأكيد فقط.
          subtitle: Text(
            "Tap on the person to view profile", 
            style: const TextStyle(color: Colors.grey),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // 🎯 استدعاء الكيوبيت لإصدار إشارة التنقل بالـ UID و Name
            context.read<SearchCubit>().selectProfile(user.id, user.name);
          },
        );
      },
    );
  }

  // 💡 دالة عرض قائمة الوظائف القديمة (محتفظ بها)
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