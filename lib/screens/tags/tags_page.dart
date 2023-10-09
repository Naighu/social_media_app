import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:social_media/helper_widgets/appbar.dart';
import 'package:social_media/helper_widgets/bottom_navigation/app_bottom_navigation.dart';
import 'package:social_media/screens/tags/controller/tags_controller.dart';

import 'list_tags.dart';

class TagsPage extends StatelessWidget {
  const TagsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.delete<TagsController>();
        return Future.value(true);
      },
      child: SafeArea(
          child: Scaffold(
        appBar: customAppbar(context),
        bottomNavigationBar: const AppBottombar(
          currentIndex: 1,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            SizedBox(height: 50, child: ListTags()),
            Expanded(child: GetBuilder<TagsController>(builder: (controller) {
              return Text(controller.selectedTag);
            }))
          ],
        ),
      )),
    );
  }
}
