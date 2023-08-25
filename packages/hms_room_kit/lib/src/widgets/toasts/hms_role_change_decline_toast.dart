
import "dart:math" as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toast.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class HMSRoleChangeDeclineToast extends StatelessWidget {
  final HMSPeer peer;
  final MeetingStore meetingStore;
  const HMSRoleChangeDeclineToast(
      {super.key, required this.peer, required this.meetingStore});

  @override
  Widget build(BuildContext context) {
    return HMSToast(
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
              "${peer.name.substring(0,math.min(15,peer.name.length))} declined the request to join the stage",
          textColor: HMSThemeColors.onSurfaceHighEmphasis,
          fontWeight: FontWeight.w600,
          maxLines: 3,
          letterSpacing: 0.1,
        ),
      ),
      cancelToastButton: IconButton(
        icon: const Icon(
          Icons.close,
          color: Colors.white,
          size: 24,
        ),
        onPressed: () {
          meetingStore.toggleRequestDeclined(peer);
        },
      ),
    );
  }
}
