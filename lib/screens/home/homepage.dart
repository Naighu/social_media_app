import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:social_media/controller/home_controller.dart';
import 'package:social_media/domain/core/dll/injectable.dart';
import 'package:social_media/domain/post/i_post_repo.dart';
import 'package:social_media/helper_widgets/list_posts.dart';
import 'package:social_media/models/post.dart';

import '../../constants/constants.dart';
import '../../helper_widgets/appbar.dart';
import '../../helper_widgets/bottom_navigation/app_bottom_navigation.dart';
import '../../models/user.dart';
import '../create_post/create_post_page.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: customAppbar(context),
            bottomNavigationBar: const AppBottombar(),
            floatingActionButton: FloatingActionButton(
              backgroundColor: kPrimaryColor,
              onPressed: () {
                Navigator.push<Post?>(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreatePostPage(
                              user: getIt<User>(),
                            ))).then((value) {
                  if (value != null) {
                    //update the homepage with newly created post
                    Get.find<HomeController>().addPost(value);
                  }
                });
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                Get.find<HomeController>().update(['refresh']);
              },
              child: GetBuilder<HomeController>(
                  id: 'refresh',
                  builder: (context) {
                    return ListHomepagePosts(
                      user: getIt<User>(),
                    );
                  }),
            )));
  }
}

class ListHomepagePosts extends StatefulWidget {
  final User user;
  const ListHomepagePosts({super.key, required this.user});

  @override
  State<ListHomepagePosts> createState() => _ListHomepagePostsState();
}

class _ListHomepagePostsState extends State<ListHomepagePosts> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getIt<IPostRepo>().getRecommendedPosts(widget.user.id),
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
                  ), (r) {
            Get.find<HomeController>().recommendedPosts = r;
            return GetBuilder<HomeController>(builder: (controller) {
              return ListPosts(
                posts: controller.recommendedPosts,
              );
            });
          });
        });
  }
}
