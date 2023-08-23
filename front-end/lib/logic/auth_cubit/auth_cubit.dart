import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  var box = Hive.box("users");
  void login(String email) async {
    box.put("email", email);
    // var deviceToken = await FirebaseMessaging.instance.getToken();
    
    emit(Authenticated(email: email));
  }

  void logout() {
    box.delete("email");
    emit(UnAuthenticated());
  }
}
