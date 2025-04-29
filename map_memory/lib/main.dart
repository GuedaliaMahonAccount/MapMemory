import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MapMemoryApp());
}

class MapMemoryApp extends StatelessWidget {
  const MapMemoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map Memory',
      theme: ThemeData.dark(),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
