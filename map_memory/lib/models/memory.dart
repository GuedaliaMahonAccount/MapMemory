import 'package:google_maps_flutter/google_maps_flutter.dart';

class Memory {
  final String title;
  final String description;
  final DateTime date;
  final String imagePath;
  final LatLng location;

  Memory({
    required this.title,
    required this.description,
    required this.date,
    required this.imagePath,
    required this.location,
  });

  factory Memory.fromJson(Map<String, dynamic> json) {
    return Memory(
      title: json['title'],
      description: json['description'] ?? '',
      date: DateTime.parse(json['date']),
      imagePath: json['photos'].isNotEmpty ? json['photos'][0] : '',
      location: LatLng(json['location']['lat'], json['location']['lng']),
    );
  }
}
