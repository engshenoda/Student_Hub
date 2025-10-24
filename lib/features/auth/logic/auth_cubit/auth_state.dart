part of 'auth_cubit.dart';

@immutable
sealed class AuthCubitState {}

final class AuthInitial extends AuthCubitState {}

final class SignUpSuccsessState extends AuthInitial {
  final UserModel user;

  SignUpSuccsessState(this.user);
}

final class SignUpLoadingState extends AuthInitial {}

final class SignUpFailureState extends AuthInitial {
  final String failure;

  SignUpFailureState(this.failure);
}

final class LoginSuccsessState extends AuthInitial {
  final UserModel user;

  LoginSuccsessState(this.user);
}

final class LoginLoadingState extends AuthInitial {}

final class LoginFailureState extends AuthInitial {
  final String failure;

  LoginFailureState(this.failure);
}

final class AuthPasswordVisibilityChanged extends AuthCubitState {
  final bool obscurePassword;
  final bool obscureConfirmPassword;

  AuthPasswordVisibilityChanged({
    required this.obscurePassword,
    required this.obscureConfirmPassword,
  });
}
