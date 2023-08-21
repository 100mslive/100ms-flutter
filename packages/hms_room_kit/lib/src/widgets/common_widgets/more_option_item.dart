import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subtitle_text.dart';

class MoreOptionItem extends StatelessWidget {
  final Function onTap;
  final Widget optionIcon;
  final String optionText;
  const MoreOptionItem(
      {super.key,
      required this.onTap,
      required this.optionIcon,
      required this.optionText});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
            color: HMSThemeColors.surfaceDim,
            borderRadius: BorderRadius.circular(4)),
        height: 60,
        width: 109,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            optionIcon,
            const SizedBox(height: 8),
            HMSSubtitleText(
              text: optionText,
              textColor: HMSThemeColors.onSurfaceHighEmphasis,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}
