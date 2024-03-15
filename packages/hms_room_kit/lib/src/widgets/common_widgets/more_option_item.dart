///Package imports
library;

import 'package:flutter/material.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subtitle_text.dart';

///[MoreOptionItem] is a widget that is used to render the more option items
class MoreOptionItem extends StatelessWidget {
  final Function onTap;
  final Widget optionIcon;
  final String optionText;
  final bool isActive;
  final Color? optionTextColor;
  const MoreOptionItem(
      {super.key,
      required this.onTap,
      required this.optionIcon,
      required this.optionText,
      this.isActive = false,
      this.optionTextColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
            color: isActive
                ? HMSThemeColors.surfaceBright
                : HMSThemeColors.surfaceDim,
            borderRadius: BorderRadius.circular(4)),
        height: 60,
        width: 109,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            optionIcon,
            const SizedBox(height: 8),
            HMSSubtitleText(
              maxLines: 2,
              text: optionText,
              textAlign: TextAlign.center,
              textColor:
                  optionTextColor ?? HMSThemeColors.onSurfaceHighEmphasis,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}
