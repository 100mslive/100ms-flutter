///Package imports
library;

import 'package:flutter/material.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';

///[HMSLoader] returns a loader with the default theme
///The height of the loader is the height of the screen
///The default color of the loader is [HMSThemeColors.primaryDefault]
///The default strokeWidth(thickness) of the loader is 2
class HMSLoader extends StatelessWidget {
  final double? height;
  final double? strokeWidth;
  final Color? loaderColor;
  const HMSLoader({super.key, this.height, this.loaderColor, this.strokeWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HMSThemeColors.backgroundDefault,
      height: height ?? (MediaQuery.of(context).size.height),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth ?? 2,
          color: loaderColor ?? HMSThemeColors.primaryDefault,
        ),
      ),
    );
  }
}
