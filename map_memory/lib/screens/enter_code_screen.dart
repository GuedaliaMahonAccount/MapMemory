import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class EnterCodeScreen extends StatefulWidget {
  const EnterCodeScreen({Key? key}) : super(key: key);

  @override
  State<EnterCodeScreen> createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {
  final _codeController = TextEditingController();

  Future<void> _submitCode() async {
    final success = await ApiService.connectWithPartner(_codeController.text);
    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid code')),
      );
    }
  }

  Future<void> _generateNewCode() async {
    final prefs = await SharedPreferences.getInstance();
    final sharedCode = prefs.getString('sharedCode') ?? '';

    await Clipboard.setData(ClipboardData(text: sharedCode));

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Your Share Code"),
        content: Text("Code copied: $sharedCode"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shared Space"),
        backgroundColor: theme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text("Join your partner"),
            const SizedBox(height: 10),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: "Share Code",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _submitCode,
              icon: const Icon(Icons.link),
              label: const Text("Join"),
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            ),
            const Divider(height: 40),
            const Text("Create your code"),
            FilledButton.icon(
              onPressed: _generateNewCode,
              icon: const Icon(Icons.refresh),
              label: const Text("Generate and enter"),
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            ),
          ],
        ),
      ),
    );
  }
}
