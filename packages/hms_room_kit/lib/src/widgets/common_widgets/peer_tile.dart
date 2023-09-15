// Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

// Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/inset_tile_more_option.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/name_and_network.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/screen_share_tile_name.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/degrade_tile.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/video_view.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/audio_mute_status.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/brb_tag.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/hand_raise.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/more_option.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/rtc_stats_view.dart';

///This widget is used to render the peer tile
///It contains following parameters
///[scaleType] is used to set the scale type of the video view
///[islongPressEnabled] is used to enable or disable the long press on the video view
///[avatarRadius] is used to set the radius of the avatar
///[avatarTitleFontSize] is used to set the font size of the avatar title
///[avatarTitleTextLineHeight] is used to set the line height of the avatar title
///[PeerTile] is a stateful widget because it uses [FocusDetector]
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
                          Semantics(
                            label:
                                "fl_${context.read<PeerTrackNode>().peer.name}_degraded_tile",
                            child: const DegradeTile(),
                          ),
                          NameAndNetwork(maxWidth: constraints.maxWidth),
                          const HandRaise(), //top left
                          const BRBTag(), //top left
                          const AudioMuteStatus(), //top right
                          context.read<PeerTrackNode>().peer.isLocal
                              ? const LocalPeerMoreOption(
                                  isInsetTile: false,
                                )
                              : const MoreOption(), //bottom right
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
                        builder: (context, BoxConstraints constraints) {
                      return Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: HMSThemeColors.surfaceDim, width: 1.0),
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
                            Positioned(
                                top: 5,
                                right: 5,
                                child: GestureDetector(
                                  ///This is to show the screenshare in full screen
                                  onTap: () {
                                    showGeneralDialog(
                                        context: context,
                                        transitionBuilder: (dialogContext,
                                            animation,
                                            secondaryAnimation,
                                            value) {
                                          if (mounted) {
                                            ///Setting the screenshare context
                                            ///in the meeting store to store the current context
                                            ///so that we can pop the dialog from the meeting store when screenshare is stopped
                                            context
                                                    .read<MeetingStore>()
                                                    .screenshareContext =
                                                dialogContext;
                                          }

                                          ///Here we check whether the full screen screenshare is mounted or not
                                          return context.mounted
                                              ? Transform.scale(
                                                  scale: animation.value,
                                                  child: Opacity(
                                                      opacity: animation.value,
                                                      child: ListenableProvider
                                                          .value(
                                                        value: context.read<
                                                            PeerTrackNode>(),
                                                        child: Scaffold(
                                                          body: SafeArea(
                                                            child: Container(
                                                              color: HMSThemeColors
                                                                  .backgroundDim,
                                                              height:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height,
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              child: Stack(
                                                                children: [
                                                                  InteractiveViewer(
                                                                    child: ListenableProvider
                                                                        .value(
                                                                      value: context
                                                                          .read<
                                                                              MeetingStore>(),
                                                                      child:
                                                                          VideoView(
                                                                        uid: context
                                                                            .read<PeerTrackNode>()
                                                                            .uid,
                                                                        scaleType:
                                                                            widget.scaleType,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                      top: 5,
                                                                      right: 5,
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.pop(
                                                                              dialogContext);
                                                                          context
                                                                              .read<MeetingStore>()
                                                                              .screenshareContext = null;
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              40,
                                                                          width:
                                                                              40,
                                                                          decoration: BoxDecoration(
                                                                              color: HMSThemeColors.backgroundDim.withAlpha(64),
                                                                              borderRadius: BorderRadius.circular(8)),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                SvgPicture.asset(
                                                                              "packages/hms_room_kit/lib/src/assets/icons/minimize.svg",
                                                                              height: 16,
                                                                              width: 16,
                                                                              semanticsLabel: "minimize_label",
                                                                              colorFilter: ColorFilter.mode(HMSThemeColors.onSurfaceHighEmphasis, BlendMode.srcIn),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )),
                                                                  Positioned(
                                                                    //Bottom left
                                                                    bottom: 5,
                                                                    left: 5,
                                                                    child:
                                                                        Container(
                                                                      decoration: BoxDecoration(
                                                                          color: HMSThemeColors.backgroundDim.withOpacity(
                                                                              0.64),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8)),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              left: 8.0,
                                                                              right: 4,
                                                                              top: 4,
                                                                              bottom: 4),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              SvgPicture.asset(
                                                                                "packages/hms_room_kit/lib/src/assets/icons/screen_share.svg",
                                                                                height: 20,
                                                                                width: 20,
                                                                                colorFilter: ColorFilter.mode(HMSThemeColors.onSurfaceHighEmphasis, BlendMode.srcIn),
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 6,
                                                                              ),
                                                                              ScreenshareTileName(maxWidth: constraints.maxWidth)
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                )
                                              : Container();
                                        },
                                        pageBuilder: (ctx, animation,
                                            secondaryAnimation) {
                                          return Container();
                                        });
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        color: HMSThemeColors.backgroundDim
                                            .withAlpha(64),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        "packages/hms_room_kit/lib/src/assets/icons/maximize.svg",
                                        height: 16,
                                        width: 16,
                                        semanticsLabel: "maximize_label",
                                        colorFilter: ColorFilter.mode(
                                            HMSThemeColors
                                                .onSurfaceHighEmphasis,
                                            BlendMode.srcIn),
                                      ),
                                    ),
                                  ),
                                )),
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
                                        SvgPicture.asset(
                                          "packages/hms_room_kit/lib/src/assets/icons/screen_share.svg",
                                          height: 20,
                                          width: 20,
                                          colorFilter: ColorFilter.mode(
                                              HMSThemeColors
                                                  .onSurfaceHighEmphasis,
                                              BlendMode.srcIn),
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        ScreenshareTileName(
                                            maxWidth: constraints.maxWidth)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const RTCStatsView(isLocal: false),
                          ],
                        ),
                      );
                    }),
                  );
          })),
    );
  }
}
