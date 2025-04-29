import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/memory.dart';

class MapScreen extends StatelessWidget {
  final List<Memory> memories;

  const MapScreen({super.key, required this.memories});

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = memories.map((memory) {
      return Marker(
        markerId: MarkerId(memory.title),
        position: memory.location,
        infoWindow: InfoWindow(
          title: memory.title,
          snippet: memory.description,
        ),
      );
    }).toSet();

    return Scaffold(
      appBar: AppBar(title: const Text("Map Memories")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: memories.isNotEmpty ? memories[0].location : const LatLng(32.0, 34.8),
          zoom: 10,
        ),
        markers: markers,
      ),
    );
  }
}
