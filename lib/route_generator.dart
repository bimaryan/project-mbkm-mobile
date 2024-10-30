import 'package:flutter/material.dart';
import 'package:project_mbkm/home_screen.dart';
import 'package:project_mbkm/katalog_screen.dart';
import 'package:project_mbkm/routes.dart';
import 'login_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.home:
        // Ensure that a token is passed correctly
        final token = settings.arguments as String? ?? '';
        return MaterialPageRoute(builder: (_) => HomeScreen(token: token));
      case Routes.katalog:
        final token = settings.arguments as String? ?? '';
        return MaterialPageRoute(builder: (_) => KatalogScreen(token: token));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
