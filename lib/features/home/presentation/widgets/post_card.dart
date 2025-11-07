// features/home/presentation/widgets/post_card.dart
import 'package:flutter/material.dart';
import 'package:linkedin/core/widgets/user_info_row.dart';
import 'package:linkedin/features/home/data/models/post_model.dart';

typedef LikeCallback = void Function(bool currentIsLiked);
typedef QuickCommentCallback = void Function(String text);

class PostCard extends StatefulWidget {
  final PostModel post;
  final bool isLiked;
  final LikeCallback onLike;
  final VoidCallback onTapComments;
  final QuickCommentCallback? onAddQuickComment;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const PostCard({
    super.key,
    required this.post,
    required this.isLiked,
    required this.onLike,
    required this.onTapComments,
    this.onAddQuickComment,
    this.onDelete,
    this.onEdit,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late bool _localLiked;
  late int _localLikeCount;
  final _quickCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _localLiked = widget.isLiked;
    _localLikeCount = widget.post.likeCount;
  }

  void _toggleLike() {
    setState(() {
      _localLiked = !_localLiked;
      _localLikeCount += _localLiked ? 1 : -1;
    });
    widget.onLike(_localLiked);
  }

  void _submitQuickComment() {
    final text = _quickCtrl.text.trim();
    if (text.isEmpty) return;
    widget.onAddQuickComment?.call(text);
    _quickCtrl.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserInfoRowWithFetch(
              userId: post.authorId,
              trailing: (widget.onEdit != null || widget.onDelete != null)
                  ? PopupMenuButton<String>(
                      onSelected: (v) {
                        if (v == 'edit') widget.onEdit?.call();
                        if (v == 'delete') widget.onDelete?.call();
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                    )
                  : null,
            ),
            const SizedBox(height: 10),
            if (post.content.isNotEmpty) Text(post.content),
            if (post.media.isNotEmpty) ...[
              const SizedBox(height: 8),
              // show first media image if exists (simple)
              if (post.media.first.type == 'image')
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(post.media.first.url),
                ),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                InkWell(
                  onTap: _toggleLike,
                  child: Row(
                    children: [
                      Icon(
                        _localLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                        color: _localLiked ? Colors.teal : Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text('$_localLikeCount'),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                InkWell(
                  onTap: widget.onTapComments,
                  child: Row(
                    children: [
                      const Icon(Icons.comment_outlined, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text('${post.commentCount}'),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.share_outlined),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // quick add comment (small)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _quickCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Write a comment...',
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _submitQuickComment,
                  icon: const Icon(Icons.send, color: Colors.teal),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
