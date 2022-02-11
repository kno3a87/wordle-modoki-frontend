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
  String wordId = "";
  String word = "";
  List<Answer> answer = [];

  void answerMutation() async {
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
  final _focus = [true, false, false, false, false];
  final _textController = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  final _formKey = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Guess the word!"),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: challengeCount,
        itemBuilder: (context, i) {
          return _field(i);
        },
      ),
    );
  }

  Widget _field(int index) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Form(
        key: _formKey[index],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: TextFormField(
                autofocus: true,
                minLines: 1,
                maxLines: 1,
                controller: _textController[index],
                decoration: InputDecoration(
                  filled: true,
                  // TOOD: 色作る
                  fillColor: _focus[index] ? Colors.white : Colors.grey,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 5,
                      color: WordleModokiColor.hintColor,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.url,
                enabled: _focus[index],
                onChanged: (value) {
                  setState(() {
                    word = value;
                  });
                },
                validator: (value) => validateWord(value, wordCharLength),
              ),
            ),
            IconButton(
              onPressed: !_focus[index] ||
                      _formKey[index].currentState == null ||
                      !_formKey[index].currentState!.validate()
                  ? null
                  : () {
                      answerMutation();
                      setState(() {
                        word = "";
                        answer = [];
                      });
                      setState(() {
                        _focus[index] = false;
                        if (index < challengeCount - 1) {
                          _focus[index + 1] = true;
                        }
                      });
                    },
              icon: const Icon(
                Icons.star_rate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
