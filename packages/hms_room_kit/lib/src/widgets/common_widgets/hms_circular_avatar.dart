import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_room_kit/src/common/utility_functions.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';

class HMSCircularAvatar extends StatelessWidget {
  final String name;
  final double? avatarRadius;
  final double? avatarTitleFontSize;
  final Color? avatarTitleTextColor;
  const HMSCircularAvatar(
      {super.key,
      required this.name,
      this.avatarRadius = 40,
      this.avatarTitleFontSize = 40,
      this.avatarTitleTextColor});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        backgroundColor: Utilities.getBackgroundColour(name),
        radius: avatarRadius,
        child: name.isEmpty
            ? SvgPicture.asset(
                'packages/hms_room_kit/lib/src/assets/icons/user.svg',
                fit: BoxFit.contain,
                semanticsLabel: "fl_user_icon_label",
              )
            : Text(
                Utilities.getAvatarTitle(name),
                style: GoogleFonts.inter(
                  fontSize: avatarTitleFontSize,
                  color: avatarTitleTextColor ??
                      HMSThemeColors.onSurfaceHighEmphasis,
                ),
              ));
  }
}
