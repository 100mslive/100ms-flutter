import 'package:flutter/material.dart';
import 'package:hmssdk_uikit/common/app_color.dart';

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

  const HMSEmbeddedButton(
      {super.key,
      required this.onTap,
      this.offColor,
      this.onColor,
      required this.isActive,
      required this.child,
      this.height = 48,
      this.width = 48,
      this.enabledBorderColor,
      this.disabledBorderColor});
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
                      color: enabledBorderColor ?? borderBright, width: 1)
                  : Border.all(
                      color: disabledBorderColor ?? secondaryDim, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              /**
               * The color of icon is set using the iconColor property
               * If the iconColor is not set, we use the default color which is onSurfaceHighEmphasis
               */
              color: isActive
                  ? (onColor ?? (Colors.black))
                  : (offColor ?? secondaryDim)),
          child: child),
    );
  }
}
