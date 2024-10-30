import 'package:flutter/material.dart';
import 'package:project_mbkm/route_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SILK',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      initialRoute: Routes.login,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

Future<String> getInitialRoute() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  return token != null ? Routes.home : Routes.login;
}

class MyAppWrapper extends StatelessWidget {
  const MyAppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getInitialRoute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return MaterialApp(
            title: 'SILK',
            theme: ThemeData(
              primarySwatch: Colors.teal,
            ),
            initialRoute: snapshot.data,
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        }
      },
    );
  }
}
