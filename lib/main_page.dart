import 'package:flutter/material.dart';
import 'package:wordle_modoki/feat/graphql_client.dart';
import 'package:wordle_modoki/theme/theme.dart';
import 'package:wordle_modoki/widget/form.dart';
import 'package:wordle_modoki/widget/old_form.dart';
import 'package:wordle_modoki/widget/keyboard.dart';

class Answer {
  const Answer({
    required this.position,
    required this.judge,
  });
  final int position;
  final String judge;
}

class TileState {
  TileState({
    required this.times,
    required this.position,
    required this.char,
    required this.state,
  });
  int times;
  int position;
  String char;
  CharState state;
}

class Cursor {
  Cursor({
    required this.currentTimes,
    required this.currentPosition,
  });
  int currentTimes;
  int currentPosition;
}

enum CharState {
  CORRECT,
  EXISTING,
  NOTHING,
  NO_ANSWER,
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int challengeTimes = 5;
  final int charLength = 7;
  final String wordId = "hoge";

  Cursor cursor = Cursor(currentTimes: 0, currentPosition: 0);
  List<TileState> tiles = List.generate(
    35,
    (i) => TileState(
      times: 0,
      position: 0,
      char: "",
      state: CharState.NO_ANSWER,
    ),
  );

  List<String> word = [];
  List<Answer> answer = [];

  // void postAnswer() async {
  //   final result = await answerMutation(charList[count]);

  //   debugPrint(result.data.toString());

  //   if (result.hasException) {
  //     debugPrint(result.exception.toString());
  //     showDialog(
  //       context: context,
  //       builder: (dialogContext) {
  //         return AlertDialog(
  //           title: const Text("Result"),
  //           content: const Text("そんな英単語はありませ〜〜〜〜ん"),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(dialogContext);
  //               },
  //               child: const Text("done"),
  //             )
  //           ],
  //         );
  //       },
  //     );
  //     return;
  //   }

  //   final position = result.data!['answerWord']['chars'] as List<dynamic>;
  //   for (var element in position) {
  //     setState(() {
  //       answer.add(
  //           Answer(position: element['position'], judge: element['judge']));
  //     });
  //   }
  //   setState(() {
  //     word = "";
  //     (count < 4) ? count++ : null;
  //     answer = [];
  //   });

  //   showDialog(
  //     context: context,
  //     builder: (dialogContext) {
  //       return AlertDialog(
  //         title: const Text("Result"),
  //         content: SizedBox(
  //           height: 100,
  //           width: 100,
  //           child: ListView.builder(
  //             itemCount: answer.length,
  //             itemBuilder: (context, i) {
  //               return Text(answer[i].judge);
  //             },
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(dialogContext);
  //             },
  //             child: const Text("done"),
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    print(word);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Guess the word!"),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: form(
                  tiles,
                  charLength,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: keyboard(
                cursor.currentTimes,
                context,
                onTapEnter: (word.length == charLength)
                    ? () {
                        print("OK");
                        cursor.currentPosition = 0;
                        cursor.currentTimes++;
                        setState(() {
                          word = [];
                        });

                        // correctWordQuery();
                        // postAnswer();
                      }
                    : null,
                onTapDelete: (word.isEmpty)
                    ? null
                    : () {
                        setState(() {
                          word.removeAt(word.length - 1);
                          tiles[cursor.currentPosition - 1].char = "";
                          cursor.currentPosition--;
                        });
                      },
                onTapAlphabet: (word.length == charLength)
                    ? null
                    : (String char) {
                        setState(
                          () {
                            word.add(char);
                            tiles[cursor.currentPosition +
                                    (cursor.currentTimes * charLength)]
                                .char = char;
                            cursor.currentPosition++;
                          },
                        );
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
