///Dart imports
library;

import 'dart:convert';
import 'dart:developer';

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/model/participant_store.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_cross_button.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toasts_type.dart';

///[ParticipantsViewAllBottomSheet] is a bottom sheet that is used to show all the participants of viewer groups for large rooms
///This uses the [peerListIterator] next method to get the next set of peers
class ParticipantsViewAllBottomSheet extends StatefulWidget {
  final String role;

  const ParticipantsViewAllBottomSheet({Key? key, required this.role})
      : super(key: key);

  @override
  State<ParticipantsViewAllBottomSheet> createState() =>
      _ParticipantsViewAllBottomSheetState();
}

class _ParticipantsViewAllBottomSheetState
    extends State<ParticipantsViewAllBottomSheet> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<MeetingStore>().disableRefresh();
    context.read<MeetingStore>().addBottomSheet(context);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        context.read<MeetingStore>().nextPeersForRole(widget.role);
      }
    });
  }

  @override
  void deactivate() {
    context.read<MeetingStore>().removeBottomSheet(context);
    super.deactivate();
  }

  Widget _kebabMenu(HMSPeer peer) {
    final meetingStore = context.read<MeetingStore>();
    PeerTrackNode? peerTrackNode;
    try {
      peerTrackNode = meetingStore.peerTracks
          .firstWhere((element) => element.uid == "${peer.peerId}mainVideo");
    } catch (e) {
      peerTrackNode = null;
    }

    bool mutePermission =
        meetingStore.localPeer?.role.permissions.mute ?? false;
    bool removePeerPermission =
        meetingStore.localPeer?.role.permissions.removeOthers ?? false;
    bool changeRolePermission =
        meetingStore.localPeer?.role.permissions.changeRole ?? false;
    bool isOnStageRole = meetingStore.getOnStageRole()?.name == peer.role.name;
    bool isOnStageExpPresent = HMSRoomLayout.peerType == PeerRoleType.hlsViewer
        ? HMSRoomLayout.roleLayoutData?.screens?.conferencing?.hlsLiveStreaming
                ?.elements?.onStageExp !=
            null
        : HMSRoomLayout.roleLayoutData?.screens?.conferencing?.defaultConf
                ?.elements?.onStageExp !=
            null;
    bool isOffStageRole = meetingStore.isOffStageRole(peer.role.name);

    ///Here we check whether to show three dots or not
    ///We show three dots if the peer is not local
    ///and the local peer has any of the following permissions:
    ///changeRole, removeOthers, mute/unmute others
    return (!peer.isLocal &&
            (changeRolePermission || removePeerPermission || mutePermission))
        ? PopupMenuButton(
            padding: EdgeInsets.zero,
            position: PopupMenuPosition.under,
            color: HMSThemeColors.surfaceDefault,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            onSelected: (int value) async {
              ///Here we have defined the functions to be executed on clicking the options
              switch (value) {
                case 1:

                  ///If the peer is onStage already we show the option to remove from stage
                  ///and the peer's role is changed to it's previous role
                  ///
                  ///If the peer is offStage we show the option to bring on stage
                  ///and the peer 's role is changed to offStageRole from layout api
                  ///We also update the peer metadata with the previous role
                  ///which will be used while removing the peer from stage
                  if (isOnStageRole) {
                    if (peer.metadata != null) {
                      String? peerMetadata = peer.metadata;
                      if (peerMetadata?.contains("prevRole") ?? false) {
                        String? previousRole =
                            jsonDecode(peer.metadata!)["prevRole"];
                        if (previousRole != null) {
                          try {
                            HMSRole? offStageRole = meetingStore.roles
                                .firstWhere(
                                    (element) => element.name == previousRole);
                            meetingStore.changeRoleOfPeer(
                                peer: peer,
                                roleName: offStageRole,
                                forceChange: true);
                            return;
                          } catch (e) {
                            log(e.toString());
                            return;
                          }
                        }
                      }
                    }
                  }
                  HMSRole? onStageRole = meetingStore.getOnStageRole();
                  if (onStageRole != null) {
                    meetingStore.changeRoleOfPeer(
                        peer: peer,
                        roleName: onStageRole,
                        forceChange: HMSRoomLayout.skipPreviewForRole);
                    meetingStore.removeToast(HMSToastsType.roleChangeToast,
                        data: peer);
                  }
                  break;
                case 2:

                  ///Here we lower the remote peer hand
                  meetingStore.lowerRemotePeerHand(peer);
                  break;
                case 3:

                  ///Here we check whether the video track is null or not
                  if (peerTrackNode?.track == null) {
                    return;
                  }
                  meetingStore.changeTrackState(
                      peerTrackNode!.track!, !peerTrackNode.track!.isMute);
                  break;
                case 4:

                  ///Here we check whether the audio track is null or not
                  if (peerTrackNode?.audioTrack == null) {
                    return;
                  }
                  meetingStore.changeTrackState(peerTrackNode!.audioTrack!,
                      !peerTrackNode.audioTrack!.isMute);
                  break;
                case 5:

                  ///This is called when someone clicks on remove Participant
                  meetingStore.removePeerFromRoom(peer);
                  break;
                default:
                  break;
              }
            },
            child: Icon(
              Icons.more_vert_rounded,
              size: 20,
              color: HMSThemeColors.onSurfaceHighEmphasis,
            ),
            itemBuilder: (context) => [
                  if (changeRolePermission &&
                      isOnStageExpPresent &&
                      (isOffStageRole || isOnStageRole))
                    PopupMenuItem(
                      value: 1,
                      child: Row(children: [
                        SvgPicture.asset(
                            "packages/hms_room_kit/lib/src/assets/icons/change_role.svg",
                            width: 20,
                            height: 20,
                            colorFilter: ColorFilter.mode(
                                HMSThemeColors.onSurfaceHighEmphasis,
                                BlendMode.srcIn)),
                        const SizedBox(
                          width: 8,
                        ),
                        HMSTitleText(
                          text: isOnStageRole
                              ? "Remove from Stage"
                              : "Bring on Stage",
                          textColor: HMSThemeColors.onSurfaceHighEmphasis,
                          fontSize: 14,
                          lineHeight: 20,
                          letterSpacing: 0.1,
                        ),
                      ]),
                    ),
                  if (peer.isHandRaised)
                    PopupMenuItem(
                      value: 2,
                      child: Row(children: [
                        SvgPicture.asset(
                            "packages/hms_room_kit/lib/src/assets/icons/lower_hand.svg",
                            width: 18,
                            height: 18,
                            colorFilter: ColorFilter.mode(
                                HMSThemeColors.onSurfaceHighEmphasis,
                                BlendMode.srcIn)),
                        const SizedBox(
                          width: 8,
                        ),
                        HMSTitleText(
                          text: "Lower Hand",
                          textColor: HMSThemeColors.onSurfaceHighEmphasis,
                          fontSize: 14,
                          lineHeight: 20,
                          letterSpacing: 0.1,
                        ),
                      ]),
                    ),
                  if (mutePermission &&
                      peerTrackNode != null &&
                      !peerTrackNode.peer.isLocal)
                    PopupMenuItem(
                      value: 3,
                      child: Row(children: [
                        SvgPicture.asset(
                          peerTrackNode.track?.isMute ?? false
                              ? "packages/hms_room_kit/lib/src/assets/icons/cam_state_on.svg"
                              : "packages/hms_room_kit/lib/src/assets/icons/cam_state_off.svg",
                          colorFilter: ColorFilter.mode(
                              HMSThemeColors.onSurfaceHighEmphasis,
                              BlendMode.srcIn),
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        HMSTitleText(
                          text:
                              "${peerTrackNode.track?.isMute ?? false ? "Unmute" : "Mute"} Video",
                          textColor: HMSThemeColors.onSurfaceHighEmphasis,
                          fontSize: 14,
                          lineHeight: 20,
                          letterSpacing: 0.1,
                        ),
                      ]),
                    ),
                  if (mutePermission &&
                      peerTrackNode != null &&
                      !peerTrackNode.peer.isLocal)
                    PopupMenuItem(
                      value: 4,
                      child: Row(children: [
                        SvgPicture.asset(
                          peerTrackNode.audioTrack?.isMute ?? false
                              ? "packages/hms_room_kit/lib/src/assets/icons/mic_state_on.svg"
                              : "packages/hms_room_kit/lib/src/assets/icons/mic_state_off.svg",
                          colorFilter: ColorFilter.mode(
                              HMSThemeColors.onSurfaceHighEmphasis,
                              BlendMode.srcIn),
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        HMSTitleText(
                          text:
                              "${peerTrackNode.audioTrack?.isMute ?? false ? "Unmute" : "Mute"} Audio",
                          textColor: HMSThemeColors.onSurfaceHighEmphasis,
                          fontSize: 14,
                          lineHeight: 20,
                          letterSpacing: 0.1,
                        ),
                      ]),
                    ),
                  if (removePeerPermission)
                    PopupMenuItem(
                      value: 5,
                      child: Row(children: [
                        SvgPicture.asset(
                            "packages/hms_room_kit/lib/src/assets/icons/peer_remove.svg",
                            width: 20,
                            height: 20,
                            colorFilter: ColorFilter.mode(
                                HMSThemeColors.alertErrorDefault,
                                BlendMode.srcIn)),
                        const SizedBox(
                          width: 8,
                        ),
                        HMSTitleText(
                          text: "Remove Participant",
                          textColor: HMSThemeColors.alertErrorDefault,
                          fontSize: 14,
                          lineHeight: 20,
                          letterSpacing: 0.1,
                        ),
                      ]),
                    ),
                ])
        : const SizedBox();
  }

  void resetData() {
    context.read<MeetingStore>().enableRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        resetData();
        return true;
      },
      child: SafeArea(
          child: FractionallySizedBox(
        heightFactor: 0.6,
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 16, right: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          resetData();
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(
                            "packages/hms_room_kit/lib/src/assets/icons/left_arrow.svg",
                            width: 24,
                            height: 24,
                            colorFilter: ColorFilter.mode(
                                HMSThemeColors.onSurfaceHighEmphasis,
                                BlendMode.srcIn)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: HMSTitleText(
                          text: "Participants",
                          letterSpacing: 0.15,
                          textColor: HMSThemeColors.onSurfaceHighEmphasis,
                        ),
                      ),
                    ],
                  ),
                  HMSCrossButton(onPressed: () => resetData()),
                ],
              ),
              Expanded(
                child:
                    Selector<MeetingStore,
                            Tuple2<Map<String, List<ParticipantsStore>>, int>>(
                        selector: (_, meetingStore) => Tuple2(
                            meetingStore.participantsInMeetingMap,
                            meetingStore.participantsInMeeting),
                        builder: (_, data, __) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  border: Border.fromBorderSide(
                                    BorderSide(
                                        color: HMSThemeColors.borderDefault,
                                        width: 1),
                                  )),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 12),
                                        child: HMSSubheadingText(
                                          fontWeight: FontWeight.w600,
                                          text: widget.role,
                                          textColor: HMSThemeColors
                                              .onSurfaceMediumEmphasis,
                                          letterSpacing: 0.1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    height: 5,
                                    color: HMSThemeColors.borderDefault,
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                        controller: _scrollController,

                                        ///We apply the check for showing loader here
                                        itemCount: (data.item1[widget.role]
                                                    ?.length ??
                                                0) +
                                            ((context
                                                            .read<
                                                                MeetingStore>()
                                                            .peerListIterators[
                                                                widget.role]
                                                            ?.totalCount ??
                                                        0) >
                                                    (data.item1[widget.role]
                                                            ?.length ??
                                                        0)
                                                ? 1
                                                : 0),
                                        itemBuilder: (context, peerIndex) {
                                          if (peerIndex ==
                                              data.item1[widget.role]?.length) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2.0),
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 1,
                                                  color: HMSThemeColors
                                                      .primaryDefault,
                                                ),
                                              ),
                                            );
                                          }
                                          ParticipantsStore currentPeer = data
                                              .item1[widget.role]![peerIndex];
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          16, 8, 16, 16),
                                                  child:
                                                      ListenableProvider.value(
                                                    value: currentPeer,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Selector<
                                                                ParticipantsStore,
                                                                String>(
                                                            selector: (_,
                                                                    participantsStore) =>
                                                                participantsStore
                                                                    .peer.name,
                                                            builder: (_,
                                                                peerName, __) {
                                                              return HMSTitleText(
                                                                  text: peerName +
                                                                      ((data.item1[widget.role]![peerIndex].peer.isLocal)
                                                                          ? " (You)"
                                                                          : ""),
                                                                  fontSize: 14,
                                                                  lineHeight:
                                                                      20,
                                                                  letterSpacing:
                                                                      0.1,
                                                                  textColor:
                                                                      HMSThemeColors
                                                                          .onSurfaceHighEmphasis);
                                                            }),

                                                        ///This contains the network quality, hand raise icon and kebab menu
                                                        Row(
                                                          children: [
                                                            Selector<
                                                                    ParticipantsStore,
                                                                    int>(
                                                                selector: (_,
                                                                        participantsStore) =>
                                                                    (participantsStore
                                                                            .peer
                                                                            .networkQuality
                                                                            ?.quality ??
                                                                        -1),
                                                                builder: (_,
                                                                    networkQuality,
                                                                    __) {
                                                                  return networkQuality !=
                                                                              -1 &&
                                                                          networkQuality <
                                                                              3
                                                                      ? Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              right: 16.0),
                                                                          child:
                                                                              CircleAvatar(
                                                                            radius:
                                                                                16,
                                                                            backgroundColor:
                                                                                HMSThemeColors.surfaceDefault,
                                                                            child:
                                                                                SvgPicture.asset(
                                                                              "packages/hms_room_kit/lib/src/assets/icons/network_$networkQuality.svg",
                                                                              height: 16,
                                                                              width: 16,
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Container();
                                                                }),
                                                            Selector<
                                                                    ParticipantsStore,
                                                                    bool>(
                                                                selector: (_,
                                                                        participantsStore) =>
                                                                    (participantsStore
                                                                        .peer
                                                                        .isHandRaised),
                                                                builder: (_,
                                                                    isHandRaised,
                                                                    __) {
                                                                  return isHandRaised
                                                                      ? Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              right: 16.0),
                                                                          child:
                                                                              CircleAvatar(
                                                                            radius:
                                                                                16,
                                                                            backgroundColor:
                                                                                HMSThemeColors.surfaceDefault,
                                                                            child:
                                                                                SvgPicture.asset(
                                                                              "packages/hms_room_kit/lib/src/assets/icons/hand_outline.svg",
                                                                              height: 16,
                                                                              width: 16,
                                                                              colorFilter: ColorFilter.mode(HMSThemeColors.onSurfaceHighEmphasis, BlendMode.srcIn),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Container();
                                                                }),
                                                            _kebabMenu(
                                                                currentPeer
                                                                    .peer)
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
              )
            ],
          ),
        ),
      )),
    );
  }
}
