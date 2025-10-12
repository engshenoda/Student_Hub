

import 'package:flutter/material.dart';
import 'package:linkedin/core/constants/constants.dart';
import 'package:linkedin/features/chat/data/models.dart';
import 'package:linkedin/features/chat/Presentation/widget/chat_input.dart';
import 'package:linkedin/features/chat/Presentation/widget/message_bubble.dart';



class Message {
  final String text;
  final bool isMe;
  final String time;

  Message({required this.text, required this.isMe, required this.time});
}

final List<Message> dummyMessages = [
  Message(
    text: "Hi, I'm looking for a soft, long-lasting perfume. Something feminine but not too strong.",
    isMe: true,
    time: "6:30 PM",
  ),
  Message(
    text: "Hi How Are You ?",
    isMe: false,
    time: "6:30 PM",
  ),
  Message(
    text: "Mostly floral and fruity. Something light for daytime wear.",
    isMe: true,
    time: "6:30 PM",
  ),
  Message(
    text: "Great choice! Here are 3 perfumes that match your style. Would you like to see pictures?",
    isMe: false,
    time: "6:30 PM",
  ),
];

// --- Chat Screen Widget ---
class ChatScreen extends StatelessWidget {
  // New constructor takes a name (identifier) instead of the whole model
  final String chatName; 

  const ChatScreen({super.key, required this.chatName, required chatModel});

  @override
  Widget build(BuildContext context) {
    // Look up the ChatModel using the provided chatName
    final ChatModel chatModel = dummyChats.firstWhere(
      (chat) => chat.name == chatName,
      // Provide a fallback in a real app, though not strictly needed for this dummy data
      orElse: () => ChatModel(
       
      ), 
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [kLightGreen, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1.0],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kDarkTeal),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(chatModel.avatarUrl),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chatModel.name,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kDarkTeal),
                ),
                Text(
                  chatModel.subtitle,
                  style: TextStyle(fontSize: 12, color: kDarkTeal.withOpacity(0.8)),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: kDarkTeal),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
              reverse: true,
              itemCount: dummyMessages.length,
              itemBuilder: (context, index) {
                final message = dummyMessages[dummyMessages.length - 1 - index];
          
                return MessageBubble(
                  message: message, 
                  chatModel: chatModel,
                );
              },
            ),
          ),
   
          const ChatInput(),
        ],
      ),
    );
  }
}