import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatSearchLogic {
  static List<QueryDocumentSnapshot> filterUsers({
    required List<QueryDocumentSnapshot> allUsers,
    required String searchQuery,
    required User? currentUser,
  }) {
    if (searchQuery.isEmpty) {
      return allUsers.where((doc) {
        final user = doc.data() as Map<String, dynamic>? ?? {};
        final uid = user['uid']?.toString() ?? '';
        return uid.isNotEmpty && uid != currentUser?.uid;
      }).toList();
    }

    final lowerQuery = searchQuery.toLowerCase();

    return allUsers.where((doc) {
      final user = doc.data() as Map<String, dynamic>? ?? {};
      final email = (user['email'] ?? '').toString().toLowerCase();
      final uid = (user['uid'] ?? '').toString();
      if (uid.isEmpty || uid == currentUser?.uid) return false;
      return email.contains(lowerQuery);
    }).toList();
  }
}
