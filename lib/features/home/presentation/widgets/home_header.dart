import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin/features/home/data/service/post_service.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final postService = PostService();
    return FutureBuilder<Map<String, dynamic>?>(
      future: postService.getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text('User data not found.'),
          );
        }

        final userData = snapshot.data!;
        final fullName = userData['name'] ?? 'User';
        final role = userData['role'] ?? 'No role';
        final jobTitle = userData['jobTitle']; // 👈 ممكن تكون null
        final photo = userData['photoUrl'] ??
            'https://www.bing.com/th/id/OIP.EzA6vF2nER9bJEh6o1EHZAHaI7?w=174&h=211&c=8&rs=1&qlt=90&o=6&cb=12&dpr=1.3&pid=3.1&rm=2';

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFB2DFDB), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(radius: 22, backgroundImage: NetworkImage(photo)),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hi, $fullName",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.teal[800],
                    ),
                  ),
                  if (jobTitle != null && jobTitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      jobTitle, // 💼 Job Title
                      style: TextStyle(
                        color: Colors.teal[700],
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  const SizedBox(height: 2),
                  Text(
                    role, // 🔹 Role
                    style: TextStyle(color: Colors.teal[800], fontSize: 12),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  GoRouter.of(context).push('/search');
                },
                icon: const Icon(Icons.search, color: Colors.teal),
              ),
              IconButton(
                onPressed: () {
                  GoRouter.of(context).push('/notifcation');
                },
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.teal,
                  size: 26,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
