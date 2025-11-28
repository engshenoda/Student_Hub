import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin/core/routes/route.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userId = currentUser?.uid;

    if (userId == null) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('No user logged in'),
      );
    }

    final userStream = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots();

    return StreamBuilder<DocumentSnapshot>(
      stream: userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text('User data not found.'),
          );
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final fullName = userData['name'] ?? 'User';
        final jobTitle = userData['title'] ?? 'No jobTitle';
        final photo = userData['photoUrl'];

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
              GestureDetector(
                onTap: () {
                  GoRouter.of(context).push(
                    Routes.viewprofile,
                    extra: {'uid': userId, 'name': fullName},
                  );
                },
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.teal[100],
                  child: photo != null && photo.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            photo,
                            fit: BoxFit.cover,
                            width: 44,
                            height: 44,
                          ),
                        )
                      : const Icon(Icons.person, color: Colors.teal, size: 28),
                ),
              ),
              const SizedBox(width: 10),

              /// 📝 معلومات المستخدم
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi, $fullName",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.teal[800],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      jobTitle,
                      style: TextStyle(color: Colors.teal[800], fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              /// 🔔 زر الإشعارات
              IconButton(
                onPressed: () {
                  GoRouter.of(context).push(Routes.notifcation);
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
