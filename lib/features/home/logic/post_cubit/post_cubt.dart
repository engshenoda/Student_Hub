import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkedin/features/home/data/models/post_model.dart';
import 'package:linkedin/features/home/data/models/comment_model.dart';
import 'package:linkedin/features/home/data/repo/post_repository.dart';
import 'post_state.dart';

/// 🎯 PostCubit - Handles all post-related logic
class PostCubit extends Cubit<PostState> {
  final PostRepository _repository;

  PostCubit(this._repository) : super(PostInitial());

  /// 🟢 Add new post
  Future<void> addPost(PostModel post) async {
    emit(PostLoading());
    try {
      await _repository.addPost(post);
      emit(PostSuccess('Post uploaded successfully ✅'));
    } catch (e) {
      emit(PostError('Failed to upload post: $e'));
    }
  }

  /// 🟡 Update post
  Future<void> updatePost(PostModel post) async {
    emit(PostLoading());
    try {
      await _repository.updatePost(post);
      emit(PostSuccess('Post updated successfully ✅'));
    } catch (e) {
      emit(PostError('Failed to update post: $e'));
    }
  }

  /// 🔴 Delete post
  Future<void> deletePost(String postId) async {
    emit(PostLoading());
    try {
      await _repository.deletePost(postId);
      emit(PostSuccess('Post deleted successfully ✅'));
    } catch (e) {
      emit(PostError('Failed to delete post: $e'));
    }
  }

  /// 👀 Watch posts in real-time
  void watchPosts() {
    emit(PostLoading());
    _repository.watchPosts().listen(
      (posts) {
        emit(PostsLoaded(posts));
      },
      onError: (e) => emit(PostError('Error loading posts: $e')),
    );
  }

  /// 💬 Add comment to a post
  Future<void> addComment(String postId, CommentModel comment) async {
    try {
      await _repository.addComment(postId, comment);
      emit(PostSuccess('Comment added successfully 💬'));
    } catch (e) {
      emit(PostError('Failed to add comment: $e'));
    }
  }

  /// 💬 Update comment
  Future<void> updateComment(String postId, CommentModel comment) async {
    try {
      await _repository.updateComment(postId, comment);
      emit(PostSuccess('Comment updated successfully ✏️'));
    } catch (e) {
      emit(PostError('Failed to update comment: $e'));
    }
  }

  /// 👀 Watch comments of a post
  void watchComments(String postId) {
    _repository.watchComments(postId).listen(
      (comments) {
        emit(CommentsLoaded(comments));
      },
      onError: (e) => emit(PostError('Error loading comments: $e')),
    );
  }

  /// ❤️ Like or unlike a post
  Future<void> toggleLike(PostModel post, bool isLiked) async {
    try {
      await _repository.toggleLike(post: post, isLiked: isLiked);
    } catch (e) {
      emit(PostError('Failed to toggle like: $e'));
    }
  }

  /// ❤️ Like or unlike a comment
  Future<void> toggleCommentLike(String postId, CommentModel comment, bool isLiked) async {
    try {
      await _repository.toggleCommentLike(postId: postId, comment: comment, isLiked: isLiked);
    } catch (e) {
      emit(PostError('Failed to toggle comment like: $e'));
    }
  }
}
