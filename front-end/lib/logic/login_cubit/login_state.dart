part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

class LoginLoad extends LoginState {}

class LoginGetPhone extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginError extends LoginState {
  String message;
  LoginError({required this.message});
}
