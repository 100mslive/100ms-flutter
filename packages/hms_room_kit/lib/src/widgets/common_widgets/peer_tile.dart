// Package imports
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/name_and_network.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hms_room_kit/src/common/utility_components.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/degrade_tile.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/video_view.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/audio_mute_status.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/brb_tag.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/hand_raise.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/more_option.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/peer_name.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/rtc_stats_view.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/tile_border.dart';
import 'package:provider/provider.dart';

// Project imports

class PeerTile extends StatefulWidget {
  final ScaleType scaleType;
  final bool islongPressEnabled;
  final double avatarRadius;
  final double avatarTitleFontSize;
  final double avatarTitleTextLineHeight;
  const PeerTile(
      {Key? key,
      this.scaleType = ScaleType.SCALE_ASPECT_FILL,
      this.islongPressEnabled = true,
      this.avatarRadius = 34,
      this.avatarTitleFontSize = 34,
      this.avatarTitleTextLineHeight = 40})
      : super(key: key);

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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: HMSThemeColors.backgroundDefault,
                    ),
                    child: Semantics(
                      label:
                          "fl_${context.read<PeerTrackNode>().peer.name}_video_on",
                      child: Stack(
                        children: [
                          VideoView(
                            uid: context.read<PeerTrackNode>().uid,
                            scaleType: widget.scaleType,
                            avatarTitleFontSize: widget.avatarTitleFontSize,
                            avatarRadius: widget.avatarRadius,
                            avatarTitleTextLineHeight:
                                widget.avatarTitleTextLineHeight,
                          ),
                          TileBorder(
                              name: context.read<PeerTrackNode>().peer.name,
                              uid: context.read<PeerTrackNode>().uid),
                          Semantics(
                            label:
                                "fl_${context.read<PeerTrackNode>().peer.name}_degraded_tile",
                            child: const DegradeTile(),
                          ),
                          NameAndNetwork(maxWidth: constraints.maxWidth),
                          const HandRaise(), //top left
                          const BRBTag(), //top left
                          const AudioMuteStatus(), //top right
                          const MoreOption(), //bottom right
                          Semantics(
                            label: "fl_stats_on_tile",
                            child: RTCStatsView(
                                isLocal:
                                    context.read<PeerTrackNode>().peer.isLocal),
                          )
                        ],
                      ),
                    ),
                  )
                : Semantics(
                    label:
                        "fl_${context.read<PeerTrackNode>().peer.name}_screen_share_tile",
                    child: LayoutBuilder(
                      builder: (context,BoxConstraints constraints) {
                        return Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1.0),
                              color: Colors.transparent,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          key: key,
                          child: Stack(
                            children: [
                              VideoView(
                                uid: context.read<PeerTrackNode>().uid,
                                scaleType: widget.scaleType,
                              ),
                              NameAndNetwork(maxWidth: constraints.maxWidth),
                              const RTCStatsView(isLocal: false),
                            ],
                          ),
                        );
                      }
                    ),
                  );
          })),
    );
  }
}
