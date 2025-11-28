import 'package:flutter/material.dart';
import 'package:linkedin/core/widgets/user_info_row.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:linkedin/features/home/data/models/post_model.dart';

typedef LikeCallback = Future<bool> Function(bool currentIsLiked);
typedef QuickCommentCallback = void Function(String text);

class PostCardComment extends StatefulWidget {
  final PostModel post;
  final bool isLiked;
  final LikeCallback onLike;
  final VoidCallback onTapComments;
  final QuickCommentCallback? onAddQuickComment;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const PostCardComment({
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
  State<PostCardComment> createState() => _PostCardState();
}

class _PostCardState extends State<PostCardComment> {
  late bool _localLiked;
  late int _localLikeCount;
  final _quickCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _localLiked = widget.isLiked;
    _localLikeCount = widget.post.likeCount;
  }

  @override
  void didUpdateWidget(covariant PostCardComment oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.post.likeCount != oldWidget.post.likeCount) {
      setState(() {
        _localLikeCount = widget.post.likeCount;
      });
    }
    if (widget.isLiked != oldWidget.isLiked) {
      setState(() {
        _localLiked = widget.isLiked;
      });
    }
  }

  void _toggleLike() async {
    setState(() {
      _localLiked = !_localLiked;
      _localLikeCount += _localLiked ? 1 : -1;
    });
    final success = await widget.onLike(_localLiked);
    if (!success) {
      // rollback
      setState(() {
        _localLiked = !_localLiked;
        _localLikeCount += _localLiked ? 1 : -1;
      });
      // show message
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to update like')));
      }
    }
  }

  void _submitQuickComment() {
    final text = _quickCtrl.text.trim();
    if (text.isEmpty) return;
    widget.onAddQuickComment?.call(text);
    _quickCtrl.clear();
    FocusScope.of(context).unfocus();
  }

  Widget _buildLinkPreview() {
    if (widget.post.links.isEmpty) return const SizedBox.shrink();
    return Column(
      children: widget.post.links.map((link) {
        return Card(
          margin: const EdgeInsets.only(top: 8),
          child: ListTile(
            leading: const Icon(Icons.link, color: Colors.teal),
            title: InkWell(
              onTap: () async {
                try {
                  final uri = Uri.tryParse(link);
                  if (uri == null) throw Exception('Invalid URL');
                  if (!await launchUrl(
                    uri,
                    mode: LaunchMode.externalApplication,
                  )) {
                    throw Exception('Could not launch');
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Unable to open link')),
                    );
                  }
                }
              },
              child: Text(
                link,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.teal,
                ),
              ),
            ),
            onTap: () async {
              // also handle tapping the whole tile
              final uri = Uri.tryParse(link);
              if (uri != null) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),
        );
      }).toList(),
    );
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
              userId: post.authorId, // ✅ هذا هو الحل الصحيح
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

            _buildLinkPreview(),

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
              ],
            ),
            const SizedBox(height: 8),
            if (widget.onAddQuickComment != null) ...[
              Row(
                children: [
                  // Expanded(
                  //   child: TextField(
                  //     controller: _quickCtrl,
                  //     decoration: const InputDecoration(
                  //       hintText: 'Write a comment...',
                  //       isDense: true,
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.zero,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // IconButton(
                  //   onPressed: _submitQuickComment,
                  //   icon: const Icon(Icons.send, color: Colors.teal),
                  // ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
