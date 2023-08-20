import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/common/app_color.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';

class HMSListenableButton extends StatelessWidget {
  final double width;
  final Color? shadowColor;
  final Function() onPressed;
  final Widget childWidget;
  final TextEditingController textController;
  final String errorMessage;

  const HMSListenableButton(
      {super.key,
      required this.width,
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
                        shadowColor ?? themeSurfaceColor),
                    backgroundColor: textController.text.isEmpty
                        ? MaterialStateProperty.all(
                            HMSThemeColors.primaryDisabled)
                        : MaterialStateProperty.all(
                            HMSThemeColors.primaryDefault),
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
