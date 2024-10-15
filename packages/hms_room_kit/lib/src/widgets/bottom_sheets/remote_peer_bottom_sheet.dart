library;

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/change_role_bottom_sheet.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_cross_button.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

///[RemotePeerBottomSheet] is a widget that is used to render the bottom sheet for remote peers
///This bottom sheet is shown when the more option button is clicked on a remote peer tile
class RemotePeerBottomSheet extends StatefulWidget {
  final MeetingStore meetingStore;
  final PeerTrackNode peerTrackNode;

  const RemotePeerBottomSheet(
      {Key? key, required this.meetingStore, required this.peerTrackNode})
      : super(key: key);
  @override
  State<RemotePeerBottomSheet> createState() => _RemotePeerBottomSheetState();
}

class _RemotePeerBottomSheetState extends State<RemotePeerBottomSheet> {
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
      heightFactor: 0.35,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ///We render a Column with the name and role of the peer
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width - 100),
                          child: HMSTitleText(
                            text: widget.peerTrackNode.peer.name,
                            textColor: HMSThemeColors.onSurfaceHighEmphasis,
                            letterSpacing: 0.15,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        HMSSubtitleText(
                            text: widget.peerTrackNode.peer.role.name,
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
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Divider(
              color: HMSThemeColors.borderDefault,
              height: 5,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),

              ///We render a list view with the following options
              ///1. Pin Tile for Myself
              ///2. Spotlight Tile for Everyone
              ///3. Mute/Unmute Audio
              ///4. Mute/Unmute Video
              ///5. Volume
              ///6. Remove Participant
              child: ListView(
                children: [
                  // ListTile(
                  //     horizontalTitleGap: 1,
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

                  if ((widget.meetingStore.localPeer?.role.permissions.mute ??
                      false))
                    ListTile(
                        horizontalTitleGap: 2,
                        onTap: () async {
                          Navigator.pop(context);
                          if (widget.peerTrackNode.audioTrack != null) {
                            widget.meetingStore.changeTrackState(
                                widget.peerTrackNode.audioTrack!,
                                !(widget.peerTrackNode.audioTrack!.isMute));
                          }
                        },
                        contentPadding: EdgeInsets.zero,
                        leading: SvgPicture.asset(
                          "packages/hms_room_kit/lib/src/assets/icons/${(widget.peerTrackNode.audioTrack?.isMute ?? true) ? "mic_state_on" : "mic_state_off"}.svg",
                          semanticsLabel: "fl_mic_toggle",
                          height: 20,
                          width: 20,
                          colorFilter: ColorFilter.mode(
                              widget.peerTrackNode.audioTrack == null
                                  ? HMSThemeColors.onSurfaceLowEmphasis
                                  : HMSThemeColors.onSurfaceHighEmphasis,
                              BlendMode.srcIn),
                        ),
                        title: HMSSubheadingText(
                            text:
                                "${(widget.peerTrackNode.audioTrack?.isMute ?? true) ? "Unmute" : "Mute"} Audio",
                            textColor: widget.peerTrackNode.audioTrack == null
                                ? HMSThemeColors.onSurfaceLowEmphasis
                                : HMSThemeColors.onSurfaceHighEmphasis)),

                  if ((widget.meetingStore.localPeer?.role.permissions.mute ??
                          false) &&
                      widget.peerTrackNode.peer.type == HMSPeerType.regular)
                    ListTile(
                        horizontalTitleGap: 2,
                        onTap: () async {
                          Navigator.pop(context);
                          if (widget.peerTrackNode.track != null) {
                            widget.meetingStore.changeTrackState(
                                widget.peerTrackNode.track!,
                                !(widget.peerTrackNode.track!.isMute));
                          }
                        },
                        contentPadding: EdgeInsets.zero,
                        leading: SvgPicture.asset(
                          "packages/hms_room_kit/lib/src/assets/icons/${(widget.peerTrackNode.track?.isMute ?? true) ? "cam_state_on" : "cam_state_off"}.svg",
                          semanticsLabel: "fl_camera_toggle",
                          height: 20,
                          width: 20,
                          colorFilter: ColorFilter.mode(
                              widget.peerTrackNode.track == null
                                  ? HMSThemeColors.onSurfaceLowEmphasis
                                  : HMSThemeColors.onSurfaceHighEmphasis,
                              BlendMode.srcIn),
                        ),
                        title: HMSSubheadingText(
                            text:
                                "${(widget.peerTrackNode.track?.isMute ?? true) ? "Unmute" : "Mute"} Video",
                            textColor: widget.peerTrackNode.track == null
                                ? HMSThemeColors.onSurfaceLowEmphasis
                                : HMSThemeColors.onSurfaceHighEmphasis)),
                  if ((widget.meetingStore.localPeer?.role.permissions
                              .changeRole ??
                          false) &&
                      (widget.meetingStore.roles.length > 1))
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
                                    child: ChangeRoleBottomSheet(
                                        peerName:
                                            widget.peerTrackNode.peer.name,
                                        roles: widget.meetingStore.roles,
                                        peer: widget.peerTrackNode.peer,
                                        changeRole: (newRole, isForceChange) =>
                                            widget.meetingStore
                                                .changeRoleOfPeer(
                                                    peer: widget
                                                        .peerTrackNode.peer,
                                                    roleName: newRole,
                                                    forceChange:
                                                        isForceChange)))),
                          );
                        },
                        contentPadding: EdgeInsets.zero,
                        leading: SvgPicture.asset(
                          "packages/hms_room_kit/lib/src/assets/icons/peer_settings.svg",
                          semanticsLabel: "fl_change_role",
                          colorFilter: ColorFilter.mode(
                              HMSThemeColors.onSurfaceHighEmphasis,
                              BlendMode.srcIn),
                        ),
                        title: HMSSubheadingText(
                            text: "Switch Role",
                            textColor: HMSThemeColors.onSurfaceHighEmphasis)),
                  // ListTile(
                  //     horizontalTitleGap: 2,
                  //     onTap: () async {
                  //       Navigator.pop(context);
                  //     },
                  //     contentPadding: EdgeInsets.zero,
                  //     leading: SvgPicture.asset(
                  //       "packages/hms_room_kit/lib/src/assets/icons/speaker_state_on.svg",
                  //       semanticsLabel: "fl_change_volume",
                  //       height: 20,
                  //       width: 20,
                  //       colorFilter: ColorFilter.mode(
                  //           HMSThemeColors.onSurfaceHighEmphasis,
                  //           BlendMode.srcIn),
                  //     ),
                  //     title: HMSSubheadingText(
                  //         text: "Volume",
                  //         textColor: HMSThemeColors.onSurfaceHighEmphasis)),
                  if (widget.meetingStore.localPeer?.role.permissions
                          .removeOthers ??
                      false)
                    ListTile(
                        horizontalTitleGap: 2,
                        onTap: () async {
                          Navigator.pop(context);
                          widget.meetingStore
                              .removePeerFromRoom(widget.peerTrackNode.peer);
                        },
                        contentPadding: EdgeInsets.zero,
                        leading: SvgPicture.asset(
                          "packages/hms_room_kit/lib/src/assets/icons/peer_remove.svg",
                          semanticsLabel: "fl_remove_peer",
                          height: 20,
                          width: 20,
                          colorFilter: ColorFilter.mode(
                              HMSThemeColors.alertErrorDefault,
                              BlendMode.srcIn),
                        ),
                        title: HMSSubheadingText(
                            text: "Remove Participant",
                            textColor: HMSThemeColors.alertErrorDefault)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
