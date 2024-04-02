///Package imports
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toast.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toast_button.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toasts_type.dart';

///[HMSRecordingErrorToast] renders the toast when recording fails to start
class HMSRecordingErrorToast extends StatelessWidget {
  final HMSException recordingError;
  final MeetingStore meetingStore;
  final Color? toastColor;
  final double? toastPosition;
  const HMSRecordingErrorToast(
      {super.key,
      required this.recordingError,
      required this.meetingStore,
      this.toastColor,
      this.toastPosition});

  @override
  Widget build(BuildContext context) {
    return HMSToast(
      toastColor: toastColor,
      toastPosition: toastPosition,
      leading: SvgPicture.asset(
        "packages/hms_room_kit/lib/src/assets/icons/recording_error.svg",
        height: 24,
        width: 24,
        colorFilter: ColorFilter.mode(
            HMSThemeColors.onSurfaceHighEmphasis, BlendMode.srcIn),
      ),
      subtitle: HMSSubheadingText(
        text: "Recording failed to start",
        textColor: HMSThemeColors.onSurfaceHighEmphasis,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
      action: HMSToastButton(
        buttonTitle: "Retry",
        action: () {
          meetingStore.startRtmpOrRecording(toRecord: true);
          meetingStore.removeToast(HMSToastsType.recordingErrorToast);
        },
        height: 36,
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
          meetingStore.removeToast(HMSToastsType.recordingErrorToast);
        },
      ),
    );
  }
}
