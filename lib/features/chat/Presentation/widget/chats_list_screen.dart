import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkedin/core/theme/app_colors.dart';
import 'package:linkedin/features/chat/Logic/cubit/cubit/search_chat.dart';
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

           final docs = snapshot.data!.docs;
           

            final filteredDocs = ChatSearchLogic.filterUsers(
                allUsers: docs,
                searchQuery: searchQuery,
                currentUser: FirebaseAuth.instance.currentUser,
              );

          

          return ListView.builder(
            itemCount: filteredDocs.length,
            itemBuilder: (context, index) {
            final user = filteredDocs[index].data() as Map<String, dynamic>;
             
              // تحقق من وجود uid
              if (user['uid'] == null || user['uid'].toString().isEmpty) {
               debugPrint('⚠️ Skipping user without UID: $user');
                return const SizedBox.shrink();
              }
              
               final currentUser = FirebaseAuth.instance.currentUser;
              if (user['uid'] == currentUser?.uid) {
              return const SizedBox.shrink(); // Hide current user
              }


              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.kDarkTeal,
                  child: Icon(Icons.person, color: Colors.white),
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
