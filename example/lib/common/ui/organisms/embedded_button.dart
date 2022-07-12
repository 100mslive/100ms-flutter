import 'package:flutter/cupertino.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';

class EmbeddedButton extends StatelessWidget {
  final Function() onTap;
  final Color offColor;
  final Color onColor;
  final bool isActive;
  final Widget child;
  final double? height;
  final double? width;
  final Color? enabledBorderColor;
  final Color? disabledBorderColor;

  EmbeddedButton(
      {required this.onTap,
      required this.offColor,
      required this.onColor,
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
              border: isActive
                  ? Border.all(
                      color: (enabledBorderColor == null)
                          ? borderColor
                          : enabledBorderColor!,
                      width: 1)
                  : Border.all(
                      color: (disabledBorderColor == null)
                          ? defaultColor
                          : disabledBorderColor!,
                      width: 1),
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: isActive ? onColor : offColor),
          child: child),
    );
  }
}
