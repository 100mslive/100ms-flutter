///Package imports
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_cross_button.dart';

///[ReceipientSelectorChip] is a widget that is used to render the receipient selector chip
class RecipientSelectorWidget extends StatefulWidget {
  final Function updateUI;
  final String selectedValue;

  const RecipientSelectorWidget(
      {super.key, required this.updateUI, required this.selectedValue});

  @override
  State<RecipientSelectorWidget> createState() =>
      _RecipientSelectorWidgetState();
}

class _RecipientSelectorWidgetState extends State<RecipientSelectorWidget> {
  String currentlySelectedValue = "";

  @override
  void initState() {
    super.initState();
    currentlySelectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        maxChildSize: 0.7,
        builder: (context, controller) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              color: HMSThemeColors.surfaceDefault,
            ),
            child: Column(
              children: [
                Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 24.0, right: 24, top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          HMSTitleText(
                            text: "Send message to",
                            textColor: HMSThemeColors.onSurfaceHighEmphasis,
                            letterSpacing: 0.15,
                          ),
                          HMSCrossButton(
                            iconColor: HMSThemeColors.onSecondaryMediumEmphasis,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Divider(
                        height: 1,
                        color: HMSThemeColors.borderBright,
                      ),
                    ),
                  ],
                ),

                ///TODO: Add search bar here

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (HMSRoomLayout.chatData?.isPublicChatEnabled ??
                            false)
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 24.0, right: 24),
                            child: ListTile(
                              onTap: () {
                                setState(() {
                                  currentlySelectedValue = "Everyone";
                                });
                                widget.updateUI(currentlySelectedValue, null);
                                context
                                    .read<MeetingStore>()
                                    .recipientSelectorValue = "Everyone";
                                Navigator.pop(context);
                              },
                              dense: true,
                              horizontalTitleGap: 0,
                              contentPadding: EdgeInsets.zero,
                              titleAlignment: ListTileTitleAlignment.center,
                              leading: SvgPicture.asset(
                                "packages/hms_room_kit/lib/src/assets/icons/everyone.svg",
                                colorFilter: ColorFilter.mode(
                                    HMSThemeColors.onSurfaceMediumEmphasis,
                                    BlendMode.srcIn),
                                width: 20,
                                height: 20,
                              ),
                              title: HMSTitleText(
                                text: "Everyone",
                                textColor: HMSThemeColors.onSurfaceHighEmphasis,
                                fontSize: 14,
                                letterSpacing: 0.1,
                                lineHeight: 20,
                              ),
                              trailing: currentlySelectedValue == "Everyone"
                                  ? SvgPicture.asset(
                                      "packages/hms_room_kit/lib/src/assets/icons/tick.svg",
                                      fit: BoxFit.scaleDown,
                                      height: 20,
                                      width: 20,
                                      colorFilter: ColorFilter.mode(
                                          HMSThemeColors.onSurfaceHighEmphasis,
                                          BlendMode.srcIn),
                                    )
                                  : const SizedBox(),
                            ),
                          ),

                        if (HMSRoomLayout.chatData?.isPublicChatEnabled ??
                            false)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Divider(
                              height: 1,
                              color: HMSThemeColors.borderBright,
                            ),
                          ),

                        ///Group based selection
                        if (HMSRoomLayout.chatData?.rolesWhitelist.isNotEmpty ??
                            false)
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 24.0, right: 24),
                            child: ListTile(
                              dense: true,
                              horizontalTitleGap: 0,
                              contentPadding: EdgeInsets.zero,
                              titleAlignment: ListTileTitleAlignment.center,
                              leading: SvgPicture.asset(
                                "packages/hms_room_kit/lib/src/assets/icons/participants.svg",
                                colorFilter: ColorFilter.mode(
                                    HMSThemeColors.onSurfaceMediumEmphasis,
                                    BlendMode.srcIn),
                                width: 20,
                                height: 20,
                              ),
                              title: HMSTitleText(
                                text: "ROLE GROUP",
                                textColor:
                                    HMSThemeColors.onSurfaceMediumEmphasis,
                                fontSize: 10,
                                letterSpacing: 1.5,
                                lineHeight: 16,
                              ),
                            ),
                          ),

                        if (HMSRoomLayout.chatData?.rolesWhitelist.isNotEmpty ??
                            false)
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10),
                            child: Column(
                              children: HMSRoomLayout.chatData!.rolesWhitelist
                                  .map((roleName) => ListTile(
                                        onTap: () {
                                          setState(() {
                                            currentlySelectedValue = roleName;
                                          });
                                          widget.updateUI(
                                              currentlySelectedValue, null);
                                          context
                                                  .read<MeetingStore>()
                                                  .recipientSelectorValue =
                                              context
                                                  .read<MeetingStore>()
                                                  .roles
                                                  .firstWhere((element) =>
                                                      element.name == roleName);
                                          Navigator.pop(context);
                                        },
                                        title: HMSTitleText(
                                          text: roleName,
                                          textColor: HMSThemeColors
                                              .onSurfaceHighEmphasis,
                                          fontSize: 14,
                                          letterSpacing: 0.1,
                                          lineHeight: 20,
                                        ),
                                        trailing:
                                            currentlySelectedValue == roleName
                                                ? SvgPicture.asset(
                                                    "packages/hms_room_kit/lib/src/assets/icons/tick.svg",
                                                    fit: BoxFit.scaleDown,
                                                    height: 20,
                                                    width: 20,
                                                    colorFilter: ColorFilter.mode(
                                                        HMSThemeColors
                                                            .onSurfaceHighEmphasis,
                                                        BlendMode.srcIn),
                                                  )
                                                : const SizedBox(),
                                      ))
                                  .toList(),
                            ),
                          ),

                        if (HMSRoomLayout.chatData?.rolesWhitelist.isNotEmpty ??
                            false)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Divider(
                              height: 1,
                              color: HMSThemeColors.borderBright,
                            ),
                          ),

                        ///Participant based selection

                        if (HMSRoomLayout.chatData?.isPrivateChatEnabled ??
                            false)
                          Selector<MeetingStore, Tuple2<List<HMSPeer>, int>>(
                              selector: (_, meetingStore) => Tuple2(
                                  meetingStore.peers,
                                  meetingStore.peers.length),
                              builder: (_, data, __) {
                                return data.item2 <= 1
                                    ? const SizedBox()
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            left: 24.0, right: 24),
                                        child: ListTile(
                                          dense: true,
                                          horizontalTitleGap: 0,
                                          contentPadding: EdgeInsets.zero,
                                          titleAlignment:
                                              ListTileTitleAlignment.center,
                                          leading: SvgPicture.asset(
                                            "packages/hms_room_kit/lib/src/assets/icons/person.svg",
                                            colorFilter: ColorFilter.mode(
                                                HMSThemeColors
                                                    .onSurfaceMediumEmphasis,
                                                BlendMode.srcIn),
                                            width: 20,
                                            height: 20,
                                          ),
                                          title: HMSTitleText(
                                            text: "DIRECT MESSAGE",
                                            textColor: HMSThemeColors
                                                .onSurfaceMediumEmphasis,
                                            fontSize: 10,
                                            letterSpacing: 1.5,
                                            lineHeight: 16,
                                          ),
                                        ),
                                      );
                              }),

                        if (HMSRoomLayout.chatData?.isPrivateChatEnabled ??
                            false)
                          Selector<MeetingStore, Tuple2<List<HMSPeer>, int>>(
                              selector: (_, meetingStore) => Tuple2(
                                  meetingStore.peers,
                                  meetingStore.peers.length),
                              builder: (_, data, __) {
                                return data.item2 <= 1
                                    ? ((HMSRoomLayout.chatData
                                                    ?.isPrivateChatEnabled ??
                                                false) &&
                                            !(HMSRoomLayout.chatData
                                                    ?.isPublicChatEnabled ??
                                                true) &&
                                            (HMSRoomLayout.chatData
                                                    ?.rolesWhitelist.isEmpty ??
                                                false))
                                        ? HMSTitleText(
                                            text: "No recipients yet",
                                            textColor: HMSThemeColors
                                                .onSurfaceMediumEmphasis,
                                            fontSize: 14,
                                            letterSpacing: 0.1,
                                            lineHeight: 20,
                                          )
                                        : const SizedBox()
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 10),
                                        child: Column(
                                          children: data.item1
                                              .where((peer) =>

                                                  ///Don't show local and SIP peers
                                                  peer.isLocal == false &&
                                                  peer.type != HMSPeerType.sip)
                                              .map((peer) => ListTile(
                                                    onTap: () {
                                                      setState(() {
                                                        currentlySelectedValue =
                                                            peer.name;
                                                      });
                                                      widget.updateUI(peer.name,
                                                          peer.peerId);
                                                      context
                                                              .read<MeetingStore>()
                                                              .recipientSelectorValue =
                                                          data.item1.firstWhere(
                                                              (element) =>
                                                                  element
                                                                      .peerId ==
                                                                  peer.peerId);
                                                      Navigator.pop(context);
                                                    },
                                                    title: HMSTitleText(
                                                      text: peer.name,
                                                      textColor: HMSThemeColors
                                                          .onSurfaceHighEmphasis,
                                                      fontSize: 14,
                                                      letterSpacing: 0.1,
                                                      lineHeight: 20,
                                                    ),
                                                    trailing:
                                                        currentlySelectedValue ==
                                                                peer.peerId
                                                            ? SvgPicture.asset(
                                                                "packages/hms_room_kit/lib/src/assets/icons/tick.svg",
                                                                fit: BoxFit
                                                                    .scaleDown,
                                                                height: 20,
                                                                width: 20,
                                                                colorFilter: ColorFilter.mode(
                                                                    HMSThemeColors
                                                                        .onSurfaceHighEmphasis,
                                                                    BlendMode
                                                                        .srcIn),
                                                              )
                                                            : const SizedBox(),
                                                  ))
                                              .toList(),
                                        ),
                                      );
                              }),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
