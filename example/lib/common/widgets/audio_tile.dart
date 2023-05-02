// Package imports
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/common/peer_widgets/audio_level_avatar.dart';
import 'package:hmssdk_flutter_example/common/peer_widgets/audio_mute_status.dart';
import 'package:hmssdk_flutter_example/common/peer_widgets/brb_tag.dart';
import 'package:hmssdk_flutter_example/common/peer_widgets/hand_raise.dart';
import 'package:hmssdk_flutter_example/common/peer_widgets/more_option.dart';
import 'package:hmssdk_flutter_example/common/peer_widgets/network_icon_widget.dart';
import 'package:hmssdk_flutter_example/common/peer_widgets/rtc_stats_view.dart';
import 'package:hmssdk_flutter_example/common/peer_widgets/tile_border.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:provider/provider.dart';

// Project imports
import 'package:hmssdk_flutter_example/model/peer_track_node.dart';

import '../peer_widgets/peer_name.dart';

class AudioTile extends StatelessWidget {
  final double itemHeight;
  final double itemWidth;
  AudioTile({this.itemHeight = 200.0, this.itemWidth = 200.0, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      padding: EdgeInsets.all(2),
      margin: EdgeInsets.all(2),
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
            Center(child: AudioLevelAvatar()),
            Positioned(
              //Bottom left
              bottom: 5,
              left: 5,
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.9),
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
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
            HandRaise(), //bottom left
            BRBTag(), //top right
            AudioMuteStatus(),
            TileBorder(
                name: context.read<PeerTrackNode>().peer.name,
                itemHeight: itemHeight,
                itemWidth: itemWidth,
                uid: context.read<PeerTrackNode>().uid),
            RTCStatsView(isLocal: context.read<PeerTrackNode>().peer.isLocal),
            MoreOption(), //bottom center
          ],
        ),
      ),
    );
  }
}
