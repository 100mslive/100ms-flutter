
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';

class LeaveOrEndMeetingDialogOption extends StatefulWidget {

  final MeetingStore meetingStore;
  const LeaveOrEndMeetingDialogOption({required this.meetingStore});

  @override
  _LeaveOrEndMeetingDialogOptionState createState() => _LeaveOrEndMeetingDialogOptionState();
}

class _LeaveOrEndMeetingDialogOptionState extends State<LeaveOrEndMeetingDialogOption> {
  bool forceValue=false;



  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("leave or End"),
      content: Container(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 20.0),
              child: GestureDetector(
                onTap: () {
                  widget.meetingStore.leaveMeeting();
                  Navigator.of(context).pop();
                },
                child: Row(
                  children: [
                    Icon(Icons.call_end),
                    SizedBox(
                      width: 16,
                    ),
                    Text("leave")
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),

            GestureDetector(
              onTap: () {
                widget.meetingStore.endRoom(forceValue);
                Navigator.of(context).pop();
              },
              child: Row(
                children: [
                  Icon(Icons.cancel_schedule_send),
                  SizedBox(
                    width: 16,
                  ),
                  Text("end"),
                  SizedBox(
                    width: 16,
                  ),
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
                        SizedBox(
                          width: 16,
                        ),
                        Text('Lock Room')
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
