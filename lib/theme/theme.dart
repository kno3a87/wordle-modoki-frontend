import 'package:flutter/material.dart';

class WMColor {
  static const primaryColor = Color.fromRGBO(0xc5, 0xca, 0xe9, 1.0);
  static const primaryLightColor = Color.fromRGBO(0xff, 0xf7, 0xff, 1.0);
  static const primaryDarkColor = Color.fromRGBO(0xa0, 0x94, 0xb7, 1.0);
  static const secondaryColor = Color.fromRGBO(0xcf, 0xd8, 0xdc, 1.0);
  static const secondaryLightColor = Color.fromRGBO(0xff, 0xff, 0xff, 1.0);
  static const secondaryDarkColor = Color.fromRGBO(0x9e, 0xa7, 0xaa, 1.0);
}

final lightTheme = ThemeData.from(
  colorScheme: const ColorScheme.light(
    primary: WMColor.primaryColor,
  ),
);
