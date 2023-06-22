//Package imports
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hmssdk_uikit/model/peer_track_node.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

//Project imports

class AudioMuteStatus extends StatefulWidget {
  const AudioMuteStatus({super.key});

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
            child: Semantics(
              label: "fl_${context.read<PeerTrackNode>().peer.name}_audio_mute",
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                  child: data
                      ? SvgPicture.asset(
                          'packages/hmssdk_uikit/lib/assets/icons/tile_mute.svg',
                          width: 30,
                          semanticsLabel: "audio_mute_label",
                        )
                      : Container()),
            ),
          );
        });
  }
}
