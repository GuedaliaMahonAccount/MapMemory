import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import 'enter_code_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLogin = true;

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    bool success = false;

    print("📧 Email: $email");
    print("🔑 Password: $password");

    try {
      if (isLogin) {
        print("🟢 Attempting to log in...");
        success = await ApiService.login(email, password);
        print("🟢 Login success: $success");
      } else {
        print("🆕 Attempting to register...");
        success = await ApiService.register(email, password);
        print("🆕 Registration success: $success");

        if (success) {
          print("🟢 Auto-login after registration...");
          success = await ApiService.login(email, password);
          print("🟢 Auto-login success: $success");
        }
      }
    } catch (e) {
      print("❌ Error during authentication: $e");
    }

    if (success) {
      print("✅ Authentication successful, navigating to the next screen...");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              isLogin ? const HomeScreen() : const EnterCodeScreen(),
        ),
      );
    } else {
      print("❌ Authentication failed, showing snackbar...");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication failed')),
      );
    }
  }

  void _toggleMode() => setState(() => isLogin = !isLogin);

  void _loginWithGoogle() {
    // TODO: Intégration réelle de Google Sign-In
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.background,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  '💖 Map Memory',
                  style: GoogleFonts.quicksand(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: theme.primary,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.favorite),
                  label: Text(isLogin ? 'Login' : 'Register'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
                TextButton(
                  onPressed: _toggleMode,
                  child: Text(
                    isLogin
                        ? 'No account? Register here'
                        : 'Already have an account? Login',
                    style: TextStyle(color: theme.secondary),
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _loginWithGoogle,
                  icon: const Icon(Icons.account_circle),
                  label: const Text('Continue with Google'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
