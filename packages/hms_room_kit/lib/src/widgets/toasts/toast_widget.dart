///Package imports
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/model/poll_store.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_bring_on_stage_toast.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_chat_pause_resume_toast.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_local_screen_share_toast.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_poll_start_toast.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_recording_error_toast.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_role_change_decline_toast.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toast_model.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toasts_type.dart';

///[ToastWidget] returns toast based on the toast type
class ToastWidget extends StatelessWidget {
  final HMSToastModel toast;
  final int index;
  final int toastsCount;
  final MeetingStore meetingStore;

  const ToastWidget({
    super.key,
    required this.toast,
    required this.index,
    required this.toastsCount,
    required this.meetingStore,
  });

  @override
  Widget build(BuildContext context) {
    switch (toast.hmsToastType) {
      case HMSToastsType.roleChangeToast:
        return HMSBringOnStageToast(
          toastColor: Utilities.getToastColor(index, toastsCount),
          peer: toast.toastData,
          meetingStore: meetingStore,
        );
      case HMSToastsType.recordingErrorToast:
        return HMSRecordingErrorToast(
          recordingError: toast.toastData,
          meetingStore: meetingStore,
        );
      case HMSToastsType.localScreenshareToast:
        return HMSLocalScreenShareToast(
          toastColor: Utilities.getToastColor(index, toastsCount),
          meetingStore: meetingStore,
        );
      case HMSToastsType.roleChangeDeclineToast:
        return HMSRoleChangeDeclineToast(
          peer: toast.toastData,
          toastColor: Utilities.getToastColor(index, toastsCount),
          meetingStore: meetingStore,
        );
      case HMSToastsType.chatPauseResumeToast:
        return HMSChatPauseResumeToast(
          isChatEnabled: toast.toastData["enabled"],
          userName: toast.toastData["updatedBy"],
          meetingStore: meetingStore,
        );
      case HMSToastsType.pollStartedToast:
        return ChangeNotifierProvider.value(
          value: toast.toastData! as HMSPollStore,
          child: Transform.scale(
            scale: Utilities.getToastScale(index, toastsCount),
            child: HMSPollStartToast(
              poll: toast.toastData.poll,
              meetingStore: meetingStore,
            ),
          ),
        );
      default:
        return const SizedBox();
    }
  }
}
