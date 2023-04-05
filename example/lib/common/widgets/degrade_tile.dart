//package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hmssdk_flutter_example/common/widgets/subtitle_text.dart';
import 'package:hmssdk_flutter_example/common/peer_widgets/audio_level_avatar.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:provider/provider.dart';

//Package imports
import 'package:hmssdk_flutter_example/model/peer_track_node.dart';

class DegradeTile extends StatefulWidget {
  final double itemHeight;
  final double itemWidth;
  final bool isOneToOne;
  DegradeTile(
      {Key? key,
      this.itemHeight = 200,
      this.itemWidth = 200,
      this.isOneToOne = false})
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
              visible: !data,
              child: Container(
                height: widget.itemHeight + 110,
                width: widget.itemWidth - 4,
                decoration: BoxDecoration(
                    color: themeBottomSheetColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: widget.isOneToOne ? 18 : 45.0),
                      child: Align(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (!widget.isOneToOne)
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: SvgPicture.asset(
                                  'assets/icons/degrade.svg',
                                ),
                              ),
                            SubtitleText(
                                text: "DEGRADED", textColor: Colors.white),
                          ],
                        ),
                        alignment: Alignment.bottomCenter,
                      ),
                    ),
                    AudioLevelAvatar()
                  ],
                ),
              ));
        },
        selector: (_, peerTrackNode) =>
            peerTrackNode.track?.isDegraded ?? false);
  }
}
