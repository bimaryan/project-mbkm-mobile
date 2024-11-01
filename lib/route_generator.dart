import 'package:flutter/material.dart';
import 'package:project_mbkm/home_screen.dart';
import 'package:project_mbkm/informasi_screen.dart';
import 'package:project_mbkm/katalog_screen.dart';
import 'package:project_mbkm/routes.dart';
import 'package:project_mbkm/view_barang_screen.dart';
import 'login_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case Routes.home:
        // Retrieve the token argument if passed
        final token = settings.arguments as String? ?? '';
        return MaterialPageRoute(builder: (_) => HomeScreen(token: token));

      case Routes.katalog:
        // Handle token and namaBarang arguments as a Map
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

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
