part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

class LoginLoad extends LoginState {}

class LoginGetPhone extends LoginState {
  String email;
  LoginGetPhone({required this.email});
}

class LoginSuccess extends LoginState {
  String email;
  LoginSuccess({required this.email});

}

class LoginError extends LoginState {
  String message;
  LoginError({required this.message});
}
