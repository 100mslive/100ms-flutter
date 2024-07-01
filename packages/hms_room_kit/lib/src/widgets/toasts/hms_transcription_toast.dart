library;

///Package imports
import 'package:flutter/material.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toast.dart';

///[HMSTranscriptionToast] is a widget that displays the transcription toast
class HMSTranscriptionToast extends StatelessWidget {
  final String message;
  final MeetingStore meetingStore;
  const HMSTranscriptionToast(
      {Key? key, required this.message, required this.meetingStore});

  @override
  Widget build(BuildContext context) {
    return HMSToast(
        leading: SizedBox(
          height: 18,
          width: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: HMSThemeColors.onSurfaceHighEmphasis,
          ),
        ),
        subtitle: HMSSubheadingText(
          text: message,
          textColor: HMSThemeColors.onSurfaceHighEmphasis,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          textOverflow: TextOverflow.ellipsis,
          maxLines: 2,
        ));
  }
}
