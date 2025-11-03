import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin/core/widgets/custom_bottom_navigation.dart';
import 'package:linkedin/features/home/data/rebo/posr_repo.dart';
import 'package:linkedin/features/home/data/service/post_service.dart';
import 'package:linkedin/features/home/logic/post_cubit/post_cubt.dart';
import 'package:linkedin/features/home/logic/post_cubit/post_state.dart';
import 'package:linkedin/features/home/presentation/widgets/home_header.dart';
import '../widgets/post_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserId = currentUser?.uid ?? 'guest_user';
    final currentUserName = currentUser?.displayName ?? 'Unknown User';

    return BlocProvider(
      create: (context) {
        final repo = PostRepository(PostService());
        final cubit = PostCubit(repo: repo);
        cubit.start(); // يبدأ تحميل البيانات
        return cubit;
      },
      child: CustomBottomNavigationBar(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              // -------- Header Section --------
              const HomeHeader(),
              const SizedBox(height: 10),

              // -------- Posts Section --------
              Expanded(
                child: BlocBuilder<PostCubit, PostState>(
                  builder: (context, state) {
                    if (state is PostLoading || state is PostInitial) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is PostLoaded) {
                      final posts = state.posts;
                      if (posts.isEmpty) {
                        return const Center(child: Text('No posts yet.'));
                      }

                      return ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: posts.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return PostCard(
                            post: post,

                            // ❤️ Like
                            onLike: () {
                              context.read<PostCubit>().toggleLike(
                                    post.id,
                                    currentUserId,
                                  );
                            },

                            // 🗑️ Delete
                            onDelete: () async {
    await context.read<PostCubit>().deletePost(post.id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post deleted successfully'),
      backgroundColor: Colors.teal,),
    );
  },

                            // ✏️ Edit
                            onEdit: () {
                              context.push('/AddPost', extra: post);
                            },

                            // 💬 Comment
                            onAddComment: (text) {
                              context.read<PostCubit>().addComment(
                                    post.id,
                                    currentUserId,
                                    currentUserName,
                                    text,
                                  );
                            },
                          );
                        },
                      );
                    } else if (state is PostError) {
                      return Center(child: Text('Error: ${state.message}'));
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
