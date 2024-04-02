///Package imports
library;

import 'package:flutter/material.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';

///[HMSBackButton] is a button that is used to navigate back
class HMSBackButton extends StatelessWidget {
  final Function() onPressed;

  const HMSBackButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: HMSThemeColors.surfaceDefault,
      child: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          size: 16,
          color: HMSThemeColors.onSurfaceHighEmphasis,
        ),
        onPressed: () {
          onPressed();
        },
      ),
    );
  }
}
