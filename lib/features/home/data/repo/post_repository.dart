// features/home/data/repo/post_repository.dart
import 'package:linkedin/features/home/data/models/post_model.dart';
import 'package:linkedin/features/home/data/models/comment_model.dart';
import 'package:linkedin/features/home/data/service/post_service.dart';

class PostRepository {
  final PostServices _firestoreService;

  PostRepository(this._firestoreService);

  Future<void> addPost(PostModel post) async {
    await _firestoreService.addPost(post);
  }

  Future<void> updatePost(PostModel post) async {
    await _firestoreService.updatePost(post);
  }

  Future<void> deletePost(String postId) async {
    await _firestoreService.deletePost(postId);
  }

  Stream<List<PostModel>> watchPosts() {
    return _firestoreService.watchPosts();
  }

  Future<void> addComment(String postId, CommentModel comment) async {
    await _firestoreService.addComment(postId, comment);
  }

  Future<void> updateComment(String postId, CommentModel comment) async {
    await _firestoreService.updateComment(postId, comment);
  }

  Future<void> deleteComment(String postId, String commentId) async {
    await _firestoreService.deleteComment(postId, commentId);
  }

  Stream<List<CommentModel>> watchComments(String postId) {
    return _firestoreService.watchComments(postId);
  }

  Future<void> toggleLike({
    required String postId,
    required String userId,
    required bool isLiked,
  }) async {
    try {
      await _firestoreService.toggleLike(postId, userId, isLiked);
    } catch (e) {
      throw Exception('❌ Failed to toggle like: $e');
    }
  }

  Future<void> toggleCommentLike({
    required String postId,
    required String commentId,
    required String userId,
    required bool isLiked,
  }) async {
    try {
      await _firestoreService.toggleCommentLike(
        postId,
        commentId,
        userId,
        isLiked,
      );
    } catch (e) {
      throw Exception('❌ Failed to toggle comment like: $e');
    }
  }
}
