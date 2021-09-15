import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:mobx/mobx.dart';

class PeerItemOrganism extends StatefulWidget {
  final HMSTrack track;
  final bool isVideoMuted;
  PeerItemOrganism({Key? key, required this.track, this.isVideoMuted = true,})
      : super(key: key);

  @override
  _PeerItemOrganismState createState() => _PeerItemOrganismState();
}

class _PeerItemOrganismState extends State<PeerItemOrganism> {



  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.key,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
          border: Border.all(color: widget.track.isHighestAudio?Colors.blue:Colors.green,width: widget.track.isHighestAudio?3.0:1.0),
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Column(
        children: [
          Expanded(child: LayoutBuilder(
            builder: (context, constraints) {
              if (widget.isVideoMuted) {
                List<String> parts = widget.track.peer?.name.split(" ") ?? [];

                late String name;
                if (parts.length == 1) {
                  parts[0] += " ";
                  name = parts[0][0] + parts[0][1];
                }
                else
                  name = parts.map((e) => e.substring(0, 1)).join();
                return Container(
                  child: Center(child: CircleAvatar(child: Text(name))),
                );
              }
              return HMSVideoView(
                track: widget.track,
                isAuxiliaryTrack: widget.track.source==HMSTrackSource.kHMSTrackSourceScreen,
              );
            },
          )),
          SizedBox(
            height: 16,
          ),
          Text("${widget.track.peer?.name ?? ''} ${widget.track.peer?.isLocal??false?"(You)":""}")
        ],
      ),
    );
  }
}
