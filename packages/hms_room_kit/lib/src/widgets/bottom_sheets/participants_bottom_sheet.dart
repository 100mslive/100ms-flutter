library;

///Dart imports
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/change_role_bottom_sheet.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toasts_type.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/model/participant_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/participants_view_all_bottom_sheet.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';

///[ParticipantsBottomSheet] is the bottom sheet that is shown when the user
///clicks on the participants button
class ParticipantsBottomSheet extends StatefulWidget {
  const ParticipantsBottomSheet({super.key});

  @override
  State<ParticipantsBottomSheet> createState() =>
      _ParticipantsBottomSheetState();
}

class _ParticipantsBottomSheetState extends State<ParticipantsBottomSheet> {
  Timer? timer;
  bool isLargeRoom = false;

  @override
  void initState() {
    super.initState();

    isLargeRoom = context.read<MeetingStore>().hmsRoom?.isLarge ?? false;
    if (isLargeRoom) {
      timer = Timer.periodic(const Duration(seconds: 5),
          (Timer t) => context.read<MeetingStore>().refreshPeerList());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void viewAll(String role) {
    var meetingStore = context.read<MeetingStore>();
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: HMSThemeColors.surfaceDim,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      context: context,
      builder: (ctx) => ChangeNotifierProvider.value(
          value: meetingStore,
          child: ParticipantsViewAllBottomSheet(role: role)),
    );
  }

  bool isHandRaisedRow(String role) {
    return role == "Hand Raised";
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

                  ///This is called when someone clicks on switch Role
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
                        value: meetingStore,
                        child: Padding(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(ctx).viewInsets.bottom),
                            child: ChangeRoleBottomSheet(
                                peerName: peer.name,
                                roles: meetingStore.roles,
                                peer: peer,
                                changeRole: (newRole, isForceChange) =>
                                    meetingStore.changeRoleOfPeer(
                                        peer: peer,
                                        roleName: newRole,
                                        forceChange: true)))),
                  );
                case 6:

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
                      !peerTrackNode.peer.isLocal &&
                      peerTrackNode.peer.type == HMSPeerType.regular)
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
                  if (changeRolePermission && meetingStore.roles.length > 1)
                    PopupMenuItem(
                      value: 5,
                      child: Row(children: [
                        SvgPicture.asset(
                            "packages/hms_room_kit/lib/src/assets/icons/peer_settings.svg",
                            colorFilter: ColorFilter.mode(
                                HMSThemeColors.onSurfaceHighEmphasis,
                                BlendMode.srcIn)),
                        const SizedBox(
                          width: 8,
                        ),
                        HMSTitleText(
                          text: "Switch Role",
                          textColor: HMSThemeColors.onSurfaceHighEmphasis,
                          fontSize: 14,
                          lineHeight: 20,
                          letterSpacing: 0.1,
                        ),
                      ]),
                    ),
                  if (removePeerPermission)
                    PopupMenuItem(
                      value: 6,
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Need to add search bar
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 16.0),
              //   child: Container(
              //     height: 40,
              //     width: MediaQuery.of(context).size.width - 32,
              //     color: HMSThemeColors.surfaceDefault,
              //     child: TextField(),
              //   ),
              // ),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: context
                      .read<MeetingStore>()
                      .participantsInMeetingMap
                      .keys
                      .length,
                  itemBuilder: (context, index) {
                    String role = context
                        .read<MeetingStore>()
                        .participantsInMeetingMap
                        .keys
                        .elementAt(index);
                    return Selector<MeetingStore,
                            Tuple3<int, List<ParticipantsStore>?, String>>(
                        selector: (_, meetingStore) => Tuple3(
                            meetingStore
                                    .participantsInMeetingMap[role]?.length ??
                                0,
                            meetingStore.participantsInMeetingMap[role],
                            role),
                        builder: (_, participantsPerRole, __) {
                          return (participantsPerRole.item2?.isNotEmpty ??
                                  false)
                              ? Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: ExpansionTile(
                                        childrenPadding: EdgeInsets.zero,
                                        tilePadding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 0),
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: HMSThemeColors
                                                    .borderDefault,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        collapsedShape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: HMSThemeColors
                                                    .borderDefault,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        collapsedIconColor: HMSThemeColors
                                            .onSurfaceHighEmphasis,
                                        iconColor: HMSThemeColors
                                            .onSurfaceHighEmphasis,
                                        title: HMSSubheadingText(
                                          text:
                                              "${context.read<MeetingStore>().participantsInMeetingMap.keys.elementAt(index)} (${((HMSRoomLayout.offStageRoles?.contains(role) ?? false) && isLargeRoom) ? context.read<MeetingStore>().peerListIterators[role]?.totalCount ?? 0 : participantsPerRole.item1}) ",
                                          textColor: HMSThemeColors
                                              .onSurfaceMediumEmphasis,
                                          letterSpacing: 0.1,
                                        ),
                                        children: [
                                          SizedBox(
                                            height: participantsPerRole.item2 ==
                                                    null
                                                ? 0
                                                : (participantsPerRole.item1) *
                                                    (isHandRaisedRow(role)
                                                        ? 60
                                                        : 54),
                                            child: Center(
                                              child: ListView.builder(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount:
                                                      participantsPerRole.item1,
                                                  itemBuilder:
                                                      (context, peerIndex) {
                                                    ParticipantsStore
                                                        currentPeer =
                                                        participantsPerRole
                                                            .item2![peerIndex];
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          peerIndex != 0
                                                              ? const SizedBox()
                                                              : Divider(
                                                                  height: 5,
                                                                  color: HMSThemeColors
                                                                      .borderDefault,
                                                                ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    16,
                                                                    8,
                                                                    16,
                                                                    16),
                                                            child:
                                                                ListenableProvider
                                                                    .value(
                                                              value:
                                                                  currentPeer,
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
                                                                              .peer
                                                                              .name,
                                                                      builder: (_,
                                                                          peerName,
                                                                          __) {
                                                                        return Container(
                                                                          constraints:
                                                                              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
                                                                          child: HMSTitleText(
                                                                              text: peerName + ((participantsPerRole.item2![peerIndex].peer.isLocal) ? " (You)" : ""),
                                                                              fontSize: 14,
                                                                              lineHeight: 20,
                                                                              letterSpacing: 0.1,
                                                                              textColor: HMSThemeColors.onSurfaceHighEmphasis),
                                                                        );
                                                                      }),

                                                                  ///This contains the network quality, hand raise icon and kebab menu
                                                                  Row(
                                                                    children: [
                                                                      Selector<
                                                                              ParticipantsStore,
                                                                              bool>(
                                                                          builder: (_,
                                                                              isSIPPeer,
                                                                              __) {
                                                                            return isSIPPeer
                                                                                ? Padding(
                                                                                    padding: const EdgeInsets.only(right: 4.0),
                                                                                    child: CircleAvatar(
                                                                                        radius: 12,
                                                                                        backgroundColor: HMSThemeColors.surfaceDefault,
                                                                                        child: SvgPicture.asset(
                                                                                          "packages/hms_room_kit/lib/src/assets/icons/sip_call.svg",
                                                                                          height: 12,
                                                                                          width: 12,
                                                                                          colorFilter: ColorFilter.mode(HMSThemeColors.onSurfaceHighEmphasis, BlendMode.srcIn),
                                                                                        )),
                                                                                  )
                                                                                : const SizedBox();
                                                                          },
                                                                          selector: (_, participantsStore) =>
                                                                              participantsStore.peer.type ==
                                                                              HMSPeerType.sip),
                                                                      Selector<
                                                                              ParticipantsStore,
                                                                              Tuple2<int,
                                                                                  bool>>(
                                                                          selector: (_, participantsStore) => Tuple2(
                                                                              participantsStore.peer.networkQuality?.quality ?? -1,
                                                                              participantsStore.peer.type != HMSPeerType.sip),
                                                                          builder: (_, participantData, __) {
                                                                            return participantData.item1 != -1 && participantData.item1 < 3 && participantData.item2
                                                                                ? Padding(
                                                                                    padding: const EdgeInsets.only(right: 4.0),
                                                                                    child: CircleAvatar(
                                                                                      radius: 12,
                                                                                      backgroundColor: HMSThemeColors.surfaceDefault,
                                                                                      child: SvgPicture.asset(
                                                                                        "packages/hms_room_kit/lib/src/assets/icons/network_${participantData.item1}.svg",
                                                                                        height: 12,
                                                                                        width: 12,
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                : const SizedBox();
                                                                          }),
                                                                      Selector<
                                                                              ParticipantsStore,
                                                                              bool>(
                                                                          selector: (_, participantsStore) => (participantsStore
                                                                              .peer
                                                                              .isHandRaised),
                                                                          builder: (_,
                                                                              isHandRaised,
                                                                              __) {
                                                                            return isHandRaised
                                                                                ? Padding(
                                                                                    padding: const EdgeInsets.only(right: 16.0),
                                                                                    child: CircleAvatar(
                                                                                      radius: 12,
                                                                                      backgroundColor: HMSThemeColors.surfaceDefault,
                                                                                      child: SvgPicture.asset(
                                                                                        "packages/hms_room_kit/lib/src/assets/icons/hand_outline.svg",
                                                                                        height: 12,
                                                                                        width: 12,
                                                                                        colorFilter: ColorFilter.mode(HMSThemeColors.onSurfaceHighEmphasis, BlendMode.srcIn),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                : const SizedBox();
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
                                          ),
                                          if ((HMSRoomLayout.offStageRoles
                                                      ?.contains(role) ??
                                                  false) &&
                                              ((context
                                                          .read<MeetingStore>()
                                                          .peerListIterators[
                                                              role]
                                                          ?.totalCount ??
                                                      0) >
                                                  10))
                                            Column(
                                              children: [
                                                Divider(
                                                  height: 5,
                                                  color: HMSThemeColors
                                                      .borderDefault,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          16, 12, 16, 12),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      viewAll(role);
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            HMSSubheadingText(
                                                                text:
                                                                    "View All",
                                                                textColor:
                                                                    HMSThemeColors
                                                                        .onSurfaceHighEmphasis),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          4.0),
                                                              child: SvgPicture.asset(
                                                                  "packages/hms_room_kit/lib/src/assets/icons/right_arrow.svg",
                                                                  width: 24,
                                                                  height: 24,
                                                                  colorFilter: ColorFilter.mode(
                                                                      HMSThemeColors
                                                                          .onSurfaceHighEmphasis,
                                                                      BlendMode
                                                                          .srcIn)),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    )
                                  ],
                                )
                              : const SizedBox();
                        });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
