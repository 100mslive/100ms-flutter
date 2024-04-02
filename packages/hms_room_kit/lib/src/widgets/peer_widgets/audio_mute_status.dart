//Package imports
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

//Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:tuple/tuple.dart';

///[AudioMuteStatus] is a widget that is used to render the audio mute status
class AudioMuteStatus extends StatefulWidget {
  const AudioMuteStatus({super.key});

  @override
  State<AudioMuteStatus> createState() => _AudioMuteStatusState();
}

class _AudioMuteStatusState extends State<AudioMuteStatus> {
  @override
  Widget build(BuildContext context) {
    ///Here we either render the mute icon or the audio level based on whether
    ///the mic is mute or the audio levels
    return Selector<PeerTrackNode, Tuple2<bool, int>>(
        selector: (_, peerTrackNode) => Tuple2(
            peerTrackNode.audioTrack?.isMute ?? true, peerTrackNode.audioLevel),
        builder: (_, data, __) {
          return Positioned(
              top: 5,
              right: 5,
              child: Semantics(
                label:
                    "fl_${context.read<PeerTrackNode>().peer.name}_audio_mute",
                child: data.item1
                    ? Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: HMSThemeColors.secondaryDim),
                        child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: SvgPicture.asset(
                              'packages/hms_room_kit/lib/src/assets/icons/mic_state_off.svg',
                              width: 16,
                              height: 16,
                              semanticsLabel: "audio_mute_label",
                              colorFilter: ColorFilter.mode(
                                  HMSThemeColors.onSecondaryHighEmphasis,
                                  BlendMode.srcIn),
                            )),
                      )

                    ///We render the animation only when the audio level is greater than zero
                    ///else we show the ellipsis icon
                    : Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: HMSThemeColors.secondaryDim),
                        child: data.item2 > 0
                            ? Lottie.asset(
                                "packages/hms_room_kit/lib/src/assets/icons/audio-level.json",
                                height: 24,
                                width: 24)
                            : SvgPicture.asset(
                                'packages/hms_room_kit/lib/src/assets/icons/zero_audio_level.svg',
                                fit: BoxFit.scaleDown,
                                semanticsLabel: "audio_mute_label",
                                colorFilter: ColorFilter.mode(
                                    HMSThemeColors.onSecondaryHighEmphasis,
                                    BlendMode.srcIn),
                              )),
              ));
        });
  }
}
