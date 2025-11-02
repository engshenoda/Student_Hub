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
    } finally {
      // return to loaded state; posts stream will update automatically
    }
  }

  Future<void> editPost({required String postId, required Map<String, dynamic> updates, dynamic newImage}) async {
    emit(PostActionInProgress());
    try {
      await repo.updatePost(postId: postId, updates: updates, newImage: newImage);
      emit(PostActionSuccess());
    } catch (e) {
      emit(PostActionFailure(e.toString()));
    }
  }

  Future<void> deletePost(String postId) async {
    emit(PostActionInProgress());
    try {
      await repo.removePost(postId);
      emit(PostActionSuccess());
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


  Future<void> toggleLike(String postId, String userId) => repo.toggleLike(postId, userId);

  Future<void> addComment(String postId, String userId, String userName, String text) =>
      repo.addComment(postId, userId, userName, text);

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
