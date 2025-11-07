import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin/core/routes/route.dart';

class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key});

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
        final role = userData['role'] ?? 'No role';
        final photo = userData['photoUrl'];

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                /// 🧍‍♂️ صورة المستخدم أو أيقونة شخص
                GestureDetector(
                  onTap: () {
                    GoRouter.of(context).push(Routes.profile, extra: userId);
                  },
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.green.shade700,
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: photo != null && photo.isNotEmpty
                          ? Image.network(photo, fit: BoxFit.cover)
                          : const Icon(
                              Icons.person,
                              color: Colors.green,
                              size: 40,
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                /// 📝 معلومات المستخدم
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(role, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),

                /// ➡️ زر الانتقال
                IconButton(
                  onPressed: () {
                    GoRouter.of(context).push(Routes.profile, extra: userId);
                  },
                  icon: const Icon(Icons.arrow_forward_ios, size: 18),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
