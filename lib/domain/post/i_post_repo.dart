import 'package:dartz/dartz.dart';
import 'package:social_media/domain/core/failure/app_failure.dart';
import 'package:social_media/models/post.dart';

abstract class IPostRepo {
  ///Returns the posts created by the user
  Future<Either<AppFailure, List<Post>>> getCreatedPosts(String userid);

  ///Returns the post of the specified user as well as the post of other users who is been following
  Future<Either<AppFailure, List<Post>>> getRecommendedPosts(String userid);

  ///Returns the post that contains mentions
  Future<Either<AppFailure, List<Post>>> getMentionedPosts(String username);

  ///Follow a user
  Future<Either<AppFailure, bool>> followUser(
      {required String userid, required String followUser});

  ///UnFollow a user
  Future<Either<AppFailure, bool>> unFollowUser(
      {required String userid, required String followUser});

  ///Create a post
  Future<Either<AppFailure, Post>> createPosts(
      {required String userId, String? description, String? image});
}
