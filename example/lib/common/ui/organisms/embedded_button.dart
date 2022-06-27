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
  EmbeddedButton(
      {required this.onTap,
      required this.offColor,
      required this.onColor,
      required this.isActive,
      required this.child,
      this.height = 50,
      this.width = 50});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              border: isActive?Border.all(color: borderColor,width: 1):Border.all(color: defaultColor,width: 0),
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: isActive ? onColor : offColor),
          child: child),
    );
  }
}
