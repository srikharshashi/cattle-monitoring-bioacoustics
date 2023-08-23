part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  String email;
  Authenticated({required this.email});
}

class UnAuthenticated extends AuthState {}
