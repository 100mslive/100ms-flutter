// Package imports
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hms_room_kit/src/common/utility_components.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/degrade_tile.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/video_view.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/audio_mute_status.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/brb_tag.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/hand_raise.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/more_option.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/network_icon_widget.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/peer_name.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/rtc_stats_view.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/tile_border.dart';
import 'package:provider/provider.dart';

// Project imports

class PeerTile extends StatefulWidget {
  final double itemHeight;
  final double itemWidth;
  final ScaleType scaleType;
  final bool islongPressEnabled;
  final bool isOneToOne;
  final double avatarRadius;
  final double avatarTitleFontSize;
  const PeerTile({
    Key? key,
    this.itemHeight = 200.0,
    this.itemWidth = 200.0,
    this.scaleType = ScaleType.SCALE_ASPECT_FILL,
    this.islongPressEnabled = true,
    this.isOneToOne = false,
    this.avatarRadius = 36,
    this.avatarTitleFontSize = 36,
  }) : super(key: key);

  @override
  State<PeerTile> createState() => _PeerTileState();
}

class _PeerTileState extends State<PeerTile> {
  String name = "";
  GlobalKey key = GlobalKey();

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
          //Here we check whether the video track is a regular
          //video track or a screen share track
          //We check this by checking the uid of the track
          //If it contains `mainVideo` then it is a regular video track
          //else it is a screen share track
          child: LayoutBuilder(builder: (context, BoxConstraints constraints) {
            return context.read<PeerTrackNode>().uid.contains("mainVideo")
                ? Container(
                    key: key,
                    height: widget.itemHeight + 110,
                    width: widget.itemWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: HMSThemeColors.surfaceDim,
                    ),
                    child: Semantics(
                      label:
                          "fl_${context.read<PeerTrackNode>().peer.name}_video_on",
                      child: Stack(
                        children: [
                          VideoView(
                            uid: context.read<PeerTrackNode>().uid,
                            scaleType: widget.scaleType,
                            itemHeight: widget.itemHeight,
                            itemWidth: widget.itemWidth,
                          ),
                          TileBorder(
                              itemHeight: widget.itemHeight,
                              itemWidth: widget.itemWidth,
                              name: context.read<PeerTrackNode>().peer.name,
                              uid: context.read<PeerTrackNode>().uid),
                          Semantics(
                            label:
                                "fl_${context.read<PeerTrackNode>().peer.name}_degraded_tile",
                            child: DegradeTile(
                              isOneToOne: widget.isOneToOne,
                              itemHeight: widget.itemHeight,
                              itemWidth: widget.itemWidth,
                              avatarRadius: widget.avatarRadius,
                              avatarTitleFontSize: widget.avatarTitleFontSize,
                            ),
                          ),
                          if (!widget.isOneToOne)
                            Positioned(
                              //Bottom left
                              bottom: 5,
                              left: 5,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: HMSThemeColors.backgroundDim
                                        .withOpacity(0.64),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 4, top: 4, bottom: 4),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        PeerName(
                                          width: constraints.maxWidth,
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
                          const HandRaise(), //top left
                          const BRBTag(), //top left
                          const AudioMuteStatus(), //top right
                          const MoreOption(), //bottom right
                          if (!widget.isOneToOne)
                            Semantics(
                              label: "fl_stats_on_tile",
                              child: RTCStatsView(
                                  isLocal: context
                                      .read<PeerTrackNode>()
                                      .peer
                                      .isLocal),
                            )
                        ],
                      ),
                    ),
                  )
                : Semantics(
                    label:
                        "fl_${context.read<PeerTrackNode>().peer.name}_screen_share_tile",
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1.0),
                          color: Colors.transparent,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      key: key,
                      height: widget.itemHeight + 110,
                      width: widget.itemWidth,
                      child: Stack(
                        children: [
                          VideoView(
                            uid: context.read<PeerTrackNode>().uid,
                            scaleType: widget.scaleType,
                          ),
                          Positioned(
                            //Bottom left
                            bottom: 5,
                            left: 5,
                            child: Container(
                              key: Key(
                                  "fl_${context.read<PeerTrackNode>().peer.name}_name"),
                              decoration: BoxDecoration(
                                  color: HMSThemeColors.backgroundDim
                                      .withOpacity(0.64),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 4, top: 4, bottom: 4),
                                  child: PeerName(
                                    width: constraints.maxWidth,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const RTCStatsView(isLocal: false),
                          Align(
                            alignment: Alignment.topRight,
                            child: widget.islongPressEnabled
                                ? UtilityComponents.rotateScreen(context)
                                : const SizedBox(),
                          )
                        ],
                      ),
                    ),
                  );
          })),
    );
  }
}
