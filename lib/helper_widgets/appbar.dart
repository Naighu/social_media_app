import 'package:flutter/material.dart';
import 'package:social_media/constants/constants.dart';
import 'package:social_media/domain/core/dll/injectable.dart';
import 'package:social_media/models/user.dart';

import '../screens/profile/profile_page.dart';

AppBar customAppbar(BuildContext context) => AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: kAppbarBackground,
      centerTitle: false,
      title: const Text(
        'Social Media App',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: kDefaultPadding),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(
                            user: getIt<User>(),
                          )));
            },
            child: CircleAvatar(
              backgroundColor: Colors.green,
              child: Text(
                getIt<User>().name!.characters.first,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        )
      ],
    );
