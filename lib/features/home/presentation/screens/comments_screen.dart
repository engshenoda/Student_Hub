// features/home/presentation/screens/comments_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linkedin/features/home/logic/post_cubit/post_cubit.dart';
import 'package:linkedin/features/home/logic/post_cubit/post_state.dart';
import 'package:linkedin/features/home/data/models/post_model.dart';
import 'package:linkedin/features/home/data/models/comment_model.dart';
import 'package:linkedin/features/home/presentation/widgets/comment_item.dart';
import 'package:linkedin/features/home/presentation/widgets/add_comment_field.dart';
import 'package:linkedin/features/home/presentation/widgets/post_card.dart';

class CommentsScreen extends StatefulWidget {
  final PostModel post;

  const CommentsScreen({super.key, required this.post});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late final PostCubit _cubit;
  late final String currentUserId;
  final Set<String> _optimisticLiked = {};

  @override
  void initState() {
    super.initState();
    _cubit = context.read<PostCubit>();
    final user = FirebaseAuth.instance.currentUser;
    currentUserId = user?.uid ?? '';

    _cubit.watchComments(widget.post.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments', style: TextStyle(color: Colors.teal)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.teal,
        elevation: 1,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PostCard(
              post: widget.post,
              isLiked: widget.post.likes.contains(currentUserId),
              onLike: (isLiked) async {
                final success = await _cubit.toggleLike(
                  postId: widget.post.id,
                  userId: currentUserId,
                  isLiked: isLiked,
                );
                if (!success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to update like')),
                  );
                }
                return success;
              },
              onTapComments: () {},
              onAddQuickComment: (_) {},
              onEdit: () {},
              onDelete: () {},
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: BlocBuilder<PostCubit, PostState>(
              builder: (context, state) {
                if (state is PostLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is CommentsLoaded) {
                  final comments = state.comments;
                  if (comments.isEmpty) {
                    return const Center(
                      child: Text('No comments yet — be first!'),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: comments.length,
                    separatorBuilder: (_, __) => const Divider(height: 0),
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      final isOwner = comment.authorId == currentUserId;
                      final serverLiked = comment.likes.contains(currentUserId);
                      final isOptimistic = _optimisticLiked.contains(
                        comment.id,
                      );
                      final isLiked = isOptimistic ? !serverLiked : serverLiked;
                      final displayedLikeCount =
                          comment.likeCount +
                          (isOptimistic ? (serverLiked ? -1 : 1) : 0);
                      return CommentItem(
                        comment: comment,
                        isOwner: isOwner,
                        isLiked: isLiked,
                        displayedLikeCount: displayedLikeCount,
                        onLike: () async {
                          final currentLiked = serverLiked;
                          // optimistic update: toggle presence in set
                          setState(() {
                            if (_optimisticLiked.contains(comment.id)) {
                              _optimisticLiked.remove(comment.id);
                            } else {
                              _optimisticLiked.add(comment.id);
                            }
                          });
                          final success = await _cubit.toggleCommentLike(
                            postId: widget.post.id,
                            comment: comment,
                            userId: currentUserId,
                            isLiked: currentLiked,
                          );
                          if (!success && mounted) {
                            // revert optimistic
                            setState(() {
                              if (currentLiked) {
                                _optimisticLiked.add(comment.id);
                              } else {
                                _optimisticLiked.remove(comment.id);
                              }
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Failed to update comment like'),
                              ),
                            );
                          }
                        },
                        onEdit: (newText) {
                          final updated = comment.copyWith(
                            content: newText,
                            updatedAt: DateTime.now(),
                          );
                          _cubit.updateComment(widget.post.id, updated);
                        },
                        onDelete: () =>
                            _cubit.deleteComment(widget.post.id, comment.id),
                      );
                    },
                  );
                }

                if (state is PostError) {
                  return Center(child: Text('Error: ${state.message}'));
                }

                return const SizedBox.shrink();
              },
            ),
          ),

          AddCommentField(
            onSubmit: (text) {
              if (text.trim().isEmpty) return;
              final newComment = CommentModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                postId: widget.post.id,
                authorId: currentUserId,
                content: text.trim(),
                createdAt: DateTime.now(),
              );
              _cubit.addComment(widget.post.id, newComment);
            },
          ),
        ],
      ),
    );
  }
}
