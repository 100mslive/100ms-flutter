import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toast.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toast_button.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class HMSBringOnStageToast extends StatelessWidget {
  final HMSPeer peer;
  final MeetingStore meetingStore;
  const HMSBringOnStageToast(
      {super.key, required this.peer, required this.meetingStore});

  @override
  Widget build(BuildContext context) {
    return HMSToast(
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
          text: "${peer.name.substring(0, 15)} raised hand",
          textColor: HMSThemeColors.onSurfaceHighEmphasis,
          fontWeight: FontWeight.w600,
          maxLines: 3,
          letterSpacing: 0.1,
        ),
      ),
      action: HMSToastButton(
        buttonTitle: "Bring on Stage",
        action: () {
          meetingStore.changeRoleOfPeer(
              peer: peer, roleName: meetingStore.getOnStageRole());
          meetingStore.toggleToastForRoleChange(peer: peer);
        },
        height: 36,
        width: 135,
        buttonColor: HMSThemeColors.secondaryDefault,
        textColor: HMSThemeColors.onSecondaryHighEmphasis,
      ),
      cancelToastButton: IconButton(
        icon: const Icon(
          Icons.close,
          color: Colors.white,
          size: 24,
        ),
        onPressed: () {
          meetingStore.toggleToastForRoleChange(peer: peer);
        },
      ),
    );
  }
}
