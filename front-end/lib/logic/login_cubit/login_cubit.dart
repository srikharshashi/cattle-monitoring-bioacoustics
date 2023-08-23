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
        String email = user!.email ?? "dasojusrikhar@gmail.com";
        //check if user exists else get phonenumber
        bool ans = await checkUser(email);
        if (!ans) {
          emit(LoginGetPhone(email: email));
        } else {
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(email)
              .update({
            'email': email,
            'createdAt': DateTime.now().toString(),
            'deviceToken': 'fakeToken'
          });
          emit(LoginSuccess(email: user!.email ?? "dasojusrikhar@gmail.com"));
        }
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

  Future<bool> checkUser(String email) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('Users');
      QuerySnapshot ss = await users.where('email', isEqualTo: email).get();
      print(ss.docs.length);
      return ss.docs.length > 0;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  void reload() {
    emit(LoginInitial());
  }

  void setPhone(String email, String phoneno) async {
    emit(LoginLoad());
    await FirebaseFirestore.instance.collection('Users').doc(email).set({
      'email': email,
      'createdAt': DateTime.now().toString(),
      'deviceToken': 'fakeToken',
      'phoneno': "91" + phoneno
    });
    emit(LoginSuccess(email: email));
  }
}
