//Package imports
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

//Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/enums/session_store_keys.dart';
import 'package:hms_room_kit/src/widgets/chat_widgets/hms_empty_chat_widget.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/message_container.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';

class ChatBottomSheet extends StatefulWidget {
  const ChatBottomSheet({super.key});

  @override
  State<ChatBottomSheet> createState() => _ChatBottomSheetState();
}

class _ChatBottomSheetState extends State<ChatBottomSheet> {
  late double widthOfScreen;
  TextEditingController messageTextController = TextEditingController();
  String valueChoose = "Everyone";
  final ScrollController _scrollController = ScrollController();
  final DateFormat formatter = DateFormat('hh:mm a');
  @override
  void dispose() {
    messageTextController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    if (_scrollController.positions.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollController
          .animateTo(_scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut));
    }
  }

  String sender(HMSMessageRecipient hmsMessageRecipient) {
    if ((hmsMessageRecipient.recipientPeer != null) &&
        (hmsMessageRecipient.recipientRoles == null)) {
      return "PRIVATE";
    } else if ((hmsMessageRecipient.recipientPeer == null) &&
        (hmsMessageRecipient.recipientRoles != null)) {
      return hmsMessageRecipient.recipientRoles![0].name;
    }
    return "";
  }

  void sendMessage() async {
    MeetingStore meetingStore = context.read<MeetingStore>();
    List<HMSRole> hmsRoles = meetingStore.roles;
    String message = messageTextController.text.trim();
    if (message.isEmpty) return;

    List<String> rolesName = <String>[];
    for (int i = 0; i < hmsRoles.length; i++) {
      rolesName.add(hmsRoles[i].name);
    }

    if (valueChoose == "Everyone") {
      meetingStore.sendBroadcastMessage(message);
    } else if (rolesName.contains(valueChoose)) {
      List<HMSRole> selectedRoles = [];
      selectedRoles
          .add(hmsRoles.firstWhere((role) => role.name == valueChoose));
      meetingStore.sendGroupMessage(message, selectedRoles);
    } else if (meetingStore.localPeer!.peerId != valueChoose) {
      var peer = await meetingStore.getPeer(peerId: valueChoose);
      meetingStore.sendDirectMessage(message, peer!);
    }
    messageTextController.clear();
  }

  @override
  Widget build(BuildContext context) {
    widthOfScreen = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        context.read<MeetingStore>().setNewMessageFalse();
        return true;
      },
      child: SafeArea(
        child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              Selector<MeetingStore, Tuple3<List<HMSMessage>, int, String?>>(
                selector: (_, meetingStore) => Tuple3(meetingStore.messages,
                    meetingStore.messages.length, meetingStore.sessionMetadata),
                builder: (context, data, _) {
                  _scrollToEnd();
                  return

                      ///If there are no chats and no pinned messages
                      (data.item2 == 0 && data.item3 == null)
                          ? const Expanded(
                              child: Center(child: HMSEmptyChatWidget()))
                          : Expanded(
                              child: Column(children: [
                                ///If there is a pinned chat
                                if (data.item3 != null && data.item3 != "")
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Container(
                                      constraints:
                                          const BoxConstraints(maxHeight: 150),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: HMSThemeColors.surfaceDefault),
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    "packages/hms_room_kit/lib/src/assets/icons/pin.svg",
                                                    height: 20,
                                                    width: 20,
                                                    colorFilter: ColorFilter.mode(
                                                        HMSThemeColors
                                                            .onSurfaceMediumEmphasis,
                                                        BlendMode.srcIn),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.75,
                                                    child: SelectableLinkify(
                                                      text: data.item3!,
                                                      onOpen: (link) async {
                                                        Uri url =
                                                            Uri.parse(link.url);
                                                        if (await canLaunchUrl(
                                                            url)) {
                                                          await launchUrl(url,
                                                              mode: LaunchMode
                                                                  .externalApplication);
                                                        }
                                                      },
                                                      options:
                                                          const LinkifyOptions(
                                                              humanize: false),
                                                      style: HMSTextStyle
                                                          .setTextStyle(
                                                        fontSize: 14.0,
                                                        color: HMSThemeColors
                                                            .onSurfaceHighEmphasis,
                                                        letterSpacing: 0.25,
                                                        height: 20 / 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                      linkStyle: HMSTextStyle
                                                          .setTextStyle(
                                                              fontSize: 14.0,
                                                              color: HMSThemeColors
                                                                  .primaryDefault,
                                                              letterSpacing:
                                                                  0.25,
                                                              height: 20 / 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                      onTap: () {
                                                        context
                                                            .read<
                                                                MeetingStore>()
                                                            .setSessionMetadataForKey(
                                                                key: SessionStoreKeyValues
                                                                    .getNameFromMethod(
                                                                        SessionStoreKey
                                                                            .pinnedMessageSessionKey),
                                                                metadata: null);
                                                      },
                                                      child: SvgPicture.asset(
                                                        "packages/hms_room_kit/lib/src/assets/icons/close.svg",
                                                        height: 20,
                                                        width: 20,
                                                        colorFilter:
                                                            ColorFilter.mode(
                                                                HMSThemeColors
                                                                    .onSurfaceMediumEmphasis,
                                                                BlendMode
                                                                    .srcIn),
                                                      )),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                /// List containing chats
                                Expanded(
                                  child: SingleChildScrollView(
                                    reverse: true,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ListView.builder(
                                            controller: _scrollController,
                                            shrinkWrap: true,
                                            itemCount: data.item1.length,
                                            itemBuilder: (_, index) {
                                              return MessageContainer(
                                                message: data
                                                    .item1[index].message
                                                    .trim()
                                                    .toString(),
                                                senderName: data.item1[index]
                                                        .sender?.name ??
                                                    "Anonymous",
                                                date: formatter.format(
                                                    data.item1[index].time),
                                                role: data.item1[index]
                                                            .hmsMessageRecipient ==
                                                        null
                                                    ? ""
                                                    : sender(data.item1[index]
                                                        .hmsMessageRecipient!),
                                              );
                                            }),
                                      ],
                                    ),
                                  ),
                                )
                              ]),
                            );
                },
              ),

              ///Will be added later
              ///
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 8.0, left: 16,top: 16),
              //   child: Row(
              //     children: [
              //       HMSTitleText(
              //         text: "SEND TO ",
              //         textColor: HMSThemeColors.onSurfaceMediumEmphasis,
              //         fontSize: 10,
              //         lineHeight: 16,
              //         letterSpacing: 1.5,
              //       ),
              //       Container(
              //           width: 96,
              //           height: 24,
              //           decoration: BoxDecoration(
              //               border: Border.all(
              //                   color: HMSThemeColors.borderBright, width: 1),
              //               borderRadius:
              //                   const BorderRadius.all(Radius.circular(4)),
              //               color:
              //                   HMSThemeColors.surfaceDim),
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               HMSTitleText(
              //                   text: "EVERYONE",
              //                   fontSize: 10,
              //                   lineHeight: 16,
              //                   letterSpacing: 1.5,
              //                   textColor:
              //                       HMSThemeColors.onSurfaceHighEmphasis),
              //               Icon(Icons.keyboard_arrow_down,color: HMSThemeColors.onSurfaceMediumEmphasis,size: 16,),
              //             ],
              //           ))
              //     ],
              //   ),
              // ),
              ///Text Field
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: HMSThemeColors.surfaceDefault),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.send,
                          onTapOutside: (event) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                          onSubmitted: (value) {
                            sendMessage();
                          },
                          onChanged: (value) {
                            setState(() {});
                          },
                          style: HMSTextStyle.setTextStyle(
                              color: HMSThemeColors.onSurfaceHighEmphasis,
                              fontWeight: FontWeight.w400,
                              height: 20 / 14,
                              fontSize: 14,
                              letterSpacing: 0.25),
                          controller: messageTextController,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    if (messageTextController.text
                                        .trim()
                                        .isEmpty) {
                                      Utilities.showToast(
                                          "Message can't be empty");
                                    }
                                    sendMessage();
                                  },
                                  icon: SvgPicture.asset(
                                    "packages/hms_room_kit/lib/src/assets/icons/send_message.svg",
                                    height: 24,
                                    width: 24,
                                    colorFilter: ColorFilter.mode(
                                        messageTextController
                                                .text
                                                .trim()
                                                .isEmpty
                                            ? HMSThemeColors
                                                .onSurfaceLowEmphasis
                                            : HMSThemeColors
                                                .onSurfaceHighEmphasis,
                                        BlendMode.srcIn),
                                  )),
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2,
                                      color: HMSThemeColors.primaryDefault),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8))),
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintStyle: HMSTextStyle.setTextStyle(
                                  color: HMSThemeColors.onSurfaceLowEmphasis,
                                  fontSize: 14,
                                  height: 20 / 14,
                                  letterSpacing: 0.25,
                                  fontWeight: FontWeight.w400),
                              contentPadding: const EdgeInsets.only(
                                  left: 16, bottom: 8, top: 12, right: 8),
                              hintText: "Send a message..."),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
