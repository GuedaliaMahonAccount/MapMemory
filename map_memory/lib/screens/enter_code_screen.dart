import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../services/api_service.dart'; // ajouter au début
import 'package:shared_preferences/shared_preferences.dart';

class EnterCodeScreen extends StatefulWidget {
  const EnterCodeScreen({super.key});

  @override
  State<EnterCodeScreen> createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {
  final _codeController = TextEditingController();

  void _submitCode() async {
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

  void _generateNewCode() async {
    // Get the shared code saved during login
    final prefs = await SharedPreferences.getInstance();
    final sharedCode = prefs.getString('sharedCode') ?? 'No code found';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Your sharing code"),
        content: Text("Share this code with your partner: $sharedCode"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Espace partagé")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
                "Tu veux rejoindre ton/ta partenaire ? Entre son code :"),
            const SizedBox(height: 10),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: "Code de partage"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitCode,
              child: const Text("Rejoindre"),
            ),
            const Divider(height: 40),
            const Text("Tu veux créer un nouveau code ?"),
            ElevatedButton(
              onPressed: _generateNewCode,
              child: const Text("Générer un nouveau code"),
            ),
          ],
        ),
      ),
    );
  }
}
