// features/home/logic/post_cubit/post_cubit.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkedin/features/home/data/models/post_model.dart';
import 'package:linkedin/features/home/data/models/comment_model.dart';
import 'package:linkedin/features/home/data/repo/post_repository.dart';
import 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepository _repository;
  StreamSubscription<List<PostModel>>? _postsSub;
  StreamSubscription<List<CommentModel>>? _commentsSub;

  PostCubit(this._repository) : super(PostInitial());

  Future<void> addPost(PostModel post) async {
    emit(PostLoading());
    try {
      await _repository.addPost(post);
      emit(PostSuccess('Post uploaded successfully ✅'));
    } catch (e) {
      emit(PostError('Failed to upload post: $e'));
    }
  }

  Future<void> updatePost(PostModel post) async {
    emit(PostLoading());
    try {
      await _repository.updatePost(post);
      emit(PostSuccess('Post updated successfully ✅'));
    } catch (e) {
      emit(PostError('Failed to update post: $e'));
    }
  }

  Future<void> deletePost(String postId) async {
    emit(PostLoading());
    try {
      await _repository.deletePost(postId);
      emit(PostSuccess('Post deleted successfully ✅'));
    } catch (e) {
      emit(PostError('Failed to delete post: $e'));
    }
  }

  void watchPosts() {
    emit(PostLoading());
    _postsSub?.cancel();
    _postsSub = _repository.watchPosts().listen((posts) {
      emit(PostsLoaded(posts));
    }, onError: (e) => emit(PostError('Error loading posts: $e')));
  }

  Future<void> addComment(String postId, CommentModel comment) async {
    try {
      await _repository.addComment(postId, comment);
      emit(PostSuccess('Comment added successfully 💬'));
    } catch (e) {
      emit(PostError('Failed to add comment: $e'));
    }
  }

  Future<void> updateComment(String postId, CommentModel comment) async {
    try {
      await _repository.updateComment(postId, comment);
      emit(PostSuccess('Comment updated successfully ✏️'));
    } catch (e) {
      emit(PostError('Failed to update comment: $e'));
    }
  }

  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await _repository.deleteComment(postId, commentId);
      emit(PostSuccess('Comment deleted successfully 🗑️'));
    } catch (e) {
      emit(PostError('Failed to delete comment: $e'));
    }
  }

  void watchComments(String postId) {
    _commentsSub?.cancel();
    _commentsSub = _repository.watchComments(postId).listen((comments) {
      emit(CommentsLoaded(comments));
    }, onError: (e) => emit(PostError('Error loading comments: $e')));
  }

  @override
  Future<void> close() {
    _postsSub?.cancel();
    _commentsSub?.cancel();
    return super.close();
  }

  Future<bool> toggleLike({
    required String postId,
    required String userId,
    required bool isLiked,
  }) async {
    try {
      await _repository.toggleLike(
        postId: postId,
        userId: userId,
        isLiked: isLiked,
      );
      return true;
    } catch (e) {
      emit(PostError('Failed to toggle like: $e'));
      return false;
    }
  }

  Future<bool> toggleCommentLike({
    required String postId,
    required CommentModel comment,
    required String userId,
    required bool isLiked,
  }) async {
    try {
      await _repository.toggleCommentLike(
        postId: postId,
        commentId: comment.id,
        userId: userId,
        isLiked: isLiked,
      );
      return true;
    } catch (e) {
      emit(PostError('Failed to toggle comment like: $e'));
      return false;
    }
  }
}
