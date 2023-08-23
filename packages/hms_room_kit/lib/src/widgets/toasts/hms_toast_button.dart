import 'package:flutter/material.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';

class HMSToastButton extends StatelessWidget {
  final String buttonTitle;
  final Function action;
  final double height;
  final double width;
  const HMSToastButton(
      {super.key,
      required this.buttonTitle,
      required this.action,
      this.height = 36,
      this.width = 65});

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
            color: HMSThemeColors.alertErrorDefault,
            borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: HMSSubheadingText(
            text: buttonTitle,
            textColor: HMSThemeColors.alertErrorBrighter,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
