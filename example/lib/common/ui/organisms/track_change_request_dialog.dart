// Package imports
import 'package:flutter/material.dart';

// Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class TrackChangeDialogOrganism extends StatefulWidget {
  final HMSTrackChangeRequest trackChangeRequest;

  const TrackChangeDialogOrganism({required this.trackChangeRequest}) : super();

  @override
  _RoleChangeDialogOrganismState createState() =>
      _RoleChangeDialogOrganismState();
}

class _RoleChangeDialogOrganismState extends State<TrackChangeDialogOrganism> {
  @override
  Widget build(BuildContext context) {
    String message = widget.trackChangeRequest.requestBy.name.toString() +
        " requested to " +
        ((widget.trackChangeRequest.mute) ? "mute" : "unmute") +
        " your " +
        ((widget.trackChangeRequest.track.kind ==
                HMSTrackKind.kHMSTrackKindAudio)
            ? "audio"
            : "video");
    return AlertDialog(
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context, '');
          },
        ),
        ElevatedButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.pop(context, 'OK');
          },
        ),
      ],
    );
  }
}
