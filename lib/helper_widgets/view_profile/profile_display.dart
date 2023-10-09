import 'package:flutter/material.dart';
import 'package:social_media/constants/constants.dart';
import 'package:social_media/domain/auth/i_auth_repo.dart';
import 'package:social_media/domain/core/dll/injectable.dart';
import 'package:social_media/domain/post/i_post_repo.dart';
import 'package:social_media/helper_widgets/list_posts.dart';
import 'package:social_media/models/post.dart';
import 'package:social_media/models/user.dart';
import 'package:social_media/helper_widgets/view_profile/top_section.dart';

class ProfileDisplay extends StatelessWidget {
  final User user;
  const ProfileDisplay({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          getIt<IAuthRepo>().getUserDetails(user.id),
          getIt<IPostRepo>().getCreatedPosts(user.id)
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          String? error;
          User? user;
          List<Post> posts = [];
          snapshot.data![0].fold((l) {
            error = l.message;
          }, (r) {
            user = r as User;
          });
          snapshot.data![1].fold((l) {
            error = l.message;
          }, (r) {
            posts = r as List<Post>;
          });

          if (error != null) {
            return Center(
              child: Text(error.toString()),
            );
          }
          return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ProfileTopSection(
                  user: user!,
                  posts: posts.length,
                ),
                kSizedBox,
                const Text(
                  'Your posts',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                kSizedBox,
                Expanded(
                    child: ListPosts(
                  posts: posts,
                ))
              ]);
        });
  }
}
