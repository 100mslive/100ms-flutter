import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class PeerItemOrganism extends StatefulWidget {
  final HMSTrack track;
  final bool isVideoMuted;
  final double height;
  final double width;
  final bool isLocal;
  bool setMirror;
  final bool matchParent;

  PeerItemOrganism(
      {Key? key,
      required this.track,
      this.isVideoMuted = true,
      this.height = 200.0,
      this.width = 200.0,
      this.isLocal = false,
      this.setMirror = false,
      this.matchParent = true})
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
    print(
        "isVideoMuted ${widget.isVideoMuted} ${widget.track.source} ${widget.track.peer?.name} ${widget.setMirror}");

    return Container(
      key: key,
      padding: EdgeInsets.all(2),
      margin: EdgeInsets.all(2),
      height: widget.height + 20,
      width: widget.width - 5.0,
      decoration: BoxDecoration(
          border: Border.all(
              color: widget.track.isHighestAudio ? Colors.blue : Colors.grey,
              width: widget.track.isHighestAudio ? 4.0 : 1.0),
          borderRadius: BorderRadius.all(Radius.circular(4))),
      child: Column(
        children: [
          Expanded(child: LayoutBuilder(
            builder: (context, constraints) {
              if ((widget.isVideoMuted)) {
                List<String> parts = widget.track.peer?.name.split(" ") ?? [];

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
                  child: Center(child: CircleAvatar(child: Text(name))),
                );
              }

              return Container(
                height: widget.height + 100,
                width: widget.width - 5,
                padding: EdgeInsets.all(5.0),
                child: HMSVideoView(
                    track: widget.track, setMirror: widget.setMirror,matchParent: widget.matchParent),
              );
            },
          )),
          SizedBox(
            height: 4,
          ),
          Text(
              "${widget.track.peer?.name ?? ''} ${widget.track.peer?.isLocal ?? false ? "(You)" : ""}",overflow: TextOverflow.ellipsis,maxLines: 1,)
        ],
      ),
    );
  }
}
