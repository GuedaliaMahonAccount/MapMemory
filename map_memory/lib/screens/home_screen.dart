import 'package:flutter/material.dart';
import '../models/memory.dart';
import '../services/api_service.dart';
import '../widgets/memory_card.dart';
import 'add_memory_screen.dart';
import 'map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Memory> _memories = [];

  @override
  void initState() {
    super.initState();
    _loadMemories();
  }

  Future<void> _loadMemories() async {
    final memoriesData = await ApiService.getMemories();
    setState(() {
      _memories = memoriesData.map<Memory>((json) => Memory.fromJson(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Our Journal')),
      body: _memories.isEmpty
          ? const Center(child: Text('No memories yet'))
          : ListView.builder(
              itemCount: _memories.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                return MemoryCard(memory: _memories[index]);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddMemoryScreen()),
          );
          _loadMemories(); // Reload memories after adding one
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        child: IconButton(
          icon: const Icon(Icons.map),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => MapScreen(memories: _memories)),
            );
          },
        ),
      ),
    );
  }
}
