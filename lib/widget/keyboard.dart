import 'package:flutter/material.dart';
import 'package:wordle_modoki/theme/theme.dart';

Widget keyboard(
  int count,
  BuildContext context, {
  VoidCallback? onTapEnter,
  VoidCallback? onTapDelete,
  Function(String)? onTapAlphabet,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _alphabet("Q", count, context, onTapAlphabet),
          _alphabet("W", count, context, onTapAlphabet),
          _alphabet("E", count, context, onTapAlphabet),
          _alphabet("R", count, context, onTapAlphabet),
          _alphabet("T", count, context, onTapAlphabet),
          _alphabet("Y", count, context, onTapAlphabet),
          _alphabet("U", count, context, onTapAlphabet),
          _alphabet("I", count, context, onTapAlphabet),
          _alphabet("O", count, context, onTapAlphabet),
          _alphabet("P", count, context, onTapAlphabet),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _alphabet("A", count, context, onTapAlphabet),
          _alphabet("S", count, context, onTapAlphabet),
          _alphabet("D", count, context, onTapAlphabet),
          _alphabet("F", count, context, onTapAlphabet),
          _alphabet("G", count, context, onTapAlphabet),
          _alphabet("H", count, context, onTapAlphabet),
          _alphabet("J", count, context, onTapAlphabet),
          _alphabet("K", count, context, onTapAlphabet),
          _alphabet("L", count, context, onTapAlphabet),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _button(
            "Enter",
            onTapEnter,
            context,
          ),
          _alphabet("Z", count, context, onTapAlphabet),
          _alphabet("X", count, context, onTapAlphabet),
          _alphabet("C", count, context, onTapAlphabet),
          _alphabet("V", count, context, onTapAlphabet),
          _alphabet("B", count, context, onTapAlphabet),
          _alphabet("N", count, context, onTapAlphabet),
          _alphabet("M", count, context, onTapAlphabet),
          _button(
            "Delete",
            onTapDelete,
            context,
          ),
        ],
      ),
    ],
  );
}

// キーボードのアルファベットボタンひとつひとつ
Widget _alphabet(
  String char,
  int index,
  BuildContext context,
  Function(String)? onTapAlphabet,
) {
  return Padding(
    padding: const EdgeInsets.all(2.0),
    child: SizedBox(
      width: MediaQuery.of(context).size.width / 12,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: WMColor.primaryDarkColor,
        ),
        child: Text(
          char,
          style: const TextStyle(
            color: WMColor.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: (onTapAlphabet != null) ? () => onTapAlphabet(char) : null,
      ),
    ),
  );
}

// キーボードのEnterとDeleteのボタン
Widget _button(String text, VoidCallback? onTap, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(2.0),
    child: SizedBox(
      width: MediaQuery.of(context).size.width / 7,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: WMColor.primaryDarkColor,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: WMColor.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: onTap,
      ),
    ),
  );
}
// }
