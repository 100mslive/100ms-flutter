import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/role_change_request_dialog.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/track_change_request_dialog.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class UtilityComponents {
  static void showSnackBarWithString(event, context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(event)));
  }

  static Future<dynamic> onBackPressed(BuildContext context) {
    MeetingStore _meetingStore = context.read<MeetingStore>();
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Leave the Meeting?'),
        actions: [
          TextButton(
              onPressed: () => {
                _meetingStore.meetingController.leaveMeeting(),

                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (ctx) => HomePage(),
                //   ),
                // ),
                Navigator.popUntil(context, (route) => route.isFirst)
              },
              child: Text('Yes', style: TextStyle(height: 1, fontSize: 24))),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(
                  height: 1, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  static void showRoleChangeDialog(event,context) async {
    event = event as HMSRoleChangeRequest;
    String answer = await showDialog(
        context: context,
        builder: (ctx) => RoleChangeDialogOrganism(roleChangeRequest: event));
    if (answer == "OK") {
      debugPrint("OK accepted");
      context.read<MeetingStore>().meetingController.acceptRoleChangeRequest();
      UtilityComponents.showSnackBarWithString(
          (event as HMSError).description, context);
    }
  }

  static showTrackChangeDialog(event,context) async {
    event = event as HMSTrackChangeRequest;
    String answer = await showDialog(
        context: context,
        builder: (ctx) => TrackChangeDialogOrganism(trackChangeRequest: event));
    if (answer == "OK") {
      debugPrint("OK accepted");
      context.read<MeetingStore>().changeTracks();
    }
  }
}
