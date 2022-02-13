import 'package:flutter/material.dart';
import 'package:wordle_modoki/feat/validator.dart';
import 'package:wordle_modoki/theme/theme.dart';
import 'package:graphql/client.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Answer {
  const Answer({
    required this.position,
    required this.judge,
  });
  final int position;
  final String judge;
}

class _MyHomePageState extends State<MyHomePage> {
  String wordId = "hoge";
  String word = "";
  List<Answer> answer = [];

  void answerMutation() async {
    for (var element in charList) {
      word += element;
    }

    final Link _httpLink = HttpLink(
      'http://ff68-106-184-135-238.ngrok.io/graphql',
    );

    final GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: _httpLink,
    );

    const String answerMutation = r'''
      mutation AnswerWord($wordId: String!, $word: String!) {
        answerWord(wordId: $wordId, word: $word) {
          chars {
            judge
            position
          }
        }
      }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(answerMutation),
      variables: <String, String>{
        'wordId': wordId,
        'word': word,
      },
    );

    final QueryResult result = await client.mutate(options);

    debugPrint(result.data.toString());

    if (result.hasException) {
      debugPrint(result.exception.toString());
      return;
    }

    final position = result.data!['answerWord']['chars'] as List<dynamic>;
    for (var element in position) {
      setState(() {
        answer.add(
            Answer(position: element['position'], judge: element['judge']));
      });
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("ぷぷぷ"),
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

  final challengeCount = 5;
  final wordCharLength = 7;

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 48),
              child: _form(0),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: _keyboard(),
            ),
          ],
        ),
      ),
      // ListView.builder(
      //   itemCount: challengeCount,
      //   itemBuilder: (context, i) {
      //     return _field(i);
      //   },
      // ),
    );
  }

  List<String> charList = [];

  Widget _keyboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _alphabet("Q"),
            _alphabet("W"),
            _alphabet("E"),
            _alphabet("R"),
            _alphabet("T"),
            _alphabet("Y"),
            _alphabet("U"),
            _alphabet("I"),
            _alphabet("O"),
            _alphabet("P"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _alphabet("A"),
            _alphabet("S"),
            _alphabet("D"),
            _alphabet("F"),
            _alphabet("G"),
            _alphabet("H"),
            _alphabet("J"),
            _alphabet("K"),
            _alphabet("L"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _button(
              "Enter",
              (charList.length == 7)
                  ? () {
                      answerMutation();
                      // setState(() {
                      //   word = "";
                      //   answer = [];
                      // });
                      // setState(() {
                      //   _focus[index] = false;
                      //   if (index < challengeCount - 1) {
                      //     _focus[index + 1] = true;
                      //   }
                      // });
                    }
                  : null,
            ),
            _alphabet("Z"),
            _alphabet("X"),
            _alphabet("C"),
            _alphabet("V"),
            _alphabet("B"),
            _alphabet("N"),
            _alphabet("M"),
            _button(
              "Delete",
              () {
                setState(() {
                  charList.removeAt(charList.length - 1);
                });
              },
            ),
          ],
        ),
      ],
    );
  }

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

  Widget _alphabet(String char) {
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
          onPressed: () {
            setState(() {
              charList.add(char);
            });
          },
        ),
      ),
    );
  }

  Widget _form(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _tile(charList.isEmpty ? "" : charList[0]),
        _tile(charList.length >= 2 ? charList[1] : ""),
        _tile(charList.length >= 3 ? charList[2] : ""),
        _tile(charList.length >= 4 ? charList[3] : ""),
        _tile(charList.length >= 5 ? charList[4] : ""),
        _tile(charList.length >= 6 ? charList[5] : ""),
        _tile(charList.length >= 7 ? charList[6] : ""),
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
