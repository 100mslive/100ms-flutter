import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/common/util/utility_components.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';

class LeaveOrEndMeetingDialogOption extends StatefulWidget {
  final MeetingStore meetingStore;

  const LeaveOrEndMeetingDialogOption({required this.meetingStore});

  @override
  _LeaveOrEndMeetingDialogOptionState createState() =>
      _LeaveOrEndMeetingDialogOptionState();
}

class _LeaveOrEndMeetingDialogOptionState
    extends State<LeaveOrEndMeetingDialogOption> {
  bool forceValue = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(5.0),
      title: Text("👋 Leave Meeting",
          style:
              TextStyle(height: 1, fontSize: 18, fontWeight: FontWeight.bold)),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 16,
            ),
            Container(
              height: 55,
              padding: EdgeInsets.only(bottom: 16.0),
              child: GestureDetector(
                onTap: () {
                  widget.meetingStore.dialogisOn=false;
                  widget.meetingStore.leaveMeeting();
                  Navigator.of(context).pop('Leave');
                },
                child: Row(
                  children: [
                    Icon(Icons.call_end, size: 32),
                    SizedBox(width: 8),
                    Text('Leave', style: TextStyle(height: 1, fontSize: 18))
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            GestureDetector(
              onTap: () async {
                widget.meetingStore.dialogisOn=false;
                bool ended = await widget.meetingStore.endRoom(forceValue);
                if (ended)
                  Navigator.of(context).pop('End');
                else
                  UtilityComponents.showSnackBarWithString(
                      "No permission", context);
              },
              child: Row(
                children: [
                  Icon(Icons.cancel_schedule_send, size: 32),
                  SizedBox(width: 8),
                  Text('End Meeting',
                      style: TextStyle(height: 1, fontSize: 18)),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      forceValue = !forceValue;
                      setState(() {});
                    },
                    child: Row(
                      children: [
                        Icon(forceValue
                            ? Icons.check_box
                            : Icons.check_box_outline_blank),
                        SizedBox(width: 4),
                        Text('Lock Room',
                            style: TextStyle(height: 1, fontSize: 18))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
