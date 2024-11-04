import 'package:flutter/material.dart';
import 'package:project_mbkm/home_screen.dart';
import 'package:project_mbkm/informasi_screen.dart';
import 'package:project_mbkm/katalog_screen.dart';
import 'package:project_mbkm/profile_screen.dart';
import 'package:project_mbkm/routes.dart';
import 'package:project_mbkm/splash_screen.dart';
import 'package:project_mbkm/view_barang_screen.dart';
import 'login_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case Routes.home:
        final token = settings.arguments as String? ?? '';
        return MaterialPageRoute(builder: (_) => HomeScreen(token: token));

      case Routes.katalog:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final token = args['token'] ?? '';
        return MaterialPageRoute(
            builder: (_) =>
                KatalogScreen(token: token));

      case Routes.informasi:
        final token = settings.arguments as String? ?? '';
        return MaterialPageRoute(builder: (_) => InformasScreen(token: token));

      case Routes.viewBarang:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final token = args['token'] ?? '';
        final namaBarang = args['namaBarang'] ?? '';
        return MaterialPageRoute(
            builder: (_) => ViewScreen(token: token, namaBarang: namaBarang));

      case Routes.profile:
        final token = settings.arguments as String? ?? '';
        return MaterialPageRoute(builder: (_) => ProfileScreen(token: token));
      
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
