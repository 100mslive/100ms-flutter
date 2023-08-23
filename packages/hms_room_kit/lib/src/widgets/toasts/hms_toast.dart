import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';

class HMSToast extends StatefulWidget {
  final Widget? leading;
  final Widget? subtitle;
  final Widget? action;
  final Widget? cancelToastButton;
  final Color? toastColor;
  const HMSToast(
      {super.key,
      this.leading,
      this.subtitle,
      this.action,
      this.cancelToastButton,
      this.toastColor});

  @override
  State<HMSToast> createState() => _HMSToastState();
}

class _HMSToastState extends State<HMSToast> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 75,
        left: 12,
        child: Container(
          decoration: BoxDecoration(
              color: widget.toastColor ?? HMSThemeColors.surfaceDefault,
              borderRadius: BorderRadius.circular(8)),
          height: 52,
          width: MediaQuery.of(context).size.width - 24,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    widget.leading ?? Container(),
                    widget.leading != null
                        ? const SizedBox(
                            width: 8,
                          )
                        : Container(),
                    widget.subtitle ?? Container()
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    widget.action ?? Container(),
                    widget.cancelToastButton != null
                        ? const SizedBox(
                            width: 16,
                          )
                        : Container(),
                    widget.cancelToastButton ?? Container()
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
