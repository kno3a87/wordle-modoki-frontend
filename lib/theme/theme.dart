import 'package:flutter/material.dart';

class WordleModokiColor {
  static const primaryColor = Color.fromRGBO(0xc5, 0xca, 0xe9, 1.0);
  static const hintColor = Color.fromRGBO(0x94, 0x99, 0xb7, 1.0);
}

final lightTheme = ThemeData.from(
  colorScheme: const ColorScheme.light(
    primary: WordleModokiColor.primaryColor,
  ),
);
