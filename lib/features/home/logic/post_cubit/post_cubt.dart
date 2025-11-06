import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:linkedin/features/home/data/models/post_model.dart';
import 'package:linkedin/features/home/data/rebo/posr_repo.dart';
import 'package:linkedin/features/home/logic/post_cubit/post_state.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepository repo;
  StreamSubscription<List<Post>>? _sub;

  PostCubit({required this.repo}) : super(PostInitial());

  void start() {
    emit(PostLoading());
    _sub = repo.watchPosts().listen((posts) {
      emit(PostLoaded(posts: posts));
    }, onError: (e) {
      emit(PostError(message: e.toString()));
    });
  }

  Future<void> addPost({required Post post, required dynamic imageFile}) async {
    emit(PostActionInProgress());
    try {
      await repo.createPost(post: post, imageFile: imageFile);
      emit(PostActionSuccess());
    } catch (e) {
      emit(PostActionFailure(e.toString()));
    }
  }

  Future<void> editPost({
    required String postId,
    required Map<String, dynamic> updates,
    dynamic newImage,
  }) async {
    emit(PostActionInProgress());
    try {
      await repo.updatePost(postId: postId, updates: updates, newImage: newImage);
      emit(PostActionSuccess());
    } catch (e) {
      emit(PostActionFailure(e.toString()));
    }
  }

  Future<void> deletePost(String postId) async {
    final currentState = state;
    if (currentState is PostLoaded) {
      final updatedPosts = currentState.posts.where((p) => p.id != postId).toList();
      emit(PostLoaded(posts: updatedPosts)); // 🔥 تحديث محلي فوري
    }

    try {
      await repo.removePost(postId);
      // الـ stream هيتكفل بتحديث الحالة تلقائيًا
    } catch (e) {
      emit(PostActionFailure(e.toString()));
    }
  }

  Future<void> repost({
    required Post originalPost,
    required String userId,
    required String userName,
    String? userAvatar,
    String? caption,
  }) async {
    emit(PostActionInProgress());
    try {
      await repo.repostPost(
        originalPost: originalPost,
        userId: userId,
        userName: userName,
        userAvatar: userAvatar,
        caption: caption,
      );
      emit(PostActionSuccess());
    } catch (e) {
      emit(PostActionFailure(e.toString()));
    }
  }

  // ✅ تعديل toggleLike بحيث يحدث فورًا في الواجهة
  Future<void> toggleLike(String postId, String userId) async {
    try {
      final currentState = state;
      if (currentState is PostLoaded) {
        // نعمل نسخة جديدة من الليست
        final updatedPosts = currentState.posts.map((post) {
          if (post.id == postId) {
            final updatedLikes = Map<String, bool>.from(post.likes);
            if (updatedLikes.containsKey(userId)) {
              updatedLikes.remove(userId);
            } else {
              updatedLikes[userId] = true;
            }
            // نرجع نسخة جديدة من البوست بعد التحديث
            return post.copyWith(likes: updatedLikes);
          }
          return post;
        }).toList();

        // 🔹 نحدث الواجهة فورًا
        emit(PostLoaded(posts: updatedPosts));

        // 🔹 نحدث Firestore بعدين
        await repo.toggleLike(postId, userId);
      }
    } catch (e) {
      emit(PostActionFailure(e.toString()));
    }
  }

  Future<void> addComment(String postId, String userId, String userName, String text) =>
      repo.addComment(postId, userId, userName, text);

      





      

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
