import 'package:equatable/equatable.dart';
import 'package:linkedin/features/home/data/models/comment_model.dart';
import 'package:linkedin/features/home/data/models/post_model.dart';


abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<PostModel> posts;
  HomeLoaded(this.posts);

  @override
  List<Object?> get props => [posts];
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

class HomeCommentsLoaded extends HomeState {
  final String postId;
  final List<CommentModel> comments;

  HomeCommentsLoaded(this.postId, this.comments);
}
///  عند رفع الصوره
class PostImagePicked extends HomeState {}

///  عند رفع البوست
class CreatePostLoading extends HomeState {}

class CreatePostSuccess extends HomeState {}

class CreatePostError extends HomeState {
  final String message;
   CreatePostError(this.message);

  @override
  List<Object?> get props => [message];
}


class RepostSuccess extends HomeState {}


