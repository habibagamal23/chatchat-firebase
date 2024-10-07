part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final User user;
  LoginSuccess({required this.user});
}

class LoginFailure extends LoginState {
  final String errorMessage;
  LoginFailure(this.errorMessage);
}

// Password visibility toggle state
class LoginPasswordVisibilityToggled extends LoginState {
  final bool isPasswordVisible;

  LoginPasswordVisibilityToggled(this.isPasswordVisible);
}

