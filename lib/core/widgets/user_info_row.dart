// features/home/presentation/widgets/user_info_row.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserInfoRow extends StatelessWidget {
  final String name;
  final String? role;
  final String? imageUrl;
  final Widget? trailing;
  final VoidCallback? onTap;

  const UserInfoRow({
    super.key,
    required this.name,
    this.role,
    this.imageUrl,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey[200],
            backgroundImage: (imageUrl != null && imageUrl!.isNotEmpty)
                ? NetworkImage(imageUrl!)
                : null,
            child: (imageUrl == null || imageUrl!.isEmpty)
                ? const Icon(Icons.person, color: Colors.teal)
                : null,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              if (role != null && role!.isNotEmpty)
                Text(
                  role!,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
            ],
          ),
          const Spacer(),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}





class UserInfoRowWithFetch extends StatelessWidget {
  final String userId;
  final Widget? trailing;

  const UserInfoRowWithFetch({
    super.key,
    required this.userId,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final usersRef = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: usersRef.doc(userId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text('Loading...'),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person_outline)),
            title: Text('Unknown User ($userId)'),
            trailing: trailing,
          );
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final name = userData['name'] ?? 'Unknown';
        final role = userData['role'] ?? '';
        final imageUrl = userData['profileImage'] ?? '';

        return UserInfoRow(
          name: name,
          role: role,
          imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
          trailing: trailing,
        );
      },
    );
  }
}

