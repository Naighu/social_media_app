import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:social_media/constants/constants.dart';
import 'package:social_media/screens/tags/controller/tags_controller.dart';

class ListTags extends StatelessWidget {
  const ListTags({super.key});

  @override
  Widget build(BuildContext context) {
    final TagsController tagController = Get.find<TagsController>();
    return ListView.builder(
      padding: const EdgeInsets.only(left: 10),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => GetBuilder<TagsController>(
          builder: (controller) => _ListTagCard(
                tag: controller.tags[index],
                isSelected: controller.selectedTag == controller.tags[index],
                onTap: () {
                  controller.updateTag(controller.tags[index]);
                },
              )),
      itemCount: tagController.tags.length,
    );
  }
}

class _ListTagCard extends StatelessWidget {
  final String tag;
  final bool isSelected;
  final VoidCallback onTap;
  const _ListTagCard(
      {required this.tag, required this.onTap, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(kBorderRadius),
            color: isSelected
                ? Color.fromARGB(255, 9, 99, 245)
                : Color.fromARGB(255, 237, 237, 237)),
        child: Text(
          tag,
          style: TextStyle(
              fontSize: 16, color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
