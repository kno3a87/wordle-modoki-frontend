import 'package:flutter/material.dart';
import 'package:graphql/client.dart';

// まだ使ってない
const String wordId = "hoge";

GraphQLClient initGeraphql() {
  final Link _httpLink = HttpLink(
    'http://daca-106-184-135-238.ngrok.io/graphql',
  );

  final GraphQLClient client = GraphQLClient(
    cache: GraphQLCache(),
    link: _httpLink,
  );

  return client;
}

ObservableQuery correctWordQuery() {
  const String correctWordQuery = r'''
      query CorrectWord($wordId: String!) {
        correctWord(wordId: $wordId) {
          word
          mean
        }
      }
    ''';

  final WatchQueryOptions options = WatchQueryOptions(
    fetchResults: true, // これないと listen 効かない
    document: gql(correctWordQuery),
    variables: <String, String>{
      'wordId': wordId,
    },
  );

  final result = initGeraphql().watchQuery(options);

  result.stream.listen((v) {
    debugPrint("解答は" + v.data.toString());
  });

  return result;
}

ObservableQuery answerMutation(List<String> charList) {
  String word = "";
  for (var element in charList) {
    word += element;
  }

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

  final WatchQueryOptions options = WatchQueryOptions(
    fetchResults: true,
    document: gql(answerMutation),
    variables: <String, String>{
      'wordId': wordId,
      'word': word,
    },
  );

  final result = initGeraphql().watchMutation(options);

  return result;
}
