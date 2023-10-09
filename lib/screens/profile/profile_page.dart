import 'package:flutter/material.dart';
import 'package:social_media/constants/constants.dart';
import 'package:social_media/domain/auth/i_auth_repo.dart';
import 'package:social_media/domain/core/dll/injectable.dart';
import 'package:social_media/domain/post/i_post_repo.dart';
import 'package:social_media/helper_widgets/list_posts.dart';
import 'package:social_media/models/post.dart';
import 'package:social_media/models/user.dart';
import 'package:social_media/screens/auth/login_page.dart';
import 'package:social_media/helper_widgets/view_profile/top_section.dart';
import 'package:social_media/utils/app_utils.dart';

import '../../helper_widgets/view_profile/profile_display.dart';

class ProfilePage extends StatelessWidget {
  final User user;
  final bool showLogout;
  const ProfilePage({super.key, required this.user, this.showLogout = true});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              centerTitle: false,
              backgroundColor: kPrimaryColor,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              title: const Text(
                'Profile Page',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              actions: [
                if (showLogout)
                  TextButton(
                      onPressed: () {
                        AppUtils.logout();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                            (route) => false);
                      },
                      child: const Text(
                        'Log out',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ))
              ],
            ),
            body: ProfileDisplay(
              user: user,
            )));
  }
}
