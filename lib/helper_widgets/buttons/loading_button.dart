import 'package:flutter/material.dart';
import 'package:social_media/constants/constants.dart';
import 'package:social_media/helper_widgets/buttons/elevated_button.dart';

class LoadingButton extends StatelessWidget {
  final bool loading;
  final double width, height;
  final String text;
  final VoidCallback onPressed;
  final Color color;
  const LoadingButton(
      {Key? key,
      this.color = kPrimaryColor,
      this.text = "",
      required this.loading,
      this.height = 55,
      this.width = double.infinity,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final w = width == double.infinity
        ? MediaQuery.of(context).size.width - kDefaultPadding
        : width;
    return AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        width: loading ? 80 : w,
        child: AppElevatedButton(
            onPressed: () {
              if (!loading) {
                onPressed();
              }
            },
            text: text,
            color: color,
            height: height,
            width: loading ? 80 : w,
            child: loading
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : null));
  }
}
