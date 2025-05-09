import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl =
      "http://10.0.2.2:5000/api"; // Android Emulator (sinon localhost pour web)

  // Get saved token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Register
  static Future<bool> register(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    print('Register response: ${response.statusCode} - ${response.body}');

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('sharedCode', data['sharedCode']);
      return true;
    } else {
      return false;
    }
  }

  // Login
  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('sharedCode', data['sharedCode']);
      return true;
    } else {
      return false;
    }
  }

  // Connect with partner
  static Future<bool> connectWithPartner(String code) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/auth/connect'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'sharedCode': code}),
    );
    return response.statusCode == 200;
  }

  // Fetch memories
  static Future<List<dynamic>> getMemories() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/memories'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      return [];
    }
  }

  // Add a memory
  static Future<bool> addMemory(Map<String, dynamic> memory) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/memories'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(memory),
    );
    return response.statusCode == 201;
  }

  // Update a memory
  static Future<bool> updateMemory(
      String id, Map<String, dynamic> memory) async {
    final token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/memories/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(memory),
    );
    return response.statusCode == 200;
  }

  // Delete a memory
  static Future<bool> deleteMemory(String id) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/memories/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return response.statusCode == 200;
  }
}
