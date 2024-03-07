///Package imports
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';

///[HMSCircularAvatar] is a widget that is used to render the circular avatar
///It takes following parameters:
///[name] is the name of the peer
///[avatarRadius] is the radius of the avatar
///[avatarTitleFontSize] is the font size of the avatar title
///[avatarTitleTextColor] is the color of the avatar title
///[avatarTitleTextLineHeight] is the line height of the avatar title
///If the name is empty, we render the default user icon
class HMSCircularAvatar extends StatelessWidget {
  final String name;
  final double? avatarRadius;
  final double? avatarTitleFontSize;
  final Color? avatarTitleTextColor;
  final double avatarTitleTextLineHeight;
  const HMSCircularAvatar(
      {super.key,
      required this.name,
      this.avatarRadius = 34,
      this.avatarTitleFontSize = 34,
      this.avatarTitleTextColor,
      this.avatarTitleTextLineHeight = 32});

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
            : HMSTitleText(
                text: Utilities.getAvatarTitle(name),
                textColor: avatarTitleTextColor ??
                    HMSThemeColors.onSurfaceHighEmphasis,
                fontSize: avatarTitleFontSize,
                lineHeight: avatarTitleTextLineHeight,
              ));
  }
}
