import 'package:flutter/material.dart';
import 'package:project/presentation/screens/homePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        // colorScheme: ColorScheme.fromSeed(
        //   seedColor: Colors.white
        // )
      ),
      home: const HomePage(),
    );
  }
}
