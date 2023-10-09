import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickMedia {
  final int? maxSize;
  final List<String> allowedExtensions = ["jpg", "png", "jpeg", "bmp"];
  PickMedia({this.maxSize});
  Future<XFile?> pickImage(
      {ImageSource source = ImageSource.gallery, int imageQuality = 80}) async {
    final image = await ImagePicker().pickImage(
        source: source, imageQuality: imageQuality, requestFullMetadata: true);

    if (image == null) {
      return null;
    }
    try {
      await _validateImage(image);
      return image;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<XFile>> pickImages({int imageQuality = 80}) async {
    final picked =
        await ImagePicker().pickMultiImage(imageQuality: imageQuality);
    bool error = false;

    for (XFile image in picked) {
      try {
        await _validateImage(image);
      } catch (e) {
        debugPrint(e.toString());
        error = true;
        break;
      }
    }

    if (error) {
      return [];
    }

    return picked;
  }

  Future<void> _validateImage(XFile image) async {
    if (!(await _checkImageSize(image))) {
      throw Exception('Maximum image size is $maxSize');
    }
    if (!_checkImageExtension(image)) {
      throw Exception('Supported file formats are $allowedExtensions');
    }
  }

  Future<bool> _checkImageSize(XFile file) async {
    if (maxSize == null) {
      return true;
    }
    final size = await file.length();
    if (size > maxSize!) {
      return false;
    }
    return true;
  }

  bool _checkImageExtension(XFile image) {
    bool valid = false;
    for (String ext in allowedExtensions) {
      if (image.name.toLowerCase().endsWith(ext)) {
        valid = true;
        break;
      }
    }
    return valid;
  }

  static Future<void> chooseImagePickerMode(BuildContext context,
      {required void Function(ImageSource source) onSelected}) async {
    showModalBottomSheet(
        barrierColor: Colors.black26,
        elevation: 11.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            minWidth: MediaQuery.of(context).size.width,
            minHeight: 80,
            maxHeight: 150),
        context: context,
        builder: (context) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "chooseFrom",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          onSelected(ImageSource.camera);
                          Navigator.pop(context);
                        },
                        child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: [
                              const WidgetSpan(
                                  child: Icon(
                                Icons.camera,
                                size: 30,
                              )),
                              TextSpan(
                                  text: "\nCamera",
                                  style: Theme.of(context).textTheme.subtitle1),
                            ])),
                      ),
                      const SizedBox(
                        width: 20 * 1.5,
                      ),
                      InkWell(
                        onTap: () {
                          onSelected(ImageSource.gallery);
                          Navigator.pop(context);
                        },
                        child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: [
                              const WidgetSpan(
                                  child: Icon(
                                Icons.photo_library_outlined,
                                size: 30,
                              )),
                              TextSpan(
                                  text: "\nGallery",
                                  style: Theme.of(context).textTheme.subtitle1),
                            ])),
                      )
                    ],
                  )
                ],
              ),
            ));
  }
}
