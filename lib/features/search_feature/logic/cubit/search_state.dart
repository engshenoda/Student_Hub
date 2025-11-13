import 'package:equatable/equatable.dart';
import 'package:linkedin/features/search_feature/model/search_model.dart';

abstract class SearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<UserModel> people;
  final List<PostModel> posts;
  final List<JobModel> jobs;

  SearchLoaded({
    this.people = const [],
    this.posts = const [],
    this.jobs = const [],
  });

  @override
  List<Object?> get props => [people, posts, jobs];
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);

  @override
  List<Object?> get props => [message];
}
