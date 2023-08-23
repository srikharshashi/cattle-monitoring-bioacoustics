import 'package:cattleplus/UI/add_cattle.dart';
import 'package:cattleplus/logic/addcatlle_cubit/addcattle_cubit.dart';
import 'package:cattleplus/logic/auth_cubit/auth_cubit.dart';
import 'package:cattleplus/logic/home_cubit/home_cubit.dart';
import 'package:cattleplus/logic/localize_cubit/localize_cubit.dart';
import 'package:cattleplus/logic/login_cubit/login_cubit.dart';
import 'package:cattleplus/logic/splash_screencubit/splash_screen_cubit.dart';
import 'package:cattleplus/routing/router.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> initializeRemoteNotifications({required bool debug}) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('users');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final AppRouter appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SplashScreenCubit>(
            create: (context) => SplashScreenCubit()),
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => HomeCubit()),
        BlocProvider(create: (context) => AddcattleCubit()),
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => LocalizeCubit())
      ],
      child: BlocBuilder<LocalizeCubit, LocalizeState>(
        builder: (context, localstate) {
          return MaterialApp(
            title: 'Cattle Plus',
            debugShowCheckedModeBanner: false,
            onGenerateRoute: appRouter.onGenerateRoute,
            themeMode: ThemeMode.system,
            theme: ThemeData(
                colorScheme: ColorScheme.light(primary: Colors.blueGrey),
                brightness: Brightness.light,
                useMaterial3: true),
            darkTheme: ThemeData(
                colorScheme: ColorScheme.dark(
                  primary: Color(0xffbb86fc),
                ),
                brightness: Brightness.dark,
                useMaterial3: true),
          );
        },
      ),
    );
  }
}
