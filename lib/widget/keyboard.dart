import 'package:flutter/material.dart';
import 'package:wordle_modoki/main_page.dart';
import 'package:wordle_modoki/theme/theme.dart';

class AlphabetState {
  AlphabetState({
    required this.char,
    required this.state,
  });
  String char;
  CharState state;
}

class KeyBoard extends StatefulWidget {
  const KeyBoard({
    Key? key,
    required this.tiles,
    required this.count,
    this.onTapEnter,
    this.onTapDelete,
    this.onTapAlphabet,
  }) : super(key: key);

  final List<TileState> tiles;
  final int count;
  final VoidCallback? onTapEnter;
  final VoidCallback? onTapDelete;
  final Function(String)? onTapAlphabet;

  @override
  State<KeyBoard> createState() => _KeyBoardState();
}

class _KeyBoardState extends State<KeyBoard> {
  List<AlphabetState> alphabets = [
    AlphabetState(char: "Q", state: CharState.NO_ANSWER),
    AlphabetState(char: "W", state: CharState.NO_ANSWER),
    AlphabetState(char: "E", state: CharState.NO_ANSWER),
    AlphabetState(char: "R", state: CharState.NO_ANSWER),
    AlphabetState(char: "T", state: CharState.NO_ANSWER),
    AlphabetState(char: "Y", state: CharState.NO_ANSWER),
    AlphabetState(char: "U", state: CharState.NO_ANSWER),
    AlphabetState(char: "I", state: CharState.NO_ANSWER),
    AlphabetState(char: "O", state: CharState.NO_ANSWER),
    AlphabetState(char: "P", state: CharState.NO_ANSWER),
    AlphabetState(char: "A", state: CharState.NO_ANSWER),
    AlphabetState(char: "S", state: CharState.NO_ANSWER),
    AlphabetState(char: "D", state: CharState.NO_ANSWER),
    AlphabetState(char: "F", state: CharState.NO_ANSWER),
    AlphabetState(char: "G", state: CharState.NO_ANSWER),
    AlphabetState(char: "H", state: CharState.NO_ANSWER),
    AlphabetState(char: "J", state: CharState.NO_ANSWER),
    AlphabetState(char: "K", state: CharState.NO_ANSWER),
    AlphabetState(char: "L", state: CharState.NO_ANSWER),
    AlphabetState(char: "Z", state: CharState.NO_ANSWER),
    AlphabetState(char: "X", state: CharState.NO_ANSWER),
    AlphabetState(char: "C", state: CharState.NO_ANSWER),
    AlphabetState(char: "V", state: CharState.NO_ANSWER),
    AlphabetState(char: "B", state: CharState.NO_ANSWER),
    AlphabetState(char: "N", state: CharState.NO_ANSWER),
    AlphabetState(char: "M", state: CharState.NO_ANSWER),
  ];

  @override
  Widget build(BuildContext context) {
    return keyboard(
      widget.tiles,
      widget.count,
      widget.onTapEnter,
      widget.onTapDelete,
      widget.onTapAlphabet,
    );
  }

  Widget keyboard(
    List<TileState> tiles,
    int count,
    VoidCallback? onTapEnter,
    VoidCallback? onTapDelete,
    Function(String)? onTapAlphabet,
  ) {
    final width = MediaQuery.of(context).size.width;

    for (var tileState in tiles) {
      if (tileState.state == CharState.CORRECT) {
        for (var alphabet in alphabets) {
          if (tileState.char == alphabet.char) {
            setState(() {
              debugPrint("せいかい：${alphabet.char}");
              alphabet.state = CharState.CORRECT;
            });
          }
        }
      } else if (tileState.state == CharState.EXISTING) {
        for (var alphabet in alphabets) {
          if (tileState.char == alphabet.char) {
            setState(() {
              debugPrint("おしい：${alphabet.char}");
              // CORRECT が合ったら色上書きされないように
              if (alphabet.state == CharState.CORRECT) {
                return;
              }
              alphabet.state = CharState.EXISTING;
            });
          }
        }
      } else if (tileState.state == CharState.NOTHING) {
        for (var alphabet in alphabets) {
          if (tileState.char == alphabet.char) {
            setState(() {
              debugPrint("まちがい：${alphabet.char}");
              alphabet.state = CharState.NOTHING;
            });
          }
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < 10; i++)
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: _alphabet(
                  alphabets[i].char,
                  width,
                  onTapAlphabet,
                  alphabets[i].state,
                ),
              ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 10; i < 19; i++)
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: _alphabet(
                  alphabets[i].char,
                  width,
                  onTapAlphabet,
                  alphabets[i].state,
                ),
              ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _button(
              "Enter",
              onTapEnter,
              width,
            ),
            for (var i = 19; i < 26; i++)
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: _alphabet(
                  alphabets[i].char,
                  width,
                  onTapAlphabet,
                  alphabets[i].state,
                ),
              ),
            _button(
              "Delete",
              onTapDelete,
              width,
            ),
          ],
        ),
      ],
    );
  }

  // キーボードのアルファベットボタンひとつひとつ
  Widget _alphabet(
    String char,
    double width,
    Function(String)? onTapAlphabet,
    CharState charState,
  ) {
    Color backgroundColor = WMColor.lightGray;
    if (charState == CharState.CORRECT) {
      backgroundColor = WMColor.primaryColor;
    } else if (charState == CharState.EXISTING) {
      backgroundColor = WMColor.secondaryColor;
    } else if (charState == CharState.NOTHING) {
      backgroundColor = WMColor.gray;
    }

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        width: width / 13,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: backgroundColor,
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
  Widget _button(
    String text,
    VoidCallback? onTap,
    double width,
  ) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        width: width / 7,
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
}
