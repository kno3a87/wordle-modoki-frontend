import 'package:flutter/material.dart';
import 'package:wordle_modoki/theme/theme.dart';

class KeyBoard extends StatefulWidget {
  const KeyBoard({
    Key? key,
    required this.count,
    required this.onTapEnter,
    required this.onTapDelete,
    required this.onTapAlphabet,
  }) : super(key: key);

  final int count;
  final VoidCallback? onTapEnter;
  final VoidCallback? onTapDelete;
  final Function(String)? onTapAlphabet;

  @override
  State<KeyBoard> createState() => _KeyBoardState();
}

class _KeyBoardState extends State<KeyBoard> {
  @override
  Widget build(BuildContext context) {
    return keyboard(widget.count, context);
  }

  Widget keyboard(int count, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            alphabet("Q", count, context),
            alphabet("W", count, context),
            alphabet("E", count, context),
            alphabet("R", count, context),
            alphabet("T", count, context),
            alphabet("Y", count, context),
            alphabet("U", count, context),
            alphabet("I", count, context),
            alphabet("O", count, context),
            alphabet("P", count, context),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            alphabet("A", count, context),
            alphabet("S", count, context),
            alphabet("D", count, context),
            alphabet("F", count, context),
            alphabet("G", count, context),
            alphabet("H", count, context),
            alphabet("J", count, context),
            alphabet("K", count, context),
            alphabet("L", count, context),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _button(
              "Enter",
              widget.onTapEnter,
            ),
            alphabet("Z", count, context),
            alphabet("X", count, context),
            alphabet("C", count, context),
            alphabet("V", count, context),
            alphabet("B", count, context),
            alphabet("N", count, context),
            alphabet("M", count, context),
            _button(
              "Delete",
              widget.onTapDelete,
            ),
          ],
        ),
      ],
    );
  }

  // キーボードのアルファベットボタンひとつひとつ
  Widget alphabet(String char, int index, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 12,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: WMColor.primaryLightColor,
          ),
          child: Text(
            char,
            style: const TextStyle(
              color: WMColor.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () => widget.onTapAlphabet!(char),
        ),
      ),
    );
  }

  // キーボードのEnterとDeleteのボタン
  Widget _button(String text, VoidCallback? onTap) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 7,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: WMColor.primaryLightColor,
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: WMColor.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: onTap,
        ),
      ),
    );
  }
}
