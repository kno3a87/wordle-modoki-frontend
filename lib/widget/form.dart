import 'package:flutter/material.dart';
import 'package:wordle_modoki/main_page.dart';
import 'package:wordle_modoki/theme/theme.dart';

Widget form(List<TileState> tilesState, int charLength) {
  return GridView.count(
    crossAxisCount: charLength,
    children: [
      for (var tileState in tilesState)
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: _tile(tileState),
        ),
    ],
  );
}

Widget _tile(TileState tileState) {
  Color boxBackgroundColor = WMColor.white;
  if (tileState.state == CharState.CORRECT) {
    boxBackgroundColor = WMColor.primaryLightColor;
  } else if (tileState.state == CharState.EXISTING) {
    boxBackgroundColor = WMColor.primaryColor;
  } else if (tileState.state == CharState.NOTHING) {
    boxBackgroundColor = WMColor.secondaryLightColor;
  }

  return Padding(
    padding: const EdgeInsets.all(2.0),
    child: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: WMColor.secondaryColor),
        color: boxBackgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        tileState.char,
        style: const TextStyle(
          fontSize: 60,
          color: WMColor.secondaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
