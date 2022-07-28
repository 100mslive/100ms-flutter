// Package imports
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/enum/meeting_mode.dart';
import 'package:hmssdk_flutter_example/hls-streaming/util/hls_title_text.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';

class TrackChangeDialogOrganism extends StatefulWidget {
  final HMSTrackChangeRequest trackChangeRequest;
  final MeetingStore meetingStore;
  final bool isAudioModeOn;
  const TrackChangeDialogOrganism(
      {required this.trackChangeRequest,
      required this.meetingStore,
      this.isAudioModeOn = false})
      : super();

  @override
  _RoleChangeDialogOrganismState createState() =>
      _RoleChangeDialogOrganismState();
}

class _RoleChangeDialogOrganismState extends State<TrackChangeDialogOrganism> {
  @override
  Widget build(BuildContext context) {
    String message = "‘" +
        widget.trackChangeRequest.requestBy.name.toString() +
        "’ requested to " +
        ((widget.trackChangeRequest.mute) ? "mute" : "unmute") +
        " your ‘" +
        ((widget.trackChangeRequest.track.kind ==
                HMSTrackKind.kHMSTrackKindAudio)
            ? "Audio’"
            : "Video’") +
        ((widget.isAudioModeOn) ? " and switch to video view" : "");
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      actionsPadding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      backgroundColor: bottomSheetColor,
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: GoogleFonts.inter(
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                  shadowColor: MaterialStateProperty.all(surfaceColor),
                  backgroundColor: MaterialStateProperty.all(bottomSheetColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: popupButtonBorderColor),
                    borderRadius: BorderRadius.circular(8.0),
                  ))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12),
                child: HLSTitleText(text: 'Reject', textColor: defaultColor),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                  shadowColor: MaterialStateProperty.all(surfaceColor),
                  backgroundColor: MaterialStateProperty.all(errorColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: errorColor),
                    borderRadius: BorderRadius.circular(8.0),
                  ))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12),
                child: HLSTitleText(
                  text: 'Accept',
                  textColor: defaultColor,
                ),
              ),
              onPressed: () {
                if (widget.trackChangeRequest.track.kind ==
                        HMSTrackKind.kHMSTrackKindVideo &&
                    widget.isAudioModeOn) {
                  widget.meetingStore.setMode(MeetingMode.Video);
                }
                widget.meetingStore.changeTracks(widget.trackChangeRequest);
                Navigator.pop(context);
              },
            ),
          ],
        )
      ],
    );
  }
}
