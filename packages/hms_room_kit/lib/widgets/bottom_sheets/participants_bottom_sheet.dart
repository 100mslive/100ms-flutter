import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hms_room_kit/common/app_color.dart';
import 'package:hms_room_kit/common/utility_functions.dart';
import 'package:hms_room_kit/model/peer_track_node.dart';
import 'package:hms_room_kit/widgets/app_dialogs/change_role_option_dialog.dart';
import 'package:hms_room_kit/widgets/common_widgets/hms_dropdown.dart';
import 'package:hms_room_kit/widgets/common_widgets/title_text.dart';
import 'package:hms_room_kit/widgets/meeting/meeting_store.dart';
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
    context.read<MeetingStore>().getFilteredList(newValue);
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
                "packages/hms_room_kit/lib/assets/icons/more.svg",
                color: themeDefaultColor,
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
                            "packages/hms_room_kit/lib/assets/icons/role_change.svg",
                            width: 15,
                            color: themeDefaultColor),
                        const SizedBox(
                          width: 12,
                        ),
                        TitleText(
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
              "packages/hms_room_kit/lib/assets/icons/more.svg",
              color: themeDefaultColor,
              fit: BoxFit.scaleDown,
            ),
            itemBuilder: (context) => [
                  if (changeRolePermission)
                    PopupMenuItem(
                      value: 1,
                      child: Row(children: [
                        SvgPicture.asset(
                            "packages/hms_room_kit/lib/assets/icons/role_change.svg",
                            width: 15,
                            color: themeDefaultColor),
                        const SizedBox(
                          width: 12,
                        ),
                        TitleText(
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
                              ? "packages/hms_room_kit/lib/assets/icons/cam_state_on.svg"
                              : "packages/hms_room_kit/lib/assets/icons/cam_state_off.svg",
                          color: themeDefaultColor,
                          width: 15,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        TitleText(
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
                              ? "packages/hms_room_kit/lib/assets/icons/mic_state_on.svg"
                              : "packages/hms_room_kit/lib/assets/icons/mic_state_off.svg",
                          color: themeDefaultColor,
                          width: 15,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        TitleText(
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
                            "packages/hms_room_kit/lib/assets/icons/peer_remove.svg",
                            width: 15,
                            color: themeDefaultColor),
                        const SizedBox(
                          width: 12,
                        ),
                        TitleText(
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
    context.read<MeetingStore>().getFilteredList(valueChoose);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FractionallySizedBox(
        heightFactor: 0.81,
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: themeBottomSheetColor,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Participants(${context.read<MeetingStore>().peers.length})",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          color: themeDefaultColor,
                          letterSpacing: 0.15,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    DropdownButtonHideUnderline(
                      child: Selector<MeetingStore, List<HMSRole>>(
                          selector: (_, meetingStore) => meetingStore.roles,
                          builder: (context, roles, _) {
                            return HMSDropDown(
                                dropDownItems: <DropdownMenuItem>[
                                  DropdownMenuItem(
                                    value: "Everyone",
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          "packages/hms_room_kit/lib/assets/icons/participants.svg",
                                          fit: BoxFit.scaleDown,
                                          color: themeDefaultColor,
                                          height: 16,
                                        ),
                                        const SizedBox(
                                          width: 11,
                                        ),
                                        Text(
                                          "Everyone",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            letterSpacing: 0.4,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "Raised Hand",
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          "packages/hms_room_kit/lib/assets/icons/hand_outline.svg",
                                          fit: BoxFit.scaleDown,
                                          color: themeDefaultColor,
                                          height: 16,
                                        ),
                                        const SizedBox(
                                          width: 11,
                                        ),
                                        Text(
                                          "Raised Hand",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            letterSpacing: 0.4,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  ...roles
                                      .sortedBy((element) =>
                                          element.priority.toString())
                                      .map((role) => DropdownMenuItem(
                                            value: role.name,
                                            child: Text(
                                              role.name,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  color: iconColor),
                                            ),
                                          ))
                                      .toList(),
                                ],
                                dropdownButton: Container(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 8, top: 4, bottom: 4),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: borderColor,
                                          style: BorderStyle.solid,
                                          width: 0.80)),
                                  child: Row(
                                    children: [
                                      Text(
                                        valueChoose,
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          letterSpacing: 0.4,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Icon(Icons.keyboard_arrow_down),
                                    ],
                                  ),
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: themeSurfaceColor),
                                  offset: const Offset(-10, -10),
                                ),
                                buttonStyleData: const ButtonStyleData(
                                    width: 100, height: 35),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 45,
                                ),
                                selectedValue: valueChoose,
                                updateSelectedValue: _updateDropDownValue);
                          }),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: SvgPicture.asset(
                              "packages/hms_room_kit/lib/assets/icons/close_button.svg",
                              width: 40,
                            ),
                            onPressed: () {
                              context
                                  .read<MeetingStore>()
                                  .filteredPeers
                                  .clear();
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 10),
                  child: Divider(
                    color: dividerColor,
                    height: 5,
                  ),
                ),
                Selector<MeetingStore, Tuple2<List<HMSPeer>, int>>(
                    selector: (_, meetingStore) => Tuple2(
                        meetingStore.filteredPeers,
                        meetingStore.filteredPeers.length),
                    builder: (_, data, __) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.65,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: data.item2,
                            itemBuilder: (context, index) {
                              return Selector<MeetingStore,
                                      Tuple4<String, HMSPeer, String, String>>(
                                  selector: (_, meetingStore) => Tuple4(
                                      meetingStore.filteredPeers[index].name,
                                      meetingStore.filteredPeers[index],
                                      meetingStore
                                          .filteredPeers[index].role.name,
                                      meetingStore
                                              .filteredPeers[index].metadata ??
                                          ""),
                                  builder: (_, peer, __) {
                                    return ListTile(
                                        horizontalTitleGap: 5,
                                        contentPadding: EdgeInsets.zero,
                                        leading: CircleAvatar(
                                          backgroundColor:
                                              Utilities.getBackgroundColour(
                                                  peer.item1),
                                          radius: 16,
                                          child: Text(
                                              Utilities.getAvatarTitle(
                                                  peer.item1),
                                              style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  color: themeDefaultColor,
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                        title: Text(
                                          peer.item1 +
                                              (peer.item2.isLocal
                                                  ? " (You)"
                                                  : ""),
                                          maxLines: 1,
                                          style: GoogleFonts.inter(
                                              fontSize: 16,
                                              color: themeDefaultColor,
                                              letterSpacing: 0.15,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        subtitle: Text(
                                          peer.item3,
                                          style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: themeSubHeadingColor,
                                              letterSpacing: 0.40,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            peer.item4.contains(
                                                    "\"isHandRaised\":true")
                                                ? SvgPicture.asset(
                                                    "packages/hms_room_kit/lib/assets/icons/hand.svg",
                                                    color: const Color.fromRGBO(
                                                        250, 201, 25, 1),
                                                    height: 15,
                                                  )
                                                : const SizedBox(),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            _kebabMenu(peer.item2),
                                          ],
                                        ));
                                  });
                            }),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
