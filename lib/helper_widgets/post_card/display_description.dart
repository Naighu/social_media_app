import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:social_media/constants/constants.dart';
import 'package:social_media/screens/profile/profile_page.dart';

import 'view_mentioned_user.dart';

class DisplayDescription extends StatelessWidget {
  final String description;
  const DisplayDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    final splited = description.split(' ');
    return RichText(
        text: TextSpan(
            style: const TextStyle(color: Colors.black),
            children: List.generate(splited.length, (index) {
              //A mention
              if (splited[index].contains(RegExp(r'^@\w+$'))) {
                return TextSpan(
                    text: '${splited[index]} ',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewMentionedUser(
                                    username:
                                        splited[index].replaceFirst('@', ''))));
                      },
                    style: const TextStyle(color: kPrimaryColor));
              }
              return TextSpan(text: '${splited[index]} ');
            })));
  }
}
