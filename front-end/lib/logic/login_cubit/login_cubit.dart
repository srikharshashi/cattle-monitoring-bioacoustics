import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> signInWithGoogle({required BuildContext context}) async {
    emit(LoginLoad());
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);
        user = userCredential.user;
        //check if user exists else get phonenumber
        emit(LoginSuccess());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          emit(LoginError(message: "account-exists-with-different-credential"));
        } else if (e.code == 'invalid-credential') {
          emit(LoginError(message: 'invalid-credential'));
        }
      } catch (e) {
        emit(LoginError(message: e.toString()));
      }
    }
  }

  Future<bool> checkUser() async{
    try {
      FirebaseFirestore.collection('users').doc('id')
    } catch (e) {
      
    }

  }

  void reload() {
    emit(LoginInitial());
  }
}
