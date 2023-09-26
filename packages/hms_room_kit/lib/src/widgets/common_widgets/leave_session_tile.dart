import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';

class LeaveSessionTile extends StatelessWidget {
  final EdgeInsets? tilePadding;
  final Widget? leading;
  final String? title;
  final String? subTitle;
  final Color? titleColor;
  final Color? subTitleColor;
  final Function? onTap;
  final Color? tileColor;

  const LeaveSessionTile(
      {super.key,
      this.leading,
      this.title,
      this.subTitle,
      this.titleColor,
      this.subTitleColor,
      this.onTap,
      this.tileColor,
      this.tilePadding});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        if (onTap != null) {onTap!()}
      },
      child: Container(
        height: 116,
        color: tileColor ?? HMSThemeColors.surfaceDim,
        child: Padding(
          padding: tilePadding ??
              const EdgeInsets.only(top: 24.0, left: 18, right: 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              leading ?? const SizedBox(),
              const SizedBox(
                width: 14,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HMSTitleText(
                    text: title ?? "Leave",
                    textColor:
                        titleColor ?? HMSThemeColors.onSurfaceHighEmphasis,
                    fontSize: 20,
                    letterSpacing: 0.15,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.78,
                    child: HMSSubheadingText(
                        text: subTitle ??
                            "Others will continue after you leave. You can join the session again.",
                        maxLines: 2,
                        textColor: subTitleColor ??
                            HMSThemeColors.onSurfaceMediumEmphasis),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
