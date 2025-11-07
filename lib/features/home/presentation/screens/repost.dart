import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkedin/features/home/data/models/post_model.dart';
import 'package:linkedin/features/home/logic/post_cubit/post_cubt.dart';
import 'package:linkedin/features/home/presentation/widgets/post_card_repost.dart';

class Repost extends StatelessWidget {
  final PostModel originalPost;
  const Repost({super.key, required this.originalPost});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserId = currentUser?.uid ?? 'guest_user';
    final currentUserName = currentUser?.displayName ?? 'Unknown User';
    final currentUserAvatar =
        currentUser?.photoURL ??
        'https://i.pravatar.cc/150?img=12'; // صورة افتراضية لو مفيش
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
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.cancel_outlined,
                      size: 40,
                      color: Colors.teal,
                    ),
                  ),
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
                      CircleAvatar(
                        radius: 22,
                        backgroundImage: NetworkImage(currentUserAvatar),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentUserName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.teal[800],
                            ),
                          ),
                          Text(
                            "Sharing a post", // وصف بسيط بدل الـ jobTitle الثابت
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.teal[800],
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          // await context.read<PostCubit>().repost(
                          //   originalPost: originalPost,
                          //   userId: currentUserId,
                          //   userName: currentUserName,
                          //   userAvatar: currentUserAvatar,
                          //   caption: captionController.text,
                          // );

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Post shared successfully!'),
                              backgroundColor: Colors.teal,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF004D40),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Share your thoughts",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
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
                        borderSide: const BorderSide(
                          color: Colors.teal,
                          width: 0.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Original Post Preview
                  // PostCardRepost(
                  //   name: originalPost.authorName,
                  //   jobTitle: "Shared post",
                  //   text: originalPost.text,
                  //   image: originalPost.imageUrl ?? "",
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
