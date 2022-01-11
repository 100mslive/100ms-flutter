import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/role_change_request_dialog.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/track_change_request_dialog.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:provider/provider.dart';

class UtilityComponents {
  static void showSnackBarWithString(event, context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(event)));
  }

  static Future<dynamic> onBackPressed(BuildContext context) {
    MeetingStore _meetingStore = context.read<MeetingStore>();
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Leave Room?'),
        actions: [
          TextButton(
              onPressed: () => {
                    _meetingStore.leaveMeeting(),
                    Navigator.popUntil(context, (route) => route.isFirst)
                  },
              child: Text('Yes',
                  style: TextStyle(fontSize: 24, color: Colors.red))),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }

  static void showRoleChangeDialog(event, context) async {
    event = event as HMSRoleChangeRequest;
    String answer = await showDialog(
        context: context,
        builder: (ctx) => RoleChangeDialogOrganism(roleChangeRequest: event));
    if (answer == "OK") {
      debugPrint("OK accepted");
      MeetingStore meetingStore =
          Provider.of<MeetingStore>(context, listen: false);
      meetingStore.acceptRoleChangeRequest();
      UtilityComponents.showSnackBarWithString(
          (event as HMSException).description, context);
    }
  }

  static showTrackChangeDialog(event, context) async {
    event = event as HMSTrackChangeRequest;
    String answer = await showDialog(
        context: context,
        builder: (ctx) => TrackChangeDialogOrganism(trackChangeRequest: event));
    print(answer + '----------------->');
    if (answer == "OK") {
      debugPrint("OK accepted");
      MeetingStore meetingStore =
          Provider.of<MeetingStore>(context, listen: false);
      meetingStore.changeTracks(event);
    }
  }

  static showonExceptionDialog(event, context) {
    event = event as HMSException;
    var message =
        "${event.message} ${event.id??""} ${event.code?.errorCode??""} ${event.description} ${event.action} ${event.params??"".toString()}";
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(message),
            actions: [
              ElevatedButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
            ],
          );
        });
  }
}
