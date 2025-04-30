import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'enter_code_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLogin = true;

  Future<void> _submit() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    bool success = false;
    if (isLogin) {
      success = await ApiService.login(email, password);
    } else {
      success = await ApiService.register(email, password);
    }

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const EnterCodeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication failed')),
      );
    }
  }

  void _toggleMode() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  void _loginWithGoogle() {
    // TODO: Integrate real Google Sign-In
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
              Text("Map Memory", style: Theme.of(context).textTheme.headlineMedium),
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
              ElevatedButton(
                onPressed: _submit,
                child: Text(isLogin ? "Login" : "Register"),
              ),
              TextButton(
                onPressed: _toggleMode,
                child: Text(isLogin ? "No account? Register here" : "Already have an account? Login"),
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
