import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_media/constants/constants.dart';
import 'package:social_media/domain/core/dll/injectable.dart';
import 'package:social_media/domain/post/i_post_repo.dart';
import 'package:social_media/models/post.dart';
import 'package:social_media/models/user.dart';

import 'add_description.dart';
import 'add_image.dart';

class CreatePostPage extends StatefulWidget {
  final User user;
  const CreatePostPage({super.key, required this.user});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  String? description;
  String? imagePath;
  final ValueNotifier<bool> loadingNotifier = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
            onPressed: () => Navigator.pop(context), icon: Icon(Icons.close)),
        title: Text(
          'Create Post',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          ValueListenableBuilder(
              valueListenable: loadingNotifier,
              builder: (context, _, __) {
                if (loadingNotifier.value) {
                  return const CircularProgressIndicator();
                }
                return TextButton(
                    onPressed: _createPost,
                    child: Text(
                      'Post',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Theme.of(context).primaryColor),
                    ));
              })
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
              minWidth: MediaQuery.of(context).size.width),
          child: Column(children: [
            kSizedBox,
            Expanded(child: AddDecriptionWidget(
              onChanged: (value) {
                description = value;
              },
            )),
            Expanded(
                flex: 2,
                child: AddImageWidget(
                  onChoose: (p) {
                    imagePath = p;
                  },
                ))
          ]),
        ),
      ),
    );
  }

  String? _validate() {
    if (description == null || description!.isEmpty) {
      return 'Description should not be empty';
    }
    return null;
  }

  Future<void> _createPost() async {
    final msg = _validate();
    if (msg != null) {
      Fluttertoast.showToast(msg: msg);
      return;
    }

    loadingNotifier.value = true;
    String? base64Image;
    if (imagePath != null) {
      final imageFile = File(imagePath!);
      List<int> imageBytes = imageFile.readAsBytesSync();
      base64Image = base64Encode(imageBytes);
    }

    final result = await getIt<IPostRepo>().createPosts(
        userId: widget.user.id, description: description, image: base64Image);
    loadingNotifier.value = false;
    result.fold((l) {
      Fluttertoast.showToast(msg: l.message);
    }, (r) {
      Fluttertoast.showToast(msg: 'Post created');
      Navigator.pop<Post>(context, r);
    });
  }
}
