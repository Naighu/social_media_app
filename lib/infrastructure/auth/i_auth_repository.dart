import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:social_media/api/api.dart';
import 'package:social_media/domain/auth/i_auth_repo.dart';
import 'package:social_media/domain/core/failure/app_failure.dart';
import 'package:social_media/models/user.dart';

@LazySingleton(as: IAuthRepo)
class AuthRepository implements IAuthRepo {
  final Api api;

  AuthRepository(this.api);
  @override
  Future<Either<AppFailure, User>> getUserDetails(String userId) async {
    final response = await api.call(QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql('''
    {
      user(_id : "$userId",phone:"" ,username: ""){
        _id,
        name,
        followers,
        following,
        phone,
        username
      }
    }
    '''),
    ));
    if (response.data != null && !response.hasException) {
      if (response.data!['user']['_id'] == null) {
        return Left(ClientFailure('User does not exists'));
      } else {
        final User user = User.fromJson(response.data!['user']);
        return Right(user);
      }
    } else {
      return Left(ClientFailure(response.exception.toString()));
    }
  }

  @override
  Future<Either<AppFailure, User>> login({required String mob}) async {
    final response = await api.call(QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql('''
  mutation  {
      login(phone : "$mob"){
        _id,
        name,
        username,
        name,
        phone,
        followers,
        following
      }
    }
    '''),
    ));
    try {
      if (response.data != null && !response.hasException) {
        final User user = User.fromJson(response.data!['login']);
        return Right(user);
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
  Future<Either<AppFailure, bool>> logout() async {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<Either<AppFailure, User>> updateDetails(
      {required String userId,
      required String name,
      required String username}) async {
    final response = await api.call(QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql('''
  mutation  {
      createUser(user : "$userId", name: "$name", username: "$username"){
        _id,
        name,
        username,
        name,
        phone,
        followers,
        following
      }
    }
    '''),
    ));
    try {
      if (response.data != null && !response.hasException) {
        final User user = User.fromJson(response.data!['createUser']);
        return Right(user);
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
  Future<Either<AppFailure, List<User>>> searchUsers({String? username}) async {
    final response = await api.call(QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql('''
  query  {
      search_users(search : "$username"  ){
        _id,
        name,
        username,
        name,
        phone,
        followers,
        following
      }
    }
    '''),
    ));
    try {
      if (response.data != null && !response.hasException) {
        final List<User> users = List.from(
            response.data!['search_users'].map((e) => User.fromJson(e)));
        return Right(users);
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
  Future<Either<AppFailure, User>> getUserDetailsFromUsername(
      String username) async {
    final response = await api.call(QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql('''
    {
      user(_id : "",phone:"" ,username: "$username"){
        _id,
        name,
        followers,
        following,
        phone,
        username
      }
    }
    '''),
    ));
    if (response.data != null && !response.hasException) {
      if (response.data!['user']['_id'] == null) {
        return Left(ClientFailure('User does not exists'));
      } else {
        final User user = User.fromJson(response.data!['user']);
        return Right(user);
      }
    } else {
      return Left(ClientFailure(response.exception.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<User>>> searchUsersForTag(
      {String? username}) async {
    final response = await api.call(QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql('''
  query  {
      search_users(search : "$username"  ){
        username
      }
    }
    '''),
    ));
    try {
      if (response.data != null && !response.hasException) {
        final List<User> users = List.from(
            response.data!['search_users'].map((e) => User.fromJson(e)));
        return Right(users);
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
