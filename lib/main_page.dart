import 'package:flutter/material.dart';
import 'package:wordle_modoki/theme/theme.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final challengeCount = 5;
  final _focus = [true, false, false, false, false];
  final _textController = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
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
          return _field(_textController, _focus, i);
        },
      ),
    );
  }

  Widget _field(
    List<TextEditingController> controller,
    List<bool> focus,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: TextField(
                autofocus: true,
                minLines: 1,
                maxLines: 1,
                controller: controller[index],
                decoration: InputDecoration(
                  filled: true,
                  // TOOD: 色作る
                  fillColor: focus[index] ? Colors.white : Colors.grey,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 5,
                      color: WordleModokiColor.hintColor,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.url,
                enabled: focus[index],
                onChanged: (value) {
                  setState(() {
                    inputWord = value;
                  });
                },
              ),
            ),
          ),
          // TODO: Mutation 呼ぶ
          IconButton(
            onPressed: !focus[index]
                ? null
                : () {
                    setState(() {
                      focus[index] = false;
                      if (index < challengeCount - 1) {
                        focus[index + 1] = true;
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
              Icons.arrow_right_alt_outlined,
            ),
          ),
        ],
      ),
    );
  }
}
