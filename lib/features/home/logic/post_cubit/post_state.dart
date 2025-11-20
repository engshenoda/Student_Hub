// features/home/logic/post_cubit/post_state.dart
import 'package:linkedin/features/home/data/models/post_model.dart';
import 'package:linkedin/features/home/data/models/comment_model.dart';

abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostSuccess extends PostState {
  final String message;
  PostSuccess(this.message);
}

class PostError extends PostState {
  final String message;
  PostError(this.message);
}

class PostsLoaded extends PostState {
  final List<PostModel> posts;
  PostsLoaded(this.posts);
}

class CommentsLoaded extends PostState {
  final List<CommentModel> comments;
  CommentsLoaded(this.comments);
}