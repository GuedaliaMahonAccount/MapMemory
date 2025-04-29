import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/memory.dart';
import '../widgets/memory_card.dart';
import 'add_memory_screen.dart';
import 'map_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simule une liste de souvenirs
    final List<Memory> mockMemories = [
      Memory(
        title: 'Premier baiser',
        description: 'Un moment magique ❤️',
        date: DateTime(2025, 2, 18, 16, 49),
        imagePath: 'assets/kiss.jpg',
        location: const LatLng(32.015, 34.775),
      ),
      Memory(
        title: 'Shopping au centre',
        description: 'On s\'est bien marrés 😂',
        date: DateTime(2025, 4, 29, 13, 30),
        imagePath: 'assets/mall.jpg',
        location: const LatLng(31.965, 34.771),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Our Journal")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mockMemories.length,
        itemBuilder: (context, index) => MemoryCard(memory: mockMemories[index]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddMemoryScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        child: IconButton(
          icon: const Icon(Icons.map),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => MapScreen(memories: mockMemories)),
          ),
        ),
      ),
    );
  }
}
