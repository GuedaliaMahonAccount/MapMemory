import 'package:google_maps_flutter/google_maps_flutter.dart';

class Memory {
  final String title;
  final String description;
  final DateTime date;
  final String imagePath; // Pour simplifier : local path ou URL
  final LatLng location;

  Memory({
    required this.title,
    required this.description,
    required this.date,
    required this.imagePath,
    required this.location,
  });
}
