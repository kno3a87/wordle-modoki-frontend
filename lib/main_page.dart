import 'package:flutter/material.dart';
import 'package:wordle_modoki/feat/graphql_client.dart';
import 'package:wordle_modoki/theme/theme.dart';
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
                    return _form(count);
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

  Widget _form(int index) {
    if (charList[index].isNotEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _tile(charList[index].isEmpty ? "" : charList[index][0]),
          _tile(charList[index].length >= 2 ? charList[index][1] : ""),
          _tile(charList[index].length >= 3 ? charList[index][2] : ""),
          _tile(charList[index].length >= 4 ? charList[index][3] : ""),
          _tile(charList[index].length >= 5 ? charList[index][4] : ""),
          _tile(charList[index].length >= 6 ? charList[index][5] : ""),
          _tile(charList[index].length >= 7 ? charList[index][6] : ""),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _tile(""),
        _tile(""),
        _tile(""),
        _tile(""),
        _tile(""),
        _tile(""),
        _tile(""),
      ],
    );
  }

  Widget _tile(String char) {
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
}
