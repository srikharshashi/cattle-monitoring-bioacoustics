import 'package:cattleplus/UI/add_cattle.dart';
import 'package:cattleplus/UI/home.dart';
import 'package:cattleplus/UI/login_ui.dart';
import 'package:cattleplus/UI/splash_Screen.dart';
import 'package:cattleplus/routing/routes.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.SPLASH:
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case Routes.LOGIN:
        return MaterialPageRoute(builder: (context) => LoginUI());
      // case Routes.ADD_CATTLE:
      //   return MaterialPageRoute(builder: (context) => AddCattle());
    }
  }
}
