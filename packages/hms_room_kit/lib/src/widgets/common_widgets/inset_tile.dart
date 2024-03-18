///Dart imports
library;

import 'dart:async';

///Package imports
import 'package:flutter/material.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/local_peer_more_option.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/video_view.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/audio_mute_status.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/brb_tag.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/hand_raise.dart';

///[InsetTile] is a widget that is used to render the local peer tile in the inset view
class InsetTile extends StatefulWidget {
  final double itemHeight;
  final double itemWidth;
  final ScaleType scaleType;
  final double avatarRadius;
  final double avatarTitleFontSize;
  final double avatarTitleTextLineHeight;
  final Function()? callbackFunction;
  const InsetTile(
      {Key? key,
      this.itemHeight = 186,
      this.itemWidth = 104,
      this.scaleType = ScaleType.SCALE_ASPECT_FILL,
      this.avatarRadius = 30,
      this.avatarTitleFontSize = 24,
      this.avatarTitleTextLineHeight = 32,
      this.callbackFunction})
      : super(key: key);

  @override
  State<InsetTile> createState() => _InsetTileState();
}

class _InsetTileState extends State<InsetTile> {
  String name = "";
  GlobalKey key = GlobalKey();
  bool isButtonVisible = true;

  @override
  void initState() {
    super.initState();
    _autoHideOption();
  }

  ///This function is used to auto hide the more option button
  void _autoHideOption() {
    Timer(const Duration(seconds: 3), () {
      if (isButtonVisible && mounted) {
        setState(() {
          isButtonVisible = !isButtonVisible;
        });
      }
    });
  }

  ///This function is used to toggle the visibility of the more option button
  void _toggleButtonVisibility() {
    if (!isButtonVisible) {
      setState(() {
        isButtonVisible = !isButtonVisible;
      });
      _autoHideOption();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "fl_${context.read<PeerTrackNode>().peer.name}_video_tile",
      child: FocusDetector(
          onFocusLost: () {
            if (mounted) {
              Provider.of<PeerTrackNode>(context, listen: false)
                  .setOffScreenStatus(true);
            }
          },
          onFocusGained: () {
            Provider.of<PeerTrackNode>(context, listen: false)
                .setOffScreenStatus(false);
          },
          key: Key(context.read<PeerTrackNode>().uid),
          child: InkWell(
            onTap: () => _toggleButtonVisibility(),
            child: Container(
              key: key,
              height: widget.itemHeight,
              width: widget.itemWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: HMSThemeColors.surfaceDefault,
              ),
              child: Semantics(
                label: "fl_${context.read<PeerTrackNode>().peer.name}_video_on",
                child: Stack(
                  children: [
                    IgnorePointer(
                      child: VideoView(
                          uid: context.read<PeerTrackNode>().uid,
                          scaleType: widget.scaleType,
                          avatarRadius: widget.avatarRadius,
                          avatarTitleFontSize: widget.avatarTitleFontSize,
                          avatarTitleTextLineHeight:
                              widget.avatarTitleTextLineHeight),
                    ),
                    const HandRaise(), //top left
                    const BRBTag(), //top left
                    const AudioMuteStatus(), //top right
                    if (isButtonVisible)
                      LocalPeerMoreOption(
                        callbackFunction: widget.callbackFunction,
                      ), //bottom right
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
