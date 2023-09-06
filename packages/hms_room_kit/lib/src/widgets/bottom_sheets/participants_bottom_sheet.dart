import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hms_room_kit/src/common/app_color.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/app_dialogs/change_role_option_dialog.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

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

    //For HLS-Viewer
    if (peerTrackNode == null) {
      return changeRolePermission
          ? PopupMenuButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: themeSurfaceColor,
              icon: SvgPicture.asset(
                "packages/hms_room_kit/lib/src/assets/icons/more.svg",
                colorFilter:
                    ColorFilter.mode(themeDefaultColor, BlendMode.srcIn),
                fit: BoxFit.scaleDown,
              ),
              onSelected: (int value) async {
                switch (value) {
                  case 1:
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (_) => ChangeRoleOptionDialog(
                              peerName: peer.name,
                              roles: meetingStore.roles,
                              peer: peer,
                              changeRole: (role, forceChange) {
                                meetingStore.changeRoleOfPeer(
                                    peer: peer,
                                    roleName: role,
                                    forceChange: forceChange);
                              },
                            ));
                    break;
                  default:
                    break;
                }
              },
              itemBuilder: ((context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Row(children: [
                        SvgPicture.asset(
                            "packages/hms_room_kit/lib/src/assets/icons/role_change.svg",
                            width: 15,
                            colorFilter: ColorFilter.mode(
                                themeDefaultColor, BlendMode.srcIn)),
                        const SizedBox(
                          width: 12,
                        ),
                        HMSTitleText(
                          text: "Change Role",
                          textColor: themeDefaultColor,
                          fontSize: 14,
                          lineHeight: 20,
                          letterSpacing: 0.25,
                        ),
                      ]),
                    ),
                  ]))
          : const SizedBox();
    }

    return (changeRolePermission || removePeerPermission || mutePermission)
        ? PopupMenuButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: themeSurfaceColor,
            onSelected: (int value) async {
              switch (value) {
                case 1:
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (_) => ChangeRoleOptionDialog(
                            peerName: peerTrackNode!.peer.name,
                            roles: meetingStore.roles,
                            peer: peerTrackNode.peer,
                            changeRole: (role, forceChange) {
                              meetingStore.changeRoleOfPeer(
                                  peer: peerTrackNode!.peer,
                                  roleName: role,
                                  forceChange: forceChange);
                            },
                          ));

                  break;
                case 2:
                  if (peerTrackNode!.track == null) {
                    return;
                  }
                  meetingStore.changeTrackState(
                      peerTrackNode.track!, !peerTrackNode.track!.isMute);
                  break;
                case 3:
                  if (peerTrackNode!.audioTrack == null) {
                    return;
                  }
                  meetingStore.changeTrackState(peerTrackNode.audioTrack!,
                      !peerTrackNode.audioTrack!.isMute);
                  break;
                case 4:
                  var peer = await meetingStore.getPeer(
                      peerId: peerTrackNode!.peer.peerId);
                  if (peer == null) {
                    return;
                  }
                  meetingStore.removePeerFromRoom(peer);
                  break;
                default:
                  break;
              }
            },
            icon: SvgPicture.asset(
              "packages/hms_room_kit/lib/src/assets/icons/more.svg",
              colorFilter: ColorFilter.mode(themeDefaultColor, BlendMode.srcIn),
              fit: BoxFit.scaleDown,
            ),
            itemBuilder: (context) => [
                  if (changeRolePermission)
                    PopupMenuItem(
                      value: 1,
                      child: Row(children: [
                        SvgPicture.asset(
                            "packages/hms_room_kit/lib/src/assets/icons/role_change.svg",
                            width: 15,
                            colorFilter: ColorFilter.mode(
                                themeDefaultColor, BlendMode.srcIn)),
                        const SizedBox(
                          width: 12,
                        ),
                        HMSTitleText(
                          text: "Change Role",
                          textColor: themeDefaultColor,
                          fontSize: 14,
                          lineHeight: 20,
                          letterSpacing: 0.25,
                        ),
                      ]),
                    ),
                  if (mutePermission && !peerTrackNode!.peer.isLocal)
                    PopupMenuItem(
                      value: 2,
                      child: Row(children: [
                        SvgPicture.asset(
                          peerTrackNode.track?.isMute ?? false
                              ? "packages/hms_room_kit/lib/src/assets/icons/cam_state_on.svg"
                              : "packages/hms_room_kit/lib/src/assets/icons/cam_state_off.svg",
                          colorFilter: ColorFilter.mode(
                              themeDefaultColor, BlendMode.srcIn),
                          width: 15,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        HMSTitleText(
                          text:
                              "${peerTrackNode.track?.isMute ?? false ? "Unmute" : "Mute"} Video",
                          textColor: themeDefaultColor,
                          fontSize: 14,
                          lineHeight: 20,
                          letterSpacing: 0.25,
                        ),
                      ]),
                    ),
                  if (mutePermission && !peerTrackNode!.peer.isLocal)
                    PopupMenuItem(
                      value: 3,
                      child: Row(children: [
                        SvgPicture.asset(
                          peerTrackNode.audioTrack?.isMute ?? false
                              ? "packages/hms_room_kit/lib/src/assets/icons/mic_state_on.svg"
                              : "packages/hms_room_kit/lib/src/assets/icons/mic_state_off.svg",
                          colorFilter: ColorFilter.mode(
                              themeDefaultColor, BlendMode.srcIn),
                          width: 15,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        HMSTitleText(
                          text:
                              "${peerTrackNode.audioTrack?.isMute ?? false ? "Unmute" : "Mute"} Audio",
                          textColor: themeDefaultColor,
                          fontSize: 14,
                          lineHeight: 20,
                          letterSpacing: 0.25,
                        ),
                      ]),
                    ),
                  if (removePeerPermission && !peerTrackNode!.peer.isLocal)
                    PopupMenuItem(
                      value: 4,
                      child: Row(children: [
                        SvgPicture.asset(
                            "packages/hms_room_kit/lib/src/assets/icons/peer_remove.svg",
                            width: 15,
                            colorFilter: ColorFilter.mode(
                                themeDefaultColor, BlendMode.srcIn)),
                        const SizedBox(
                          width: 12,
                        ),
                        HMSTitleText(
                          text: "Remove Peer",
                          textColor: themeDefaultColor,
                          fontSize: 14,
                          lineHeight: 20,
                          letterSpacing: 0.25,
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
        padding: const EdgeInsets.only(top:16),
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
              Selector<MeetingStore, Tuple2<Map<String, List<HMSPeer>>, int>>(
                  selector: (_, meetingStore) => Tuple2(
                      meetingStore.filteredPeers,
                      meetingStore.filteredPeers.values.length),
                  builder: (_, data, __) {
                    return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.item1.keys.length,
                        itemBuilder: (context, index) {
                          String role = data.item1.keys.elementAt(index);
                          return 
                          (data.item1[role]?.isNotEmpty??false)?
                          Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: ExpansionTile(
                                  tilePadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 0),
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: HMSThemeColors.borderDefault,
                                          width: 1),
                                      borderRadius: BorderRadius.circular(8)),
                                  collapsedShape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: HMSThemeColors.borderDefault,
                                          width: 1),
                                      borderRadius: BorderRadius.circular(8)),
                                  collapsedIconColor:
                                      HMSThemeColors.onSurfaceHighEmphasis,
                                  iconColor:
                                      HMSThemeColors.onSurfaceHighEmphasis,
                                  title: HMSSubheadingText(
                                    text:
                                        "${data.item1.keys.elementAt(index)} (${data.item1[role]?.length})",
                                    textColor: HMSThemeColors
                                        .onSurfaceMediumEmphasis,
                                    letterSpacing: 0.1,
                                  ),
                                  children: [
                                    SizedBox(
                                      height:
                                          (data.item1[role]?.length ?? 0) *
                                              48,
                                      child: ListView.builder(
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount:
                                              data.item1[role]?.length ?? 0,
                                          itemBuilder: (context, peerIndex) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                peerIndex != 0
                                                    ? const SizedBox(
                                                        height: 8,
                                                      )
                                                    : Divider(
                                                        height: 5,
                                                        color: HMSThemeColors
                                                            .borderDefault,
                                                      ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .fromLTRB(
                                                      16, 8, 16, 16),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      HMSTitleText(
                                                          text: (data
                                                              .item1[role]![
                                                                  peerIndex]
                                                              .name),
                                                          fontSize: 14,
                                                          lineHeight: 20,
                                                          letterSpacing: 0.1,
                                                          textColor:
                                                              HMSThemeColors
                                                                  .onSurfaceHighEmphasis),
                                                      Row(
                                                        children: [
                                                          PopupMenuButton(
                                                            color: HMSThemeColors
                                                                .surfaceDefault,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                            itemBuilder:
                                                                (context) {
                                                              return List
                                                                  .generate(1,
                                                                      (index) {
                                                                return PopupMenuItem(
                                                                    height:
                                                                        52,
                                                                    child:
                                                                        Row(
                                                                      children: [
                                                                        SvgPicture
                                                                            .asset(
                                                                          "packages/hms_room_kit/lib/src/assets/icons/change_role.svg",
                                                                          height:
                                                                              20,
                                                                          width:
                                                                              20,
                                                                          colorFilter:
                                                                              ColorFilter.mode(HMSThemeColors.onSurfaceMediumEmphasis, BlendMode.srcIn),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              8,
                                                                        ),
                                                                        HMSTitleText(
                                                                          text:
                                                                              "Change Role",
                                                                          fontSize:
                                                                              14,
                                                                          lineHeight:
                                                                              20,
                                                                          letterSpacing:
                                                                              0.1,
                                                                          textColor:
                                                                              HMSThemeColors.onSurfaceHighEmphasis,
                                                                        )
                                                                      ],
                                                                    ),
                                                                    onTap: () =>
                                                                        {});
                                                              });
                                                            },
                                                            child: SvgPicture
                                                                .asset(
                                                              "packages/hms_room_kit/lib/src/assets/icons/more.svg",
                                                              height: 20,
                                                              width: 20,
                                                              colorFilter: ColorFilter.mode(
                                                                  HMSThemeColors
                                                                      .onSurfaceMediumEmphasis,
                                                                  BlendMode
                                                                      .srcIn),
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              )
                            ],
                          ):const SizedBox();
                        });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
