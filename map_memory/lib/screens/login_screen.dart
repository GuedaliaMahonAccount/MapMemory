import 'package:flutter/material.dart';
import 'enter_code_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _loginWithEmail() {
    // TODO: Envoyer au backend (simulé pour l’instant)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const EnterCodeScreen()),
    );
  }

  void _loginWithGoogle() {
    // TODO: Connexion Google
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const EnterCodeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Map Memory", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _loginWithEmail,
                icon: const Icon(Icons.email),
                label: const Text("Continue with Email"),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _loginWithGoogle,
                icon: const Icon(Icons.account_circle),
                label: const Text("Continue with Google"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
