import 'package:flutter/material.dart';
import 'package:wordle_modoki/feat/validator.dart';
import 'package:wordle_modoki/theme/theme.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

  String inputWord = "";

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
                    inputWord = value;
                  });
                },
                validator: (value) => validateWord(value, wordCharLength),
              ),
            ),
            // TODO: Mutation 呼ぶ
            IconButton(
              onPressed: !_focus[index] ||
                      _formKey[index].currentState == null ||
                      !_formKey[index].currentState!.validate()
                  ? null
                  : () {
                      setState(() {
                        _focus[index] = false;
                        if (index < challengeCount - 1) {
                          _focus[index + 1] = true;
                        }
                      });
                      showDialog(
                        context: context,
                        builder: (dialogContext) {
                          return AlertDialog(
                            title: const Text("ぷぷぷ"),
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
