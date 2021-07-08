import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/enum/meeting_flow.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_controller.dart';

class MeetingPage extends StatefulWidget {
  final String roomId;
  final MeetingFlow flow;
  final String user;

  const MeetingPage(
      {Key? key, required this.roomId, required this.flow, required this.user})
      : super(key: key);

  @override
  _MeetingPageState createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  late MeetingController meetingController;
  Stream? controller;

  @override
  void initState() {
    meetingController = MeetingController(
        roomId: widget.roomId, flow: widget.flow, user: widget.user);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roomId),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.volume_up),
          ),
          IconButton(
            onPressed: () async {
              controller = await meetingController.startMeeting();
              setState(() {});
            },
            icon: Icon(Icons.sync),
          ),
          IconButton(
            onPressed: () {
              meetingController.endMeeting();
            },
            icon: Icon(Icons.close),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text(widget.user),
            Text(widget.flow.toString()),
            Text(widget.roomId),
            CupertinoActivityIndicator(),
            controller != null
                ? StreamBuilder(
                    stream: controller,
                    builder: (context, data) {
                      return Text(data.toString());
                    })
                : Text("NO controller")
          ],
        ),
      ),
    );
  }
}
