import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'splash_screen_state.dart';

class SplashScreenCubit extends Cubit<SplashScreenState> {
  SplashScreenCubit() : super(SplashScreenInitial()) {
    print("abc");
    initialize();
  }

  void initialize() async {
    await Future.delayed(Duration(seconds: 2));
    var userBox = Hive.box('users');
    var email = userBox.get("email");
    print(email);
    if (email != null) {
      emit(LoggedIn(email: email));
    } else {
      print("abcefg");
      emit(LoggedOut());
    }
  }
}
