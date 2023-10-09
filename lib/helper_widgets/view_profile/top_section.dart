import 'package:flutter/material.dart';
import 'package:social_media/constants/constants.dart';
import 'package:social_media/models/user.dart';

class ProfileTopSection extends StatelessWidget {
  final User user;
  final int posts;
  const ProfileTopSection({super.key, required this.user, this.posts = 0});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            kSizedBox,
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.green,
              child: Text(
                user.name.toString().characters.first,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            kSizedBox,
            Text(
              user.name.toString(),
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(user.username.toString(),
                style: const TextStyle(fontSize: 15)),
          ],
        ),
        _countWidget('Posts', posts),
        _countWidget('Followers', user.followers.length),
        _countWidget('Following', user.following.length),
      ],
    );
  }

  Widget _countWidget(String text, int count) => Column(
        children: [
          Text(
            count.toString(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            text.toString(),
            style: const TextStyle(fontSize: 15),
          ),
        ],
      );
}
