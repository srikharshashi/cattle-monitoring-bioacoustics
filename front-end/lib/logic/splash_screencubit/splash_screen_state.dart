part of 'splash_screen_cubit.dart';

abstract class SplashScreenState {}

class SplashScreenInitial extends SplashScreenState {}

class LoggedIn extends SplashScreenState {
  String email;
  LoggedIn({required this.email});
}

class LoggedOut extends SplashScreenState {}
