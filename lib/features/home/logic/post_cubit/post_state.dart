import 'package:linkedin/features/home/data/models/post_model.dart';
import 'package:linkedin/features/home/data/models/comment_model.dart';

/// 🧠 Base class for all post states
abstract class PostState {}

/// 🔵 Initial state
class PostInitial extends PostState {}

/// 🟡 Loading state (for add, delete, update)
class PostLoading extends PostState {}

/// 🟢 Success state with message
class PostSuccess extends PostState {
  final String message;
  PostSuccess(this.message);
}

/// 🔴 Error state with message (to show red icon + gray background)
class PostError extends PostState {
  final String message;
  PostError(this.message);
}

/// 👀 Stream state for watching posts
class PostsLoaded extends PostState {
  final List<PostModel> posts;
  PostsLoaded(this.posts);
}

/// 💬 Stream state for watching comments
class CommentsLoaded extends PostState {
  final List<CommentModel> comments;
  CommentsLoaded(this.comments);
}
