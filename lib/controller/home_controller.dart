import 'package:get/get.dart';

import '../models/post.dart';

class HomeController extends GetxController {
  List<Post> recommendedPosts = [];

  void addPost(Post post) {
    recommendedPosts.insert(0, post);
    update();
  }

  void removePost(int index) {
    recommendedPosts.removeAt(index);
    update();
  }
}
