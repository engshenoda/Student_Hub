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

final class ResetPasswordLoadingState extends AuthCubitState {}

final class ResetPasswordSuccessState extends AuthCubitState {
  final String message;
  ResetPasswordSuccessState(this.message);
}

final class ResetPasswordFailureState extends AuthCubitState {
  final String failure;
  ResetPasswordFailureState(this.failure);
}
class GoogleLoginLoadingState extends AuthCubitState {}
class GoogleLoginSuccessState extends AuthCubitState {
  final UserModel user;
  GoogleLoginSuccessState(this.user);
}
class GoogleLoginFailureState extends AuthCubitState {
  final String error;
  GoogleLoginFailureState(this.error);
}

final class FacebookLoginLoadingState extends AuthCubitState {}

final class FacebookLoginSuccessState extends AuthCubitState {
  final UserModel user;
  FacebookLoginSuccessState(this.user);
}

final class FacebookLoginFailureState extends AuthCubitState {
  final String failure;
  FacebookLoginFailureState(this.failure);
}


