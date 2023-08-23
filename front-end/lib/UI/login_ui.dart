import 'package:cattleplus/UI/home.dart';
import 'package:cattleplus/logic/auth_cubit/auth_cubit.dart';
import 'package:cattleplus/logic/home_cubit/home_cubit.dart';
import 'package:cattleplus/logic/localize_cubit/localize_cubit.dart';
import 'package:cattleplus/logic/localize_cubit/strings.dart';
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
          Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Home(email: state.email)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(""),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: BlocBuilder<LocalizeCubit, LocalizeState>(
              builder: (context, localstate) {
                return BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                    if (state is LoginSuccess) {
                      context.read<AuthCubit>().login(state.email);
                      context.read<HomeCubit>().load_home(state.email);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Home(email: state.email)));
                    }
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
                                      Strings.map["sign_in_google"]![
                                          localstate.index],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800),
                                    ),
                                    Icon(FontAwesomeIcons.google)
                                  ],
                                )),
                          )
                        ],
                      );
                    } else if (state is LoginLoad) {
                      return Center(
                          child:
                              SpinKitHourGlass(color: Colors.black, size: 30));
                    } else if (state is LoginGetPhone) {
                      return Container(
                        child: Column(
                          children: [
                            Text(
                              Strings.map["enter_phon"]![localstate.index],
                              style: GoogleFonts.montserrat(fontSize: 30),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextField(
                              controller: tdc,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  if (tdc.text.length != 10)
                                    showToast(Strings.map["invalid_phno"]![
                                        localstate.index]);
                                  else {
                                    context
                                        .read<LoginCubit>()
                                        .setPhone(state.email, tdc.text);
                                  }
                                },
                                child: Text(
                                    Strings.map["add_phno"]![localstate.index]))
                          ],
                        ),
                      );
                    } else {
                      return Center(
                        child: Column(
                          children: [
                            Text(Strings
                                .map["error_occured"]![localstate.index]),
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
