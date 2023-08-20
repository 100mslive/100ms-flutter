import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';

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
                      color: disabledBorderColor ?? HMSThemeColors.secondaryDim,
                      width: 1),
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              /**
               * The color of icon is set using the iconColor property
               * If the iconColor is not set, we use the default color which is onSurfaceHighEmphasis
               */
              color: isActive
                  ? (onColor ?? (HMSThemeColors.backgroundDefault))
                  : (offColor ?? HMSThemeColors.secondaryDim)),
          child: child),
    );
  }
}
