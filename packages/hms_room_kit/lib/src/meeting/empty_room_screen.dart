library;

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/hms_room_kit.dart';

///[EmptyRoomScreen] is a widget that is used to render the empty room screen
///This screen is shown when there is only single publisher
class EmptyRoomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: HMSThemeColors.surfaceDefault,
          radius: 40,
          child: SvgPicture.asset(
            "packages/hms_room_kit/lib/src/assets/icons/add_peer.svg",
            height: 37,
            width: 37,
            colorFilter: ColorFilter.mode(
                HMSThemeColors.onSurfaceHighEmphasis, BlendMode.srcIn),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        HMSTitleText(
          text: "You’re the first to join",
          textColor: HMSThemeColors.onSurfaceHighEmphasis,
          fontSize: 24,
          lineHeight: 32,
        ),
        const SizedBox(
          height: 8,
        ),
        HMSTitleText(
          text: "Sit back and relax till others join",
          textColor: HMSThemeColors.onSurfaceMediumEmphasis,
          fontWeight: FontWeight.w400,
          maxLines: 3,
        )
      ],
    );
  }
}
