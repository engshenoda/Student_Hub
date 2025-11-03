import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin/features/home/data/models/post_model.dart';
import 'package:share_plus/share_plus.dart';

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
  late bool isLiked;
  late int likesCount;
  late String currentUserId;
  bool _isLiking = false; // 🔒 عشان نمنع السبام أو الضغط المزدوج

  @override
  void initState() {
    super.initState();

    // ✅ جلب ID المستخدم الحالي
    currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "guest_user";

    // ✅ حالة اللايك المبدئية
    isLiked = widget.post.likes.containsKey(currentUserId);

    // ✅ عدد اللايكات المبدئي
    likesCount = widget.post.likes.length;
  }

  void _handleLike() async {
    if (_isLiking) return; // 🛑 منع الضغط المكرر
    _isLiking = true;

    setState(() {
      if (isLiked) {
        likesCount--;
        isLiked = false;
      } else {
        likesCount++;
        isLiked = true;
      }
    });

    // 🔹 نبلغ الكيوبت بالتغيير
    if (widget.onLike != null) {
      await Future.delayed(const Duration(milliseconds: 100)); // تأخير بسيط للتجربة السلسة
      widget.onLike!();
    }

    _isLiking = false;
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

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
                  post.authorAvatar ?? 'https://i.pravatar.cc/150?img=12',
                ),
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
                    post.createdAt.toLocal().toString().split('.')[0],
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
      // ✅ Check if Repost or Normal Post
if (!post.isRepost) ...[
  // 🔹 Text (Normal Post)
  Text(
    post.text,
    style: TextStyle(fontSize: 13.5, color: Colors.teal[800]),
  ),
  const SizedBox(height: 6),

  // 🔹 Image
  if (post.imageUrl != null)
    ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: post.imageUrl!.startsWith('/')
          ? Image.file(File(post.imageUrl!), fit: BoxFit.cover)
          : Image.network(post.imageUrl!, fit: BoxFit.cover),
    ),
] else ...[
  // 🌀 Repost Layout
  if (post.text.isNotEmpty)
    Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        post.text,
        style: TextStyle(fontSize: 13.5, color: Colors.teal[800]),
      ),
    ),

  Container(
    margin: const EdgeInsets.only(top: 4),
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                post.originalPost?.authorAvatar ??
                    'https://i.pravatar.cc/150?img=5',
              ),
            ),
            const SizedBox(width: 8),
            Text(
              post.originalPost?.authorName ?? "Unknown User",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          post.originalPost?.text ?? '',
          style: TextStyle(fontSize: 13.5, color: Colors.teal[800]),
        ),
        const SizedBox(height: 6),
        if (post.originalPost?.imageUrl != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              post.originalPost!.imageUrl!,
              fit: BoxFit.cover,
            ),
          ),
      ],
    ),
  ),
]
,

          const SizedBox(height: 6),

          // 🔹 Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // ❤️ Like
              Row(
                children: [
                  IconButton(
                    onPressed: _handleLike,
                    icon: Icon(
                      isLiked
                          ? Icons.thumb_up_alt
                          : Icons.thumb_up_alt_outlined,
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
  onPressed: () {
    String content = widget.post.text;
    if (widget.post.imageUrl != null && widget.post.imageUrl!.isNotEmpty) {
      // ✅ مشاركة نص + صورة
      Share.share('${widget.post.text}\n\n${widget.post.imageUrl}');
    } else {
      // ✅ مشاركة النص فقط
      Share.share(content);
    }
  },
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
