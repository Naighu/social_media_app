import 'package:flutter/material.dart';
import 'package:social_media/constants/constants.dart';
import 'package:social_media/models/post.dart';

import 'display_description.dart';

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    const SizedBox sizedBox = SizedBox(
      height: 10,
    );
    return Container(
      margin: const EdgeInsets.only(bottom: kDefaultPadding),
      padding: const EdgeInsets.only(
          left: kDefaultPadding * 0.5,
          right: kDefaultPadding * 0.5,
          bottom: kDefaultPadding * 0.5),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(kBorderRadius),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        sizedBox,
        _DisplayUser(
          user: post.user,
        ),
        sizedBox,
        if (post.description != null)
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DisplayDescription(description: post.description!)),
        sizedBox,
        if (post.image != null)
          ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: kBorderRadius,
                  topRight: kBorderRadius,
                  bottomLeft: kBorderRadius,
                  bottomRight: kBorderRadius),
              child: Image.network(post.image!))
      ]),
    );
  }
}

class _DisplayUser extends StatelessWidget {
  final PostUser user;
  const _DisplayUser({required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.green,
          child: Text(user.name.characters.first),
        ),
        kSizedBox,
        Text(
          user.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        )
      ],
    );
  }
}
