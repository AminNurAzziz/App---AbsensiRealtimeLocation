import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:absensi/Models/ModelUser.dart';

class ServiceUser {
  static const baseUrl = "http://192.168.178.135:3000";

  Future<Map<String, dynamic>> login(User user) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': user.email,
        'password': user.password,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody['error'] == false) {
        // Jika login berhasil
        return {
          'success': true,
          'data': responseBody,
        };
      } else {
        // Jika ada error dari server
        return {
          'success': false,
          'errorMessage': responseBody['error'],
        };
      }
    } else {
      // Jika terjadi kesalahan jaringan atau server
      throw Exception('Failed to login');
    }
  }
}
