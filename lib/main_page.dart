import 'package:flutter/material.dart';
import 'package:wordle_modoki/feat/graphql_client.dart';
import 'package:wordle_modoki/widget/form.dart';
import 'package:wordle_modoki/widget/keyboard.dart';

class Answer {
  const Answer({
    required this.position,
    required this.judge,
  });
  final int position;
  final String judge;
}

class CorrectAnswer {
  const CorrectAnswer({
    required this.word,
    required this.mean,
  });
  final String word;
  final String mean;
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
  final int charLength = 4;
  final String wordId = "hoge"; // UUID入れると単語が変わる

  Cursor cursor = Cursor(currentTimes: 0, currentPosition: 0);
  List<TileState> tiles = List.generate(
    20, // challengeTimesかcharLengthを変えたらここも変える（掛け算）
    (i) => TileState(
      times: 0,
      position: 0,
      char: "",
      state: CharState.NO_ANSWER,
    ),
  );

  List<String> word = [];
  List<Answer> answers = [];
  int correctCount = 0;

  void postAnswer() async {
    answerMutation(word).stream.listen((result) {
      if (result.isLoading) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) {
            return const AlertDialog(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              title: Center(
                child: SizedBox(width: 40, child: CircularProgressIndicator()),
              ),
            );
          },
        );
        return;
      }
      Navigator.pop(context); // loading dialog 消す用

      if (result.hasException) {
        debugPrint("エラーは" + result.exception.toString());
        showDialog(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: const Text("Result"),
              content: const Text("そんな英単語はありませ〜〜〜〜ん"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text("done"),
                )
              ],
            );
          },
        );
        return;
      }

      debugPrint("結果は" + result.data.toString());

      final position = result.data!['answerWord']['chars'] as List<dynamic>;
      for (var element in position) {
        setState(() {
          answers.add(
            Answer(
              position: element['position'],
              judge: element['judge'],
            ),
          );
        });
      }

      for (var answer in answers) {
        if (answer.judge == "CORRECT") {
          tiles[answer.position + (cursor.currentTimes * charLength)].state =
              CharState.CORRECT;
          setState(() {
            correctCount++;
          });
        } else if (answer.judge == "EXISTING") {
          tiles[answer.position + (cursor.currentTimes * charLength)].state =
              CharState.EXISTING;
        } else if (answer.judge == "NOTHING") {
          tiles[answer.position + (cursor.currentTimes * charLength)].state =
              CharState.NOTHING;
        }
      }

      if (cursor.currentTimes == challengeTimes - 1 ||
          correctCount == charLength) {
        correctWordQuery().stream.listen((result) {
          final correctWord = result.data!['correctWord']['word'] as String;
          final correctWordMean = result.data!['correctWord']['mean'] as String;

          showDialog(
            context: context,
            builder: (dialogContext) {
              return AlertDialog(
                title: Text(
                  (correctCount == charLength) ? "おめでちょい❣️" : "ざんねんちょい",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("答えは『 $correctWord 』"),
                    Text("意味は$correctWordMean"),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    child: const Text("done"),
                  )
                ],
              );
            },
          );
        });
      }

      // 初期化
      setState(() {
        cursor.currentPosition = 0;
        (cursor.currentTimes < 4) ? cursor.currentTimes++ : null;
        word = [];
        answers = [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("回答は" + word.toString());

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
              child: KeyBoard(
                tiles: tiles,
                count: cursor.currentTimes,
                onTapEnter: (word.length == charLength)
                    ? () {
                        postAnswer();
                        setState(() {
                          correctCount = 0;
                        });
                      }
                    : null,
                onTapDelete: (word.isEmpty)
                    ? null
                    : () {
                        setState(() {
                          word.removeAt(word.length - 1);
                          tiles[cursor.currentPosition +
                                  (cursor.currentTimes * charLength) -
                                  1]
                              .char = "";
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
