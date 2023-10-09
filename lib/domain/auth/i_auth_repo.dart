import 'package:dartz/dartz.dart';
import 'package:social_media/domain/core/failure/app_failure.dart';
import 'package:social_media/models/user.dart';

abstract class IAuthRepo {
  ///Login
  Future<Either<AppFailure, User>> login({
    required String mob,
  });

  ///Update the user details such as name and username
  Future<Either<AppFailure, User>> updateDetails(
      {required String userId, required String name, required String username});

  ///Get the user details from userid
  Future<Either<AppFailure, User>> getUserDetails(String userId);

  ///Get the user details from username
  Future<Either<AppFailure, User>> getUserDetailsFromUsername(String username);

  ///Search for a user
  ///Returns all the user which matches the username specified
  Future<Either<AppFailure, List<User>>> searchUsers({String? username});
}
