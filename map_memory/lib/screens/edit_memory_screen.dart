import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/memory.dart';
import '../services/api_service.dart';
import 'map_selection_screen.dart';

class EditMemoryScreen extends StatefulWidget {
  final Memory memory;
  const EditMemoryScreen({Key? key, required this.memory}) : super(key: key);

  @override
  _EditMemoryScreenState createState() => _EditMemoryScreenState();
}

class _EditMemoryScreenState extends State<EditMemoryScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  File? _imageFile;
  DateTime _selectedDateTime = DateTime.now();
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.memory.title);
    _descController  = TextEditingController(text: widget.memory.description);
    _selectedDateTime = widget.memory.date;
    if (widget.memory.imagePath.isNotEmpty) {
      _imageFile = File(widget.memory.imagePath);
    }
    _selectedLocation = widget.memory.location;
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _imageFile = File(picked.path));
  }

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (time != null) {
      setState(() {
        _selectedDateTime = DateTime(
          date.year, date.month, date.day, time.hour, time.minute);
      });
    }
  }

  Future<void> _selectLocation() async {
    final loc = await Navigator.push<LatLng?>(
      context,
      MaterialPageRoute(
        builder: (_) => MapSelectionScreen(
          initialLocation: _selectedLocation,
        ),
      ),
    );
    if (loc != null) setState(() => _selectedLocation = loc);
  }

  Future<void> _submit() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title is required')),
      );
      return;
    }
    final payload = <String, dynamic>{
      'title': _titleController.text,
      'description': _descController.text,
      'date': _selectedDateTime.toIso8601String(),
      if (_imageFile != null)  'photos': [_imageFile!.path],
      if (_selectedLocation != null)
        'location': {
          'lat': _selectedLocation!.latitude,
          'lng': _selectedLocation!.longitude,
        },
    };
    final success =
        await ApiService.updateMemory(widget.memory.id, payload);
    if (success) Navigator.pop(context, true);
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Update failed')),
      );
    }
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete memory?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (confirm == true) {
      await ApiService.deleteMemory(widget.memory.id);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Memory'),
        actions: [
          IconButton(icon: const Icon(Icons.delete), onPressed: _delete),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: const Text("Choose Date"),
                  onPressed: _selectDateTime,
                ),
                const SizedBox(width: 10),
                Text(DateFormat('dd/MM/yyyy HH:mm')
                    .format(_selectedDateTime)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.image),
                  label: const Text("Pick Image"),
                  onPressed: _pickImage,
                ),
                const SizedBox(width: 10),
                _imageFile != null
                    ? Image.file(_imageFile!, width: 80, height: 80)
                    : const Text("No image"),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.map),
                  label: const Text("Localisation"),
                  onPressed: _selectLocation,
                ),
                const SizedBox(width: 10),
                _selectedLocation != null
                    ? Text(
                        '${_selectedLocation!.latitude.toStringAsFixed(5)}, ${_selectedLocation!.longitude.toStringAsFixed(5)}')
                    : const Text("Aucune"),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.check),
              label: const Text("Save Changes"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
