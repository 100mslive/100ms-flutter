///Dart imports
library;

import "dart:math" as math;

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toasts_type.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toast.dart';

///[HMSRoleChangeDeclineToast] is a toast that is shown when a peer declines the request to join the stage
///It takes the following parameters:
///[peer] is the peer that declined the request
///[meetingStore] is the meetingStore of the meeting
///[toastColor] is the color of the toast
///[toastPosition] is the position of the toast from the bottom
class HMSRoleChangeDeclineToast extends StatelessWidget {
  final HMSPeer peer;
  final MeetingStore meetingStore;
  final Color? toastColor;
  final double? toastPosition;

  const HMSRoleChangeDeclineToast(
      {super.key,
      required this.peer,
      required this.meetingStore,
      this.toastColor,
      this.toastPosition});

  @override
  Widget build(BuildContext context) {
    return HMSToast(
      toastColor: toastColor,
      toastPosition: toastPosition,
      leading: SvgPicture.asset(
        "packages/hms_room_kit/lib/src/assets/icons/role_change_decline.svg",
        height: 17,
        width: 15,
        colorFilter: ColorFilter.mode(
            HMSThemeColors.onSurfaceHighEmphasis, BlendMode.srcIn),
      ),
      subtitle: SizedBox(
        width: MediaQuery.of(context).size.width * 0.65,
        child: HMSSubheadingText(
          text:
              "${peer.name.substring(0, math.min(15, peer.name.length))} declined the request to join the stage",
          textColor: HMSThemeColors.onSurfaceHighEmphasis,
          fontWeight: FontWeight.w600,
          maxLines: 3,
          letterSpacing: 0.1,
        ),
      ),
      cancelToastButton: IconButton(
        icon: Icon(
          Icons.close,
          color: HMSThemeColors.onSurfaceHighEmphasis,
          size: 24,
        ),
        onPressed: () {
          meetingStore.removeToast(HMSToastsType.roleChangeDeclineToast,
              data: peer);
        },
      ),
    );
  }
}
