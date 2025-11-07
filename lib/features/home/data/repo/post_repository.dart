import 'package:linkedin/features/home/data/models/post_model.dart';
import 'package:linkedin/features/home/data/models/comment_model.dart';
import 'package:linkedin/features/home/data/service/post_service.dart';

/// 🧩 Repository layer between Cubit and FirestoreService
/// Responsible for managing posts, comments, and likes logic
class PostRepository {
  final PostServices _firestoreService;

  PostRepository(this._firestoreService);

  /// 🟢 Add a new post
  Future<void> addPost(PostModel post) async {
    await _firestoreService.addPost(post);
  }

  /// 🟡 Update post
  Future<void> updatePost(PostModel post) async {
    await _firestoreService.updatePost(post);
  }

  /// 🔴 Delete post
  Future<void> deletePost(String postId) async {
    await _firestoreService.deletePost(postId);
  }

  /// 👀 Watch all posts
  Stream<List<PostModel>> watchPosts() {
    return _firestoreService.watchPosts();
  }

  /// 💬 Add comment to a specific post
  Future<void> addComment(String postId, CommentModel comment) async {
    await _firestoreService.addComment(postId, comment);
  }

  /// 🟡 Update comment
  Future<void> updateComment(String postId, CommentModel comment) async {
    await _firestoreService.updateComment(postId, comment);
  }

  /// 👀 Watch all comments for a post
  Stream<List<CommentModel>> watchComments(String postId) {
    return _firestoreService.watchComments(postId);
  }

  /// ❤️ Like/Unlike post
  Future<void> toggleLike({
    required PostModel post,
    required bool isLiked,
  }) async {
    try {
      final updatedLikes = isLiked ? post.likeCount - 1 : post.likeCount + 1;
      await _firestoreService.updatePost(
        post.copyWith(likeCount: updatedLikes),
      );
    } catch (e) {
      throw Exception('❌ Failed to toggle like: $e');
    }
  }

  /// 💬 Like/Unlike comment
  Future<void> toggleCommentLike({
    required String postId,
    required CommentModel comment,
    required bool isLiked,
  }) async {
    try {
      final updatedLikes = isLiked
          ? comment.likeCount - 1
          : comment.likeCount + 1;
      final updatedComment = comment.copyWith(likeCount: updatedLikes);
      await _firestoreService.updateComment(postId, updatedComment);
    } catch (e) {
      throw Exception('❌ Failed to toggle comment like: $e');
    }
  }
}
