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

// まだ使ってない
void correctWordQuery() async {
  const String correctWordQuery = r'''
      query CorrectWord($wordId: String!) {
        correctWord(wordId: $wordId) {
          word
          mean
        }
      }
    ''';

  final QueryOptions options = QueryOptions(
    document: gql(correctWordQuery),
    variables: <String, String>{
      'wordId': wordId,
    },
  );

  final QueryResult result = await initGeraphql().query(options);
  print(result);
}

Future<QueryResult> answerMutation(List<String> charList) async {
  String word = "";
  for (var element in charList) {
    word += element;
  }
  debugPrint(word);

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

  final QueryResult result = await initGeraphql().mutate(options);

  debugPrint(result.data.toString());

  return result;
}
