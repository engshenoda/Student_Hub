import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin/core/widgets/custom_bottom_navigation.dart';
import 'package:linkedin/features/home/data/rebo/posr_repo.dart';
import 'package:linkedin/features/home/data/service/post_service.dart';
import 'package:linkedin/features/home/logic/post_cubit/post_cubt.dart';
import 'package:linkedin/features/home/logic/post_cubit/post_state.dart';
import '../widgets/post_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final repo = PostRepository(PostService());
        final cubit = PostCubit(repo: repo);
        cubit.start(); // يبدأ تحميل البيانات
        return cubit;
      },
      child: CustomBottomNavigationBar(
        // خلى الـ Scaffold هنا جوه الـ CustomBottomNavigationBar مباشرة
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              // -------- Header Section --------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFB2DFDB), Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 22,
                          backgroundImage: NetworkImage(
                            'https://www.bing.com/th/id/OIP.EzA6vF2nER9bJEh6o1EHZAHaI7?w=174&h=211&c=8&rs=1&qlt=90&o=6&cb=12&dpr=1.3&pid=3.1&rm=2',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hi, Mera Mourad",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.teal[800],
                              ),
                            ),
                            Text(
                              "UI / UX Designer",
                              style: TextStyle(
                                color: Colors.teal[800],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.search, color: Colors.teal)),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.notifications_none_rounded,
                                color: Colors.teal, size: 26)),
                      ],
                    ),
                  ],
                ),
              ),
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
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return PostCard(
                            post: post,
                            onLike: () {
                              final currentUserId = 'CURRENT_USER_ID';
                              context
                                  .read<PostCubit>()
                                  .toggleLike(post.id, currentUserId);
                            },
                            onDelete: () {
                              context.read<PostCubit>().deletePost(post.id);
                            },
                            onEdit: () {
                              
  // نروح لصفحة Edit Post ونمرر البوست الحالي
  context.push('/AddPost', extra: post);


                            },
                            onAddComment: (text) {
                              final currentUserId = 'CURRENT_USER_ID';
                              final currentUserName = 'Mera Mourad';
                              context.read<PostCubit>().addComment(
                                  post.id, currentUserId, currentUserName, text);
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
