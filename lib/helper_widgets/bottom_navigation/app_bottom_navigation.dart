import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:social_media/screens/mentions/list_mentions.dart';
import 'package:social_media/screens/search_user/search_user.dart';
import 'package:social_media/screens/tags/controller/tags_controller.dart';

import '../../constants/constants.dart';
import '../../screens/home/homepage.dart';
import '../../screens/tags/tags_page.dart';

class AppBottombar extends StatelessWidget {
  final int currentIndex;
  const AppBottombar({super.key, this.currentIndex = 0});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        iconSize: 28,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: kBottomNavigationBackground,
        // type: BottomNavigationBarType.fixed,
        // selectedItemColor: kGreen,
        currentIndex: currentIndex,
        onTap: (index) => _onTap(context, index),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "Mentions",
            icon: Icon(Icons.tag_sharp),
          ),
          BottomNavigationBarItem(
            label: "Search",
            icon: Icon(
              Icons.search,
            ),
          ),
        ]);
  }

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) {
      return;
    }
    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Homepage()));
        break;
      case 1:
        // Get.put(TagsController());
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ListMentionsPage()));
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SearchUserPage()));
        break;
    }
  }
}
