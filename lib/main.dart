import 'package:flutter/material.dart';
import 'package:tasks/view/homepage.dart';
import 'package:tasks/view/teste/teste.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Testee()
    );
  }
}
