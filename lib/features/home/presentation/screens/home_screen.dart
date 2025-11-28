// features/home/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin/core/routes/route.dart';
import 'package:linkedin/features/home/data/models/comment_model.dart';
import 'package:linkedin/features/home/logic/post_cubit/post_cubit.dart';
import 'package:linkedin/features/home/logic/post_cubit/post_state.dart';
import 'package:linkedin/features/home/presentation/widgets/home_header.dart';
import 'package:linkedin/features/home/presentation/widgets/post_card.dart';
import 'package:linkedin/features/home/presentation/widgets/post_card_comment.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // PostCubit begins watching posts at app startup (created in main.dart)
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserId = currentUser?.uid ?? '';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const HomeHeader(),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<PostCubit, PostState>(
                builder: (context, state) {
                  final cubit = context.read<PostCubit>();
                  final posts = state is PostsLoaded
                      ? state.posts
                      : cubit.latestPosts;


                  if (posts.isEmpty) {
                    if (state is PostLoading || state is PostInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is PostError)
                      return Center(child: Text('Error: ${state.message}'));
                    return const Center(
                      child: Text('No posts yet — be the first!'),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      cubit.watchPosts();
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      itemCount: posts.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, idx) {
                        final post = posts[idx];
                        final isLiked = post.likes.contains(currentUserId);

                        final isOwner = post.authorId == currentUserId;

                        return PostCard(
                          post: post,
                          isLiked: isLiked,
                          onLike: (liked) async {
                            final success = await context
                                .read<PostCubit>()
                                .toggleLike(
                                  postId: post.id,
                                  userId: currentUserId,
                                  isLiked: liked,
                                );
                            if (!success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Failed to update like'),
                                ),
                              );
                            }
                            return success;
                          },
                          onTapComments: () =>
                              context.push(Routes.comments, extra: post),
                          onAddQuickComment: (text) {
                            if (text.trim().isEmpty) return;
                            final newComment = CommentModel(
                              id: DateTime.now().millisecondsSinceEpoch
                                  .toString(),
                              postId: post.id,
                              authorId: currentUserId,
                              content: text.trim(),
                              createdAt: DateTime.now(),
                            );
                            context.read<PostCubit>().addComment(
                              post.id,
                              newComment,
                            );
                          },
                          onDelete: isOwner
                              ? () async {
                                  await context.read<PostCubit>().deletePost(
                                    post.id,
                                  );
                                  if (context.mounted)
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Post deleted'),
                                      ),
                                    );
                                }
                              : null,
                          onEdit: isOwner
                              ? () => context.push(
                                  Routes.addPostScreen,
                                  extra: post,
                                )
                              : null,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
