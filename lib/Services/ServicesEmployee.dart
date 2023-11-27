import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:absensi/Models/ModelEmployee.dart';

class ServicesEmployee {
  static const baseUrl = "http://192.168.178.135:3000";

  Future<void> addEmployee(Employee employee) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register"),
        body: {
          "nama": employee.name,
          "email": employee.email,
          "password": employee.password,
          "role": employee.role,
          "pw": employee.pw,
        },
      );

      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);

        if (responseBody["error"] == false) {
          print("Success: ${responseBody["message"]}");
        } else {
          print("Error: ${responseBody["message"]}");
        }
      } else {
        print("HTTP request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<List<Employee>> getEmployee() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/pegawai"));

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        if (responseBody["error"] == false) {
          if (responseBody["pegawai"] is List) {
            final listEmployee = (responseBody["pegawai"] as List)
                .map((listMap) => Employee.fromJson(listMap))
                .toList();

            print('INI LIST');
            return listEmployee;
          } else {
            print("Error: 'pegawai' field is not a list");
            return []; // Return an empty list or handle the error case accordingly
          }
        } else {
          print("Error: ${responseBody["message"]}");
          return [];
        }
      } else {
        print("HTTP request failed with status: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }
}
