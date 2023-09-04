// Package imports
import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/common/app_color.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/audio_level_avatar.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/audio_mute_status.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/brb_tag.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/hand_raise.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/more_option.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/network_icon_widget.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/rtc_stats_view.dart';
import 'package:provider/provider.dart';

// Project imports

import '../peer_widgets/peer_name.dart';

class AudioTile extends StatelessWidget {
  final double itemHeight;
  final double itemWidth;
  const AudioTile({this.itemHeight = 200.0, this.itemWidth = 200.0, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      return Container(
        key: key,
        height: itemHeight + 110,
        width: itemWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: themeBottomSheetColor,
        ),
        child: Semantics(
          label: "${context.read<PeerTrackNode>().peer.name}_audio",
          child: Stack(
            children: [
              const Center(child: AudioLevelAvatar()),
              Positioned(
                //Bottom left
                bottom: 5,
                left: 5,
                child: Container(
                  decoration: BoxDecoration(
                      color: HMSThemeColors.backgroundDim.withOpacity(0.64),
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PeerName(
                            maxWidth: constraints.maxWidth,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          const NetworkIconWidget(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const HandRaise(), //bottom left
              const BRBTag(), //top right
              const AudioMuteStatus(),
              RTCStatsView(isLocal: context.read<PeerTrackNode>().peer.isLocal),
              const MoreOption(), //bottom center
            ],
          ),
        ),
      );
    });
  }
}
