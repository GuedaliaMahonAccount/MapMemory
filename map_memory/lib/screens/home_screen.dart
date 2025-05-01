import 'package:flutter/material.dart';
import '../models/memory.dart';
import '../services/api_service.dart';
import '../widgets/memory_card.dart';
import 'add_memory_screen.dart';
import 'edit_memory_screen.dart';
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
    final list = await ApiService.getMemories();
    setState(() {
      _memories = list.map<Memory>((json) => Memory.fromJson(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('💖 My Memories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MapScreen(memories: _memories),
                ),
              );
            },
          ),
        ],
      ),
      body: _memories.isEmpty
          ? const Center(child: Text('No memories yet 😢'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _memories.length,
              itemBuilder: (context, i) {
                final mem = _memories[i];
                return MemoryCard(
                  memory: mem,
                  onTap: () async {
                    final updated = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditMemoryScreen(memory: mem),
                      ),
                    );
                    if (updated == true) _loadMemories();
                  },
                  onDelete: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Delete memory?'),
                        content: const Text('Are you sure?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await ApiService.deleteMemory(mem.id);
                      _loadMemories();
                    }
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final created = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const AddMemoryScreen()),
          );
          if (created == true) _loadMemories();
        },
        icon: const Icon(Icons.add),
        label: const Text("New Memory"),
      ),
    );
  }
}
