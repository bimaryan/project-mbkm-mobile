import 'package:flutter/material.dart';
import 'package:project_mbkm/route_generator.dart';
import './routes.dart';

void main() {
  runApp(const MyAppWrapper());
}

class MyAppWrapper extends StatelessWidget {
  const MyAppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SILK',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      initialRoute: Routes.splash,
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
