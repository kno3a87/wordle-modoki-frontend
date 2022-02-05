import 'package:flutter/material.dart';
import 'package:wordle_modoki/main_page.dart';
import 'package:wordle_modoki/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wordle Modoki',
      theme: lightTheme,
      home: const MyHomePage(),
    );
  }
}
