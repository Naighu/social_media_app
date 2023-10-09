import 'package:get/get_state_manager/get_state_manager.dart';

class TagsController extends GetxController {
  final tags = [
    '#trending',
    '#moview',
    '#games',
    '#cricket',
    '#fottball',
    '#player',
    '#kerala',
    '#beauty'
  ];

  late String _selectedTag;
  TagsController() {
    _selectedTag = tags[0];
  }

  String get selectedTag => _selectedTag;

  void updateTag(String tag) {
    _selectedTag = tag;
    update();
  }
}
