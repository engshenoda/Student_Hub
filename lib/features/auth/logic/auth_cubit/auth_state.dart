part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}
final class SuccsessState extends AuthInitial {}
final class LoadingState extends AuthInitial {}
final class FailureState extends AuthInitial {}
