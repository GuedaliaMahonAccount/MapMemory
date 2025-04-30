import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

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

  final ImagePicker _picker = ImagePicker();
  // ignore: unused_field
  GoogleMapController? _mapController;

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
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
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  void _onMapTap(LatLng position) {
    setState(() => _selectedLocation = position);
  }

  Future<void> _submitMemory() async {
    // 1 seul champ obligatoire : le titre
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le titre est requis')),
      );
      return;
    }

    // Valeurs par défaut
    final date = _selectedDateTime ?? DateTime.now();

    // Construction dynamique de l’objet à envoyer
    final memory = <String, dynamic>{
      'title': _titleController.text,
      'description': _descController.text,
      'date': date.toIso8601String(),
      if (_imageFile != null)
        'photos': [_imageFile!.path], // photo peuplée seulement si existante
      if (_selectedLocation != null)
        'location': {
          'lat': _selectedLocation!.latitude,
          'lng': _selectedLocation!.longitude,
        },
    };

    final success = await ApiService.addMemory(memory);
    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Échec lors de la sauvegarde')),
      );
    }
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
                      ? DateFormat('dd/MM/yyyy HH:mm')
                          .format(_selectedDateTime!)
                      : 'Date par défaut',
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
                    : const Text("Pas d’image"),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: GoogleMap(
                onMapCreated: (c) => _mapController = c,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(32.0853, 34.7818), // Tel Aviv
                  zoom: 10,
                ),
                onTap: _onMapTap,
                markers: _selectedLocation != null
                    ? {
                        Marker(
                          markerId: const MarkerId("sel"),
                          position: _selectedLocation!,
                        )
                      }
                    : {},
              ),
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
