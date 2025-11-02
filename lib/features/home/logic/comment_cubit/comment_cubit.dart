import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkedin/features/home/data/models/comment_model.dart';
import 'package:linkedin/features/home/data/rebo/posr_repo.dart';
import 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  final PostRepository repo;
  StreamSubscription<List<CommentModel>>? _sub;

  CommentCubit(this.repo) : super(CommentInitial());

  void start(String postId) {
    emit(CommentLoading());
    _sub = repo.watchComments(postId).listen((comments) {
      emit(CommentLoaded(comments));
    }, onError: (e) {
      emit(CommentError(e.toString()));
    });
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
