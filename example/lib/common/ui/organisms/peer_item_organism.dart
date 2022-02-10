// Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

// SDK imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

// Package imports
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node_store.dart';

class PeerItemOrganism extends StatefulWidget {
  final double height;
  final double width;
  final bool isLocal;
  final bool setMirror;
  final PeerTrackNodeStore peerTrackNodeStore;

  PeerItemOrganism(
      {Key? key,
      //required this.peerTracKNode,
      this.height = 200.0,
      this.width = 200.0,
      this.isLocal = false,
      this.setMirror = false,
      required this.peerTrackNodeStore})
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
    print("PeerItemOrganism ${widget.peerTrackNodeStore.track.toString()}");

    return Container(
      color: Colors.transparent,
      key: key,
      padding: EdgeInsets.all(2),
      margin: EdgeInsets.all(2),
      height: widget.height + 110,
      width: widget.width - 5.0,
      child: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if ((widget.peerTrackNodeStore.track == null) ||
                  !(widget.peerTrackNodeStore.isVideoOn ?? true)) {
                List<String>? parts =
                    widget.peerTrackNodeStore.peer.name.split(" ");
                if (parts.length == 1) {
                  name = parts[0][0];
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
                  child: Center(child: CircleAvatar(child: Text(name))),
                );
              }

              return Container(
                height: widget.height + 100,
                width: widget.width - 5,
                padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 15.0),
                child: HMSVideoView(
                  track: widget.peerTrackNodeStore.track!,
                  setMirror: widget.setMirror,
                  matchParent: false,
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
                "${widget.peerTrackNodeStore.peer.name} ${widget.peerTrackNodeStore.peer.isLocal ? "(You)" : ""}"),
          ),
          if (widget.peerTrackNodeStore.peer.metadata ==
              "{\"isHandRaised\":true,\"isBRBOn\":false}")
            Positioned(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Image.asset(
                  'assets/icons/raise_hand.png',
                  color: Colors.amber.shade300,
                ),
              ),
              top: 5.0,
              left: 5.0,
            ),
          Observer(builder: (context) {
            print("${widget.peerTrackNodeStore.isHighestAudio}");
            return Container(
              height: widget.height + 110,
              width: widget.width - 4,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: widget.peerTrackNodeStore.isHighestAudio
                          ? Colors.blue
                          : Colors.grey,
                      width:
                          widget.peerTrackNodeStore.isHighestAudio ? 5.0 : 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            );
          })
        ],
      ),
    );
  }
}
