///Package imports
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

///Project imports
import 'package:hms_room_kit/src/widgets/toasts/hms_toasts_type.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/model/participant_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';
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

    bool isHandRaised =
        peer.metadata?.contains("\"isHandRaised\":true") ?? false;
    bool isOnStageRole = meetingStore.getOnStageRole()?.name == peer.role.name;
    bool isOnStageExpPresent = HMSRoomLayout.peerType == PeerRoleType.hlsViewer
        ? HMSRoomLayout.roleLayoutData?.screens?.conferencing?.hlsLiveStreaming
                ?.elements?.onStageExp !=
            null
        : HMSRoomLayout.roleLayoutData?.screens?.conferencing?.defaultConf
                ?.elements?.onStageExp !=
            null;
    return (!peer.isLocal &&
            (changeRolePermission || removePeerPermission || mutePermission))
        ? PopupMenuButton(
            padding: EdgeInsets.zero,
            position: PopupMenuPosition.under,
            color: HMSThemeColors.surfaceDefault,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            onSelected: (int value) async {
              switch (value) {
                case 1:
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
                          }
                        }
                      }
                    }
                  }
                  HMSRole? onStageRole = meetingStore.getOnStageRole();
                  if (onStageRole != null) {
                    meetingStore.changeRoleOfPeer(
                        peer: peer, roleName: onStageRole, forceChange: false);
                    meetingStore.removeToast(HMSToastsType.roleChangeToast,
                        data: peer);
                  }
                  break;
                case 2:
                  if (peerTrackNode?.track == null) {
                    return;
                  }
                  meetingStore.changeTrackState(
                      peerTrackNode!.track!, !peerTrackNode.track!.isMute);
                  break;
                case 3:
                  if (peerTrackNode?.audioTrack == null) {
                    return;
                  }
                  meetingStore.changeTrackState(peerTrackNode!.audioTrack!,
                      !peerTrackNode.audioTrack!.isMute);
                  break;
                case 4:
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
                  if (changeRolePermission && isOnStageExpPresent 
                  && (isHandRaised || isOnStageRole)
                  )
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
                  if (mutePermission &&
                      peerTrackNode != null &&
                      !peerTrackNode.peer.isLocal &&
                      isOnStageRole)
                    PopupMenuItem(
                      value: 2,
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
                      !peerTrackNode.peer.isLocal &&
                      isOnStageRole)
                    PopupMenuItem(
                      value: 3,
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
                      value: 4,
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
              Selector<MeetingStore,
                      Tuple2<Map<String, List<ParticipantsStore>>, int>>(
                  selector: (_, meetingStore) => Tuple2(
                      meetingStore.participantsInMeetingMap,
                      meetingStore.participantsInMeeting),
                  builder: (_, data, __) {
                    return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.item1.keys.length,
                        itemBuilder: (context, index) {
                          String role = data.item1.keys.elementAt(index);
                          return (data.item1[role]?.isNotEmpty ?? false)
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
                                              "${data.item1.keys.elementAt(index)} (${data.item1[role]?.length})",
                                          textColor: HMSThemeColors
                                              .onSurfaceMediumEmphasis,
                                          letterSpacing: 0.1,
                                        ),
                                        children: [
                                          SizedBox(
                                            height: data.item1[role] == null
                                                ? 0
                                                : (data.item1[role]!.length) *
                                                    60,
                                            child: Center(
                                              child: ListView.builder(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount: data.item1[role]
                                                          ?.length ??
                                                      0,
                                                  itemBuilder:
                                                      (context, peerIndex) {
                                                    ParticipantsStore
                                                        currentPeer =
                                                        data.item1[role]![
                                                            peerIndex];
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
                                                                        return HMSTitleText(
                                                                            text:
                                                                                peerName + ((data.item1[role]![peerIndex].peer.isLocal) ? " (You)" : ""),
                                                                            fontSize: 14,
                                                                            lineHeight: 20,
                                                                            letterSpacing: 0.1,
                                                                            textColor: HMSThemeColors.onSurfaceHighEmphasis);
                                                                      }),
                                                                  Row(
                                                                    children: [
                                                                      Selector<
                                                                              ParticipantsStore,
                                                                              int>(
                                                                          selector: (_, participantsStore) => (participantsStore.peer.networkQuality?.quality ??
                                                                              -1),
                                                                          builder: (_,
                                                                              networkQuality,
                                                                              __) {
                                                                            return networkQuality != -1 && networkQuality < 3
                                                                                ? Padding(
                                                                                    padding: const EdgeInsets.only(right: 16.0),
                                                                                    child: CircleAvatar(
                                                                                      radius: 16,
                                                                                      backgroundColor: HMSThemeColors.surfaceDefault,
                                                                                      child: SvgPicture.asset(
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
                                                                          selector: (_, participantsStore) => (participantsStore.peer.metadata?.contains("\"isHandRaised\":true") ??
                                                                              false),
                                                                          builder: (_,
                                                                              isHandRaised,
                                                                              __) {
                                                                            return isHandRaised
                                                                                ? Padding(
                                                                                    padding: const EdgeInsets.only(right: 16.0),
                                                                                    child: CircleAvatar(
                                                                                      radius: 16,
                                                                                      backgroundColor: HMSThemeColors.surfaceDefault,
                                                                                      child: SvgPicture.asset(
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
                                          )
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
