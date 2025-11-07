// features/home/presentation/screens/comments_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linkedin/features/home/logic/post_cubit/post_cubt.dart';
import 'package:linkedin/features/home/logic/post_cubit/post_state.dart';
import 'package:linkedin/features/home/data/models/post_model.dart';
import 'package:linkedin/features/home/data/models/comment_model.dart';
import 'package:linkedin/features/home/presentation/widgets/comment_item.dart';
import 'package:linkedin/features/home/presentation/widgets/add_comment_field.dart';
import 'package:linkedin/features/home/presentation/widgets/post_card.dart';

class CommentsScreen extends StatefulWidget {
  // post will arrive via GoRouter extra
  const CommentsScreen({super.key});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late final PostCubit _cubit;
  late final PostModel post;
  late final String currentUserId;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<PostCubit>();
    // get post from extra
    final extra = GoRouterState.of(context).extra;
    if (extra != null && extra is PostModel) {
      post = extra;
    } else {
      // fallback: route should always pass post
      throw Exception('CommentsScreen requires a PostModel in extra');
    }
    final user = FirebaseAuth.instance.currentUser;
    currentUserId = user?.uid ?? '';

    // start listening comments for this post
    _cubit.watchComments(post.id);
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
          // show post summary on top
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PostCard(
              post: post,
              isLiked:
                  (post is dynamic &&
                  (post.likes != null &&
                      (post.likes as List).contains(currentUserId))),
              onLike: (isLiked) => _cubit.toggleLike(post, isLiked),
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
                if (state is PostLoading || state is PostInitial) {
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
                      final CommentModel comment = comments[index];
                      final isOwner = comment.authorId == currentUserId;
                      return CommentItem(
                        comment: comment,
                        isOwner: isOwner,
                        onLike: () => _cubit.toggleCommentLike(
                          post.id,
                          comment,
                          comment.likeCount > 0 ? true : false,
                        ),
                        onEdit: (newText) {
                          final updated = comment.copyWith(
                            content: newText,
                            updatedAt: DateTime.now(),
                          );
                          _cubit.updateComment(post.id, updated);
                        },
                        // no deleteComment method in cubit — not calling
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

          // add comment
          AddCommentField(
            onSubmit: (text) {
              if (text.trim().isEmpty) return;
              final newComment = CommentModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                postId: post.id,
                authorId: currentUserId,
                content: text.trim(),
                createdAt: DateTime.now(),
                updatedAt: null,
                likeCount: 0,
                parentCommentId: null,
              );
              _cubit.addComment(post.id, newComment);
            },
          ),
        ],
      ),
    );
  }
}
