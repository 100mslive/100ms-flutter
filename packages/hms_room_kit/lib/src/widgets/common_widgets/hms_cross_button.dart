///Package imports
library;

import 'package:flutter/material.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';

///This renders the cross button
class HMSCrossButton extends StatelessWidget {
  final Function? onPressed;
  final Color? iconColor;
  const HMSCrossButton({super.key, this.onPressed, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.close,
        color: iconColor ?? HMSThemeColors.onSurfaceHighEmphasis,
        size: 24,
      ),
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        }
        Navigator.pop(context);
      },
    );
  }
}
