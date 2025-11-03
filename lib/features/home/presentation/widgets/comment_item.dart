import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkedin/features/home/logic/comment_cubit/comment_cubit.dart';

class CommentItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String job;
  final String time;
  final String comment;
  final String postId;
  final String commentId;
  final Map<String, dynamic> likes; // userId -> true
  final String currentUserId;

  const CommentItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.job,
    required this.time,
    required this.comment,
    required this.postId,
    required this.commentId,
    required this.likes,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLiked = likes.containsKey(currentUserId);
    final int likeCount = likes.length;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundImage: NetworkImage(imageUrl),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header (name + job + time)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.teal[800],
                        ),
                      ),
                      Text(
                        job,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.teal[800],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // Comment text
              Text(
                comment,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 6),

              // Actions (like button + count)
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                      size: 18,
                      color: isLiked ? Colors.teal[800] : Colors.teal[800],
                    ),
                    onPressed: () {
                      context.read<CommentCubit>().toggleCommentLike(
                            postId,
                            commentId,
                            currentUserId,
                          );
                    },
                  ),

                  // 🔹 "Like" + عداد
                  Row(
                    children: [
                      Text(
                        'Like',
                        style: TextStyle(
                          fontSize: 13,
                          color: isLiked ? Colors.teal[800] : Colors.teal[800],
                        ),
                      ),
                      if (likeCount > 0) ...[
                        const SizedBox(width: 4),
                        Text(
                          '($likeCount)',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.teal[800],
                          ),
                        ),
                      ],
                    ],
                  ),

                  

                 
               
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
