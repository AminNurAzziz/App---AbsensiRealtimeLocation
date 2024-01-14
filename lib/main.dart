import 'package:absensi/Screen/User/UserFormAbsen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:absensi/State/ProviderAbsen.dart';
import 'package:absensi/State/ProviderEmployee.dart';

import 'package:absensi/HomePage.dart';
import 'package:absensi/Screen/LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final email = prefs.getString('email');
  final pw = prefs.getString('pw');

  final loginStatus = await login(email, pw);
  print(loginStatus);

  runApp(MyApp(loginStatus: loginStatus));
}

Future<Map<String, dynamic>?> login(String? email, String? pw) async {
  if (email == null || pw == null) return null;

  try {
    final response = await http.post(
      Uri.parse("http://192.168.178.135:3000/login"),
      body: {
        "email": email,
        "password": pw,
      },
    );

    if (response.statusCode == 200 &&
        jsonDecode(response.body)["error"] == false) {
      return jsonDecode(response.body);
    } else {
      print("Error: ${response.statusCode}");
      // Add more descriptive error handling here
      return null;
    }
  } catch (e) {
    print("Error: $e");
    // Handle other types of errors (e.g., connection, server issues)
    return null;
  }
}

class MyApp extends StatelessWidget {
  final Map<String, dynamic>? loginStatus;
  const MyApp({super.key, this.loginStatus});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final role = loginStatus?["user"]?["role"] ?? null;
    print(role);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProviderAbsen()),
        ChangeNotifierProvider(create: (_) => ProviderEmployee()),
      ],
      child: MaterialApp(
        routes: {
          '/': (context) => loginStatus == null
              ? LoginPage()
              : role == "Admin"
                  ? FormAbsen()
                  : HomePage(),
          '/homePage': (context) => HomePage(),
          '/formAbsen': (context) => FormAbsen(),
          '/loginPage': (context) => LoginPage(),
        },
        initialRoute: '/',
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
      ),
    );
  }
}
