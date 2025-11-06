import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkedin/features/home/data/rebo/posr_repo.dart';
import 'package:linkedin/features/home/data/service/post_service.dart';
import 'package:linkedin/features/home/logic/comment_cubit/comment_cubit.dart';
import 'package:linkedin/features/home/logic/comment_cubit/comment_state.dart';
import '../widgets/comment_item.dart';

class Comments extends StatefulWidget {
  final String postId;
  const Comments({super.key, required this.postId});

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
  final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserId = currentUser?.uid ?? 'guest_user';
    final currentUserName = currentUser?.displayName ?? 'Unknown User';
final currentUserImagrUrl= currentUser?.photoURL ?? 'https://i.pravatar.cc/150?img=3';
    return BlocProvider(
      create: (_) {
        final repo = PostRepository(PostService());
        final cubit = CommentCubit(repo);
        cubit.start(widget.postId);
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Comments', style: TextStyle(color: Colors.teal)),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.teal),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<CommentCubit, CommentState>(
                builder: (context, state) {
                  if (state is CommentLoading || state is CommentInitial) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CommentLoaded) {
                    if (state.comments.isEmpty) {
                      return const Center(child: Text('No comments yet.'));
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.comments.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final c = state.comments[index];
                        return CommentItem(
  imageUrl: c.userImage.isNotEmpty ? c.userImage : currentUserImagrUrl,
  name: c.userName,
  job: '',
  time: c.createdAt.toLocal().toString().split('.')[0],
  comment: c.text,
  postId: widget.postId, // ✅ البوست الحالي
  commentId: c.id,       // ✅ id الكومنت نفسه
  likes: c.likes,        // ✅ خريطة اللايكات من الموديل
  currentUserId: currentUserId, // ✅ المستخدم الحالي
);

                      },
                    );
                  } else if (state is CommentError) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),

            // إضافة كومنت
            SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                color: Colors.grey.shade100,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Write a comment...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.teal),
                      onPressed: () {
                        final text = _controller.text.trim();
                        if (text.isEmpty) return;

                        // استخدام PostCubit لإضافة الكومنت
                        final postRepo = PostRepository(PostService());
                        postRepo.addComment(
                          widget.postId,
                          currentUserId,
                          currentUserName,
                          text,
                        );

                        _controller.clear();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
