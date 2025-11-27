// features/home/presentation/widgets/comment_item.dart
import 'package:flutter/material.dart';
import 'package:linkedin/core/widgets/user_info_row.dart';
import 'package:linkedin/features/home/data/models/comment_model.dart';

class CommentItem extends StatelessWidget {
  final CommentModel comment;
  final bool isOwner;
  final bool isLiked;
  final VoidCallback onLike;
  final int? displayedLikeCount;
  final void Function(String newText) onEdit;
  final VoidCallback? onDelete;

  const CommentItem({
    super.key,
    required this.comment,
    required this.isOwner,
    required this.isLiked,
    required this.onLike,
    this.displayedLikeCount,
    required this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // استخدم UserInfoRowWithFetch لجلب بيانات كاتب التعليق
          UserInfoRowWithFetch(
            userId: comment.authorId, // ✅ هذا هو الحل الصحيح
            trailing: isOwner
                ? PopupMenuButton<String>(
                    onSelected: (v) {
                      if (v == 'edit') {
                        final ctrl = TextEditingController(
                          text: comment.content,
                        );
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Edit comment'),
                            content: TextField(controller: ctrl, maxLines: 3),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  onEdit(ctrl.text.trim());
                                  Navigator.pop(context);
                                },
                                child: const Text('Save'),
                              ),
                            ],
                          ),
                        );
                      } else if (v == 'delete') {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Delete Comment'),
                            content: const Text(
                              'Are you sure you want to delete this comment?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  onDelete?.call();
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  )
                : null,
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Text(comment.content),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                  isLiked ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
                  size: 18,
                  color: isLiked ? Colors.blue : null,
                ),
                onPressed: onLike,
              ),
              Text('${displayedLikeCount ?? comment.likeCount}'),
            ],
          ),
        ],
      ),
    );
  }
}
