import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/model/hms_peer.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_controller.dart';

class ParticipantOrganism extends StatefulWidget {
  final HMSPeer peer;
  final MeetingController meetingController;
  const ParticipantOrganism(
      {Key? key, required this.peer, required this.meetingController})
      : super(key: key);

  @override
  _ParticipantOrganismState createState() => _ParticipantOrganismState();
}

class _ParticipantOrganismState extends State<ParticipantOrganism> {
  bool isVideoOn = false, isAudioOn = false;

  @override
  void initState() {
    super.initState();
    checkButtons();
  }

  @override
  Widget build(BuildContext context) {
    HMSPeer peer = widget.peer;
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Row(
        children: [
          Expanded(
              child: Text(
            peer.name,
            style: TextStyle(fontSize: 20.0),
          )),
          SizedBox(
            width: 50.0,
          ),
          Expanded(
            child: (Text(
              peer.role!.name,
              style: TextStyle(fontSize: 15.0),
            )),
          ),
          SizedBox(
            width: 50.0,
          ),
          Expanded(
              child: Icon(isVideoOn ? Icons.videocam : Icons.videocam_off)),
          Expanded(child: Icon(isAudioOn ? Icons.mic : Icons.mic_off)),
        ],
      ),
    );
  }

  void checkButtons() async {
    this.isAudioOn = !(await widget.meetingController.isAudioMute(widget.peer));
    this.isVideoOn = !(await widget.meetingController.isVideoMute(widget.peer));
    setState(() {});
  }
}
