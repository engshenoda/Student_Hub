import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkedin/features/search_feature/model/search_model.dart';
import 'package:linkedin/features/search_feature/repository/search_repo.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepository repository;

  StreamSubscription<List<UserModel>>? _peopleSub;
  StreamSubscription<List<JobModel>>? _jobsSub;

  SearchCubit(this.repository) : super(SearchInitial());

  void searchAll(String query) {
    emit(SearchLoading());

    _peopleSub?.cancel();
    _jobsSub?.cancel();

    List<UserModel> people = [];
    List<JobModel> jobs = [];

    _peopleSub = repository.streamPeople(query).listen((data) {
      people = data;
      emit(SearchLoaded(
        people: people,
        jobs: jobs,
      ));
    });


    _jobsSub = repository.streamJobs(query).listen((data) {
      jobs = data;
      emit(SearchLoaded(
        people: people,
        jobs: jobs,
      ));
    });


  @override
  Future<void> close() {
    _peopleSub?.cancel();
    _jobsSub?.cancel();
    return super.close();
  }
}

}