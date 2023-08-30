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
  String valueChoose = "Everyone";

  void _updateDropDownValue(dynamic newValue) {
    // context.read<MeetingStore>().getFilteredList(newValue);
    context.read<MeetingStore>().selectedRoleFilter = newValue;
    setState(() {
      valueChoose = newValue;
    });
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
  void initState() {
    super.initState();
    // context.read<MeetingStore>().getFilteredList(valueChoose);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 32,
                color: HMSThemeColors.surfaceDefault,
              ),
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
                          return Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: ExpansionTile(
                                  tilePadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 0),
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: HMSThemeColors.borderBright,
                                          width: 1),
                                      borderRadius: BorderRadius.circular(8)),
                                  collapsedShape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: HMSThemeColors.borderBright,
                                          width: 1),
                                      borderRadius: BorderRadius.circular(8)),
                                  collapsedIconColor:
                                      HMSThemeColors.onSurfaceHighEmphasis,
                                  iconColor:
                                      HMSThemeColors.onSurfaceHighEmphasis,
                                  title: HMSSubheadingText(
                                    text:
                                        "${data.item1.keys.elementAt(index)}(${data.item1.keys.elementAt(index).length})",
                                    textColor:
                                        HMSThemeColors.onSurfaceMediumEmphasis,
                                    letterSpacing: 0.1,
                                  ),
                                  children: [
                                    SizedBox(
                                      height: data.item1.keys
                                              .elementAt(index)
                                              .length *
                                          48,
                                      child: ListView.builder(
                                          itemCount: data
                                                    .item1[data.item1.keys
                                                        .elementAt(
                                                            index)]?.length??0,
                                          itemBuilder: (context, peerIndex) {
                                            return Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  HMSTitleText(
                                                      text: (data
                                                          .item1[data.item1.keys
                                                              .elementAt(
                                                                  index)]![peerIndex]
                                                          .name),
                                                      fontSize: 14,
                                                      lineHeight: 20,
                                                      letterSpacing: 0.1,
                                                      textColor: HMSThemeColors
                                                          .onSurfaceHighEmphasis),
                                                  Row(
                children: [
                    PopupMenuButton(
                      color: HMSThemeColors.surfaceDefault,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      itemBuilder: (context) {
                        return List.generate(1, (index) {
                          return PopupMenuItem(
                            height: 52,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "packages/hms_room_kit/lib/src/assets/icons/pin.svg",
                                  height: 20,
                                  width: 20,
                                  colorFilter: ColorFilter.mode(
                                      HMSThemeColors.onSurfaceMediumEmphasis,
                                      BlendMode.srcIn),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                HMSTitleText(
                                  text: "Test",
                                  fontSize: 14,
                                  lineHeight: 20,
                                  letterSpacing: 0.1,
                                  textColor:
                                      HMSThemeColors.onSurfaceHighEmphasis,
                                )
                              ],
                            ),
                            onTap: () => {}
                          );
                        });
                      },
                      child: SvgPicture.asset(
                        "packages/hms_room_kit/lib/src/assets/icons/more.svg",
                        height: 20,
                        width: 20,
                        colorFilter: ColorFilter.mode(
                            HMSThemeColors.onSurfaceMediumEmphasis,
                            BlendMode.srcIn),
                      ),
                    )
                ],
              )
           
                                                ],
                                              ),
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
                          );
                          // return Selector<MeetingStore,
                          //         Tuple4<String, HMSPeer, String, String>>(
                          //     selector: (_, meetingStore) => Tuple4(
                          //         meetingStore.filteredPeers[index].name,
                          //         meetingStore.filteredPeers[index],
                          //         meetingStore.filteredPeers[index].role.name,
                          //         meetingStore.filteredPeers[index].metadata ??
                          //             ""),
                          //     builder: (_, peer, __) {
                          //       return ListTile(
                          //           horizontalTitleGap: 5,
                          //           contentPadding: EdgeInsets.zero,
                          //           leading: CircleAvatar(
                          //               backgroundColor:
                          //                   Utilities.getBackgroundColour(
                          //                       peer.item1),
                          //               radius: 16,
                          //               child: peer.item1.isEmpty
                          //                   ? SvgPicture.asset(
                          //                       'packages/hms_room_kit/lib/src/assets/icons/user.svg',
                          //                       height: 16,
                          //                       width: 16,
                          //                       semanticsLabel:
                          //                           "fl_user_icon_label",
                          //                     )
                          //                   : Text(
                          //                       Utilities.getAvatarTitle(
                          //                           peer.item1),
                          //                       style: GoogleFonts.inter(
                          //                         fontSize: 12,
                          //                         color: HMSThemeColors
                          //                             .onSurfaceHighEmphasis,
                          //                       ),
                          //                     )),
                          //           title: Text(
                          //             peer.item1,
                          //             maxLines: 1,
                          //             style: GoogleFonts.inter(
                          //                 fontSize: 16,
                          //                 color: themeDefaultColor,
                          //                 letterSpacing: 0.15,
                          //                 fontWeight: FontWeight.w600),
                          //           ),
                          //           subtitle: Text(
                          //             peer.item3,
                          //             style: GoogleFonts.inter(
                          //                 fontSize: 12,
                          //                 color: themeSubHeadingColor,
                          //                 letterSpacing: 0.40,
                          //                 fontWeight: FontWeight.w400),
                          //           ),
                          //           trailing: Row(
                          //             mainAxisSize: MainAxisSize.min,
                          //             children: [
                          //               peer.item4.contains(
                          //                       "\"isHandRaised\":true")
                          //                   ? SvgPicture.asset(
                          //                       "packages/hms_room_kit/lib/src/assets/icons/hand.svg",
                          //                       colorFilter:
                          //                           const ColorFilter.mode(
                          //                               Color.fromRGBO(
                          //                                   250, 201, 25, 1),
                          //                               BlendMode.srcIn),
                          //                       height: 15,
                          //                     )
                          //                   : const SizedBox(),
                          //               const SizedBox(
                          //                 width: 5,
                          //               ),
                          //               _kebabMenu(peer.item2),
                          //             ],
                          //           ));
                          //     });
                        });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
