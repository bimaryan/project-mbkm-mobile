import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_mbkm/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> loginUser() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final identifier = _identifierController.text;
    final password = _passwordController.text;
    final url = Uri.parse(
        'https://86ea-103-148-130-53.ngrok-free.app/api/login'); // Replace with your actual API URL

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'identifier': identifier,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);

        print('Login successful');
        print('Token: $token');

        // Navigate to home screen or perform other actions
        Navigator.pushReplacementNamed(context, Routes.home, arguments: token);
      } else {
        final data = jsonDecode(response.body);
        setState(() {
          _errorMessage =
              data['error'] ?? 'Login failed. Please check your credentials.';
        });
        print('Login failed: $_errorMessage');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
      print('Error: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _identifierController,
              decoration: const InputDecoration(labelText: 'Username/NIM'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : loginUser,
              child: _isLoading ? const CircularProgressIndicator() : const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
