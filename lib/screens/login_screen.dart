import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _controller = TextEditingController();

  void _login() async {
    if (_controller.text.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', _controller.text);
      Navigator.pushReplacementNamed(context, '/todo');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: _controller, decoration: const InputDecoration(labelText: 'Enter your name')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: const Text("Login"))
          ],
        ),
      ),
    );
  }
}
