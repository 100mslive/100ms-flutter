///Dart imports
library;

import "dart:math" as math;

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toasts_type.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toast.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toast_button.dart';

///[HMSBringOnStageToast] renders the toast when a user requests to be on stage
///It takes the following parameters:
///[peer] is the peer that requested to be on stage
///[meetingStore] is the meetingStore of the meeting
///[toastColor] is the color of the toast
///[toastPosition] is the position of the toast from the bottom
class HMSBringOnStageToast extends StatelessWidget {
  final HMSPeer peer;
  final MeetingStore meetingStore;
  final Color? toastColor;
  final double? toastPosition;

  const HMSBringOnStageToast(
      {super.key,
      required this.peer,
      required this.meetingStore,
      this.toastColor,
      this.toastPosition});

  String? _getButtonText() {
    if (HMSRoomLayout.peerType == PeerRoleType.conferencing) {
      if (HMSRoomLayout.roleLayoutData?.screens?.conferencing?.defaultConf
              ?.elements?.onStageExp?.offStageRoles
              ?.contains(peer.role.name) ??
          false) {
        return HMSRoomLayout.roleLayoutData?.screens?.conferencing?.defaultConf
            ?.elements?.onStageExp?.bringToStageLabel;
      } else {
        return HMSRoomLayout.roleLayoutData?.screens?.conferencing
            ?.hlsLiveStreaming?.elements?.onStageExp?.bringToStageLabel;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return HMSToast(
      toastColor: toastColor,
      toastPosition: toastPosition,
      leading: SvgPicture.asset(
        "packages/hms_room_kit/lib/src/assets/icons/hand_outline.svg",
        height: 24,
        width: 24,
        colorFilter: ColorFilter.mode(
            HMSThemeColors.onSurfaceHighEmphasis, BlendMode.srcIn),
      ),
      subtitle: SizedBox(
        width: MediaQuery.of(context).size.width * 0.32,
        child: HMSSubheadingText(
          text:
              "${peer.name.substring(0, math.min(15, peer.name.length))} raised hand",
          textColor: HMSThemeColors.onSurfaceHighEmphasis,
          fontWeight: FontWeight.w600,
          maxLines: 3,
          letterSpacing: 0.1,
        ),
      ),
      action: HMSToastButton(
        buttonTitle: _getButtonText() ?? "",
        action: () {
          HMSRole? onStageRole = meetingStore.getOnStageRole();
          if (onStageRole != null) {
            meetingStore.changeRoleOfPeer(peer: peer, roleName: onStageRole);
            meetingStore.removeToast(HMSToastsType.roleChangeToast, data: peer);
          }
        },
        height: 36,
        width: 128,
        buttonColor: HMSThemeColors.secondaryDefault,
        textColor: HMSThemeColors.onSecondaryHighEmphasis,
      ),
      cancelToastButton: IconButton(
        icon: Icon(
          Icons.close,
          color: HMSThemeColors.onSurfaceHighEmphasis,
          size: 24,
        ),
        onPressed: () {
          meetingStore.removeToast(HMSToastsType.roleChangeToast, data: peer);
        },
      ),
    );
  }
}
