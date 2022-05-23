//Package imports
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

//Project imports
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';

class AudioMuteStatus extends StatefulWidget {
  @override
  State<AudioMuteStatus> createState() => _AudioMuteStatusState();
}

class _AudioMuteStatusState extends State<AudioMuteStatus> {
  @override
  Widget build(BuildContext context) {
    return Selector<PeerTrackNode, bool>(
        selector: (_, peerTrackNode) =>
            peerTrackNode.audioTrack?.isMute ?? true,
        builder: (_, data, __) {
          return Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: data
                    ? CircleAvatar(
                        backgroundColor: Colors.transparent.withOpacity(0.2),
                        child: Icon(
                          Icons.mic_off,
                          color: Colors.red,
                        ))
                    : Container()),
          );
        });
  }
}
