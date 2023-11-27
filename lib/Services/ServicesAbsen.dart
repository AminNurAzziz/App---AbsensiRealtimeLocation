import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:absensi/Models/ModelAbsen.dart';

class ServicesAbsen {
  static const baseUrl = "http://192.168.178.135:3000";

  Future<void> addAbsen(Absen absen) async {
    try {
      print(absen.idPegawai!.id);
      print(absen.status);
      final response = await http.post(
        Uri.parse("$baseUrl/absen"),
        body: {
          "idPegawai": absen.idPegawai!.id,
          "status": absen.status,
          "images": absen.images,
          "lat": absen.lat,
          "long": absen.long,
        },
      );

      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        print(responseBody);

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

  Future<List<Absen>> getAbsen() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/absen"));

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        if (responseBody["error"] == false) {
          if (responseBody["absen"] is List) {
            final listAbsen = (responseBody["absen"] as List)
                .map((listMap) => Absen.fromJson(listMap))
                .toList();

            print('INI LIST');
            return listAbsen;
          } else {
            print("Error: 'absen' field is not a list");
            return []; // Return an empty list or handle the error case accordingly
          }
        } else {
          print("Error: ${responseBody["message"]}");
          return []; // Return an empty list or handle the error case accordingly
        }
      } else {
        print("HTTP request failed with status: ${response.statusCode}");
        return []; // Return an empty list or handle the error case accordingly
      }
    } catch (e) {
      print("Error: $e");
      return []; // Return an empty list or handle the error case accordingly
    }
  }
}
