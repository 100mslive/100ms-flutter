// Package imports
import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/common/app_color.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/audio_level_avatar.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/audio_mute_status.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/brb_tag.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/hand_raise.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/more_option.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/network_icon_widget.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/rtc_stats_view.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/tile_border.dart';
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
    return Container(
      key: key,
      padding: const EdgeInsets.all(2),
      margin: const EdgeInsets.all(2),
      height: itemHeight + 110,
      width: itemWidth - 5.0,
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
                    color: const Color.fromRGBO(0, 0, 0, 0.9),
                    borderRadius: BorderRadius.circular(8)),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        NetworkIconWidget(),
                        PeerName(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const HandRaise(), //bottom left
            const BRBTag(), //top right
            const AudioMuteStatus(),
            TileBorder(
                name: context.read<PeerTrackNode>().peer.name,
                itemHeight: itemHeight,
                itemWidth: itemWidth,
                uid: context.read<PeerTrackNode>().uid),
            RTCStatsView(isLocal: context.read<PeerTrackNode>().peer.isLocal),
            const MoreOption(), //bottom center
          ],
        ),
      ),
    );
  }
}
