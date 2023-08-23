import 'package:cattleplus/logic/auth_cubit/auth_cubit.dart';
import 'package:cattleplus/logic/home_cubit/home_cubit.dart';
import 'package:cattleplus/logic/splash_screencubit/splash_screen_cubit.dart';
import 'package:cattleplus/main.dart';
import 'package:cattleplus/routing/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static const String name = 'Awesome Notifications - Example App';
  static const Color mainColor = Colors.deepPurple;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashScreenCubit, SplashScreenState>(
        builder: (context, state) {
      return SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image(image: AssetImage('assets/logo.png'))],
            ),
          ),
        ),
      );
    }, listener: (context, state) {
      if (state is LoggedIn) {
        context.read<AuthCubit>().login(state.email);
        context.read<HomeCubit>().load_home(state.email);
        Navigator.pushReplacementNamed(context, Routes.HOME);
      } else if (state is LoggedOut) {
        Navigator.pushReplacementNamed(context, Routes.LOGIN);
      }
    });
  }
}
