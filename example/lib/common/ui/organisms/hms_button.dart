import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';

class HMSButton extends StatelessWidget {
  final double width;
  final Color? shadowColor;
  final Function() onPressed;
  final Widget child;

  HMSButton(
      {required this.width,
      this.shadowColor,
      required this.onPressed,
      required this.child});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width * 0.5,
        child: ElevatedButton(
          style: ButtonStyle(
              shadowColor: MaterialStateProperty.all(
                  shadowColor == null ? surfaceColor : shadowColor),
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ))),
          onPressed: onPressed,
          child: Container(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: child
          ),
        ));
  }
}
