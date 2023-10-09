import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/constants/constants.dart';
import 'package:social_media/utils/pick_media.dart';

class AddImageWidget extends StatefulWidget {
  final Function(String imagePath)? onChoose;
  const AddImageWidget({super.key, this.onChoose});

  @override
  State<AddImageWidget> createState() => _AddImageWidgetState();
}

class _AddImageWidgetState extends State<AddImageWidget> {
  //Choosen image
  String? image;
  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(fontSize: 16);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          image == null ? 'Would you like to add image?' : 'You added an image',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        kSizedBox,
        Expanded(
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(kBorderRadius)),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: image == null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            _pick(ImageSource.camera);
                          },
                          child: const Column(
                            children: [
                              Icon(
                                Icons.camera,
                                size: 30,
                              ),
                              Text(
                                'Camera',
                                style: style,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        InkWell(
                          onTap: () {
                            _pick(ImageSource.gallery);
                          },
                          child: const Column(
                            children: [
                              Icon(
                                Icons.photo,
                                size: 30,
                              ),
                              Text(
                                'Gallery',
                                style: style,
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  : Expanded(
                      child: _DisplayImage(
                        imagePath: image!,
                        onDelete: () {
                          setState(() {
                            image = null;
                          });
                        },
                      ),
                    ),
            ),
          ),
        )
      ],
    );
  }

  Future _pick(ImageSource source) async {
    final media = await PickMedia().pickImage(source: source);
    if (media == null) {
      return;
    }
    final size = await media.length();
    if (size >= 5000000) {
      Fluttertoast.showToast(msg: 'Choose image less than 5MB');
      return;
    }
    if (widget.onChoose != null) {
      widget.onChoose!(media.path);
    }
    log(media.path);

    setState(() {
      image = media.path;
    });
  }
}

class _DisplayImage extends StatelessWidget {
  final VoidCallback onDelete;
  final String imagePath;
  const _DisplayImage({required this.onDelete, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.file(
          File(imagePath),
        ),
        Positioned(
            right: 0,
            child: IconButton(
              onPressed: onDelete,
              icon: Icon(
                Icons.close,
                size: 25,
                color: Theme.of(context).colorScheme.error,
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(kBorderRadius)))),
            ))
      ],
    );
  }
}
