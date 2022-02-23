import 'package:flutter/material.dart';

class WMColor {
  static const primaryColor = Color.fromRGBO(0x26, 0xc6, 0xda, 1.0);
  static const primaryLightColor = Color.fromRGBO(0x6f, 0xf09, 0xff, 1.0);
  static const primaryDarkColor = Color.fromRGBO(0x00, 0x95, 0xa8, 1.0);
  static const secondaryColor = Color.fromRGBO(0x60, 0x7d, 0x8b, 1.0);
  static const secondaryLightColor = Color.fromRGBO(0x8e, 0xac, 0xbb, 1.0);
  static const secondaryDarkColor = Color.fromRGBO(0x34, 0x51, 0x5e, 1.0);
  static const white = Color.fromRGBO(0xff, 0xff, 0xff, 1.0);
  static const black = Color.fromRGBO(0x00, 0x00, 0x00, 1.0);
}

final lightTheme = ThemeData.from(
  colorScheme: const ColorScheme.light(
    primary: WMColor.primaryColor,
    secondary: WMColor.secondaryColor,
  ),
);
