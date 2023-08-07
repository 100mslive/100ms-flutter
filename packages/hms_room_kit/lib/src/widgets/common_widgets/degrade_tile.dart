//package imports
import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/audio_level_avatar.dart';
import 'package:provider/provider.dart';

//Package imports

class DegradeTile extends StatefulWidget {
  final double itemHeight;
  final double itemWidth;
  final bool isOneToOne;
  final double avatarRadius;
  final double avatarTitleFontSize;

  const DegradeTile(
      {Key? key,
      this.itemHeight = 200,
      this.itemWidth = 200,
      this.isOneToOne = false,
      this.avatarRadius = 36,
      this.avatarTitleFontSize = 36})
      : super(key: key);

  @override
  State<DegradeTile> createState() => _DegradeTileState();
}

class _DegradeTileState extends State<DegradeTile> {
  @override
  Widget build(BuildContext context) {
    return Selector<PeerTrackNode, bool>(
        builder: (_, data, __) {
          return Visibility(
              visible: data,
              child: Container(
                height: widget.itemHeight + 110,
                width: widget.itemWidth - 4,
                decoration: BoxDecoration(
                    color: HMSThemeColors.surfaceDim,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Stack(
                  children: [
                    AudioLevelAvatar(
                      avatarRadius: widget.avatarRadius,
                      avatarTitleFontSize: widget.avatarTitleFontSize,
                    )
                  ],
                ),
              ));
        },
        selector: (_, peerTrackNode) =>
            peerTrackNode.track?.isDegraded ?? false);
  }
}
