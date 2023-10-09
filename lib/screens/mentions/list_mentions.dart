import 'package:flutter/material.dart';
import 'package:social_media/domain/core/dll/injectable.dart';
import 'package:social_media/domain/post/i_post_repo.dart';
import 'package:social_media/helper_widgets/appbar.dart';
import 'package:social_media/helper_widgets/bottom_navigation/app_bottom_navigation.dart';

import '../../helper_widgets/list_posts.dart';
import '../../models/user.dart';

class ListMentionsPage extends StatelessWidget {
  const ListMentionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: customAppbar(context),
      bottomNavigationBar: const AppBottombar(
        currentIndex: 1,
      ),
      body: FutureBuilder(
          future: getIt<IPostRepo>().getMentionedPosts(getIt<User>().username!),
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
            return snapshot.data!.fold(
                (l) => Center(
                      child: Text(l.message),
                    ),
                (r) => ListPosts(
                      posts: r,
                    ));
          }),
    ));
  }
}
