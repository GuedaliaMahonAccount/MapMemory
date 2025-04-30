import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/memory.dart';

class MemoryCard extends StatelessWidget {
  final Memory memory;
  const MemoryCard({super.key, required this.memory});

  Widget buildPhoto() {
    // Si imagePath non vide ET fichier existant
    if (memory.imagePath.isNotEmpty && File(memory.imagePath).existsSync()) {
      return Image.file(
        File(memory.imagePath),
        width: 60,
        height: 60,
        fit: BoxFit.cover,
      );
    }
    // Sinon placeholder
    return const SizedBox(
      width: 60,
      height: 60,
      child: Icon(Icons.photo, color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: buildPhoto(),  // <-- ici
        title: Text(memory.title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle:
            Text(DateFormat('dd MMM yyyy – HH:mm').format(memory.date)),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
