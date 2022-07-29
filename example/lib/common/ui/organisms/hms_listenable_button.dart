import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';

class HMSListenableButton extends StatelessWidget {
  final double width;
  final Color? shadowColor;
  final Function() onPressed;
  final Widget childWidget;
  final TextEditingController textController;
  final String errorMessage;

  HMSListenableButton(
      {required this.width,
      this.shadowColor,
      required this.onPressed,
      required this.childWidget,
      required this.textController,
      required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ValueListenableBuilder<TextEditingValue>(
          valueListenable: textController,
          builder: (context, value, child) {
            return ElevatedButton(
                style: ButtonStyle(
                    shadowColor: MaterialStateProperty.all(
                        shadowColor == null ? surfaceColor : shadowColor),
                    backgroundColor: textController.text.isEmpty
                        ? MaterialStateProperty.all(surfaceColor)
                        : MaterialStateProperty.all(hmsdefaultColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ))),
                onPressed: onPressed,
                child: childWidget);
          }),
    );
  }
}
