import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_room_kit/common/app_color.dart';
import 'package:hms_room_kit/common/utility_functions.dart';

class HMSCircularAvatar extends StatelessWidget {
  final String name;

  const HMSCircularAvatar({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        backgroundColor: Utilities.getBackgroundColour(name),
        radius: 40,
        child: name.isEmpty
            ? SvgPicture.asset(
                'packages/hms_room_kit/lib/assets/icons/user.svg',
                fit: BoxFit.contain,
                semanticsLabel: "fl_user_icon_label",
              )
            : Text(
                Utilities.getAvatarTitle(name),
                style: GoogleFonts.inter(
                  fontSize: 40,
                  color: onSurfaceHighEmphasis,
                ),
              ));
  }
}
