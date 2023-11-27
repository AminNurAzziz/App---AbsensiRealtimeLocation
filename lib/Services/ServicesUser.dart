import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:absensi/Models/ModelUser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceUser {
  static const baseUrl = "http://192.168.178.135:3000";

  Future<Map<String, dynamic>> login(User user) async {
    print(user.email);
    print(user.password);
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': user.email,
        'password': user.password,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody['error'] == false) {
        // Jika login berhasil
        print("HASIL++++++++++++++++++++++++++++++");
        print(responseBody);
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
      print(response.statusCode);
      print(response.body);
      print(response.reasonPhrase);
      print(response.request);
      print(response.request!.headers);
      // Jika terjadi kesalahan jaringan atau server
      throw Exception('Failed to login');
    }
  }

  Future<Map<String, dynamic>> register(User user) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': user.name,
        'email': user.email,
        'password': user.password,
        'role': user.role,
      }),
    );

    if (response.statusCode == 201) {
      final responseBody = json.decode(response.body);
      if (responseBody['error'] == false) {
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

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('pw');
  }
}
