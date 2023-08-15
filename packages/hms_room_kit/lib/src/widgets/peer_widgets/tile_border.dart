//Package imports
import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:provider/provider.dart';

//Project imports

class TileBorder extends StatelessWidget {
  final String uid;
  final String name;

  const TileBorder(
      {super.key,
      required this.uid,
      required this.name});

  @override
  Widget build(BuildContext context) {
    return Selector<PeerTrackNode, int>(
        selector: (_, peerTrackNode) => peerTrackNode.audioLevel,
        builder: (_, audioLevel, __) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: (audioLevel != -1)
                      ? HMSThemeColors.primaryDefault
                      : HMSThemeColors.surfaceDim,
                  width: (audioLevel != -1) ? 4.0 : 0.0),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          );
        });
  }
}
