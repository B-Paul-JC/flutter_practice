import 'package:flutter/material.dart';
import 'package:colours/colours.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colours.hotPink,
      theme: ThemeData(
        primarySwatch: Colours.sandyBrown,
        fontFamily: "Raleway",
      ),
      title: "Practice App",
      home: const Scaffold(
        body: Center(
          child: Text(
            "Hello",
          ),
        ),
      ),
    );
  }
}
