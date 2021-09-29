import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class PeerItemOrganism extends StatefulWidget {
  final HMSTrack track;
  final bool isVideoMuted;

  PeerItemOrganism({Key? key, required this.track, this.isVideoMuted = true})
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
    return Container(
      key: key,
      padding: EdgeInsets.all(2),
      margin: EdgeInsets.all(2),
      height: 200.0,
      decoration: BoxDecoration(
          border: Border.all(
              color: widget.track.isHighestAudio ? Colors.blue : Colors.grey,
              width: widget.track.isHighestAudio ? 4.0 : 1.0),
          borderRadius: BorderRadius.all(Radius.circular(4))),
      child: Column(
        children: [
          Expanded(child: LayoutBuilder(
            builder: (context, constraints) {
              if (widget.isVideoMuted) {
                List<String> parts = widget.track.peer?.name.split(" ") ?? [];

                if (parts.length == 1) {
                  parts[0] += " ";
                  name = parts[0][0] + parts[0][1];
                } else if (parts.length >= 2) {
                  name = parts[0][0] + parts[1][0];
                }
                return Container(
                  child: Center(child: CircleAvatar(child: Text(name))),
                );
              }

              return HMSVideoView(
                  track: widget.track,
                  isAuxiliaryTrack: widget.track.source ==
                      HMSTrackSource.kHMSTrackSourceScreen);
            },
          )),
          SizedBox(
            height: 4,
          ),
          Text(
              "${widget.track.peer?.name ?? ''} ${widget.track.peer?.isLocal ?? false ? "(You)" : ""}")
        ],
      ),
    );
  }
}
