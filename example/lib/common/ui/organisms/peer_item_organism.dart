// Package imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/meeting/peerTrackNode.dart';

class PeerItemOrganism extends StatefulWidget {
  final PeerTracKNode peerTracKNode;
  final bool isVideoMuted;
  final double height;
  final double width;
  final bool isLocal;
  final bool setMirror;
  final Map<String, String> observableMap;

  PeerItemOrganism(
      {Key? key,
      required this.peerTracKNode,
      this.isVideoMuted = true,
      this.height = 200.0,
      this.width = 200.0,
      this.isLocal = false,
      this.setMirror = false,
      required this.observableMap})
      : super(key: key);

  @override
  _PeerItemOrganismState createState() => _PeerItemOrganismState();
}

class _PeerItemOrganismState extends State<PeerItemOrganism> {
  GlobalKey key = GlobalKey();

  String name = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MeetingStore meetingStore = context.watch<MeetingStore>();
    return Container(
      key: key,
      padding: EdgeInsets.all(2),
      margin: EdgeInsets.all(2),
      height: widget.height + 20,
      width: widget.width - 5.0,
      decoration: BoxDecoration(
          border: Border.all(
              color: widget.peerTracKNode.peerId ==
                      meetingStore.highestSpeaker.peerId
                  ? Colors.blue
                  : Colors.grey,
              width: widget.peerTracKNode.peerId ==
                      meetingStore.highestSpeaker.peerId
                  ? 4.0
                  : 1.0),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if ((widget.isVideoMuted || widget.peerTracKNode.track == null)) {
                List<String>? parts = widget.peerTracKNode.name.split(" ");

                if (parts.length == 1) {
                  parts[0] += " ";
                  name = parts[0][0] + parts[0][1];
                } else if (parts.length >= 2) {
                  name = parts[0][0];
                  if (parts[1] == "" || parts[1] == " ") {
                    name += parts[0][1];
                  } else {
                    name += parts[1][0];
                  }
                }
                return Container(
                  height: widget.height + 100,
                  width: widget.width - 5,
                  child: Center(
                      child: CircleAvatar(
                          child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ))),
                );
              }
              return Container(
                height: widget.height + 100,
                width: widget.width - 5,
                padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 15.0),
                child: HMSVideoView(
                  track: widget.peerTracKNode.track!,
                  setMirror: widget.setMirror,
                  matchParent: false,
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
                "${widget.peerTracKNode.name} ${widget.peerTracKNode.track?.peer?.isLocal ?? false ? "(You)" : ""}"),
          ),
          //Raise Hand on Tile is turned off
          // if (widget.peerTracKNode.isRaiseHand)
          //   Positioned(
          //     child: Padding(
          //       padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          //       child: Image.asset(
          //         'assets/icons/raise_hand.png',
          //         color: Colors.amber.shade300,
          //       ),
          //     ),
          //     top: 5.0,
          //     left: 5.0,
          //   )
        ],
      ),
    );
  }
}
