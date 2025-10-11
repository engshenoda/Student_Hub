

import 'package:flutter/material.dart';
import 'package:linkedin/core/constants/constants.dart';
import 'package:linkedin/features/chat%20copy/Presentation/Model/models.dart';


import 'chat_screen.dart';

class ChatsListScreen extends StatelessWidget {
  const ChatsListScreen({super.key});

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
                colors: [kLightGreen, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 1.0],
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Chats',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: kDarkTeal,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: kDarkTeal),
                      onPressed: () {},
                    ),
                  ],
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
                  child: const TextField(
                    decoration: InputDecoration(
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
      body: ListView.builder(
        itemCount: dummyChats.length,
        itemBuilder: (context, index) {
          final chat = dummyChats[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(chat.avatarUrl),
            ),
            title: Text(
              chat.name,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            subtitle: Text(
              chat.subtitle,
              style: TextStyle(color: Colors.grey[600]),
            ),
            trailing: Text(
              chat.date,
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
            onTap: () {
              // Pass a unique identifier (like the name) instead of the whole model
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(chatName: chat.name), 
                ),
              );
            },
          );
        },
      ),
    );
  }
}