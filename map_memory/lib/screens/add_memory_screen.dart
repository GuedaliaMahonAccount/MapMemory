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
  _AddMemoryScreenState createState() => _AddMemoryScreenState();
}

class _AddMemoryScreenState extends State<AddMemoryScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  File? _imageFile;
  DateTime? _selectedDateTime;
  LatLng? _selectedLocation;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
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

  Future<void> _submitMemory() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le titre est requis')),
      );
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
    if (success) Navigator.pop(context);
    else ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Échec lors de la sauvegarde')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Memory")),
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
                Text(
                  _selectedDateTime != null
                      ? DateFormat('dd/MM/yyyy HH:mm').format(_selectedDateTime!)
                      : 'Default Date',
                ),
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
                    : const Text("No Image"),
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
                    : const Text("No Location"),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.check),
              label: const Text("Save Memory"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _submitMemory,
            ),
          ],
        ),
      ),
    );
  }
}
