import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hmssdk_flutter/model/hms_peer.dart';
import 'package:hmssdk_flutter/model/hms_track.dart';
import 'package:hmssdk_flutter/ui/meeting/video_view.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';

class PeerItemOrganism extends StatelessWidget {
  final HMSTrack track;
  MeetingStore? meetingStore;
  final bool isVideoMuted;

  PeerItemOrganism(
      {Key? key,
      required this.track,
      this.meetingStore,
      this.isVideoMuted = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Column(
        children: [
          Observer(builder: (_) {
            HMSPeer? peer;
            if (meetingStore != null)
              peer = meetingStore!.peers.firstWhere((element) {
                return element.peerId == track.peer!.peerId;
              });
            return Column(
              children: [
                Text(peer?.role?.name ?? ' [Undefined Role] '),
                Text(peer?.name ?? '[Undefined Name]'),
              ],
            );
          }),
          Expanded(child: LayoutBuilder(
            builder: (context, constraints) {
              if (isVideoMuted) {
                return Container(
                  child: Text(track.peer?.name.splitMapJoin((RegExp(r' ')),
                          onMatch: (m) => '${m[0]}') ??
                      ''),
                );
              }
              return VideoView(
                track: track,
                args: {
                  'height': constraints.maxHeight,
                  'width': constraints.maxWidth,
                },
              );
            },
          ))
        ],
      ),
    );
  }
}
