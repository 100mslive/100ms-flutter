///Package imports
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_cross_button.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/change_name_bottom_sheet.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';

///[LocalPeerBottomSheet] is a widget that is used to render the bottom sheet when the more option button is clicked on the local peer tile
///It has following parameters:
///[meetingStore] is the meetingStore of the meeting
///[peerTrackNode] is the peerTrackNode of the local peer
///[callbackFunction] is a function that is called when the more option button is clicked
class LocalPeerBottomSheet extends StatefulWidget {
  final MeetingStore meetingStore;
  final PeerTrackNode peerTrackNode;
  final Function()? callbackFunction;
  final bool isInsetTile;

  const LocalPeerBottomSheet(
      {Key? key,
      required this.meetingStore,
      required this.peerTrackNode,
      this.callbackFunction,
      this.isInsetTile = true})
      : super(key: key);
  @override
  State<LocalPeerBottomSheet> createState() => _LocalPeerBottomSheetState();
}

class _LocalPeerBottomSheetState extends State<LocalPeerBottomSheet> {
  @override
  void initState() {
    super.initState();
    context.read<MeetingStore>().addBottomSheet(context);
  }

  @override
  void deactivate() {
    context.read<MeetingStore>().removeBottomSheet(context);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor:
          (AppDebugConfig.isDebugMode && widget.meetingStore.isVideoOn)
              ? (widget.isInsetTile ? 0.46 : 0.4)
              : (widget.isInsetTile ? 0.26 : 0.2),
      child: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 24, right: 24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width - 100),
                            child: HMSTitleText(
                              text:
                                  "${widget.meetingStore.localPeer?.name} (You)",
                              textColor: HMSThemeColors.onSurfaceHighEmphasis,
                              letterSpacing: 0.15,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          HMSSubtitleText(
                              text: widget.meetingStore.localPeer?.role.name ??
                                  "",
                              textColor: HMSThemeColors.onSurfaceMediumEmphasis)
                        ],
                      ),
                    ],
                  ),
                  const Row(
                    children: [HMSCrossButton()],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Divider(
                  color: HMSThemeColors.borderDefault,
                  height: 5,
                ),
              ),
              Expanded(
                ///Here we use a listview to render the options
                ///The list contains following item
                ///1. Pin Tile for Myself
                ///2. Spotlight Tile for Everyone
                ///3. Change Name
                ///4. Minimize Your Tile
                child: ListView(
                  children: [
                    // ListTile(
                    //     horizontalTitleGap: 2,
                    //     onTap: () async {
                    //       widget.meetingStore
                    //           .changePinTileStatus(widget.peerTrackNode);
                    //     },
                    //     contentPadding: EdgeInsets.zero,
                    //     leading: SvgPicture.asset(
                    //       "packages/hms_room_kit/lib/src/assets/icons/pin.svg",
                    //       semanticsLabel: "fl_local_pin_tile",
                    //       height: 20,
                    //       width: 20,
                    //       colorFilter: ColorFilter.mode(
                    //           HMSThemeColors.onSurfaceHighEmphasis,
                    //           BlendMode.srcIn),
                    //     ),
                    //     title: HMSSubheadingText(
                    //         text: "Pin Tile for Myself",
                    //         textColor: HMSThemeColors.onSurfaceHighEmphasis)),
                    // ListTile(
                    //     horizontalTitleGap: 2,
                    //     onTap: () async {
                    //       if (widget.meetingStore.spotLightPeer?.uid ==
                    //           widget.peerTrackNode.uid) {
                    //         widget.meetingStore.setSessionMetadataForKey(
                    //             key: SessionStoreKeyValues.getNameFromMethod(
                    //                 SessionStoreKey.spotlight),
                    //             metadata: null);
                    //         return;
                    //       }

                    //       ///Setting the metadata as audio trackId if it's not present
                    //       ///then setting it as video trackId
                    //       String? metadata =
                    //           (widget.peerTrackNode.audioTrack == null)
                    //               ? widget.peerTrackNode.track?.trackId
                    //               : widget.peerTrackNode.audioTrack?.trackId;
                    //       widget.meetingStore.setSessionMetadataForKey(
                    //           key: SessionStoreKeyValues.getNameFromMethod(
                    //               SessionStoreKey.spotlight),
                    //           metadata: metadata);
                    //     },
                    //     contentPadding: EdgeInsets.zero,
                    //     leading: SvgPicture.asset(
                    //       "packages/hms_room_kit/lib/src/assets/icons/spotlight.svg",
                    //       semanticsLabel: "fl_spotlight_local_tile",
                    //       height: 20,
                    //       width: 20,
                    //       colorFilter: ColorFilter.mode(
                    //           HMSThemeColors.onSurfaceHighEmphasis,
                    //           BlendMode.srcIn),
                    //     ),
                    //     title: HMSSubheadingText(
                    //         text: "Spotlight Tile for Everyone",
                    //         textColor: HMSThemeColors.onSurfaceHighEmphasis)),
                    if (Constant.prebuiltOptions?.userName == null)
                      ListTile(
                          horizontalTitleGap: 2,
                          onTap: () async {
                            Navigator.pop(context);
                            showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: HMSThemeColors.surfaceDim,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16)),
                              ),
                              context: context,
                              builder: (ctx) => ChangeNotifierProvider.value(
                                  value: widget.meetingStore,
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(ctx)
                                              .viewInsets
                                              .bottom),
                                      child: const ChangeNameBottomSheet(
                                        showPrivacyInfo: false,
                                      ))),
                            );
                          },
                          contentPadding: EdgeInsets.zero,
                          leading: SvgPicture.asset(
                            "packages/hms_room_kit/lib/src/assets/icons/pencil.svg",
                            semanticsLabel: "fl_local_pin_tile",
                            height: 20,
                            width: 20,
                            colorFilter: ColorFilter.mode(
                                HMSThemeColors.onSurfaceHighEmphasis,
                                BlendMode.srcIn),
                          ),
                          title: HMSSubheadingText(
                              text: "Change Name",
                              textColor: HMSThemeColors.onSurfaceHighEmphasis)),
                    if (widget.isInsetTile)
                      ListTile(
                          horizontalTitleGap: 2,
                          onTap: () async {
                            Navigator.pop(context);
                            if (widget.callbackFunction != null) {
                              widget.callbackFunction!();
                            }
                          },
                          contentPadding: EdgeInsets.zero,
                          leading: SvgPicture.asset(
                            "packages/hms_room_kit/lib/src/assets/icons/minimize.svg",
                            semanticsLabel: "fl_minimize_local_tile",
                            height: 20,
                            width: 20,
                            colorFilter: ColorFilter.mode(
                                widget.meetingStore.peerTracks.length > 1
                                    ? HMSThemeColors.onSurfaceHighEmphasis
                                    : HMSThemeColors.onSurfaceLowEmphasis,
                                BlendMode.srcIn),
                          ),
                          title: HMSSubheadingText(
                              text: "Minimize Your Tile",
                              textColor:
                                  widget.meetingStore.peerTracks.length > 1
                                      ? HMSThemeColors.onSurfaceHighEmphasis
                                      : HMSThemeColors.onSurfaceLowEmphasis)),
                    if (AppDebugConfig.isDebugMode &&
                        widget.meetingStore.isVideoOn)
                      ListTile(
                          horizontalTitleGap: 2,
                          onTap: () async {
                            Navigator.pop(context);
                            bool isZoomSupported =
                                await HMSCameraControls.isZoomSupported();
                            if (isZoomSupported) {
                              HMSCameraControls.setZoom(zoomValue: 2);
                            }
                          },
                          contentPadding: EdgeInsets.zero,
                          leading: SvgPicture.asset(
                            "packages/hms_room_kit/lib/src/assets/icons/maximize.svg",
                            semanticsLabel: "fl_local_pin_tile",
                            height: 20,
                            width: 20,
                            colorFilter: ColorFilter.mode(
                                HMSThemeColors.onSurfaceHighEmphasis,
                                BlendMode.srcIn),
                          ),
                          title: HMSSubheadingText(
                              text: "Zoom In (2x)",
                              textColor: HMSThemeColors.onSurfaceHighEmphasis)),

                    if (AppDebugConfig.isDebugMode &&
                        widget.meetingStore.isVideoOn)
                      ListTile(
                          horizontalTitleGap: 2,
                          onTap: () async {
                            Navigator.pop(context);
                            HMSCameraControls.resetZoom();
                          },
                          contentPadding: EdgeInsets.zero,
                          leading: SvgPicture.asset(
                            "packages/hms_room_kit/lib/src/assets/icons/minimize.svg",
                            semanticsLabel: "fl_local_pin_tile",
                            height: 20,
                            width: 20,
                            colorFilter: ColorFilter.mode(
                                HMSThemeColors.onSurfaceHighEmphasis,
                                BlendMode.srcIn),
                          ),
                          title: HMSSubheadingText(
                              text: "Reset zoom",
                              textColor: HMSThemeColors.onSurfaceHighEmphasis)),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
