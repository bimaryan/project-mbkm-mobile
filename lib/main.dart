import 'package:flutter/material.dart';
import 'package:project_mbkm/route_generator.dart';
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
      onGenerateRoute:
          RouteGenerator.generateRoute,
    );
  }
}
