// features/home/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin/core/routes/route.dart';
import 'package:linkedin/features/home/data/models/comment_model.dart';
import 'package:linkedin/features/home/logic/post_cubit/post_cubt.dart';
import 'package:linkedin/features/home/logic/post_cubit/post_state.dart';
import 'package:linkedin/features/home/presentation/widgets/home_header.dart';
import 'package:linkedin/features/home/presentation/widgets/post_card.dart';
import 'package:linkedin/core/widgets/custom_bottom_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PostCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<PostCubit>();
    _cubit.watchPosts(); // تشغيل المراقبة
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserId = currentUser?.uid ?? '';

    return CustomBottomNavigationBar(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // 🟢 Header
              HomeHeader(),
              const SizedBox(height: 8),
              // 🟣 Posts Section
              Expanded(
                child: BlocBuilder<PostCubit, PostState>(
                  builder: (context, state) {
                    if (state is PostInitial || state is PostLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is PostError) {
                      return Center(child: Text('Error: ${state.message}'));
                    } else if (state is PostsLoaded) {
                      final posts = state.posts;

                      if (posts.isEmpty) {
                        return const Center(
                          child: Text('No posts yet — be the first!'),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async => _cubit.watchPosts(),
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          itemCount: posts.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, idx) {
                            final post = posts[idx];
                            final isLiked = (post.likes ?? []).contains(
                              currentUserId,
                            );

                            return PostCard(
                              post: post,
                              isLiked: isLiked,
                              onLike: (liked) => _cubit.toggleLike(post, liked),
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
                                  updatedAt: null,
                                  likeCount: 0,
                                  parentCommentId: null,
                                );
                                _cubit.addComment(post.id, newComment);
                              },
                              onDelete: () async {
                                await _cubit.deletePost(post.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Post deleted')),
                                );
                              },
                              onEdit: () =>
                                  context.push('/AddPost', extra: post),
                            );
                          },
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push(Routes.addPostScreen),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
