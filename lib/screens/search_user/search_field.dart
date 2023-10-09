import 'package:flutter/material.dart';
import 'package:social_media/constants/constants.dart';

class SearchFieldWidget extends StatelessWidget {
  final Function(String) onChanged;
  const SearchFieldWidget({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: const InputDecoration(
          hintText: 'Search username here ...',
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(kBorderRadius),
              borderSide: BorderSide(
                color: Colors.black,
              ))),
    );
  }
}
