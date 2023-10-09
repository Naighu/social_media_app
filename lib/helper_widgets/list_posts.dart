import 'package:flutter/material.dart';
import 'package:social_media/constants/constants.dart';

import 'post_card/post_card.dart';
import '../models/post.dart';

// List<Post> posts = [
//   Post(
//       id: 'sdfsfsfdsdf',
//       description: null,
//       created: DateTime.now(),
//       user: PostUser(id: 'sdfsd', name: 'Naigal Roy', username: ""),
//       image:
//           'https://thumbs.dreamstime.com/z/world-news-globalization-advertising-event-media-concept-information-54339614.jpg'),
//   Post(
//       id: 'sdfsfsfdsdf',
//       description: 'This is a long text containg large text ',
//       created: DateTime.now(),
//       user: PostUser(id: 'sdfsd', name: 'Jopaul Joy', username: ""),
//       image: null),
//   Post(
//       id: 'sdfsfsfdsdf',
//       description: 'This is a long text containg large text ',
//       created: DateTime.now(),
//       user: PostUser(id: 'sdfsd', name: 'Pranav V', username: ""),
//       image:
//           'https://thumbs.dreamstime.com/z/world-news-globalization-advertising-event-media-concept-information-54339614.jpg'),
//   Post(
//       id: 'sdfsfsfdsdf',
//       description: 'This is a long text containg large text ',
//       created: DateTime.now(),
//       user: PostUser(id: 'sdfsd', name: 'Sreejith S Karth', username: ""),
//       image: null),
//   Post(
//       id: 'sdfsfsfdsdf',
//       description: 'This is a long text containg large text ',
//       created: DateTime.now(),
//       user: PostUser(id: 'sdfsd', name: 'Maria ', username: ""),
//       image: null),
// ];

class ListPosts extends StatelessWidget {
  final List<Post> posts;
  const ListPosts({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return const Center(
        child: Text(
          'No posts yet',
          style: TextStyle(fontSize: 18),
        ),
      );
    }
    return ListView.builder(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.3),
        itemBuilder: (context, index) => PostCard(post: posts[index]),
        itemCount: posts.length);
  }
}
