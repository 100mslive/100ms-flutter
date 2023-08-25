import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';

class HMSToastButton extends StatelessWidget {
  final String buttonTitle;
  final Function action;
  final double height;
  final double width;
  final Color buttonColor;
  final Color textColor;
  const HMSToastButton(
      {super.key,
      required this.buttonTitle,
      required this.action,
      this.height = 36,
      this.width = 65,
      required this.buttonColor,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        action();
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: buttonColor, borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: HMSSubheadingText(
            text: buttonTitle,
            textColor: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
