///Package imports
library;

import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';

///[HMSEmbeddedButton] is a button that is used to render the buttons with embedded style
///The button takes following parameters:
///[onTap] - The function that is called when the button is pressed
///[offColor] - The color of the button when it's not active, the default color is [HMSThemeColors.surfaceBrighter]
///[onColor] - The color of the button when it's active, the default color is [HMSThemeColors.backgroundDefault]
///[isActive] - The property that determines whether the button is active or not
///[child] - The child widget of the button
///[height] - The height of the button, the default height is 40
///[width] - The width of the button, the default width is 40
///[enabledBorderColor] - The border color of the button when it's active, the default color is [HMSThemeColors.borderBright]
///[disabledBorderColor] - The border color of the button when it's not active, the default color is [HMSThemeColors.surfaceBrighter]
///[borderRadius] - The border radius of the button, the default value is 8
class HMSEmbeddedButton extends StatelessWidget {
  final Function() onTap;
  final Color? offColor;
  final Color? onColor;
  final bool isActive;
  final Widget child;
  final double? height;
  final double? width;
  final Color? enabledBorderColor;
  final Color? disabledBorderColor;
  final double borderRadius;

  const HMSEmbeddedButton(
      {super.key,
      required this.onTap,
      this.offColor,
      this.onColor,
      required this.isActive,
      required this.child,
      this.height = 40,
      this.width = 40,
      this.enabledBorderColor,
      this.disabledBorderColor,
      this.borderRadius = 8});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              /**
               * Here we set the border color based on whether the button is active or not
               * If the button is active, we use the enabledBorderColor if it's not null
               * If it's null, we use the default color which is borderBright
               * 
               * Similarly if the button is not active, we use the disabledBorderColor if it's not null
               */
              border: isActive
                  ? Border.all(
                      color: enabledBorderColor ?? HMSThemeColors.borderBright,
                      width: 1)
                  : Border.all(
                      color:
                          disabledBorderColor ?? HMSThemeColors.surfaceBrighter,
                      width: 1),
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              /**
               * The color of icon is set using the iconColor property
               * If the iconColor is not set, we use the default color which is onSurfaceHighEmphasis
               */
              color: isActive
                  ? (onColor ?? (HMSThemeColors.backgroundDefault))
                  : (offColor ?? HMSThemeColors.surfaceBrighter)),
          child: child),
    );
  }
}
