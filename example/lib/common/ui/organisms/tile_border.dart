//Package imports
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/model/peer_track_node.dart';
import 'package:provider/provider.dart';

//Project imports
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';

class TileBorder extends StatelessWidget {
  final double itemHeight;
  final double itemWidth;
  final String uid;
  final String name;

  TileBorder(
      {required this.itemHeight,
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
                      ? Utilities.getBackgroundColour(name)
                      : themeBottomSheetColor,
                  width: (audioLevel != -1) ? 4.0 : 0.0),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          );
        });
  }
}
