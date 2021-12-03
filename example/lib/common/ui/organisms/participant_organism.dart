import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';

import 'change_role_options.dart';

class ParticipantOrganism extends StatefulWidget {
  final HMSPeer peer;
  final MeetingStore meetingStore;

  const ParticipantOrganism(
      {Key? key, required this.peer, required this.meetingStore})
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
            maxLines: 1,
                overflow: TextOverflow.ellipsis,
          )),
          SizedBox(
            width: 50.0,
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) => ChangeRoleOptionDialog(
                        peerName: peer.name,
                        getRoleFunction: widget.meetingStore.getRoles(),
                        changeRole: (role, forceChange) {
                          Navigator.pop(context);
                          widget.meetingStore.changeRole(
                              peerId: peer.peerId,
                              roleName: role.name,
                              forceChange: forceChange);
                        },
                      ));
            },
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Text(
                "${peer.role!.name}",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(

            width: 50.0,
          ),
          Expanded(
              child: Icon(isVideoOn ? Icons.videocam : Icons.videocam_off)),
          Expanded(child: Icon(isAudioOn ? Icons.mic : Icons.mic_off)),
           Divider(height: 15,)
        ],
      ),
    );
  }

  void checkButtons() async {
    this.isAudioOn =
        !(await widget.meetingStore.meetingController.isAudioMute(widget.peer));
    this.isVideoOn =
        !(await widget.meetingStore.meetingController.isVideoMute(widget.peer));
    setState(() {});
  }
}
