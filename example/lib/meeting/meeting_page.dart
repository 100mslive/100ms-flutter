import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hmssdk_flutter_example/enum/meeting_flow.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_controller.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';

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
  late MeetingStore _meetingStore;

  @override
  void initState() {
    _meetingStore = MeetingStore();
    MeetingController meetingController = MeetingController(
        roomId: widget.roomId, flow: widget.flow, user: widget.user);
    _meetingStore.meetingController = meetingController;
    super.initState();
    initMeeting();
  }

  void initMeeting() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roomId),
        actions: [
          IconButton(
            onPressed: () {
              _meetingStore.toggleSpeaker();
            },
            icon: Icon(_meetingStore.isSpeakerOn
                ? Icons.volume_up
                : Icons.volume_down),
          ),
          IconButton(
            onPressed: () async {
              //TODO:: switch camera
            },
            icon: Icon(Icons.switch_camera),
          ),
          IconButton(
            onPressed: () {
              // meetingController.endMeeting();
            },
            icon: Icon(CupertinoIcons.settings),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text(widget.user),
            Text(widget.flow.toString()),
            Text(widget.roomId),
            Observer(builder: (_) {
              if (_meetingStore.isMeetingStarted) {
                return StreamBuilder(
                    stream: _meetingStore.controller,
                    builder: (context, data) {
                      return Text(data.toString());
                    });
              } else {
                return CupertinoActivityIndicator();
              }
            })
          ],
        ),
      ),
      bottomNavigationBar: Observer(
        builder: (_) {
          if (_meetingStore.isMeetingStarted) {
            return BottomNavigationBar(
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.videocam)),
                BottomNavigationBarItem(icon: Icon(Icons.mic)),
                BottomNavigationBarItem(icon: Icon(Icons.chat_bubble)),
                BottomNavigationBarItem(icon: Icon(Icons.call_end)),
              ],
              onTap: (index) {
                if (index == 3) {
                  _meetingStore.meetingController.leaveMeeting();
                }
              },
            );
          } else {
            return Text('Please wait while we connect you!');
          }
        },
      ),
    );
  }
}
