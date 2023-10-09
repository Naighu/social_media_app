import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppElevatedButton extends StatelessWidget {
  final String text;
  final double width, height;
  final String? icon;
  final Color? color;
  final bool loading;
  final Widget? child;
  final VoidCallback onPressed;
  const AppElevatedButton(
      {Key? key,
      this.icon,
      this.child,
      this.color,
      this.loading = false,
      required this.onPressed,
      this.text = "",
      this.height = 45,
      this.width = double.infinity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // ignore: prefer_const_constructors
      style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25))),
          ),
          alignment: Alignment.center,
          backgroundColor: color == null
              ? MaterialStateProperty.all(Theme.of(context).primaryColor)
              : MaterialStateProperty.all(color),
          minimumSize: MaterialStateProperty.all(Size(width, height))),
      onPressed: onPressed,
      child: child ??
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              if (icon != null)
                const SizedBox(
                  width: 10,
                ),
              if (icon != null)
                SvgPicture.asset(
                  icon!,
                  height: 24,
                  width: 24,
                )
            ],
          ),
    );
  }
}
