//Dart imports
import 'dart:math' as math;

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
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toast.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toast_button.dart';

///[OverlayChatComponent] is a component that is used to show the chat
class OverlayChatComponent extends StatefulWidget {
  final double? height;
  const OverlayChatComponent({super.key, this.height});

  @override
  State<OverlayChatComponent> createState() => _OverlayChatComponentState();
}

class _OverlayChatComponentState extends State<OverlayChatComponent> {
  TextEditingController messageTextController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    messageTextController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  ///This function scrolls to the end of the list
  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut));
  }

  ///This function sends the message
  void _sendMessage() async {
    MeetingStore meetingStore = context.read<MeetingStore>();
    String message = messageTextController.text.trim();
    if (message.isEmpty) return;
    meetingStore.sendBroadcastMessage(message);
    messageTextController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: widget.height ?? MediaQuery.of(context).size.height * 0.2,
        child: Column(
          children: [
            ///Chat Header
            Expanded(
              child: Selector<MeetingStore, Tuple2<List<HMSMessage>, int>>(
                  selector: (_, meetingStore) => Tuple2(
                      meetingStore.messages, meetingStore.messages.length),
                  builder: (context, data, _) {
                    _scrollToEnd();
                    return ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemCount: data.item1.length,
                        itemBuilder: (_, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HMSTitleText(
                                text: data.item1[index].sender?.name ??
                                    "Anonymous",
                                textColor: Colors.white,
                                fontSize: 14,
                                lineHeight: 20,
                                letterSpacing: 0.1,
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
                                        mode: LaunchMode.externalApplication);
                                  }
                                },
                                options: const LinkifyOptions(humanize: false),
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
                          );
                        });
                  }),
            ),
            const SizedBox(
              height: 8,
            ),

            Selector<MeetingStore, bool>(
                selector: (_, meetingStore) =>
                    meetingStore.chatControls["enabled"],
                builder: (_, isChatEnabled, __) {
                  return isChatEnabled
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, top: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ///This will be added in future versions
                              ///
                              // Row(
                              //   children: [
                              //     Padding(
                              //       padding: const EdgeInsets.only(right: 8.0),
                              //       child: HMSTitleText(
                              //         text: "TO",
                              //         textColor: HMSThemeColors
                              //             .onSurfaceMediumEmphasis,
                              //         fontSize: 12,
                              //         fontWeight: FontWeight.w400,
                              //         lineHeight: 16,
                              //         letterSpacing: 0.4,
                              //       ),
                              //     ),
                              //     Container(
                              //         height: 24,
                              //         decoration: BoxDecoration(
                              //             borderRadius: const BorderRadius.all(
                              //                 Radius.circular(4)),
                              //             color: HMSThemeColors.backgroundDim
                              //                 .withOpacity(0.64)),
                              //         child: Padding(
                              //           padding: const EdgeInsets.symmetric(
                              //               horizontal: 4.0),
                              //           child: Row(
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment.center,
                              //             children: [
                              //               Padding(
                              //                 padding: const EdgeInsets.only(
                              //                     right: 4.0),
                              //                 child: SvgPicture.asset(
                              //                   "packages/hms_room_kit/lib/src/assets/icons/participants.svg",
                              //                   height: 16,
                              //                   width: 16,
                              //                   colorFilter: ColorFilter.mode(
                              //                       HMSThemeColors
                              //                           .onSurfaceMediumEmphasis,
                              //                       BlendMode.srcIn),
                              //                 ),
                              //               ),
                              //               HMSTitleText(
                              //                   text: "Everyone",
                              //                   fontSize: 12,
                              //                   lineHeight: 16,
                              //                   letterSpacing: 0.4,
                              //                   fontWeight: FontWeight.w400,
                              //                   textColor: HMSThemeColors
                              //                       .onPrimaryHighEmphasis),
                              //               Padding(
                              //                 padding: const EdgeInsets.only(
                              //                     left: 4.0),
                              //                 child: Icon(
                              //                   Icons.keyboard_arrow_down,
                              //                   color: HMSThemeColors
                              //                       .onPrimaryHighEmphasis,
                              //                   size: 12,
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         ))
                              //   ],
                              // ),
                              const SizedBox(),
                              if (HMSRoomLayout.chatData?.realTimeControls
                                      ?.canDisableChat ??
                                  false)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    PopupMenuButton(
                                      padding: EdgeInsets.zero,
                                      position: PopupMenuPosition.over,
                                      color: HMSThemeColors.surfaceDefault,
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                            value: 1,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              child: Row(children: [
                                                SvgPicture.asset(
                                                    "packages/hms_room_kit/lib/src/assets/icons/${context.read<MeetingStore>().chatControls["enabled"] ? "recording_paused" : "resume"}.svg",
                                                    width: 20,
                                                    height: 20,
                                                    colorFilter: ColorFilter.mode(
                                                        HMSThemeColors
                                                            .onSurfaceHighEmphasis,
                                                        BlendMode.srcIn)),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                HMSTitleText(
                                                  text: context
                                                          .read<MeetingStore>()
                                                          .chatControls["enabled"]
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
                                                          .read<MeetingStore>()
                                                          .chatControls["enabled"]
                                                      ? false
                                                      : true,
                                                  "updatedBy": {
                                                    "peerID": context
                                                        .read<MeetingStore>()
                                                        .localPeer
                                                        ?.peerId,
                                                    "userID": context
                                                        .read<MeetingStore>()
                                                        .localPeer
                                                        ?.customerUserId,
                                                    "userName": context
                                                        .read<MeetingStore>()
                                                        .localPeer
                                                        ?.name
                                                  },
                                                  "updatedAt": DateTime.now()
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
                                            color: HMSThemeColors.backgroundDim
                                                .withOpacity(0.64)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
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

            Selector<MeetingStore, bool>(
                selector: (_, meetingStore) =>
                    meetingStore.chatControls["enabled"],
                builder: (_, isChatEnabled, __) {
                  return isChatEnabled
                      ? Container(
                          height: 48,
                          width: MediaQuery.of(context).size.width - 16,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: HMSThemeColors.surfaceDim),
                          child: TextField(
                            textAlignVertical: TextAlignVertical.center,
                            keyboardType: TextInputType.text,
                            cursorColor: HMSThemeColors.onSurfaceHighEmphasis,
                            onTapOutside: (event) =>
                                FocusManager.instance.primaryFocus?.unfocus(),
                            onChanged: (value) {
                              setState(() {});
                            },
                            onSubmitted: (value) {
                              if (messageTextController.text.trim().isEmpty) {
                                Utilities.showToast("Message can't be empty");
                                return;
                              }
                              _sendMessage();
                            },
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.send,
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
                                      _sendMessage();
                                    },
                                    icon: SvgPicture.asset(
                                      "packages/hms_room_kit/lib/src/assets/icons/send_message.svg",
                                      height: 24,
                                      width: 24,
                                      colorFilter: ColorFilter.mode(
                                          messageTextController.text.isEmpty
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
                                hintStyle: HMSTextStyle.setTextStyle(
                                    color: HMSThemeColors.onSurfaceLowEmphasis,
                                    fontSize: 14,
                                    height: 0.6,
                                    letterSpacing: 0.25,
                                    fontWeight: FontWeight.w400),
                                contentPadding: const EdgeInsets.only(
                                    left: 16, right: 8, top: 0, bottom: 0),
                                hintText: "Send a message..."),
                          ),
                        )
                      : HMSToast(
                          toastColor: HMSThemeColors.surfaceDefault,
                          toastPosition: 0,
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              HMSSubheadingText(
                                text: "Chat paused",
                                textColor: HMSThemeColors.onSurfaceHighEmphasis,
                                lineHeight: 20,
                                letterSpacing: 0.1,
                                fontWeight: FontWeight.w400,
                              ),
                              HMSSubtitleText(
                                text:
                                    "Chat has been paused by ${context.read<MeetingStore>().chatControls["updatedBy"].toString().substring(0, math.min(10, context.read<MeetingStore>().chatControls["updatedBy"].toString().length))}",
                                textColor:
                                    HMSThemeColors.onSurfaceMediumEmphasis,
                              )
                            ],
                          ),
                          action: (HMSRoomLayout.chatData?.realTimeControls
                                      ?.canDisableChat ??
                                  false)
                              ? HMSToastButton(
                                  buttonTitle: "Resume",
                                  action: () {
                                    context
                                        .read<MeetingStore>()
                                        .setSessionMetadataForKey(
                                            key: SessionStoreKeyValues
                                                .getNameFromMethod(
                                                    SessionStoreKey.chatState),
                                            metadata: {
                                          "enabled": true,
                                          "updatedBy": {
                                            "peerID": context
                                                .read<MeetingStore>()
                                                .localPeer
                                                ?.peerId,
                                            "userID": context
                                                .read<MeetingStore>()
                                                .localPeer
                                                ?.customerUserId,
                                            "userName": context
                                                .read<MeetingStore>()
                                                .localPeer
                                                ?.name
                                          },
                                          "updatedAt": DateTime.now()
                                              .millisecondsSinceEpoch //unix timestamp in miliseconds
                                        });
                                  },
                                  height: 36,
                                  width: 88,
                                  buttonColor: HMSThemeColors.primaryDefault,
                                  textColor:
                                      HMSThemeColors.onPrimaryHighEmphasis,
                                )
                              : null,
                        );
                }),
          ],
        ),
      ),
    );
  }
}
