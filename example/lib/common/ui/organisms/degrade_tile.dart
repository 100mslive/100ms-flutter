//package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/audio_level_avatar.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/hls-streaming/util/hls_subtitle_text.dart';
import 'package:provider/provider.dart';

//Package imports
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';

class DegradeTile extends StatefulWidget {
  final double itemHeight;

  final double itemWidth;
  DegradeTile({
    Key? key,
    this.itemHeight = 200,
    this.itemWidth = 200,
  }) : super(key: key);

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
                    color: bottomSheetColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 45.0),
                      child: Align(
                        child: HLSSubtitleText(
                            text: "DEGRADED", textColor: Colors.white),
                        alignment: Alignment.bottomCenter,
                      ),
                    ),
                    Positioned(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                        child: SvgPicture.asset(
                          'assets/icons/degrade.svg',
                        ),
                      ),
                      bottom: 5.0,
                      right: 5.0,
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
