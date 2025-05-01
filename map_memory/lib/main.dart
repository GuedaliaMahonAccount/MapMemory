import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.pinkAccent,
        brightness: Brightness.light,
        textTheme: GoogleFonts.quicksandTextTheme(),
      ),
      home: const LoginScreen(),
    );
  }
}
