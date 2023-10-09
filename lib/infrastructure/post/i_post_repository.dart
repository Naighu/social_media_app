import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:social_media/api/api.dart';
import 'package:social_media/domain/core/failure/app_failure.dart';
import 'package:social_media/domain/post/i_post_repo.dart';
import 'package:social_media/models/post.dart';

@LazySingleton(as: IPostRepo)
class IPostRepository implements IPostRepo {
  final Api api;

  IPostRepository(this.api);

  @override
  Future<Either<AppFailure, List<Post>>> getCreatedPosts(String userid) async {
    final response = await api.call(QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql('''
  query  {
      your_posts(user_id : "$userid"){
        _id,
        description,
        image,
        user {
          _id,
          name,
          username
        }
      }
    }
    '''),
    ));

    try {
      if (response.data != null && !response.hasException) {
        final List<Post> posts = List.from(
            response.data!['your_posts'].map((e) => Post.fromJson(e)));
        return Right(posts.reversed.toList());
      } else {
        log(response.exception!.graphqlErrors.toString());

        return Left(ClientFailure(response.exception.toString()));
      }
    } catch (e) {
      log(e.toString());
      return Left(ClientFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<AppFailure, List<Post>>> getRecommendedPosts(
      String userid) async {
    final response = await api.call(QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql('''
  query  {
      recommended_posts(user_id : "$userid"){
        _id,
        description,
        image,
        user {
          _id,
          name,
          username
        }
      }
    }
    '''),
    ));

    try {
      if (response.data != null && !response.hasException) {
        final List<Post> posts = List.from(
            response.data!['recommended_posts'].map((e) => Post.fromJson(e)));
        return Right(posts.reversed.toList());
      } else {
        log(response.exception!.graphqlErrors.toString());

        return Left(ClientFailure(response.exception.toString()));
      }
    } catch (e) {
      log(e.toString());
      return Left(ClientFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<AppFailure, Post>> createPosts(
      {required String userId, String? description, String? image}) async {
    try {
      const m = '''
  mutation createPost(\$user : ID, \$description: String!, \$image: String!){
      createPost(user : \$user, description: \$description, image: \$image){
        _id,
        description,
        image,
        user {
          _id,
          name,
          username
        }
      }
    }
    ''';
      final response = await api.call(QueryOptions(
          fetchPolicy: FetchPolicy.networkOnly,
          document: gql(m),
          variables: {
            'user': userId,
            'description': description,
            'image': image ?? ''
          }));

      if (response.data != null && !response.hasException) {
        final Post post = Post.fromJson(response.data!['createPost']);
        return Right(post);
      } else {
        log(response.exception.toString());

        return Left(ClientFailure(response.exception.toString()));
      }
    } catch (e) {
      log(e.toString());
      return Left(ClientFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<AppFailure, bool>> followUser(
      {required String userid, required String followUser}) async {
    final response = await api.call(QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql('''
  mutation  {
      follow_user(user_id : "$userid",follow_user: "$followUser"){
        _id,
        followers,
        following
      }
    }
    '''),
    ));

    try {
      if (response.data != null && !response.hasException) {
        // final List<Post> posts = List.from(
        //     response.data!['follow_user']);
        return const Right(true);
      } else {
        log(response.exception!.graphqlErrors.toString());

        return Left(ClientFailure(response.exception.toString()));
      }
    } catch (e) {
      log(e.toString());
      return Left(ClientFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<AppFailure, bool>> unFollowUser(
      {required String userid, required String followUser}) async {
    final response = await api.call(QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql('''
  mutation  {
      unfollow_user(user_id : "$userid",follow_user: "$followUser"){
        _id,
        followers,
        following
      }
    }
    '''),
    ));

    try {
      if (response.data != null && !response.hasException) {
        // final List<Post> posts = List.from(
        //     response.data!['follow_user']);
        return const Right(true);
      } else {
        log(response.exception!.graphqlErrors.toString());

        return Left(ClientFailure(response.exception.toString()));
      }
    } catch (e) {
      log(e.toString());
      return Left(ClientFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<AppFailure, List<Post>>> getMentionedPosts(
      String username) async {
    final response = await api.call(QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql('''
  query  {
      mentioned_posts(username : "$username"){
        _id,
        description,
        image,
        user {
          _id,
          name,
          username
        }
      }
    }
    '''),
    ));

    try {
      if (response.data != null && !response.hasException) {
        final List<Post> posts = List.from(
            response.data!['mentioned_posts'].map((e) => Post.fromJson(e)));
        return Right(posts.reversed.toList());
      } else {
        log(response.exception!.graphqlErrors.toString());

        return Left(ClientFailure(response.exception.toString()));
      }
    } catch (e) {
      log(e.toString());
      return Left(ClientFailure('Something went wrong'));
    }
  }
}
