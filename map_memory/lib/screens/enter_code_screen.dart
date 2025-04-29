import 'package:flutter/material.dart';
import 'home_screen.dart';

class EnterCodeScreen extends StatefulWidget {
  const EnterCodeScreen({super.key});

  @override
  State<EnterCodeScreen> createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {
  final _codeController = TextEditingController();

  void _submitCode() {
    // TODO: envoyer au backend
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  void _generateNewCode() {
    // TODO: récupérer depuis backend
    final generatedCode = "ABC123";
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Ton code de partage"),
        content: Text("Partage ce code : $generatedCode"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          )
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
            const Text("Tu veux rejoindre ton/ta partenaire ? Entre son code :"),
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
