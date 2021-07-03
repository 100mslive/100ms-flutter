import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_controller.dart';

class MeetingPage extends StatefulWidget {
  final String roomId;

  const MeetingPage({Key? key, required this.roomId}) : super(key: key);

  @override
  _MeetingPageState createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  late MeetingController meetingController;
  @override
  void initState() {
    meetingController = MeetingController(roomId: widget.roomId);
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
            onPressed: () {},
            icon: Icon(Icons.sync),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.close),
          )
        ],
      ),
      body: Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}
