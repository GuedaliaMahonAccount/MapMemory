import 'package:google_maps_flutter/google_maps_flutter.dart';

class Memory {
  final String title;
  final String description;
  final DateTime date;
  final String imagePath;
  final LatLng? location;  // <-- nullable

  Memory({
    required this.title,
    required this.description,
    required this.date,
    required this.imagePath,
    this.location,
  });

  factory Memory.fromJson(Map<String, dynamic> json) {
    // 1) Gère photos absentes ou vides
    final photos = (json['photos'] as List<dynamic>?) ?? [];
    final img = photos.isNotEmpty ? photos[0] as String : '';

    // 2) Gère location absente
    LatLng? loc;
    if (json['location'] != null &&
        json['location']['lat'] != null &&
        json['location']['lng'] != null) {
      loc = LatLng(
        (json['location']['lat'] as num).toDouble(),
        (json['location']['lng'] as num).toDouble(),
      );
    }

    return Memory(
      title: json['title'] as String,
      description: (json['description'] as String?) ?? '',
      date: DateTime.parse(json['date'] as String),
      imagePath: img,
      location: loc,
    );
  }
}
