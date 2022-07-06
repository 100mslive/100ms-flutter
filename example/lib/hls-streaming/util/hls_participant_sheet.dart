import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/change_role_options.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/hls-streaming/util/hls_title_text.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:collection/collection.dart';

class HLSParticipantSheet extends StatefulWidget {
  @override
  State<HLSParticipantSheet> createState() => _HLSParticipantSheetState();
}

class _HLSParticipantSheetState extends State<HLSParticipantSheet> {
  String valueChoose = "Everyone";

  Widget _kebabMenu(HMSPeer peer) {
    final _meetingStore = context.read<MeetingStore>();
    PeerTrackNode? peerTrackNode;
    try {
      peerTrackNode = _meetingStore.peerTracks
          .firstWhere((element) => element.peer.peerId == peer.peerId);
    } catch (e) {
      peerTrackNode = null;
    }

    //For HLS-Viewer
    if (peerTrackNode == null) {
      return PopupMenuButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: surfaceColor,
          icon: SvgPicture.asset(
            "assets/icons/more.svg",
            color: defaultColor,
            fit: BoxFit.scaleDown,
          ),
          onSelected: (int value) async {
            switch (value) {
              case 1:
                showDialog(
                    context: context,
                    builder: (_) => ChangeRoleOptionDialog(
                          peerName: peer.name,
                          getRoleFunction: _meetingStore.getRoles(),
                          changeRole: (role, forceChange) {
                            _meetingStore.changeRole(
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
                  child: Row(children: [
                    SvgPicture.asset("assets/icons/role_change.svg",
                        width: 15, color: defaultColor),
                    SizedBox(
                      width: 12,
                    ),
                    HLSTitleText(
                      text: "Change Role",
                      textColor: defaultColor,
                      fontSize: 14,
                      lineHeight: 20,
                      letterSpacing: 0.25,
                    ),
                  ]),
                  value: 1,
                ),
              ]));
    }

    bool mutePermission =
        _meetingStore.localPeer?.role.permissions.mute ?? false;
    bool removePeerPermission =
        _meetingStore.localPeer?.role.permissions.removeOthers ?? false;
    bool changeRolePermission =
        _meetingStore.localPeer?.role.permissions.changeRole ?? false;

    return PopupMenuButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: surfaceColor,
        onSelected: (int value) async {
          switch (value) {
            case 1:
              showDialog(
                  context: context,
                  builder: (_) => ChangeRoleOptionDialog(
                        peerName: peerTrackNode!.peer.name,
                        getRoleFunction: _meetingStore.getRoles(),
                        changeRole: (role, forceChange) {
                          Navigator.pop(context);
                          _meetingStore.changeRole(
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
              _meetingStore.changeTrackState(
                  peerTrackNode.track!, !peerTrackNode.track!.isMute);
              break;
            case 3:
              if (peerTrackNode!.audioTrack == null) {
                return;
              }
              _meetingStore.changeTrackState(
                  peerTrackNode.audioTrack!, !peerTrackNode.audioTrack!.isMute);
              break;
            case 4:
              var peer = await _meetingStore.getPeer(
                  peerId: peerTrackNode!.peer.peerId);
              if (peer == null) {
                return;
              }
              _meetingStore.removePeerFromRoom(peer);
              break;
            default:
              break;
          }
        },
        icon: SvgPicture.asset(
          "assets/icons/more.svg",
          color: defaultColor,
          fit: BoxFit.scaleDown,
        ),
        itemBuilder: (context) => [
              if (changeRolePermission)
                PopupMenuItem(
                  child: Row(children: [
                    SvgPicture.asset("assets/icons/role_change.svg",
                        width: 15, color: defaultColor),
                    SizedBox(
                      width: 12,
                    ),
                    HLSTitleText(
                      text: "Change Role",
                      textColor: defaultColor,
                      fontSize: 14,
                      lineHeight: 20,
                      letterSpacing: 0.25,
                    ),
                  ]),
                  value: 1,
                ),
              if (mutePermission && !peerTrackNode!.peer.isLocal)
                PopupMenuItem(
                  child: Row(children: [
                    SvgPicture.asset(
                      "assets/icons/cam_state_on.svg",
                      color: defaultColor,
                      width: 15,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    HLSTitleText(
                      text: "Switch Video",
                      textColor: defaultColor,
                      fontSize: 14,
                      lineHeight: 20,
                      letterSpacing: 0.25,
                    ),
                  ]),
                  value: 2,
                ),
              if (mutePermission && !peerTrackNode!.peer.isLocal)
                PopupMenuItem(
                  child: Row(children: [
                    SvgPicture.asset(
                      "assets/icons/mic_state_on.svg",
                      color: defaultColor,
                      width: 15,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    HLSTitleText(
                      text: "Switch Audio",
                      textColor: defaultColor,
                      fontSize: 14,
                      lineHeight: 20,
                      letterSpacing: 0.25,
                    ),
                  ]),
                  value: 3,
                ),
              if (removePeerPermission && !peerTrackNode!.peer.isLocal)
                PopupMenuItem(
                  child: Row(children: [
                    SvgPicture.asset("assets/icons/peer_remove.svg",
                        width: 15, color: defaultColor),
                    SizedBox(
                      width: 12,
                    ),
                    HLSTitleText(
                      text: "Remove Peer",
                      textColor: defaultColor,
                      fontSize: 14,
                      lineHeight: 20,
                      letterSpacing: 0.25,
                    ),
                  ]),
                  value: 4,
                ),
            ]);
  }

  @override
  Widget build(BuildContext context) {
    final _meetingStore = context.read<MeetingStore>();
    return FractionallySizedBox(
      heightFactor: 0.8,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Participants",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      fontSize: 16,
                      color: defaultColor,
                      letterSpacing: 0.15,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                        color: hintColor,
                        style: BorderStyle.solid,
                        width: 0.80),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: Selector<MeetingStore,
                            Tuple2<List<HMSRole>, List<HMSPeer>>>(
                        selector: (_, meetingStore) =>
                            Tuple2(meetingStore.roles, meetingStore.peers),
                        builder: (context, data, _) {
                          List<HMSRole> roles = data.item1;
                          return DropdownButton2(
                            isExpanded: true,
                            dropdownWidth:
                                MediaQuery.of(context).size.width * 0.4,
                            buttonWidth: 100,
                            buttonHeight: 32,
                            itemHeight: 48,
                            value: valueChoose,
                            icon: Icon(Icons.keyboard_arrow_down),
                            dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: surfaceColor),
                            offset: Offset(-10, -10),
                            iconEnabledColor: iconColor,
                            selectedItemHighlightColor: hmsdefaultColor,
                            onChanged: (dynamic newvalue) {
                              setState(() {
                                this.valueChoose = newvalue as String;
                              });
                            },
                            items: <DropdownMenuItem>[
                              DropdownMenuItem(
                                child: Text(
                                  "Everyone",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    letterSpacing: 0.4,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                value: "Everyone",
                              ),
                              ...roles
                                  .sortedBy(
                                      (element) => element.priority.toString())
                                  .map((role) => DropdownMenuItem(
                                        child: Text(
                                          "${role.name}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: GoogleFonts.inter(
                                              fontSize: 12, color: iconColor),
                                        ),
                                        value: role.name,
                                      ))
                                  .toList(),
                            ],
                          );
                        }),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(
                          "assets/icons/close_button.svg",
                          width: 40,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15, bottom: 10),
              child: Divider(
                color: dividerColor,
                height: 5,
              ),
            ),
            Selector<MeetingStore, Tuple2<List<HMSPeer>, int>>(
                selector: (_, meetingStore) =>
                    Tuple2(meetingStore.peers, meetingStore.peers.length),
                builder: (_, data, __) {
                  List<HMSPeer> copyList = [];
                  copyList.addAll(data.item1);
                  List<HMSPeer> peerList = [];
                  peerList.add(copyList.removeAt(
                      copyList.indexWhere((element) => element.isLocal)));
                  if (valueChoose == "Everyone") {
                    peerList.addAll(copyList.sortedBy(
                        (element) => element.role.priority.toString()));
                  } else {
                    peerList = copyList
                        .where((element) => element.role.name == valueChoose)
                        .toList();
                  }
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: peerList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                              horizontalTitleGap: 5,
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor: Utilities.getBackgroundColour(
                                    peerList[index].name),
                                radius: 16,
                                child: Text(
                                    Utilities.getAvatarTitle(
                                        peerList[index].name),
                                    style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: defaultColor,
                                        fontWeight: FontWeight.w600)),
                              ),
                              title: Text(
                                peerList[index].name +
                                    (peerList[index].isLocal ? " (You)" : ""),
                                style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: defaultColor,
                                    letterSpacing: 0.15,
                                    fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                peerList[index].role.name,
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: subHeadingColor,
                                    letterSpacing: 0.40,
                                    fontWeight: FontWeight.w400),
                              ),
                              trailing: _kebabMenu(peerList[index]));
                        }),
                  );
                })
          ],
        ),
      ),
    );
  }
}
