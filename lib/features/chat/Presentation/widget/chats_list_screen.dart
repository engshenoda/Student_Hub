import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkedin/core/theme/app_colors.dart';
import 'package:linkedin/features/chat/Logic/cubit/cubit/search_chat.dart';
import 'package:linkedin/features/chat/data/repo/chat_servure.dart';
import 'chat_screen.dart';

class ChatsListScreen extends StatefulWidget {
  const ChatsListScreen({super.key});

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(130.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.kLightGreen, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chats',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.kDarkTeal,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                   controller: _searchController,
                    onChanged: (value) {
                     setState(() {
                      searchQuery = value;
                        });
                      },
                        decoration: const InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                        ),
                          ),

                ),
              ],
            ),
          ),
        ),
      ),
body: searchQuery.isEmpty
    ? StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('participants',
                arrayContains: FirebaseAuth.instance.currentUser!.uid)
            .orderBy('lastTimestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
  return const SizedBox.shrink();
}


          final chats = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index].data() as Map<String, dynamic>;
              final participants = List<String>.from(chat['participants'] ?? []);
              final currentUserId = FirebaseAuth.instance.currentUser!.uid;
              String receiverId = currentUserId; // default

          if (participants.isNotEmpty) {  
  receiverId = participants.firstWhere(
    (id) => id != currentUserId,
    orElse: () => currentUserId,
  );
}

if (receiverId == currentUserId) {
  return const SizedBox.shrink();
}



              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(receiverId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return const SizedBox.shrink();
                  }

                  final userData =
                      userSnapshot.data!.data() as Map<String, dynamic>?;

                  if (userData == null) return const SizedBox.shrink();

                  return GestureDetector(
  onLongPress: () async {
    final confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Chat"),
        content: const Text("Are you sure you want to delete this chat?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final chatService = ChatService();
      await chatService.deleteChat(
        FirebaseAuth.instance.currentUser!.uid,
        receiverId,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Chat deleted successfully")),
      );
    }
  },
  child: ListTile(
    leading: CircleAvatar(
      backgroundColor: AppColors.kDarkTeal,
      child: const Icon(Icons.person, color: Colors.white),
    ),
    title: Text(userData['name'] ?? 'Unknown'),
    subtitle: Text(chat['lastMessage'] ?? ''),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            chatName: userData['name'] ?? 'Chat',
            receiverId: userData['uid'],
          ),
        ),
      );
    },
  ),
);

                },
              );
            },
          );
        },
      )
    : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          final filteredDocs = ChatSearchLogic.filterUsers(
            allUsers: docs,
            searchQuery: searchQuery,
            currentUser: FirebaseAuth.instance.currentUser,
          );

          if (filteredDocs.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          return ListView.builder(
            itemCount: filteredDocs.length,
            itemBuilder: (context, index) {
              final user =
                  filteredDocs[index].data() as Map<String, dynamic>;

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.kDarkTeal,
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                title: Text(user['name'] ?? 'Unknown'),
                subtitle: Text(user['email'] ?? ''),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        chatName: user['name'] ?? 'Chat',
                        receiverId: user['uid'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),

    );
  }
}
