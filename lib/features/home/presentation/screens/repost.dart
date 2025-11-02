import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkedin/features/home/data/models/post_model.dart';

import 'package:linkedin/features/home/logic/post_cubit/post_cubt.dart';
import 'package:linkedin/features/home/presentation/widgets/post_card_repost.dart';

class Repost extends StatelessWidget {
  final Post originalPost;
  const Repost({super.key, required this.originalPost});

  @override
  Widget build(BuildContext context) {
    final TextEditingController captionController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // -------- Header Section --------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFB2DFDB), Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Top Bar
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.cancel_outlined,
                            size: 40, color: Colors.teal),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),

            // -------- Body Section --------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // 🔹 User Row
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        backgroundImage: NetworkImage(
                          'https://www.bing.com/th/id/OIP.EzA6vF2nER9bJEh6o1EHZAHaI7?w=174&h=211&c=8&rs=1&qlt=90&o=6&cb=12&dpr=1.3&pid=3.1&rm=2',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi, Mera Mourad",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.teal[800],
                            ),
                          ),
                          Text(
                            "UI / UX Designer",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.teal[800],
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          final currentUserId = "CURRENT_USER_ID";
                          final currentUserName = "Mera Mourad";

                          context.read<PostCubit>().repost(
                                originalPost: originalPost,
                                userId: currentUserId,
                                userName: currentUserName,
                                caption: captionController.text,
                              );

                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF004D40),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Post',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Caption Field
                  Row(
                    children: [
                      Text(
                        "Share your thoughts",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: captionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Write something about this post...",
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: Colors.teal, width: 0.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Original Post Preview
                  PostCardRepost(
                    name: originalPost.authorName,
                    role: "Shared post",
                    text: originalPost.text,
                    image: originalPost.imageUrl ?? "",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
