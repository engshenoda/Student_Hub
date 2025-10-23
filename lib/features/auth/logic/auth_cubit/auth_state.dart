part of 'auth_cubit.dart';

@immutable
sealed class AuthCubitState {}

final class AuthInitial extends AuthCubitState {}

final class AuthSuccsessState extends AuthInitial {
  final UserModel user;

  AuthSuccsessState(this.user);
}

final class AuthLoadingState extends AuthInitial {}

final class AuthFailureState extends AuthInitial {
  final String failure;

  AuthFailureState(this.failure);
}

final class AuthPasswordVisibilityChanged extends AuthCubitState {
  final bool obscurePassword;
  final bool obscureConfirmPassword;

  AuthPasswordVisibilityChanged({
    required this.obscurePassword,
    required this.obscureConfirmPassword,
  });
}
