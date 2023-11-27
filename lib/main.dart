import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:absensi/State/ProviderAbsen.dart';
import 'package:absensi/State/ProviderEmployee.dart';

import 'package:absensi/HomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProviderAbsen()),
        ChangeNotifierProvider(create: (_) => ProviderEmployee()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        // home: LoginPage(),
        // home: FormAbsen(),
        home: HomePage(),
      ),
    );
  }
}
