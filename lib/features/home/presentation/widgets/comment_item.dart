// features/home/presentation/widgets/comment_item.dart
import 'package:flutter/material.dart';
import 'package:linkedin/core/widgets/user_info_row.dart';
import 'package:linkedin/features/home/data/models/comment_model.dart';

class CommentItem extends StatelessWidget {
  final CommentModel comment;
  final bool isOwner;
  final VoidCallback onLike;
  final void Function(String newText) onEdit;

  const CommentItem({
    super.key,
    required this.comment,
    required this.isOwner,
    required this.onLike,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserInfoRow(
            name: comment.authorId, // replace with authorName if available
            jobTitle: '',
            imageUrl: null,
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
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'edit', child: Text('Edit')),
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
                icon: const Icon(Icons.thumb_up_alt_outlined, size: 18),
                onPressed: onLike,
              ),
              Text('${comment.likeCount}'),
            ],
          ),
        ],
      ),
    );
  }
}
