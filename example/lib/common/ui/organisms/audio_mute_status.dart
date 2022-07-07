//Package imports
import 'package:flutter_svg/flutter_svg.dart';
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
            top: 5,
            right: 5,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                child: data
                    ? SvgPicture.asset(
                        'assets/icons/tile_mute.svg',
                        width: 30,
                      )
                    : Container()),
          );
        });
  }
}
