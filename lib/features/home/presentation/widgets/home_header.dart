import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
        final jobTitle = userData['jobTitle'] ?? 'No jobTitle';
        final degreeYear = userData['degreeYear'] ?? '';
        final photo = userData['photoUrl']; // ممكن تكون null

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
              /// 🧍‍♂️ صورة المستخدم أو أيقونة شخص
              GestureDetector(
                onTap: () {
                  // الانتقال إلى صفحة البروفايل
                  GoRouter.of(context).push(Routes.profile, extra: userId);
                },
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.teal[100],
                  child: photo != null && photo.isNotEmpty
                      ? ClipOval(child: Image.network(photo, fit: BoxFit.cover))
                      : const Icon(Icons.person, color: Colors.teal, size: 28),
                ),
              ),
              const SizedBox(width: 10),

              /// 📝 معلومات المستخدم
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

                  Text(
                    jobTitle,
                    style: TextStyle(color: Colors.teal[800], fontSize: 12),
                  ),
                ],
              ),

              const Spacer(),

              /// 🔍 زر البحث

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
