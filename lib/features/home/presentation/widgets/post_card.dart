import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin/features/home/data/models/post_model.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final VoidCallback? onLike;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final Function(String text)? onAddComment;

  const PostCard({
    super.key,
    required this.post,
    this.onLike,
    this.onDelete,
    this.onEdit,
    this.onAddComment,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isFollowing = true;
  late bool isLiked; // 🔹 حالة اللايك لكل بوست

  @override
  void initState() {
    super.initState();
    // هنا بنفترض إن عندك userId للمستخدم الحالي
   final userId = "currentUserId"; // استبدلها بالـ ID الحقيقي للمستخدم
  isLiked = widget.post.likes.containsKey(userId);
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    int likesCount = post.likes.length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Header
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                    post.authorAvatar ?? 'https://i.pravatar.cc/150?img=12'),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.authorName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.teal[800],
                    ),
                  ),
                  Text(
                    post.createdAt
                        .toLocal()
                        .toString()
                        .split('.')[0],
                    style: TextStyle(fontSize: 11, color: Colors.teal[800]),
                  ),
                ],
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  setState(() {
                    isFollowing = !isFollowing;
                  });
                },
                child: Text(
                  isFollowing ? "Unfollow" : "Follow",
                  style: TextStyle(color: Colors.teal[800], fontSize: 13),
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.teal[800]),
                onSelected: (v) {
                  if (v == 'edit' && widget.onEdit != null) widget.onEdit!();
                  if (v == 'delete' && widget.onDelete != null) widget.onDelete!();
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),

          const SizedBox(height: 6),

          // 🔹 Text
          Text(
            post.text,
            style: TextStyle(fontSize: 13.5, color: Colors.teal[800]),
          ),

          const SizedBox(height: 6),

          // 🔹 Image (local or network)
          if (post.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: post.imageUrl!.startsWith('/')
                  ? Image.file(File(post.imageUrl!), fit: BoxFit.cover)
                  : Image.network(post.imageUrl!, fit: BoxFit.cover),
            ),

          const SizedBox(height: 6),

          // 🔹 Bottom icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // ❤️ Like
              Row(
                children: [
                 IconButton(
  onPressed: () {
    setState(() {
      isLiked = !isLiked;
    });
    if (widget.onLike != null) widget.onLike!();
  },
  icon: Icon(
    isLiked ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
  ),
  color: isLiked ? Colors.teal : Colors.teal[800],
),
                  Text(
                    '$likesCount',
                    style: TextStyle(color: Colors.teal[800], fontSize: 13),
                  ),
                ],
              ),

              // 💬 Comment
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      context.push('/comments', extra: widget.post.id);
                    },
                    icon: const Icon(Icons.comment_outlined),
                    color: Colors.teal[800],
                  ),
                  Text(
                    '${post.commentsCount}',
                    style: TextStyle(color: Colors.teal[800], fontSize: 13),
                  ),
                ],
              ),

              // 🔁 Repost
              IconButton(
                onPressed: () {
                 context.push('/repost', extra: widget.post);

                },
                icon: const Icon(Icons.swap_horiz_outlined),
                color: Colors.teal[800],
              ),

              // ✉️ Send
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.send_outlined),
                color: Colors.teal[800],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
