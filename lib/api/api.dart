import 'package:injectable/injectable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:social_media/constants/string.dart';

@LazySingleton()
class Api {
  late GraphQLClient client;
  Api() {
    final HttpLink httpLink = HttpLink(
      '$kBaseUrl/graphql',
    );
    client = GraphQLClient(
      link: httpLink,
      // The default store is the InMemoryStore, which does NOT persist to disk
      cache: GraphQLCache(store: HiveStore()),
    );
  }

  Future<QueryResult> call(QueryOptions options) async {
    return client.query(options);
  }
}
