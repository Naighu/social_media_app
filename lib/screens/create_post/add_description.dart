import 'package:flutter/material.dart';
import 'package:social_media/constants/constants.dart';

class AddDecriptionWidget extends StatelessWidget {
  final Function(String) onChanged;
  const AddDecriptionWidget({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'You can add mentions by type ing @ followed the username',
          style: TextStyle(
              fontSize: 16, color: kPrimaryColor, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Card(
            key: key,
            color: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(kBorderRadius)),
            child: TextField(
              onChanged: onChanged,
              expands: true,
              maxLines: null,
              minLines: null,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  border: InputBorder.none,
                  hintText: 'Description'),
            ),
          ),
        ),
      ],
    );
  }
}
