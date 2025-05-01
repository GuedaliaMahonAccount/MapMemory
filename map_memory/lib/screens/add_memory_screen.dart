import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/api_service.dart';
import 'map_selection_screen.dart';

class AddMemoryScreen extends StatefulWidget {
  const AddMemoryScreen({Key? key}) : super(key: key);

  @override
  State<AddMemoryScreen> createState() => _AddMemoryScreenState();
}

class _AddMemoryScreenState extends State<AddMemoryScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  File? _imageFile;
  DateTime? _selectedDateTime;
  LatLng? _selectedLocation;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _imageFile = File(picked.path));
  }

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        _selectedDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
      });
    }
  }

  Future<void> _selectLocation() async {
    final loc = await Navigator.push<LatLng?>(
      context,
      MaterialPageRoute(
        builder: (_) => MapSelectionScreen(initialLocation: _selectedLocation),
      ),
    );
    if (loc != null) setState(() => _selectedLocation = loc);
  }

  Future<void> _submitMemory() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Title is required')));
      return;
    }

    final date = _selectedDateTime ?? DateTime.now();
    final memory = <String, dynamic>{
      'title': _titleController.text,
      'description': _descController.text,
      'date': date.toIso8601String(),
      if (_imageFile != null) 'photos': [_imageFile!.path],
      if (_selectedLocation != null)
        'location': {
          'lat': _selectedLocation!.latitude,
          'lng': _selectedLocation!.longitude,
        },
    };

    final success = await ApiService.addMemory(memory);
    if (success) Navigator.pop(context, true);
    else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Save failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add a New Memory")),
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
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text(_selectedDateTime == null
                  ? "Pick Date"
                  : DateFormat('dd/MM/yyyy HH:mm').format(_selectedDateTime!)),
              onPressed: _selectDateTime,
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              icon: const Icon(Icons.image),
              label: const Text("Pick Image"),
              onPressed: _pickImage,
            ),
            if (_imageFile != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Image.file(_imageFile!, width: 100, height: 100),
              ),
            const SizedBox(height: 10),
            FilledButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text("Select Location"),
              onPressed: _selectLocation,
            ),
            if (_selectedLocation != null)
              Text("📍 ${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}"),
            const SizedBox(height: 20),
            FilledButton.icon(
              icon: const Icon(Icons.check),
              label: const Text("Save Memory"),
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              onPressed: _submitMemory,
            ),
          ],
        ),
      ),
    );
  }
}
