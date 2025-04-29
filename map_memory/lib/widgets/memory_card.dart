import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../models/memory.dart';

class MemoryCard extends StatelessWidget {
  final Memory memory;

  const MemoryCard({super.key, required this.memory});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Image.file(
          // Tu peux mettre Image.network si tu récupères depuis une URL
          File(memory.imagePath),
          width: 60,
          fit: BoxFit.cover,
        ),
        title: Text(memory.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(DateFormat('dd MMM yyyy – HH:mm').format(memory.date)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Tu pourras plus tard ajouter un écran de détail
        },
      ),
    );
  }
}
