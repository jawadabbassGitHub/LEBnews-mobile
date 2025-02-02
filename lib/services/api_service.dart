import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // Choose `10.0.2.2` if running in an Android emulator; otherwise, use `127.0.0.1`
  final String baseUrl = kIsWeb || !defaultTargetPlatform.toString().contains('android')
      ? "http://127.0.0.1:3000"
      : "http://10.0.2.2:3000";

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Login failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }
}
