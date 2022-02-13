import 'package:flutter/material.dart';
import 'package:wordle_modoki/theme/theme.dart';

Widget form(int index, List<List<String>> charList, BuildContext context) {
  if (charList[index].isNotEmpty) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _tile(charList[index].isEmpty ? "" : charList[index][0], context),
        _tile(charList[index].length >= 2 ? charList[index][1] : "", context),
        _tile(charList[index].length >= 3 ? charList[index][2] : "", context),
        _tile(charList[index].length >= 4 ? charList[index][3] : "", context),
        _tile(charList[index].length >= 5 ? charList[index][4] : "", context),
        _tile(charList[index].length >= 6 ? charList[index][5] : "", context),
        _tile(charList[index].length >= 7 ? charList[index][6] : "", context),
      ],
    );
  }
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _tile("", context),
      _tile("", context),
      _tile("", context),
      _tile("", context),
      _tile("", context),
      _tile("", context),
      _tile("", context),
    ],
  );
}

Widget _tile(String char, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(2.0),
    child: SizedBox(
      width: MediaQuery.of(context).size.width / 8,
      height: MediaQuery.of(context).size.width / 8,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: WMColor.secondaryColor),
          color: WMColor.secondaryLightColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          char,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width / 8,
            color: WMColor.secondaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}
