///Package imports
library;

import 'package:flutter/material.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';

///[HMSToast] is a widget that is used to render the toast
///[leading] is a widget that is used to render the leading widget
///[subtitle] is a widget that is used to render the subtitle widget
///[action] is a widget that is used to render the action widget
///[cancelToastButton] is a widget that is used to render the cancel toast button
///[toastColor] is the color of the toast
///[toastPosition] is the position of the toast from the bottom
class HMSToast extends StatefulWidget {
  final Widget? leading;
  final Widget? subtitle;
  final Widget? action;
  final Widget? cancelToastButton;
  final Color? toastColor;
  final double? toastPosition;
  const HMSToast(
      {super.key,
      this.leading,
      this.subtitle,
      this.action,
      this.cancelToastButton,
      this.toastPosition,
      this.toastColor});

  @override
  State<HMSToast> createState() => _HMSToastState();
}

class _HMSToastState extends State<HMSToast> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.toastPosition ?? 68),
      child: AlertDialog(
        backgroundColor: widget.toastColor,
        insetPadding: const EdgeInsets.all(0),
        alignment: Alignment.bottomCenter,
        contentPadding: const EdgeInsets.all(0),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: Container(
          decoration: BoxDecoration(
              color: widget.toastColor ?? HMSThemeColors.surfaceDim,
              borderRadius: BorderRadius.circular(8)),
          height: 52,
          width: MediaQuery.of(context).size.width - 10,
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
                            width: 6,
                          )
                        : Container(),
                    widget.cancelToastButton ?? Container()
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
