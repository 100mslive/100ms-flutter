//Package imports
import 'package:flutter/material.dart';
import 'package:hmssdk_uikit/common/app_color.dart';
import 'package:hmssdk_uikit/model/peer_track_node.dart';
import 'package:provider/provider.dart';

//Project imports

class TileBorder extends StatelessWidget {
  final double itemHeight;
  final double itemWidth;
  final String uid;
  final String name;

  const TileBorder(
      {super.key, required this.itemHeight,
      required this.itemWidth,
      required this.uid,
      required this.name});

  @override
  Widget build(BuildContext context) {
    return Selector<PeerTrackNode, int>(
        selector: (_, peerTrackNode) => peerTrackNode.audioLevel,
        builder: (_, audioLevel, __) {
          return Container(
            height: itemHeight + 110,
            width: itemWidth - 4,
            decoration: BoxDecoration(
              border: Border.all(
                  color: (audioLevel != -1)
                      ? hmsdefaultColor
                      : themeBottomSheetColor,
                  width: (audioLevel != -1) ? 4.0 : 0.0),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          );
        });
  }
}
