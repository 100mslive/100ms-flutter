//Package imports
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
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
          return data
              ? Positioned(
                  top: 5,
                  right: 5,
                  child: Semantics(
                    label:
                        "fl_${context.read<PeerTrackNode>().peer.name}_audio_mute",
                    child: Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: HMSThemeColors.surfaceDim),
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                          child: SvgPicture.asset(
                            'packages/hms_room_kit/lib/src/assets/icons/mic_state_off.svg',
                            width: 16,
                            height: 16,
                            semanticsLabel: "audio_mute_label",
                          )),
                    ),
                  ),
                )
              : Container();
        });
  }
}
