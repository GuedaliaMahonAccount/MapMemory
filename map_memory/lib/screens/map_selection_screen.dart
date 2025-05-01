import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MapSelectionScreen extends StatefulWidget {
  final LatLng? initialLocation;
  const MapSelectionScreen({Key? key, this.initialLocation}) : super(key: key);

  @override
  State<MapSelectionScreen> createState() => _MapSelectionScreenState();
}

class _MapSelectionScreenState extends State<MapSelectionScreen> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    if (widget.initialLocation != null) {
      setState(() => _selectedLocation = widget.initialLocation);
    } else {
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        setState(() => _selectedLocation =
            const LatLng(32.0853, 34.7818)); // par défaut : Tel Aviv
        return;
      }
      Position pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() => _selectedLocation = LatLng(pos.latitude, pos.longitude));
    }
  }

  Future<void> _onSearch() async {
    final query = _searchController.text;
    if (query.isEmpty) return;

    try {
      List<Location> results = await locationFromAddress(query);
      print('Geocoding "$query" -> ${results.length} résultats: $results');
      if (results.isNotEmpty) {
        final loc = results.first;
        final newPos = LatLng(loc.latitude, loc.longitude);
        await _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(newPos, 15),
        );
        setState(() => _selectedLocation = newPos);
      } else {
        print('Aucun résultat pour "$query"');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Adresse introuvable')),
        );
      }
    } catch (e, s) {
      print('Erreur Geocoding : $e\n$s');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur de recherche')),
      );
    }
  }

  void _onMapTap(LatLng pos) {
    setState(() => _selectedLocation = pos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Location')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search address',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _onSearch,
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _onSearch(),
            ),
          ),
          Expanded(
            child: _selectedLocation == null
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    onMapCreated: (controller) {
                      _mapController = controller;
                      if (_selectedLocation != null) {
                        controller.moveCamera(
                          CameraUpdate.newLatLngZoom(_selectedLocation!, 15),
                        );
                      }
                    },
                    initialCameraPosition: CameraPosition(
                      target: _selectedLocation!,
                      zoom: 15,
                    ),
                    onTap: _onMapTap,
                    markers: {
                      Marker(
                        markerId: const MarkerId('selected'),
                        position: _selectedLocation!,
                      )
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton.icon(
              icon: const Icon(Icons.check),
              label: const Text('Validate'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () => Navigator.pop(context, _selectedLocation),
            ),
          ),
        ],
      ),
    );
  }
}
