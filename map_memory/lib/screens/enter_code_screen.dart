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
        const SnackBar(content: Text('Code invalide')),
      );
    }
  }

  Future<void> _generateNewCode() async {
    final prefs = await SharedPreferences.getInstance();
    final sharedCode = prefs.getString('sharedCode') ?? '';

    // Copie automatique dans le presse-papier
    await Clipboard.setData(ClipboardData(text: sharedCode));

    // Affiche le code avec bouton OK
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Votre code de partage"),
        content: Text("Code copié : $sharedCode"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );

    // Puis entrée directe dans l’app
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
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
            const Text("Rejoindre un partenaire :"),
            const SizedBox(height: 10),
            TextField(
              controller: _codeController,
              decoration:
                  const InputDecoration(labelText: "Code de partage"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitCode,
              child: const Text("Rejoindre"),
            ),
            const Divider(height: 40),
            const Text("Créer votre propre code :"),
            ElevatedButton(
              onPressed: _generateNewCode,
              child: const Text("Générer et entrer"),
            ),
          ],
        ),
      ),
    );
  }
}
