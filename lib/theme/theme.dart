import 'package:flutter/material.dart';

class WMColor {
  static const primaryColor = Color.fromRGBO(0x26, 0xc6, 0xda, 1.0);
  static const primaryLightColor = Color.fromRGBO(0x6f, 0xf09, 0xff, 1.0);
  static const primaryDarkColor = Color.fromRGBO(0x00, 0x95, 0xa8, 1.0);
  static const secondaryColor = Color.fromRGBO(0xfd, 0xd8, 0x35, 1.0);
  static const secondaryLightColor = Color.fromRGBO(0xff, 0xff, 0x6b, 1.0);
  static const secondaryDarkColor = Color.fromRGBO(0xc6, 0xa7, 0x00, 1.0);
  static const white = Color.fromRGBO(0xff, 0xff, 0xff, 1.0);
  static const lightGray = Color.fromRGBO(0xcf, 0xcf, 0xcf, 1.0);
  static const gray = Color.fromRGBO(0x9e, 0x9e, 0x9e, 1.0);
  static const black = Color.fromRGBO(0x00, 0x00, 0x00, 1.0);
}

final lightTheme = ThemeData.from(
  colorScheme: const ColorScheme.light(
    primary: WMColor.primaryColor,
    secondary: WMColor.secondaryColor,
  ),
);
