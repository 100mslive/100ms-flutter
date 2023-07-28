import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/common/app_color.dart';

class HMSButton extends StatelessWidget {
  final double width;
  final Color? shadowColor;
  final Function() onPressed;
  final Widget childWidget;
  final Color? buttonBackgroundColor;
  const HMSButton(
      {super.key,
      required this.width,
      this.shadowColor,
      required this.onPressed,
      required this.childWidget,
      this.buttonBackgroundColor});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        child: ElevatedButton(
          style: ButtonStyle(
              shadowColor:
                  MaterialStateProperty.all(shadowColor ?? themeSurfaceColor),
              backgroundColor: MaterialStateProperty.all(
                  buttonBackgroundColor ?? hmsdefaultColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ))),
          onPressed: onPressed,
          child: childWidget,
        ));
  }
}
