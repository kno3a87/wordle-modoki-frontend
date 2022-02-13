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

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final challengeCount = 5;
  // TODO: [] 5個かいてるのきもい
  List<List<String>> charList = [[], [], [], [], []];
  String wordId = "hoge";
  String word = "";
  List<Answer> answer = [];
  int count = 0;

  void postAnswer() async {
    final result = await answerMutation(charList[count]);

    debugPrint(result.data.toString());

    if (result.hasException) {
      debugPrint(result.exception.toString());
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

    final position = result.data!['answerWord']['chars'] as List<dynamic>;
    for (var element in position) {
      setState(() {
        answer.add(
            Answer(position: element['position'], judge: element['judge']));
      });
    }
    setState(() {
      word = "";
      (count < 4) ? count++ : null;
      answer = [];
    });

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Result"),
          content: SizedBox(
            height: 100,
            width: 100,
            child: ListView.builder(
              itemCount: answer.length,
              itemBuilder: (context, i) {
                return Text(answer[i].judge);
              },
            ),
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
  }

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.only(top: 48),
                child: ListView.separated(
                  itemCount: challengeCount,
                  itemBuilder: (context, count) {
                    return form(count, charList, context);
                  },
                  separatorBuilder: (context, i) {
                    return const SizedBox(height: 12);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: KeyBoard(
                count: count,
                onTapEnter: (charList[count].length == 7)
                    ? () {
                        // correctWordQuery();
                        postAnswer();
                      }
                    : null,
                onTapDelete: () {
                  setState(() {
                    charList[count].removeAt(charList[count].length - 1);
                  });
                },
                onTapAlphabet: (charList[count].length == 7)
                    ? null
                    : (String char) {
                        setState(() {
                          charList[count].add(char);
                        });
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
