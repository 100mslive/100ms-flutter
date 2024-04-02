library;

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/enums/session_store_keys.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/chat_utilities_bottom_sheet.dart';
import 'package:hms_room_kit/src/widgets/chat_widgets/chat_text_field.dart';
import 'package:hms_room_kit/src/widgets/chat_widgets/pin_chat_widget.dart';
import 'package:hms_room_kit/src/widgets/chat_widgets/recipient_selector_chip.dart';

///[OverlayChatComponent] is a component that is used to show the chat
class OverlayChatComponent extends StatefulWidget {
  final double? height;
  const OverlayChatComponent({super.key, this.height});

  @override
  State<OverlayChatComponent> createState() => _OverlayChatComponentState();
}

class _OverlayChatComponentState extends State<OverlayChatComponent> {
  final ScrollController _scrollController = ScrollController();
  String currentlySelectedValue = "Choose a Recipient";
  String? currentlySelectedpeerId;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setRecipientChipValue();
  }

  ///This function sets the recipient chip value
  void setRecipientChipValue() {
    dynamic currentValue = context.read<MeetingStore>().recipientSelectorValue;
    if (currentValue is HMSPeer) {
      currentlySelectedValue = currentValue.name;
      currentlySelectedpeerId = currentValue.peerId;
    } else if (currentValue is HMSRole) {
      currentlySelectedValue = currentValue.name;
    } else if (currentValue is String) {
      currentlySelectedValue = currentValue;
    }
  }

  ///This function scrolls to the end of the list
  void _scrollToEnd() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollController
          .animateTo(_scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut));
    }
  }

  ///This function updates the selected value
  void _updateValueChoose(String newValue, String? peerId) {
    currentlySelectedValue = newValue;
    currentlySelectedpeerId = peerId;
  }

  ///This function returns the message type text for public, group and private messages
  String messageTypeText(HMSMessageRecipient? hmsMessageRecipient) {
    if (hmsMessageRecipient == null) return "";
    if ((hmsMessageRecipient.recipientPeer != null) &&
        (hmsMessageRecipient.recipientRoles == null)) {
      if (hmsMessageRecipient.recipientPeer is HMSLocalPeer) {
        return "to You (DM)";
      } else {
        return "to ${hmsMessageRecipient.recipientPeer?.name} (DM)";
      }
    } else if ((hmsMessageRecipient.recipientPeer == null) &&
        (hmsMessageRecipient.recipientRoles != null)) {
      return "to ${hmsMessageRecipient.recipientRoles?.first.name} (Group)";
    }
    return "";
  }

  ///This function sends the message
  void _sendMessage(TextEditingController messageTextController) async {
    MeetingStore meetingStore = context.read<MeetingStore>();
    List<HMSRole> hmsRoles = meetingStore.roles;
    String message = messageTextController.text.trim();
    if (message.isEmpty) return;

    List<String> rolesName = <String>[];
    for (int i = 0; i < hmsRoles.length; i++) {
      rolesName.add(hmsRoles[i].name);
    }

    if (currentlySelectedValue == "Everyone") {
      meetingStore.sendBroadcastMessage(message);
    } else if (rolesName.contains(currentlySelectedValue)) {
      List<HMSRole> selectedRoles = [];
      selectedRoles.add(
          hmsRoles.firstWhere((role) => role.name == currentlySelectedValue));
      meetingStore.sendGroupMessage(message, selectedRoles);
    } else if (currentlySelectedpeerId != null &&
        meetingStore.localPeer!.peerId != currentlySelectedpeerId) {
      var peer = await meetingStore.getPeer(peerId: currentlySelectedpeerId!);
      if (peer != null) {
        meetingStore.sendDirectMessage(message, peer);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Selector<MeetingStore, bool>(
          selector: (_, meetingStore) => meetingStore.pinnedMessages.isNotEmpty,
          builder: (_, isPinnedMessage, __) {
            return SizedBox(
              height: isPinnedMessage
                  ? MediaQuery.of(context).size.height * 0.4
                  : MediaQuery.of(context).size.height * 0.3,
              child: Column(
                children: [
                  ///Chat Header
                  Expanded(
                    child: Selector<MeetingStore,
                            Tuple2<List<HMSMessage>, int>>(
                        selector: (_, meetingStore) => Tuple2(
                            meetingStore.messages,
                            meetingStore.messages.length),
                        builder: (context, data, _) {
                          _scrollToEnd();
                          return ListView.builder(
                              controller: _scrollController,
                              shrinkWrap: true,
                              itemCount: data.item1.length,
                              itemBuilder: (_, index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                constraints: BoxConstraints(
                                                    maxWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5),
                                                child: HMSTitleText(
                                                  text: data.item1[index].sender
                                                          ?.name ??
                                                      "Anonymous",
                                                  textColor: Colors.white,
                                                  fontSize: 14,
                                                  lineHeight: 20,
                                                  letterSpacing: 0.1,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Container(
                                                constraints: BoxConstraints(
                                                    maxWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5),
                                                child: HMSSubtitleText(
                                                    text: messageTypeText(data
                                                        .item1[index]
                                                        .hmsMessageRecipient),
                                                    textColor: HMSThemeColors
                                                        .onSurfaceMediumEmphasis),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          SelectableLinkify(
                                            text: data.item1[index].message,
                                            onOpen: (link) async {
                                              Uri url = Uri.parse(link.url);
                                              if (await canLaunchUrl(url)) {
                                                await launchUrl(url,
                                                    mode: LaunchMode
                                                        .externalApplication);
                                              }
                                            },
                                            scrollPhysics:
                                                const NeverScrollableScrollPhysics(),
                                            options: const LinkifyOptions(
                                                humanize: false),
                                            style: HMSTextStyle.setTextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              height: 20 / 14,
                                              letterSpacing: 0.25,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          )
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        var meetingStore =
                                            context.read<MeetingStore>();
                                        showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor:
                                              HMSThemeColors.surfaceDim,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(16),
                                                topRight: Radius.circular(16)),
                                          ),
                                          context: context,
                                          builder: (ctx) =>
                                              ChangeNotifierProvider.value(
                                                  value: meetingStore,
                                                  child:
                                                      ChatUtilitiesBottomSheet(
                                                    message: data.item1[index],
                                                  )),
                                        );
                                      },
                                      child: SvgPicture.asset(
                                        "packages/hms_room_kit/lib/src/assets/icons/more.svg",
                                        height: 20,
                                        width: 20,
                                        colorFilter: ColorFilter.mode(
                                            HMSThemeColors
                                                .onSurfaceMediumEmphasis,
                                            BlendMode.srcIn),
                                      ),
                                    )
                                  ],
                                );
                              });
                        }),
                  ),
                  const SizedBox(
                    height: 8,
                  ),

                  ///This renders the pinned message widget
                  PinChatWidget(
                    backgroundColor: HMSThemeColors.backgroundDim.withAlpha(64),
                  ),
                  Selector<MeetingStore, bool>(
                      selector: (_, meetingStore) =>
                          meetingStore.chatControls["enabled"],
                      builder: (_, isChatEnabled, __) {
                        return isChatEnabled
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 8.0, top: 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if ((HMSRoomLayout.chatData
                                                ?.isPrivateChatEnabled ??
                                            false) ||
                                        (HMSRoomLayout.chatData
                                                ?.isPublicChatEnabled ??
                                            false) ||
                                        (HMSRoomLayout.chatData?.rolesWhitelist
                                                .isNotEmpty ??
                                            false))
                                      ReceipientSelectorChip(
                                        currentlySelectedValue:
                                            currentlySelectedValue,
                                        updateSelectedValue: _updateValueChoose,
                                        chipColor: HMSThemeColors.backgroundDim
                                            .withAlpha(64),
                                      ),
                                    const SizedBox(),
                                    if (HMSRoomLayout.chatData?.realTimeControls
                                            ?.canDisableChat ??
                                        false)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          PopupMenuButton(
                                            padding: EdgeInsets.zero,
                                            position: PopupMenuPosition.over,
                                            color:
                                                HMSThemeColors.surfaceDefault,
                                            itemBuilder: (context) => [
                                              PopupMenuItem(
                                                  value: 1,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50)),
                                                    child: Row(children: [
                                                      SvgPicture.asset(
                                                          "packages/hms_room_kit/lib/src/assets/icons/${context.read<MeetingStore>().chatControls["enabled"] ? "recording_paused" : "resume"}.svg",
                                                          width: 20,
                                                          height: 20,
                                                          colorFilter:
                                                              ColorFilter.mode(
                                                                  HMSThemeColors
                                                                      .onSurfaceHighEmphasis,
                                                                  BlendMode
                                                                      .srcIn)),
                                                      const SizedBox(
                                                        width: 8,
                                                      ),
                                                      HMSTitleText(
                                                        text: context
                                                                    .read<
                                                                        MeetingStore>()
                                                                    .chatControls[
                                                                "enabled"]
                                                            ? "Pause Chat"
                                                            : "Resume Chat",
                                                        textColor: HMSThemeColors
                                                            .onSurfaceHighEmphasis,
                                                        fontSize: 14,
                                                        lineHeight: 20,
                                                        letterSpacing: 0.1,
                                                      ),
                                                    ]),
                                                  ))
                                            ],
                                            onSelected: (value) {
                                              switch (value) {
                                                case 1:
                                                  context
                                                      .read<MeetingStore>()
                                                      .setSessionMetadataForKey(
                                                          key: SessionStoreKeyValues
                                                              .getNameFromMethod(
                                                                  SessionStoreKey
                                                                      .chatState),
                                                          metadata: {
                                                        "enabled": context
                                                                    .read<
                                                                        MeetingStore>()
                                                                    .chatControls[
                                                                "enabled"]
                                                            ? false
                                                            : true,
                                                        "updatedBy": {
                                                          "peerID": context
                                                              .read<
                                                                  MeetingStore>()
                                                              .localPeer
                                                              ?.peerId,
                                                          "userID": context
                                                              .read<
                                                                  MeetingStore>()
                                                              .localPeer
                                                              ?.customerUserId,
                                                          "userName": context
                                                              .read<
                                                                  MeetingStore>()
                                                              .localPeer
                                                              ?.name
                                                        },
                                                        "updatedAt": DateTime
                                                                .now()
                                                            .millisecondsSinceEpoch //unix timestamp in miliseconds
                                                      });
                                                  break;
                                              }
                                            },
                                            child: Container(
                                              height: 24,
                                              width: 24,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(4)),
                                                  color: HMSThemeColors
                                                      .backgroundDim
                                                      .withOpacity(0.64)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: SvgPicture.asset(
                                                  "packages/hms_room_kit/lib/src/assets/icons/more.svg",
                                                  height: 16,
                                                  width: 16,
                                                  colorFilter: ColorFilter.mode(
                                                      HMSThemeColors
                                                          .onSurfaceLowEmphasis,
                                                      BlendMode.srcIn),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                  ],
                                ),
                              )
                            : const SizedBox();
                      }),
                  if ((HMSRoomLayout.chatData?.isPrivateChatEnabled ?? false) ||
                      (HMSRoomLayout.chatData?.isPublicChatEnabled ?? false) ||
                      (HMSRoomLayout.chatData?.rolesWhitelist.isNotEmpty ??
                          false))
                    ChatTextField(
                      sendMessage: _sendMessage,
                      toastBackgroundColor:
                          HMSThemeColors.backgroundDim.withAlpha(64),
                    )
                ],
              ),
            );
          }),
    );
  }
}
