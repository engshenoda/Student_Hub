import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linkedin/features/chat/data/repo/chat_servure.dart';
import 'package:linkedin/core/theme/app_colors.dart';

class ChatScreen extends StatefulWidget {
  final String chatName;
  final String receiverId;

  const ChatScreen({
    super.key,
    required this.chatName,
    required this.receiverId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _messageController = TextEditingController();

  late String receiverId;

  @override
  void initState() {
    super.initState();
    receiverId = widget.receiverId;

    final user = _auth.currentUser;
    if (user != null) {
      _chatService.markMessagesAsSeen(user.uid, receiverId);
    }
  }

  void _sendMessage() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    await _chatService.sendMessage(
      senderId: user.uid,
      receiverId: receiverId,
      message: text,
    );

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser!;
    final chatStream = _chatService.getMessages(user.uid, receiverId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.chatName,
          style: const TextStyle(color: AppColors.kDarkTeal),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.kDarkTeal),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  Future.microtask(() {
                    _chatService.markMessagesAsSeen(user.uid, receiverId);
                  });
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No messages yet."));
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data = messages[index];
                    final isMe = data['senderId'] == user.uid;

                    String timeText = '';
                    if (data['timestamp'] != null) {
                      final timestamp = data['timestamp'] as Timestamp;
                      final date = timestamp.toDate();
                      timeText =
                          '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
                    }
                    if (isMe) {
                     final seen = data['isSeen'] == true;
                     timeText += seen ? ' ✓✓' : ' ✓';
                    }

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:
                              isMe ? AppColors.kDarkTeal : Color(0xFFF7F7F7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['message'] ?? '',
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              timeText,
                              style: TextStyle(
                                  color: Colors.grey[1000], fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade200, width: 1.0),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Message',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: AppColors.kDarkTeal),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
