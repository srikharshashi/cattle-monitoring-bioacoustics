import 'package:cattleplus/logic/auth_cubit/auth_cubit.dart';
import 'package:cattleplus/logic/home_cubit/home_cubit.dart';
import 'package:cattleplus/logic/login_cubit/login_cubit.dart';
import 'package:cattleplus/logic/splash_screencubit/splash_screen_cubit.dart';
import 'package:cattleplus/routing/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({super.key});

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  TextEditingController tdc = new TextEditingController();

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  Future<User?> signInWithGoogle({required BuildContext context}) async {
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
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          showToast("account-exists-with-different-credential");
        } else if (e.code == 'invalid-credential') {
          showToast("invalid-credential");
        }
      } catch (e) {
        showToast(e.toString());
      }
    }

    return user;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        // print(state);
        if (state is Authenticated) {
          Navigator.pushReplacementNamed(context, Routes.HOME);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(""),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                if (state is LoginInitial) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset('assets/logo.png'),
                      SizedBox(
                        width: 210,
                        child: ElevatedButton(
                            onPressed: () async {
                              context
                                  .read<LoginCubit>()
                                  .signInWithGoogle(context: context);
                            },
                            child: Row(
                              children: [
                                Text(
                                  "Sign In With Google  ",
                                  style: TextStyle(fontWeight: FontWeight.w800),
                                ),
                                Icon(FontAwesomeIcons.google)
                              ],
                            )),
                      )
                    ],
                  );
                } else if (state is LoginLoad) {
                  return Center(
                      child: SpinKitHourGlass(color: Colors.black, size: 30));
                } else if (state is LoginGetPhone) {
                  return Container(
                    child: Column(
                      children: [
                        Text(
                          "Enter Phone number to send alerts",
                          style: GoogleFonts.montserrat(fontSize: 30),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextField(
                          controller: tdc,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              RegExp indianPhoneNumberRegex =
                                  RegExp(r'^\+?91?[6-9]\d{9}$');
                              if (tdc.text.length != 10 ||
                                  !indianPhoneNumberRegex.hasMatch(tdc.text))
                                showToast("Invalid phone number");
                              else {
                                // context.read<LoginCubit>().;
                              }
                            },
                            child: Text("Add Phone number"))
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Column(
                      children: [
                        Text("there was an error"),
                        ElevatedButton(
                            onPressed: () {
                              context.read<LoginCubit>().reload();
                            },
                            child: Text("Retry"))
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
