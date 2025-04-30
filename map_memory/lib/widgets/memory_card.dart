import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/memory.dart';

class MemoryCard extends StatelessWidget {
  final Memory memory;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const MemoryCard({
    Key? key,
    required this.memory,
    this.onTap,
    this.onDelete,
  }) : super(key: key);

  Widget buildPhoto() {
    if (memory.imagePath.isNotEmpty && File(memory.imagePath).existsSync()) {
      return Image.file(
        File(memory.imagePath),
        width: 60,
        height: 60,
        fit: BoxFit.cover,
      );
    }
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
        onTap: onTap,
        leading: buildPhoto(),
        title: Text(
          memory.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          DateFormat('dd MMM yyyy – HH:mm').format(memory.date),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: onDelete,
              ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
