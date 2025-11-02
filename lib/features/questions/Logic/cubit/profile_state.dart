import 'package:linkedin/features/questions/data/Model/ProfileModel.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class UserLoaded extends ProfileState {
  final UserModel user;
  UserLoaded(this.user);
}

class UserError extends ProfileState {
  final String message;
  UserError(this.message);
}
