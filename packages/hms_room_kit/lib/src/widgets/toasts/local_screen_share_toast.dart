import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toast.dart';
import 'package:hms_room_kit/src/widgets/toasts/toast_button.dart';

class LocalScreenShareToast extends StatelessWidget {
  final MeetingStore meetingStore;
  const LocalScreenShareToast({super.key, required this.meetingStore});

  @override
  Widget build(BuildContext context) {
    return HMSToast(
      leading: SvgPicture.asset(
        "packages/hms_room_kit/lib/src/assets/icons/screen_share.svg",
        height: 24,
        width: 24,
        colorFilter: ColorFilter.mode(
            HMSThemeColors.onSurfaceHighEmphasis, BlendMode.srcIn),
      ),
      subtitle: HMSSubheadingText(
        text: "You are sharing your screen",
        textColor: HMSThemeColors.onSurfaceHighEmphasis,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
      action: ToastButton(
          buttonTitle: "Stop",
          action: () {
            meetingStore.stopScreenShare();
          }),
    );
  }
}
